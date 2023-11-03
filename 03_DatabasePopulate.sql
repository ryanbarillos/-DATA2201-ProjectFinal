--Ryan Barillos, Dick Fababi, Nathaniel Gatus

USE SKS_National_Bank;
GO

--------------------------------- Code above to use correct database

-- 1. mkBank
EXEC mkBank @BankProvince = 'Alberta', @BankCity = 'Calgary', @BankCountry = 'Canada', @BankPostalCode = 'T2E 039', @BankName = 'Calgary Dominion', @BankVaultValue = 5000000.00;
EXEC mkBank @BankProvince = 'Alberta', @BankCity = 'Red Deer', @BankCountry = 'Canada', @BankPostalCode = 'T2E 040', @BankName = 'Red Deer Dominion', @BankVaultValue = 2500000.00;
EXEC mkBank @BankProvince = 'Ontario', @BankCity = 'Toronto', @BankCountry = 'Canada', @BankPostalCode = 'M5V 1J2', @BankName = 'Bank of Toronto', @BankVaultValue = 500000.00;
EXEC mkBank 'California', 'Los Angeles', 'USA', '90001', 'LA Savings Bank', 300000.00;
EXEC mkBank 'Texas', 'Houston', 'USA', '77002', 'Houston National Bank', 600000.00
EXEC mkBank 'New York', 'New York', 'USA', '10001', 'NYC Bank', 900000.00;
EXEC mkBank 'London', 'London', 'UK', 'WC2N 5DU', 'London Bank', 700000.00;
EXEC mkBank 'Quebec', 'Montreal', 'Canada', 'H2X 1Y6', 'Montreal Savings', 400000.00;
EXEC mkBank 'Florida', 'Miami', 'USA', '33101', 'Miami National Bank', 450000.00;
EXEC mkBank 'British Columbia', 'Vancouver', 'Canada', 'V6C 3E2', 'Vancouver Bank', 550000.00;
EXEC mkBank 'Illinois', 'Chicago', 'USA', '60601', 'Chicago Savings Bank', 350000.00;
EXEC mkBank 'Alberta', 'Calgary', 'Canada', 'T2P 3H7', 'Calgary Bank', 420000.00;
SELECT *
FROM BankBranch


-- 2. mkManager
EXEC mkManager @MgrName = 'John Doe', @MgrAddress = '123 45 AVE SW', @MgrWorkStarted = '2023-10-24';
EXEC mkManager @MgrName = 'Jane Doe', @MgrAddress = '234 56 AVE SE', @MgrWorkStarted = '2023-10-25';
EXEC mkManager 'John', '123 Main St', '2023-01-15';
EXEC mkManager 'Sarah', '456 Elm Ave', '2023-02-20';
EXEC mkManager 'Michael', '789 Oak Ln', '2023-03-10';
EXEC mkManager 'Emily', '101 Pine Rd', '2023-04-05';
EXEC mkManager 'William', '234 Birch Blvd', '2023-05-12';
EXEC mkManager 'Olivia', '567 Cedar Dr', '2023-06-25';
EXEC mkManager 'James', '890 Redwood St', '2023-07-15';
EXEC mkManager 'Sophia', '111 Spruce Ave', '2023-08-03';
EXEC mkManager 'Benjamin', '222 Maple Rd', '2023-09-10';
EXEC mkManager 'Ava', '333 Willow Ln', '2023-10-01';
SELECT *
FROM BankManager


-- 3.[COMBINED] Add_BankEmployee & Move_BankEmployee
EXEC Add_BankEmployee @BranchID = 1, @MgrID = 1, @EmpType = 'Loan Officer', @EmpName = 'Franky', @EmpAddress = '89 ST SE', @IsOfficeWorker = 0, @WorkStarted = '2023-10-25';
EXEC Add_BankEmployee @BranchID = 2, @MgrID = 1, @EmpType = 'Bank Officer', @EmpName = 'Frankfurt', @EmpAddress = '91 ST SE', @IsOfficeWorker = 0, @WorkStarted = '2023-10-26';
EXEC Add_BankEmployee @BranchID = 3, @MgrID = 2, @EmpType = 'Loan Officer', @EmpName = 'Woody the Woodpecker', @EmpAddress = 'Inside a Tree', @IsOfficeWorker = 1, @WorkStarted = '2023-10-27';
EXEC Add_BankEmployee @BranchID = 4, @MgrID = 2, @EmpType = 'Bank Officer', @EmpName = 'Spongebob Squarepants', @EmpAddress = 'Bikini Bottom', @IsOfficeWorker = 1, @WorkStarted = '2023-10-28';
SELECT *
FROM BankEmployee
SELECT *
FROM BankBranchWorkers
SELECT *
FROM BankOfficeWorkers


