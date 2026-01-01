# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- `package.json` with Newman dependency for standardized setup
- `.nvmrc` file specifying Node.js v25

## [1.0.0] - 2025-12-26

### Added
- Initial release with 6 e-commerce platform collections
- **Shopify GraphQL API** - 30 requests covering products, variants, inventory, orders, customers
- **Shopify REST API** - 19 requests for Admin API endpoints
- **BigCommerce API** - 15 requests for Store, Catalog, Orders, Customers
- **WooCommerce API** - 19 requests for REST API v3
- **Magento API** - 2 requests for Catalog API
- **TrustPilot API** - 3 requests for Product Reviews API
- Shared Postman environment file (`Ecommerce_APIs.postman_environment.json`)
- Cross-platform test runners (`run-tests.sh` and `run-tests.ps1`)
- GitHub Actions CI/CD workflow with 6 independent jobs
- Automatic ID extraction from list endpoints
- Smart skip logic for missing credentials
- HTML test report generation
