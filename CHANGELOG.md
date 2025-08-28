# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.2] - 2025-08-28

### Added
- `get_webhook_events()` method for fetching webhook events from SQL tables with date range filtering
- PostgreSQL database utilities (`PostgresDB` class and `PgConfig` dataclass)
- Support for both v1 and v2 webhook API versions
- Improved date/time handling with full day coverage (00:00:00 to 23:59:59)
- Better SQL query performance with proper timestamp casting

### Fixed
- Circular import issue in utils module
- SQL injection prevention with proper table name validation
- Type annotation issues for DataFrame to dict conversion
- Parameter handling in SQL queries (tuple vs list)
- Linting issues and improved code quality

### Changed
- Enhanced `parallel_decorator` to accept list of key values instead of dictionaries
- Improved error handling and logging throughout the codebase
- Better documentation and examples for parallel processing

## [1.0.0] - 2025-08-12

### Added
- Initial release of RD Station API Helper
- RD Station API v2 support
- ORM models for RD Station entities (Segmentation, Contact, Lead, etc.)
- Methods for authentication, segmentation, contact, and event retrieval
- Batch and parallel data fetching utilities
- Comprehensive error handling and retry logic
- Logging and configuration utilities
- Example usage in `examples/basic_usage.py`

### Technical
- Full type hint support
- Modular code structure for easy extension
- GPL License
