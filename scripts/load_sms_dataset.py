import os
import pandas as pd
import psycopg2
from psycopg2.extras import execute_values

EXCEL_PATH = os.path.join("data", "Datasets.xlsx")

DB = dict(
    host=os.getenv("PGHOST", "localhost"),
    port=int(os.getenv("PGPORT", "5435")),
    dbname=os.getenv("PGDATABASE", "seafood"),
    user=os.getenv("PGUSER", "airflow"),
    password=os.getenv("PGPASSWORD", "airflow"),
)

def normalize(name: str) -> str:
    return name.strip().lower().replace(" ", "_").replace("-", "_")

def create_schema(cur):
    cur.execute("CREATE SCHEMA IF NOT EXISTS raw_sms;")

def load_table(cur, df: pd.DataFrame, table: str):
    df = df.dropna(how="all")
    df.columns = [normalize(c) for c in df.columns]
    cols = df.columns.tolist()

    # All TEXT for speed + safety (perfect for interview prep)
    col_defs = ", ".join([f"{c} text" for c in cols])

    cur.execute(f'DROP TABLE IF EXISTS raw_sms."{table}" CASCADE;')
    cur.execute(f'CREATE TABLE raw_sms."{table}" ({col_defs});')

    rows = df.astype(object).where(df.notna(), None).values.tolist()
    if rows:
        insert_sql = f'INSERT INTO raw_sms."{table}" ({",".join(cols)}) VALUES %s'
        execute_values(cur, insert_sql, rows, page_size=2000)

def main():
    if not os.path.exists(EXCEL_PATH):
        raise FileNotFoundError(f"Missing {EXCEL_PATH}. Put Datasets.xlsx in ./data/")

    xl = pd.ExcelFile(EXCEL_PATH)
    print("Sheets found:", xl.sheet_names)

    with psycopg2.connect(**DB) as conn:
        with conn.cursor() as cur:
            create_schema(cur)

            for sheet in xl.sheet_names:
                df = xl.parse(sheet)
                table = normalize(sheet)
                print(f"Loading sheet '{sheet}' -> raw_sms.{table} ({len(df)} rows)")
                load_table(cur, df, table)

        conn.commit()

    print("✅ Loaded SMS dataset into schema raw_sms")

if __name__ == "__main__":
    main()
