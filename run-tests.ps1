# run-tests.ps1 - Run all Postman collection tests using Newman
#
# Usage:
#   .\run-tests.ps1                    # Run all collections
#   .\run-tests.ps1 shopify            # Run only Shopify GraphQL
#   .\run-tests.ps1 shopify-all        # Run both Shopify collections
#   .\run-tests.ps1 bigcommerce        # Run only BigCommerce
#
# Prerequisites:
#   npm install -g newman newman-reporter-htmlextra
#
# Environment:
#   Copy .env.example to .env and fill in your credentials

param(
    [Parameter(Position = 0)]
    [ValidateSet("all", "shopify", "shopify-graphql", "shopify-rest", "shopify-all", "bigcommerce", "woocommerce", "magento", "trustpilot")]
    [string]$Filter = "all"
)

$ErrorActionPreference = "Continue"

# Check if Newman is installed
$newmanPath = Get-Command newman -ErrorAction SilentlyContinue
if (-not $newmanPath) {
    Write-Host "Error: Newman is not installed" -ForegroundColor Red
    Write-Host "Install with: npm install -g newman newman-reporter-htmlextra"
    exit 1
}

# Load environment variables from .env if it exists
$envFile = Join-Path $PSScriptRoot ".env"
if (Test-Path $envFile) {
    Write-Host "Loading environment from .env" -ForegroundColor Yellow
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^\s*([^#][^=]+)=(.*)$') {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()
            # Remove surrounding quotes if present
            $value = $value -replace '^["'']|["'']$', ''
            [Environment]::SetEnvironmentVariable($name, $value, "Process")
        }
    }
}

# Create reports directory
$reportsDir = Join-Path $PSScriptRoot "reports"
if (-not (Test-Path $reportsDir)) {
    New-Item -ItemType Directory -Path $reportsDir | Out-Null
}

# Track failures
$script:failed = 0

function Run-Collection {
    param(
        [string]$Collection,
        [string]$Name,
        [string]$EnvFile = "Ecommerce_APIs.postman_environment.json"
    )

    Write-Host "`nRunning: $Name" -ForegroundColor Yellow
    Write-Host "Collection: $Collection"

    $collectionPath = Join-Path $PSScriptRoot $Collection
    $envFilePath = Join-Path $PSScriptRoot $EnvFile
    $reportPath = Join-Path $reportsDir "$Name-report.html"

    # Build Newman arguments
    $args = @(
        "run", $collectionPath
    )

    # Add environment file if it exists
    if (Test-Path $envFilePath) {
        $args += "-e", $envFilePath
    }

    # Add reporters
    $args += "--reporters", "cli,htmlextra"
    $args += "--reporter-htmlextra-export", $reportPath

    # Add environment variable overrides from shell environment
    # Shopify
    if ($env:SHOPIFY_STORE) { $args += "--env-var", "shopify_store=$env:SHOPIFY_STORE" }
    if ($env:SHOPIFY_TOKEN) { $args += "--env-var", "shopify_token=$env:SHOPIFY_TOKEN" }
    if ($env:SHOPIFY_API_VERSION) { $args += "--env-var", "shopify_api_version=$env:SHOPIFY_API_VERSION" }

    # BigCommerce
    if ($env:BIGCOMMERCE_STORE_HASH) { $args += "--env-var", "bigcommerce_store_hash=$env:BIGCOMMERCE_STORE_HASH" }
    if ($env:BIGCOMMERCE_TOKEN) { $args += "--env-var", "bigcommerce_token=$env:BIGCOMMERCE_TOKEN" }
    if ($env:BIGCOMMERCE_CLIENT_ID) { $args += "--env-var", "bigcommerce_client_id=$env:BIGCOMMERCE_CLIENT_ID" }

    # WooCommerce
    if ($env:WOO_STORE_URL) { $args += "--env-var", "woo_store_url=$env:WOO_STORE_URL" }
    if ($env:WOO_CONSUMER_KEY) { $args += "--env-var", "woo_consumer_key=$env:WOO_CONSUMER_KEY" }
    if ($env:WOO_CONSUMER_SECRET) { $args += "--env-var", "woo_consumer_secret=$env:WOO_CONSUMER_SECRET" }

    # Magento
    if ($env:MAGENTO_STORE_URL) { $args += "--env-var", "magento_store_url=$env:MAGENTO_STORE_URL" }
    if ($env:MAGENTO_TOKEN) { $args += "--env-var", "magento_token=$env:MAGENTO_TOKEN" }

    # TrustPilot
    if ($env:TRUSTPILOT_API_KEY) { $args += "--env-var", "trustpilot_api_key=$env:TRUSTPILOT_API_KEY" }
    if ($env:TRUSTPILOT_API_SECRET) { $args += "--env-var", "trustpilot_api_secret=$env:TRUSTPILOT_API_SECRET" }
    if ($env:TRUSTPILOT_USERNAME) { $args += "--env-var", "trustpilot_username=$env:TRUSTPILOT_USERNAME" }
    if ($env:TRUSTPILOT_PASSWORD) { $args += "--env-var", "trustpilot_password=$env:TRUSTPILOT_PASSWORD" }
    if ($env:TRUSTPILOT_BUSINESS_UNIT_ID) { $args += "--env-var", "trustpilot_business_unit_id=$env:TRUSTPILOT_BUSINESS_UNIT_ID" }

    # Run Newman
    & newman @args

    if ($LASTEXITCODE -eq 0) {
        Write-Host "[PASS] $Name passed" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] $Name failed" -ForegroundColor Red
        $script:failed++
    }
}

