---Nathaniel Gatus, Ryan Barillos, Dick Fababi
USE master;
GO

IF  DB_ID('SKS_National_Bank') IS NOT NULL
    DROP DATABASE SKS_National_Bank;
GO

CREATE DATABASE SKS_National_Bank;
GO

USE SKS_National_Bank;
GO
--------------------------------- Code above just used to update
CREATE TABLE BankBranch
(
  BranchID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  BankProvince VARCHAR(50) NOT NULL,
  BankCity VARCHAR(50)NOT NULL,
  BankCountry VARCHAR(50) NOT NULL,
  BankPostalCode VARCHAR(50) NOT NULL,
  BankName VARCHAR(50) NOT NULL,
  BankVaultValue MONEY NOT NULL DEFAULT 0
);

-- CREATE TABLE BankHistoryWorkers
-- (
--   MgrID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
--   MgrName VARCHAR(50) NOT NULL,
--   MgrAddress VARCHAR(50) NOT NULL,
--   MgrWorkStarted DATE NOT NULL,
--   MgrWorkEnded DATE NUll
-- );

CREATE TABLE BankManager
(
  MgrID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  MgrName VARCHAR(50) NOT NULL,
  MgrAddress VARCHAR(50) NOT NULL,
  MgrWorkStarted DATE NOT NULL
);

CREATE TABLE BankEmployee
(
  MgrID INT NOT NULL REFERENCES BankManager(MgrID),
  EmpID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  EmpType VARCHAR(12) NOT NULL
    CONSTRAINT BankerOrLoaner 
        CHECK (EmpType = 'Bank Officer' OR EmpType = 'Loan Officer'),
  EmpName VARCHAR(50) NOT NULL,
  EmpAddress VARCHAR(50) NOT NULL,
  IsOfficeWorker BIT NOT NULL,
  WorkStarted DATE NOT NULL

);

CREATE TABLE BankOfficeWorkers
(
  EmpID INT NOT NULL REFERENCES BankEmployee (EmpID),
  BranchID INT NOT NULL REFERENCES BankBranch (BranchID),
  CONSTRAINT PK_BankOfficeWorkers PRIMARY KEY (EmpID, BranchID)
);

CREATE TABLE BankBranchWorkers
(
  EmpID INT NOT NULL REFERENCES BankEmployee (EmpID),
  BranchID INT NOT NULL REFERENCES BankBranch (BranchID),
  CONSTRAINT PK_BankBranchWorkers PRIMARY KEY (EmpID, BranchID)
);


CREATE TABLE BankCustomer
(
  BranchID INT NOT NULL REFERENCES BankBranch (BranchID),
  CustID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  CustNameFirst VARCHAR(50) NOT NULL,
  CustNameLast VARCHAR(50) NOT NULL,
  CustAddress VARCHAR(50) NOT NULL
);

CREATE TABLE RelationshipCustomerLoaner
(
  OfficerID INT NOT NULL REFERENCES BankEmployee(EmpID),
  CustID INT NOT NULL REFERENCES BankCustomer(CustID),
  CONSTRAINT PK_RelationshipCustomerLoaner PRIMARY KEY (OfficerID, CustID)
);


CREATE TABLE RelationshipCustomerBanker
(
  OfficerID INT NOT NULL REFERENCES BankEmployee(EmpID),
  CustID INT NOT NULL REFERENCES BankCustomer(CustID),
  CONSTRAINT PK_RelationshipCustomerBanker PRIMARY KEY (OfficerID, CustID)
);

CREATE TABLE AccountChecking
(
  CheckingID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  CheckingBal MONEY NOT NULL DEFAULT 0,
  HasRecentOverdraft BIT DEFAULT 0,
  DateLastAccessed DATETIME DEFAULT GETDATE()
);

CREATE TABLE CheckingOverdraft
(
  CheckingID INT NOT NULL REFERENCES AccountChecking(CheckingID),
  OverdraftID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  OverdraftDate DATE NOT NULL,
  OverdraftAmount MONEY DEFAULT 0
);

CREATE TABLE AccountSavings

(
  SavingsID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  SavingsBal MONEY NOT NULL DEFAULT 0,
  SavingsInterestRate MONEY NOT NULL DEFAULT 0,
  DateLastAccessed DATETIME DEFAULT GETDATE()
);


CREATE TABLE OwnerSavingsAccount
(
  CustID INT NOT NULL REFERENCES BankCustomer(CustID),
  SavingsID INT NOT NULL REFERENCES AccountSavings(SavingsID),
  CONSTRAINT PK_OwnerSavingsAccount PRIMARY KEY (SavingsID, CustID)
);

CREATE TABLE OwnerCheckingAccount
(
  CustID INT NOT NULL REFERENCES BankCustomer(CustID),
  CheckingID INT NOT NULL REFERENCES AccountChecking(CheckingID),
  CONSTRAINT PK_OwnerCheckingAccount PRIMARY KEY (CheckingID, CustID)
);

CREATE TABLE BankLoan
(
  BranchID INT NOT NULL REFERENCES BankBranch (BranchID),
  CustID INT NOT NULL REFERENCES BankCustomer (CustID),
  PaymentNo INT NOT NULL IDENTITY(1,1) UNIQUE,
  TransactionDate DATETIME NOT NULL,
  RemainingBalance MONEY,
  IsFullyPaid BIT,
  CONSTRAINT PK_BankLoan PRIMARY KEY (PaymentNo, TransactionDate)
);

-- Disconnect to current database for it to be easily dropped
USE master;
GO
PRINT 'Disconnected from SKS_National_Bank'