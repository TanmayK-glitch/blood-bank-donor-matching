import os
from pathlib import Path
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import mysql.connector
from mysql.connector import Error
from dotenv import load_dotenv

# Load .env from the backend/ directory (if it exists)
load_dotenv(dotenv_path=Path(__file__).parent / ".env")

app = FastAPI(title="Blood Bank API")

# CRITICAL: This allows your HTML frontend to talk to this API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # In production this should be your actual frontend URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database Connection Helper
def get_db_connection():
    try:
        conn = mysql.connector.connect(
            host=os.getenv("DB_HOST", "localhost"),
            user=os.getenv("DB_USER", "root"),
            password=os.getenv("DB_PASSWORD", ""),
            database=os.getenv("DB_NAME", "blood_bank_db")
        )
        return conn
    except Error as e:
        print(f"Error connecting to MySQL: {e}")
        return None

# Pydantic Models for Input Validation
class DonorCreate(BaseModel):
    name: str
    blood_group: str
    contact_number: str
    city: str

class RequestCreate(BaseModel):
    bank_id: int
    required_blood_group: str
    quantity: int
    urgency_level: str

# --- API ROUTES ---

@app.post("/donors/")
def register_donor(donor: DonorCreate):
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        cursor = conn.cursor()
        sql = "INSERT INTO Donor (Name, Blood_Group, Contact_Number, City) VALUES (%s, %s, %s, %s)"
        val = (donor.name, donor.blood_group, donor.contact_number, donor.city)
        cursor.execute(sql, val)
        conn.commit()
        return {"message": "Donor registered successfully", "donor_id": cursor.lastrowid}
    except Error as e:
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        conn.close()

@app.post("/requests/")
def create_blood_request(req: RequestCreate):
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        cursor = conn.cursor()
        sql = """INSERT INTO Blood_Request 
                 (Bank_ID, Required_Blood_Group, Quantity, Urgency_Level) 
                 VALUES (%s, %s, %s, %s)"""
        val = (req.bank_id, req.required_blood_group, req.quantity, req.urgency_level)
        cursor.execute(sql, val)
        conn.commit()
        return {"message": "Blood request submitted", "request_id": cursor.lastrowid}
    except Error as e:
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        conn.close()

@app.get("/inventory/")
def get_inventory():
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        # Complex JOIN query to satisfy the "database application" requirement
        cursor = conn.cursor(dictionary=True)
        sql = """
            SELECT b.Name AS Bank_Name, b.City, i.Blood_Group, i.Quantity_Available 
            FROM Blood_Inventory i
            JOIN Blood_Bank b ON i.Bank_ID = b.Bank_ID
            WHERE i.Quantity_Available > 0
            ORDER BY b.City, i.Blood_Group
        """
        cursor.execute(sql)
        result = cursor.fetchall()
        return result
    except Error as e:
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        conn.close()