# Run collections based on filter
switch ($Filter) {
    "shopify" {
        Run-Collection "Shopify_GraphQL_API.postman_collection.json" "Shopify-GraphQL"
    }
    "shopify-graphql" {
        Run-Collection "Shopify_GraphQL_API.postman_collection.json" "Shopify-GraphQL"
    }
    "shopify-rest" {
        Run-Collection "Shopify_REST_API.postman_collection.json" "Shopify-REST"
    }
    "shopify-all" {
        Run-Collection "Shopify_GraphQL_API.postman_collection.json" "Shopify-GraphQL"
        Run-Collection "Shopify_REST_API.postman_collection.json" "Shopify-REST"
    }
    "bigcommerce" {
        Run-Collection "BigCommerce_API.postman_collection.json" "BigCommerce"
    }
    "woocommerce" {
        Run-Collection "WooCommerce_API.postman_collection.json" "WooCommerce"
    }
    "magento" {
        Run-Collection "Magento_API.postman_collection.json" "Magento"
    }
    "trustpilot" {
        Run-Collection "TrustPilot_API.postman_collection.json" "TrustPilot"
    }
    "all" {
        Write-Host "Running all collections..." -ForegroundColor Yellow
        Run-Collection "Shopify_GraphQL_API.postman_collection.json" "Shopify-GraphQL"
        Run-Collection "Shopify_REST_API.postman_collection.json" "Shopify-REST"
        Run-Collection "BigCommerce_API.postman_collection.json" "BigCommerce"
        Run-Collection "WooCommerce_API.postman_collection.json" "WooCommerce"
        Run-Collection "Magento_API.postman_collection.json" "Magento"
        Run-Collection "TrustPilot_API.postman_collection.json" "TrustPilot"
    }
}

# Summary
Write-Host "`n========================================" -ForegroundColor Yellow
if ($script:failed -eq 0) {
    Write-Host "All tests passed!" -ForegroundColor Green
    Write-Host "Reports available in: reports/"
    exit 0
} else {
    Write-Host "$($script:failed) collection(s) failed" -ForegroundColor Red
    Write-Host "Check reports in: reports/"
    exit 1
}
