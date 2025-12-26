#!/bin/bash
# run-tests.sh - Run all Postman collection tests using Newman
#
# Usage:
#   ./run-tests.sh                    # Run all collections
#   ./run-tests.sh shopify            # Run only Shopify collections
#   ./run-tests.sh bigcommerce        # Run only BigCommerce collection
#
# Prerequisites:
#   npm install -g newman newman-reporter-htmlextra
#
# Environment:
#   Copy .env.example to .env and fill in your credentials

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Newman is installed
if ! command -v newman &> /dev/null; then
    echo -e "${RED}Error: Newman is not installed${NC}"
    echo "Install with: npm install -g newman newman-reporter-htmlextra"
    exit 1
fi

# Load environment variables from .env if it exists
if [ -f .env ]; then
    echo -e "${YELLOW}Loading environment from .env${NC}"
    export $(cat .env | grep -v '^#' | xargs)
fi

# Create reports directory
mkdir -p reports

# Function to run a collection
run_collection() {
    local collection=$1
    local name=$2
    local env_file=${3:-"Ecommerce_APIs.postman_environment.json"}
    
    echo -e "\n${YELLOW}Running: ${name}${NC}"
    echo "Collection: ${collection}"
    
    # Build Newman command
    local cmd="newman run ${collection}"
    
    # Add environment file if it exists
    if [ -f "${env_file}" ]; then
        cmd="${cmd} -e ${env_file}"
    fi
    
    # Add reporters
    cmd="${cmd} --reporters cli,htmlextra"
    cmd="${cmd} --reporter-htmlextra-export reports/${name}-report.html"
    
    # Add environment variable overrides from shell environment
    # Shopify
    [ -n "$SHOPIFY_STORE" ] && cmd="${cmd} --env-var shopify_store=${SHOPIFY_STORE}"
    [ -n "$SHOPIFY_TOKEN" ] && cmd="${cmd} --env-var shopify_token=${SHOPIFY_TOKEN}"
    [ -n "$SHOPIFY_API_VERSION" ] && cmd="${cmd} --env-var shopify_api_version=${SHOPIFY_API_VERSION}"
    
    # BigCommerce
    [ -n "$BIGCOMMERCE_STORE_HASH" ] && cmd="${cmd} --env-var bigcommerce_store_hash=${BIGCOMMERCE_STORE_HASH}"
    [ -n "$BIGCOMMERCE_TOKEN" ] && cmd="${cmd} --env-var bigcommerce_token=${BIGCOMMERCE_TOKEN}"
    [ -n "$BIGCOMMERCE_CLIENT_ID" ] && cmd="${cmd} --env-var bigcommerce_client_id=${BIGCOMMERCE_CLIENT_ID}"
    
    # WooCommerce
    [ -n "$WOO_STORE_URL" ] && cmd="${cmd} --env-var woo_store_url=${WOO_STORE_URL}"
    [ -n "$WOO_CONSUMER_KEY" ] && cmd="${cmd} --env-var woo_consumer_key=${WOO_CONSUMER_KEY}"
    [ -n "$WOO_CONSUMER_SECRET" ] && cmd="${cmd} --env-var woo_consumer_secret=${WOO_CONSUMER_SECRET}"
    
    # Magento
    [ -n "$MAGENTO_STORE_URL" ] && cmd="${cmd} --env-var magento_store_url=${MAGENTO_STORE_URL}"
    [ -n "$MAGENTO_TOKEN" ] && cmd="${cmd} --env-var magento_token=${MAGENTO_TOKEN}"
    
    # TrustPilot
    [ -n "$TRUSTPILOT_API_KEY" ] && cmd="${cmd} --env-var trustpilot_api_key=${TRUSTPILOT_API_KEY}"
    [ -n "$TRUSTPILOT_API_SECRET" ] && cmd="${cmd} --env-var trustpilot_api_secret=${TRUSTPILOT_API_SECRET}"
    [ -n "$TRUSTPILOT_USERNAME" ] && cmd="${cmd} --env-var trustpilot_username=${TRUSTPILOT_USERNAME}"
    [ -n "$TRUSTPILOT_PASSWORD" ] && cmd="${cmd} --env-var trustpilot_password=${TRUSTPILOT_PASSWORD}"
    [ -n "$TRUSTPILOT_BUSINESS_UNIT_ID" ] && cmd="${cmd} --env-var trustpilot_business_unit_id=${TRUSTPILOT_BUSINESS_UNIT_ID}"
    
    # Run the collection
    if eval $cmd; then
        echo -e "${GREEN}✓ ${name} passed${NC}"
        return 0
    else
        echo -e "${RED}✗ ${name} failed${NC}"
        return 1
    fi
}

# Track failures
FAILED=0

# Determine which collections to run
FILTER=${1:-"all"}

case $FILTER in
    shopify|shopify-graphql)
        run_collection "Shopify_GraphQL_API.postman_collection.json" "Shopify-GraphQL" || FAILED=$((FAILED + 1))
        ;;
    shopify-rest)
        run_collection "Shopify_REST_API.postman_collection.json" "Shopify-REST" || FAILED=$((FAILED + 1))
        ;;
    shopify-all)
        run_collection "Shopify_GraphQL_API.postman_collection.json" "Shopify-GraphQL" || FAILED=$((FAILED + 1))
        run_collection "Shopify_REST_API.postman_collection.json" "Shopify-REST" || FAILED=$((FAILED + 1))
        ;;
    bigcommerce)
        run_collection "BigCommerce_API.postman_collection.json" "BigCommerce" || FAILED=$((FAILED + 1))
        ;;
    woocommerce)
        run_collection "WooCommerce_API.postman_collection.json" "WooCommerce" || FAILED=$((FAILED + 1))
        ;;
    magento)
        run_collection "Magento_API.postman_collection.json" "Magento" || FAILED=$((FAILED + 1))
        ;;
    trustpilot)
        run_collection "TrustPilot_API.postman_collection.json" "TrustPilot" || FAILED=$((FAILED + 1))
        ;;
    all)
        echo -e "${YELLOW}Running all collections...${NC}"
        run_collection "Shopify_GraphQL_API.postman_collection.json" "Shopify-GraphQL" || FAILED=$((FAILED + 1))
        run_collection "Shopify_REST_API.postman_collection.json" "Shopify-REST" || FAILED=$((FAILED + 1))
        run_collection "BigCommerce_API.postman_collection.json" "BigCommerce" || FAILED=$((FAILED + 1))
        run_collection "WooCommerce_API.postman_collection.json" "WooCommerce" || FAILED=$((FAILED + 1))
        run_collection "Magento_API.postman_collection.json" "Magento" || FAILED=$((FAILED + 1))
        run_collection "TrustPilot_API.postman_collection.json" "TrustPilot" || FAILED=$((FAILED + 1))
        ;;
    *)
        echo "Usage: $0 [all|shopify|shopify-rest|shopify-graphql|bigcommerce|woocommerce|magento|trustpilot]"
        exit 1
        ;;
esac

# Summary
echo -e "\n${YELLOW}========================================${NC}"
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    echo -e "Reports available in: reports/"
    exit 0
else
    echo -e "${RED}${FAILED} collection(s) failed${NC}"
    echo -e "Check reports in: reports/"
    exit 1
fi
