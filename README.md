# E-Commerce API Postman Collections

A comprehensive set of Postman collections for popular e-commerce platform APIs.

## Collections

| Collection | Requests | Description |
|------------|----------|-------------|
| [Shopify GraphQL API](#shopify-graphql-api) | 35 | Full GraphQL Admin API coverage |
| [Shopify REST API](#shopify-rest-api) | 19 | REST Admin API endpoints |
| [BigCommerce API](#bigcommerce-api) | 4 | Catalog API |
| [WooCommerce API](#woocommerce-api) | 2 | Products API |
| [Magento API](#magento-api) | 2 | Catalog API |
| [TrustPilot API](#trustpilot-api) | 3 | Product reviews API |

## Quick Start

### 1. Import Collections

```bash
# Clone the repository
git clone https://github.com/your-org/ecommerce-api-postman-collections.git

# Or download and import directly into Postman
```

1. Open Postman
2. Click **Import**
3. Select the collection files you need

### 2. Configure Variables

Each collection includes pre-defined variables. Choose your preferred method:

**Option A: Collection Variables (Quickest)**
1. Click on the collection name in Postman
2. Go to the **Variables** tab
3. Fill in the "Current value" column
4. Save and start making requests

**Option B: Environment Variables (Best for multiple stores)**
1. Import `Ecommerce_APIs.postman_environment.json`
2. Fill in your credentials for each platform
3. Select the environment from the dropdown
4. Switch environments to test different stores

> **Note**: Environment variables override collection variables, so you can use both approaches together.

### 3. Make Requests

Each collection is self-contained with authentication pre-configured.

---

## Shopify GraphQL API

Comprehensive GraphQL Admin API collection with proper `graphql` body type for Postman's GraphQL features.

### Structure

```
📁 Shop & App (4)      - Shop info, scopes, publications, locations
📁 Products (6)        - CRUD, search, metafields, publications
📁 Variants (2)        - Variant queries
📁 Inventory (4)       - Items, levels, adjustments
📁 Collections (2)     - List and products
📁 Orders (2)          - List and details
📁 Customers (1)       - Customer queries
📁 Metafields (2)      - Set and delete
📁 Bulk Operations (4) - Async bulk exports
📁 Webhooks (3)        - Subscription management
```

### Authentication

Set these environment variables:
- `shopify_store` - Your store name (without `.myshopify.com`)
- `shopify_token` - Admin API access token (`shpat_...`)
- `shopify_api_version` - API version (default: `2025-01`)

### Example: Get Product

```graphql
query GetProduct($id: ID!) {
  product(id: $id) {
    id
    title
    variants(first: 10) {
      edges {
        node {
          sku
          price
        }
      }
    }
  }
}
```

---

## Shopify REST API

REST endpoints for the Shopify Admin API.

### Structure

```
📁 Products            - CRUD operations
📁 Variants            - Variant management
📁 Inventory           - Inventory items and levels
📁 Metafields          - Product metafields
📁 Collections         - Smart and custom collections
📁 Product Images      - Image management
```

### Authentication

Uses `X-Shopify-Access-Token` header with your Admin API token.

---

## BigCommerce API

BigCommerce Catalog API v3.

### Endpoints

- List Products
- Get Product by ID
- List Variants
- Get Variant by ID

### Authentication

Set these environment variables:
- `bigcommerce_store_hash` - Your store hash (from API path)
- `bigcommerce_token` - API token (`X-Auth-Token`)
- `bigcommerce_client_id` - Client ID (`X-Auth-Client`)

---

## WooCommerce API

WooCommerce REST API for WordPress stores.

### Endpoints

- List Products (v3)
- List Products (Legacy v2)

### Authentication

Uses HTTP Basic Auth with consumer key/secret:
- `woo_store_url` - Full store URL (e.g., `https://mystore.com`)
- `woo_consumer_key` - Consumer key (`ck_...`)
- `woo_consumer_secret` - Consumer secret (`cs_...`)

---

## Magento API

Magento 2 REST API.

### Endpoints

- List Products
- Get Store Configuration

### Authentication

Supports both:
- **Bearer Token**: Set `magento_store_url` and `magento_token`
- **OAuth 1.0**: Set `magento_store_url`, consumer key, consumer secret, access token, and token secret

---

## TrustPilot API

TrustPilot Business API for product reviews.

### Endpoints

- Auth Call (OAuth token retrieval)
- Upsert Products
- Get Reviews

### Authentication

1. Set `trustpilot_api_key` and `trustpilot_api_secret`
2. Set `trustpilot_username`, `trustpilot_password`, and `trustpilot_business_unit_id`
3. Run "Auth Call" to get an access token (stored in `trustpilot_access_token`)
4. Use the token for subsequent requests

---

## Environment Variables Reference

All variables use platform prefixes for clarity. The environment file is organized by platform with visual separators.

### Shopify

| Variable | Required | Description |
|----------|----------|-------------|
| `shopify_store` | ✅ | Store name without .myshopify.com |
| `shopify_token` | ✅ | Admin API access token (`shpat_...`) |
| `shopify_api_version` | ✅ | API version (default: `2025-01`) |
| `shopify_product_id` | | Product ID for testing |
| `shopify_variant_id` | | Variant ID |
| `shopify_location_id` | | Location ID for inventory |
| `shopify_inventory_item_id` | | Inventory item ID |
| `shopify_collection_id` | | Collection ID |
| `shopify_order_id` | | Order ID |
| `shopify_webhook_callback_url` | | Webhook endpoint URL |

### BigCommerce

| Variable | Required | Description |
|----------|----------|-------------|
| `bigcommerce_store_hash` | ✅ | Store hash from API path |
| `bigcommerce_token` | ✅ | API access token (X-Auth-Token) |
| `bigcommerce_client_id` | ✅ | API client ID (X-Auth-Client) |
| `bigcommerce_product_id` | | Product ID for testing |
| `bigcommerce_variant_id` | | Variant ID |

### WooCommerce

| Variable | Required | Description |
|----------|----------|-------------|
| `woo_store_url` | ✅ | Full store URL with protocol |
| `woo_consumer_key` | ✅ | Consumer key (`ck_...`) |
| `woo_consumer_secret` | ✅ | Consumer secret (`cs_...`) |

### Magento

| Variable | Required | Description |
|----------|----------|-------------|
| `magento_store_url` | ✅ | Full store URL with protocol |
| `magento_token` | ✅* | Integration access token |
| `magento_consumer_key` | | OAuth 1.0 consumer key |
| `magento_consumer_secret` | | OAuth 1.0 consumer secret |
| `magento_access_token` | | OAuth 1.0 access token |
| `magento_token_secret` | | OAuth 1.0 token secret |

*Required for Bearer auth. Use OAuth variables instead if using OAuth 1.0.

### TrustPilot

| Variable | Required | Description |
|----------|----------|-------------|
| `trustpilot_host` | ✅ | API host (default: `https://api.trustpilot.com/`) |
| `trustpilot_api_key` | ✅ | API key |
| `trustpilot_api_secret` | ✅ | API secret |
| `trustpilot_username` | ✅ | Account email |
| `trustpilot_password` | ✅ | Account password |
| `trustpilot_business_unit_id` | ✅ | Business Unit ID |
| `trustpilot_access_token` | | OAuth token (from Auth Call) |

---

## Automated Testing

All collections include test scripts that validate successful responses. You can run these tests using Newman (Postman's CLI).

### Local Testing

```bash
# Install Newman
npm install -g newman newman-reporter-htmlextra

# Copy and configure credentials
cp .env.example .env
# Edit .env with your credentials

# Run all tests
./run-tests.sh

# Run specific platform
./run-tests.sh shopify-graphql
./run-tests.sh bigcommerce
./run-tests.sh woocommerce
```

### Test Reports

HTML reports are generated in the `reports/` directory after each run.

### CI/CD with GitHub Actions

This repository includes a GitHub Actions workflow (`.github/workflows/api-tests.yml`) that:

- Runs on push to main/master
- Runs on pull requests
- Can be triggered manually
- Runs on a daily schedule

**Setup:**

1. Go to your repository's Settings → Secrets and variables → Actions
2. Add the required secrets for each platform you want to test:

| Platform | Required Secrets |
|----------|------------------|
| Shopify | `SHOPIFY_STORE`, `SHOPIFY_TOKEN` |
| BigCommerce | `BIGCOMMERCE_STORE_HASH`, `BIGCOMMERCE_TOKEN`, `BIGCOMMERCE_CLIENT_ID` |
| WooCommerce | `WOO_STORE_URL`, `WOO_CONSUMER_KEY`, `WOO_CONSUMER_SECRET` |
| Magento | `MAGENTO_STORE_URL`, `MAGENTO_TOKEN` |
| TrustPilot | `TRUSTPILOT_API_KEY`, `TRUSTPILOT_API_SECRET`, `TRUSTPILOT_USERNAME`, `TRUSTPILOT_PASSWORD`, `TRUSTPILOT_BUSINESS_UNIT_ID` |

3. Tests will automatically skip for platforms without configured secrets

### What Gets Tested

Each request validates:
- **Status Code**: 2xx response
- **Response Time**: Under 10 seconds
- **JSON Validity**: Valid JSON when Content-Type is application/json
- **GraphQL Errors**: No errors in GraphQL response body (Shopify GraphQL only)

---

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Ensure no credentials are included
5. Submit a pull request

### Guidelines

- Use environment variables for all sensitive data
- Include descriptions for new endpoints
- Follow existing folder organization
- Test requests before submitting

---

## Security

⚠️ **Never commit credentials to this repository.**

- All sensitive values use Postman's `secret` variable type
- Environment file is a template with empty values
- Use Postman's environment management for your credentials

---

## License

MIT License - See [LICENSE](LICENSE) for details.

---

## Resources

- [Shopify API Documentation](https://shopify.dev/docs/api)
- [BigCommerce API Documentation](https://developer.bigcommerce.com/docs)
- [WooCommerce API Documentation](https://woocommerce.github.io/woocommerce-rest-api-docs/)
- [Magento API Documentation](https://developer.adobe.com/commerce/webapi/)
- [TrustPilot API Documentation](https://developers.trustpilot.com/)
