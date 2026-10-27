# Blood Bank Donor Matching System

A DBMS mini-project with a **vanilla HTML/Bootstrap frontend** and a **Python FastAPI backend** connected to **MySQL**.

---

## Project Structure

```
blood-bank-donor-matching/
├── index.html                  ← Frontend (open directly in browser)
├── backend/
│   ├── main.py                 ← FastAPI application
│   ├── requirements.txt        ← Python dependencies
│   ├── .env.example            ← Environment variable template
│   └── .env                    ← Your local credentials (NOT committed)
├── database/
│   ├── schema.sql              ← Creates database + all tables
│   └── seed_data.sql           ← Inserts realistic dummy data
├── .gitignore
└── README.md
```

---

## Prerequisites

| Tool | Minimum Version |
|------|----------------|
| Python | 3.9+ |
| MySQL Server | 8.0+ |
| A modern browser | — |

---

## Step 1 — MySQL Database Setup

Open your MySQL client (MySQL Shell, MySQL Workbench, or the `mysql` CLI) and run:

```sql
-- Step 1a: Create the database and all tables (safe to re-run)
SOURCE /full/path/to/database/schema.sql;

-- Step 1b: Insert dummy data (safe to re-run — uses INSERT IGNORE)
SOURCE /full/path/to/database/seed_data.sql;
```

**Using the `mysql` CLI on PowerShell:**

```powershell
# Replace <your_password> with your actual MySQL root password
mysql -u root -p<your_password> < database\schema.sql
mysql -u root -p<your_password> < database\seed_data.sql
```

**Verify the data loaded correctly:**

```sql
USE blood_bank_db;
SELECT COUNT(*) FROM Blood_Bank;       -- expected: 5
SELECT COUNT(*) FROM Blood_Inventory;  -- expected: 40
SELECT COUNT(*) FROM Donor;            -- expected: 12
```

> **Note:** The schema uses `CREATE DATABASE IF NOT EXISTS` and `CREATE TABLE IF NOT EXISTS`, so running it against an existing database is safe and non-destructive.

---

## Step 2 — Configure Environment Variables

```powershell
# In the backend/ directory, copy the example file
Copy-Item backend\.env.example backend\.env
```

Open `backend/.env` and fill in your MySQL credentials:

```ini
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_actual_mysql_password
DB_NAME=blood_bank_db
```

> `.env` is listed in `.gitignore` and will **never** be committed.

---

## Step 3 — Install Python Dependencies

```powershell
# Create and activate a virtual environment (recommended)
python -m venv venv
.\venv\Scripts\Activate.ps1

# Install dependencies
pip install -r backend\requirements.txt
```

---

## Step 4 — Start the FastAPI Backend

```powershell
# From the project root, with venv active
uvicorn backend.main:app --reload --host 127.0.0.1 --port 8000
```

The API will be available at `http://127.0.0.1:8000`.  
Interactive docs: `http://127.0.0.1:8000/docs`

---

## Step 5 — Open the Frontend

Open `index.html` directly in your browser (no build step needed):

```powershell
# Quick open from PowerShell
Start-Process index.html
```

The page connects to `http://127.0.0.1:8000` — make sure the backend is running first.

---

## Step 6 — Test the Integration

### Test via Browser

1. Open `index.html`
2. The **Live Blood Inventory** table should automatically populate with data from MySQL.
3. Fill in the **Register Donor** form and click **Register** — a success alert confirms insertion.
4. Fill in the **Create Blood Request** form using a valid **Bank ID** (1–5 from seed data).

### Test via FastAPI Swagger UI

Navigate to `http://127.0.0.1:8000/docs` and try:

| Endpoint | Method | Test Action |
|----------|--------|-------------|
| `/inventory/` | GET | Click **Try it out → Execute** — expect 40 rows |
| `/donors/` | POST | Register a new donor with name, blood group, contact, city |
| `/requests/` | POST | Submit a blood request with `bank_id` between 1–5 |

### Test via PowerShell (curl)

```powershell
# GET inventory
Invoke-RestMethod -Uri "http://127.0.0.1:8000/inventory/" -Method GET

# POST a new donor
$body = '{"name":"Test User","blood_group":"O+","contact_number":"9999999999","city":"Pune"}'
Invoke-RestMethod -Uri "http://127.0.0.1:8000/donors/" -Method POST `
  -ContentType "application/json" -Body $body
```

---

## API Reference

| Method | Endpoint | Description | Body Fields |
|--------|----------|-------------|-------------|
| `GET` | `/inventory/` | Live inventory (JOIN of Blood_Inventory + Blood_Bank) | — |
| `POST` | `/donors/` | Register a new donor | `name`, `blood_group`, `contact_number`, `city` |
| `POST` | `/requests/` | Submit a blood request | `bank_id`, `required_blood_group`, `quantity`, `urgency_level` |

---

## Known Limitations

### Bank ID is a free-text field
The **Create Blood Request** form asks users to type a Bank ID manually. Valid IDs after seeding are **1–5**. Entering an invalid ID returns an error.

**Suggested minimal improvement** (separate task): Add a `GET /banks/` endpoint and populate the Bank ID field as a `<select>` dropdown loaded on page load — no redesign needed, just swap the `<input type="number">` for a `<select>`.

---

## Dependency Versions

| Package | Version |
|---------|---------|
| fastapi | 0.115.0 |
| uvicorn[standard] | 0.30.6 |
| mysql-connector-python | 8.3.0 |
| python-dotenv | 1.0.1 |