-- 5. mkCustomer
EXEC mkCustomer @BranchID = 1, @CustNameFirst  = 'Mike', @CustNameLast = 'Tyson', @CustAddress = '23 AVE NW Calgary, AB';
EXEC mkCustomer @BranchID = 1, @CustNameFirst  = 'Mike', @CustNameLast = 'Wazowski', @CustAddress = 'Monsters Inc.';
EXEC mkCustomer @BranchID = 2, @CustNameFirst  = 'Bill', @CustNameLast = 'Nye', @CustAddress = 'Somewhere in the Americas';
EXEC mkCustomer @BranchID = 2, @CustNameFirst  = 'Alex', @CustNameLast = 'The Lion', @CustAddress = 'Madagascar, IDK, Zimbabwe';
SELECT *
FROM BankCustomer

-- -- 6. Remove_Employee
-- EXEC Remove_Employee @EmpID = 1;
-- SELECT *
-- FROM BankEmployee

-- -- 7. spNotify_Add
-- EXEC spNotify_Add @typeAttribute = 'Employee';

-- -- 8. spNotify_Update
-- EXEC spNotify_Update @typeAttribute = 'Employee';

-- -- 9. spNotify_Remove
-- EXEC spNotify_Remove @typeAttribute = 'Employee';

-- -- 10. Remove_BManager
-- EXEC Remove_BManager @MgrID = 1;
-- SELECT *
-- FROM BankManager

-- /*
--     Won't work without any of the following existing yet
--     —CHECKING ACCOUNT
--     —SAVINGS ACCOUNT
-- */
-- SELECT *
-- FROM AccountSavings;


-- EXEC spmkRelationship @EmpID = 2, @CustID = 7;

-- Disconnect to current database for it to be easily dropped
USE master;
GO


----------------- Initial Data 

