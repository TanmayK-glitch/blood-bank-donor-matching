-- =============================================================
-- schema.sql  –  Blood Bank Donor Matching System
-- Creates the database and all tables if they do not exist.
-- Safe to run multiple times (uses IF NOT EXISTS).
-- =============================================================

CREATE DATABASE IF NOT EXISTS blood_bank_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE blood_bank_db;

-- 1. Create Blood_Bank (Parent Table)
CREATE TABLE IF NOT EXISTS Blood_Bank (
    Bank_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Contact_Number VARCHAR(15) NOT NULL
);

-- 2. Create Donor (Parent Table)
CREATE TABLE IF NOT EXISTS Donor (
    Donor_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Blood_Group VARCHAR(5) NOT NULL,
    Contact_Number VARCHAR(15) NOT NULL,
    City VARCHAR(50) NOT NULL
);

-- 3. Create Blood_Inventory (Child of Blood_Bank)
-- Note: Uses the composite primary key we fixed in the report.
CREATE TABLE IF NOT EXISTS Blood_Inventory (
    Bank_ID INT,
    Blood_Group VARCHAR(5) NOT NULL,
    Quantity_Available INT DEFAULT 0,
    PRIMARY KEY (Bank_ID, Blood_Group),
    FOREIGN KEY (Bank_ID) REFERENCES Blood_Bank(Bank_ID) ON DELETE CASCADE
);

-- 4. Create Donation_Record (Child of Donor and Blood_Bank)
CREATE TABLE IF NOT EXISTS Donation_Record (
    Donation_ID INT PRIMARY KEY AUTO_INCREMENT,
    Donor_ID INT NOT NULL,
    Bank_ID INT NOT NULL,
    Donation_Date DATE NOT NULL,
    Quantity_Donated INT NOT NULL,
    FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID) ON DELETE CASCADE,
    FOREIGN KEY (Bank_ID) REFERENCES Blood_Bank(Bank_ID) ON DELETE CASCADE
);

-- 5. Create Blood_Request (Child of Blood_Bank)
CREATE TABLE IF NOT EXISTS Blood_Request (
    Request_ID INT PRIMARY KEY AUTO_INCREMENT,
    Bank_ID INT NOT NULL,
    Required_Blood_Group VARCHAR(5) NOT NULL,
    Quantity INT NOT NULL,
    Urgency_Level VARCHAR(20) NOT NULL,
    Status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (Bank_ID) REFERENCES Blood_Bank(Bank_ID) ON DELETE CASCADE
);