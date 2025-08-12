## RD Station API Helper

A Python library for interacting with the RD Station API, providing ORM models, authentication, segmentation, contact, and event retrieval, as well as batch and parallel data fetching utilities.

[![PyPI version](https://img.shields.io/pypi/v/rdstation-api-helper)](https://pypi.org/project/rdstation-api-helper/)
[![Last Commit](https://img.shields.io/github/last-commit/machado000/rdstation-api-helper)](https://github.com/machado000/rdstation-api-helper/commits/main)
[![Issues](https://img.shields.io/github/issues/machado000/rdstation-api-helper)](https://github.com/machado000/rdstation-api-helper/issues)
[![License](https://img.shields.io/badge/License-GPL-yellow.svg)](https://github.com/machado000/rdstation-api-helper/blob/main/LICENSE)

## Features

- **RD Station API v2 support**: Query segmentations, contacts, leads, and conversion events
- **ORM Models**: SQLAlchemy models for RD Station entities (Segmentation, Contact, Lead, etc.)
- **Batch & Parallel Fetching**: Utilities for efficient data extraction
- **Robust Error Handling**: Comprehensive error handling and retry logic
- **Logging & Config Utilities**: Easy configuration and logging
- **Type Hints**: Full type hint support for better IDE experience

## Installation

```bash
pip install rdstation-api-helper
```

## Quick Start

### 1. Set up credentials

Create a `secrets/rdstation_secret.json` file with your RD Station API credentials:

```json
{
  "RDSTATION_CLIENT_ID": "YOUR_CLIENT_ID",
  "RDSTATION_CLIENT_SECRET": "YOUR_CLIENT_SECRET",
  "RDSTATION_REFRESH_TOKEN": "YOUR_REFRESH_TOKEN"
}
```

### 2. Basic usage

```python
from rdstation_api_helper import RDStationAPI

# Initialize API client (loads credentials from environment or .env)
client = RDStationAPI()

# Fetch all segmentations
segmentations = client.get_segmentations()

# Fetch contacts for each segmentation
contacts = client.get_segmentation_contacts("segmentations_id")

# Fetch contact data for a specific UUID
status_code, contact_data = client.get_contact_data("contact_uuid")

# Fetch conversion events for a contact
status_code, events = client.get_contact_events("some-contact_uuid")
```

## ORM Models

The package provides SQLAlchemy ORM models for RD Station entities, which can be used for database integration.

- `Segmentation`
- `SegmentationContact`
- `Contact`
- `ContactFunnelStatus`
- `ConversionEvents`
- `Lead`


## Examples

Check the `examples/` directory for comprehensive usage examples:

- `basic_usage.py` - Simple report extraction


## Requirements

- Python 3.10-3.12
- pandas >= 2.0.0
- python-dotenv >= 1.0.0
- requests >= 2.32.4
- tqdm >= 4.65.0


## License

This project is licensed under the GPL License. See [LICENSE](LICENSE) file for details.


## Support

- [Documentation](https://github.com/machado000/rdstation-api-helper#readme)
- [Issues](https://github.com/machado000/rdstation-api-helper/issues)
- [Examples](examples/)


## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.