\connect seafood

CREATE TABLE IF NOT EXISTS raw_noaa.landings_raw (
  source TEXT NOT NULL DEFAULT 'noaa',
  extracted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  payload JSONB NOT NULL
);

CREATE TABLE IF NOT EXISTS raw_fda.enforcement_raw (
  source TEXT NOT NULL DEFAULT 'openfda',
  extracted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  payload JSONB NOT NULL
);
