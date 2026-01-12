import pandas as pd
import sqlite3

# Load cleaned data
df = pd.read_csv("data/processed/online_retail_clean.csv")

# Create SQLite DB
conn = sqlite3.connect("data/online_retail.db")

df.to_sql("orders", conn, if_exists="replace", index=False)

conn.close()

print("Database created successfully.")