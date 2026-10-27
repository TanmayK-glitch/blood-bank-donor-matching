-- =============================================================
-- seed_data.sql  –  Blood Bank Donor Matching System
-- Safe to re-run: uses INSERT IGNORE so duplicate PKs are skipped.
-- Run AFTER schema.sql has been executed.
-- =============================================================

USE blood_bank_db;

-- -------------------------------------------------------------
-- 1. Blood Banks  (5 banks across different cities)
-- -------------------------------------------------------------
INSERT IGNORE INTO Blood_Bank (Bank_ID, Name, City, Contact_Number) VALUES
(1, 'LifeLine Blood Centre',       'Pune',      '020-11223344'),
(2, 'Sahyadri Blood Bank',         'Mumbai',    '022-55667788'),
(3, 'Sanjeevani Blood Centre',     'Nagpur',    '0712-9988776'),
(4, 'Apollo Blood Bank',           'Nashik',    '0253-4433221'),
(5, 'RedCross Community Blood Bank','Aurangabad','0240-7766554');

-- -------------------------------------------------------------
-- 2. Blood Inventory  (all 8 standard groups for each bank)
--    Composite PK (Bank_ID, Blood_Group) prevents duplicates.
-- -------------------------------------------------------------
INSERT IGNORE INTO Blood_Inventory (Bank_ID, Blood_Group, Quantity_Available) VALUES
-- Pune – LifeLine
(1, 'A+',  45), (1, 'A-',  12), (1, 'B+',  38), (1, 'B-',   7),
(1, 'AB+', 20), (1, 'AB-',  5), (1, 'O+',  60), (1, 'O-',  18),
-- Mumbai – Sahyadri
(2, 'A+',  80), (2, 'A-',  22), (2, 'B+',  65), (2, 'B-',  14),
(2, 'AB+', 30), (2, 'AB-',  8), (2, 'O+',  95), (2, 'O-',  25),
-- Nagpur – Sanjeevani
(3, 'A+',  30), (3, 'A-',   8), (3, 'B+',  28), (3, 'B-',   4),
(3, 'AB+', 15), (3, 'AB-',  2), (3, 'O+',  40), (3, 'O-',  10),
-- Nashik – Apollo
(4, 'A+',  25), (4, 'A-',   6), (4, 'B+',  22), (4, 'B-',   5),
(4, 'AB+', 10), (4, 'AB-',  3), (4, 'O+',  35), (4, 'O-',   9),
-- Aurangabad – RedCross
(5, 'A+',  18), (5, 'A-',   4), (5, 'B+',  16), (5, 'B-',   3),
(5, 'AB+',  8), (5, 'AB-',  1), (5, 'O+',  28), (5, 'O-',   7);

-- -------------------------------------------------------------
-- 3. Donors  (12 donors with varied blood groups and cities)
-- -------------------------------------------------------------
INSERT IGNORE INTO Donor (Donor_ID, Name, Blood_Group, Contact_Number, City) VALUES
( 1, 'Aarav Sharma',    'O+',  '9876543210', 'Pune'),
( 2, 'Priya Patil',     'A+',  '9823456781', 'Mumbai'),
( 3, 'Rahul Deshmukh',  'B+',  '9712345678', 'Nagpur'),
( 4, 'Sneha Kulkarni',  'AB+', '9645678901', 'Nashik'),
( 5, 'Vivek Joshi',     'O-',  '9534567890', 'Aurangabad'),
( 6, 'Meera Nair',      'A-',  '9423456789', 'Pune'),
( 7, 'Rohit Mehta',     'B-',  '9312345678', 'Mumbai'),
( 8, 'Anjali Singh',    'AB-', '9201234567', 'Nagpur'),
( 9, 'Kiran Bhosale',   'A+',  '9198765432', 'Nashik'),
(10, 'Deepak Wagh',     'O+',  '9087654321', 'Pune'),
(11, 'Pooja Gaikwad',   'B+',  '8976543210', 'Mumbai'),
(12, 'Suresh Chavan',   'A-',  '8865432109', 'Aurangabad');

-- -------------------------------------------------------------
-- 4. Donation Records  (linking donors to banks)
-- -------------------------------------------------------------
INSERT IGNORE INTO Donation_Record (Donation_ID, Donor_ID, Bank_ID, Donation_Date, Quantity_Donated) VALUES
(1,  1, 1, '2024-06-10', 1),
(2,  2, 2, '2024-07-15', 1),
(3,  3, 3, '2024-08-20', 1),
(4,  4, 4, '2024-09-05', 1),
(5,  5, 5, '2024-10-01', 1),
(6,  6, 1, '2024-10-12', 1),
(7,  7, 2, '2024-10-18', 1),
(8,  8, 3, '2024-11-02', 1),
(9,  9, 4, '2024-11-10', 1),
(10,10, 1, '2024-11-20', 1);

-- -------------------------------------------------------------
-- 5. Blood Requests  (across banks with varied urgency levels)
-- -------------------------------------------------------------
INSERT IGNORE INTO Blood_Request (Request_ID, Bank_ID, Required_Blood_Group, Quantity, Urgency_Level, Status) VALUES
(1, 1, 'O-',  2, 'Critical', 'Pending'),
(2, 2, 'AB+', 3, 'High',     'Pending'),
(3, 3, 'B-',  1, 'Normal',   'Pending'),
(4, 4, 'A+',  4, 'High',     'Pending'),
(5, 5, 'O+',  2, 'Critical', 'Pending'),
(6, 1, 'A-',  1, 'Normal',   'Pending'),
(7, 2, 'B+',  3, 'High',     'Pending');

-- Verify row counts
SELECT 'Blood_Bank'      AS TableName, COUNT(*) AS Rows FROM Blood_Bank
UNION ALL
SELECT 'Blood_Inventory' AS TableName, COUNT(*) AS Rows FROM Blood_Inventory
UNION ALL
SELECT 'Donor'           AS TableName, COUNT(*) AS Rows FROM Donor
UNION ALL
SELECT 'Donation_Record' AS TableName, COUNT(*) AS Rows FROM Donation_Record
UNION ALL
SELECT 'Blood_Request'   AS TableName, COUNT(*) AS Rows FROM Blood_Request;