/*
USE SKS_National_Bank;

INSERT INTO BankManager
    (MgrName, MgrAddress, MgrWorkStarted, MgrWorkEnded)
VALUES


INSERT INTO BankCustomer
    (BranchID, CustNameFirst, CustNameLast, CustAddress)
VALUES
    (1, 'Alice', 'Smith', '123 Main St, Toronto, Canada'),
    (2, 'Bob', 'Johnson', '456 Elm Ave, Los Angeles, USA'),
    (3, 'Charlie', 'Brown', '789 Oak Ln, Houston, USA'),
    (4, 'David', 'Lee', '101 Pine Rd, New York, USA'),
    (5, 'Eve', 'White', '234 Birch Blvd, London, UK'),
    (6, 'Frank', 'Davis', '567 Cedar Dr, Montreal, Canada'),
    (7, 'Grace', 'Williams', '890 Redwood St, Miami, USA'),
    (8, 'Henry', 'Taylor', '111 Spruce Ave, Vancouver, Canada'),
    (9, 'Isabella', 'Martin', '222 Maple Rd, Chicago, USA'),
    (10, 'Jack', 'Harris', '333 Willow Ln, Calgary, Canada');

INSERT INTO AccountChecking
    (CheckingBal, DateLastAccessed, HasRecentOverdraft)
VALUES
    (1000.50, '2023-10-10 08:30:45', 0),
    (750.25, '2023-10-11 14:15:30', 1),
    (1500.75, '2023-10-12 10:45:20', 0),
    (500.00, '2023-10-13 12:20:10', 0),
    (2000.00, '2023-10-14 09:55:15', 1),
    (800.75, '2023-10-15 16:40:25', 0),
    (1200.25, '2023-10-16 11:10:05', 0),
    (300.50, '2023-10-17 15:25:55', 1),
    (1750.00, '2023-10-18 07:05:40', 0),
    (950.00, '2023-10-19 13:35:50', 1);

INSERT INTO CheckingOverdraft
    (CheckingID, OverdraftDate, OverdraftAmount)
VALUES
    (1, '2023-10-10', 50.25),
    (2, '2023-10-11', 75.50),
    (3, '2023-10-12', 30.75),
    (4, '2023-10-13', 90.00),
    (5, '2023-10-14', 60.25),
    (6, '2023-10-15', 40.00),
    (7, '2023-10-16', 20.50),
    (8, '2023-10-17', 10.75),
    (9, '2023-10-18', 85.00),
    (10, '2023-10-19', 95.75);

INSERT INTO AccountSavings
    (SavingsBal, SavingsInterestRate, DateLastAccessed)
VALUES
    (1500.50, 0.02, '2023-10-10 08:30:45'),
    (2000.75, 0.015, '2023-10-11 14:15:30'),
    (3000.25, 0.03, '2023-10-12 10:45:20'),
    (1000.00, 0.01, '2023-10-13 12:20:10'),
    (2500.00, 0.025, '2023-10-14 09:55:15'),
    (1800.75, 0.02, '2023-10-15 16:40:25'),
    (2200.25, 0.018, '2023-10-16 11:10:05'),
    (3500.50, 0.035, '2023-10-17 15:25:55'),
    (2700.00, 0.027, '2023-10-18 07:05:40'),
    (2100.00, 0.021, '2023-10-19 13:35:50');

INSERT INTO BankEmployee
    (MgrID, EmpName, EmpAddress, WorkStarted, WorkEnded, IsOfficeWorker, EmpType)
VALUES
    (1, 'John Smith', '123 Main St, Toronto, Canada', '2023-01-15', '2023-10-05', 1, 'Bank Officer'),
    (2, 'Sarah Johnson', '456 Elm Ave, Los Angeles, USA', '2023-02-20', '2023-09-18', 1, 'Bank Officer'),
    (3, 'Michael Brown', '789 Oak Ln, Houston, USA', '2023-03-10', '2023-08-22', 0, 'Loan Officer'),
    (4, 'Emily Lee', '101 Pine Rd, New York, USA', '2023-04-05', '2023-07-14', 0, 'Loan Officer'),
    (5, 'William White', '234 Birch Blvd, London, UK', '2023-05-12', '2023-06-30', 1, 'Bank Officer'),
    (6, 'Olivia Davis', '567 Cedar Dr, Montreal, Canada', '2023-06-25', '2023-06-25', 0, 'Bank Officer'),
    (7, 'James Williams', '890 Redwood St, Miami, USA', '2023-07-15', '2023-07-15', 1, 'Loan Officer'),
    (8, 'Sophia Taylor', '111 Spruce Ave, Vancouver, Canada', '2023-08-03', '2023-08-03', 0, 'Bank Officer'),
    (9, 'Benjamin Martin', '222 Maple Rd, Chicago, USA', '2023-09-10', '2023-09-10', 1, 'Loan Officer'),
    (10, 'Ava Harris', '333 Willow Ln, Calgary, Canada', '2023-10-01', '2023-10-01', 0, 'Bank Officer');

DECLARE @NewCustID INT;
SELECT @NewCustID = IDENT_CURRENT('BankCustomer');

DECLARE @NewBranchID INT;
SELECT @NewBranchID = IDENT_CURRENT('BankBranch');

INSERT INTO BankLoan
    (BranchID, CustID, TransactionDate, RemainingBalance, IsFullyPaid)
VALUES
    (@NewBranchID, @NewCustID, '2023-10-01 09:30:00', 1500.00, 0),
    (@NewBranchID, @NewCustID, '2023-10-15 14:45:00', 1250.00, 0),
    (@NewBranchID, @NewCustID, '2023-10-02 11:00:00', 2000.00, 0),
    (@NewBranchID, @NewCustID, '2023-10-18 16:20:00', 1800.00, 0),
    (@NewBranchID, @NewCustID, '2023-10-03 08:15:00', 3000.00, 0),
    (@NewBranchID, @NewCustID, '2023-10-12 12:30:00', 2700.00, 0),
    (@NewBranchID, @NewCustID, '2023-10-05 10:45:00', 1000.00, 0),
    (@NewBranchID, @NewCustID, '2023-10-20 15:10:00', 950.00, 0),
    (@NewBranchID, @NewCustID, '2023-10-06 09:00:00', 2500.00, 0),
    (@NewBranchID, @NewCustID, '2023-10-24 14:00:00', 2400.00, 0);
*/