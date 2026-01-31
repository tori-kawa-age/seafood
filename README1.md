# seafood
Data ingestion for seafood

## SMS Interview Dataset (Not Included)

This project supports loading a sample Sales / Customer / Product dataset
provided separately for interview and demo purposes.

The dataset is intentionally not committed to this repository.

To load it locally:
1. Place the Excel file at `./data/Datasets.xlsx`
2. Run:
   ```bash
   python scripts/load_sms_dataset.py

## Loading Sample Data

This repository includes a small, representative dataset used for demos
and interview walkthroughs.

### Prerequisites
- Docker
- Python 3.10+
- Postgres running via docker-compose

### Steps
```bash
docker compose up -d
python scripts/load_sample_data.py
