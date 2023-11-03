--Ryan Barillos, Dick Fababi, Nathaniel Gatus

USE SKS_National_Bank;
GO

--------------------------------- Code above to use correct database

/*
    CREATE FUNCTION and PROCEDURED only wants to be the only query
    Workaround is to wrap it under a few keywords to isolate it and run
        https://stackoverflow.com/a/30501681
        https://stackoverflow.com/a/34994782
        https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-executesql-transact-sql?view=sql-server-ver16
*/



-- 1. Notify that an entity is ADDED
CREATE PROCEDURE spNotify_Add
    (@typeAttribute AS VARCHAR(255))
AS
BEGIN
    PRINT CONCAT(@typeAttribute, ' ADDED!');
END;


-- 2. Notify that an entity is UPDATED
GO
CREATE PROCEDURE spNotify_Update
    (@typeAttribute AS VARCHAR(255))
AS
BEGIN
    PRINT CONCAT (@typeAttribute, ' UPDATED!');
END;
GO


-- 3. Notify that an entity is REMOVED
GO
CREATE PROCEDURE spNotify_Remove
    (@typeAttribute AS VARCHAR(255))
AS
BEGIN
    PRINT CONCAT (@typeAttribute, ' REMOVED!');
END;
GO





-- 4. Add Bank Branch
GO
CREATE PROCEDURE mkBank
    (@BankProvince VARCHAR(50),
    @BankCity VARCHAR(50),
    @BankCountry VARCHAR(50),
    @BankPostalCode VARCHAR(50),
    @BankName VARCHAR(50),
    @BankVaultValue MONEY)
AS
BEGIN
    INSERT INTO BankBranch
        (BankProvince,
        BankCity,
        BankCountry,
        BankPostalCode,
        BankName,
        BankVaultValue)
    VALUES
        (@BankProvince,
            @BankCity,
            @BankCountry,
            @BankPostalCode,
            @BankName,
            @BankVaultValue);

    -- Show that Bank Branch is made
    SELECT *
    FROM BankBranch
    WHERE BankProvince = @BankProvince
        AND BankCity = @BankCity
        AND BankCountry = @BankCountry
        AND BankPostalCode = @BankPostalCode
        AND BankName = @BankName;

    EXEC spNotify_Add "Bank Branch";
END;
GO





-- 5. Add Bank Manager
GO
CREATE PROCEDURE Add_BankManager
    @MgrName VARCHAR(50),
    @MgrAddress VARCHAR(50),
    @MgrWorkStarted DATE
AS
BEGIN
    INSERT INTO BankManager
        (MgrName,
        MgrAddress,
        MgrWorkStarted)
    VALUES
        (@MgrName,
            @MgrAddress,
            @MgrWorkStarted);

    -- Show updates
    SELECT *
    FROM BankManager
    WHERE MgrName = @MgrName
        AND MgrAddress = @MgrAddress;
    EXEC spNotify_Add @typeAttribute = 'Bank Manager';
END;





-- 6. Move Bank Employee
GO
CREATE PROCEDURE Move_BankEmployee
    (@BranchID INT,
    @EmpID INT)
AS
BEGIN
    -- Local Variables
    DECLARE @IsOfficeWorker AS BIT = (SELECT BankEmployee.IsOfficeWorker
    FROM BankEmployee
    WHERE BankEmployee.EmpID = @EmpID)

    IF (@IsOfficeWorker = 0)
    BEGIN
        IF NOT EXISTS (SELECT *
        FROM BankBranchWorkers
        WHERE BankBranchWorkers.BranchID = @BranchID AND BankBranchWorkers.EmpID = @EmpID)
        BEGIN
            -- Show Employee being moved
            SELECT *
            FROM BankEmployee
            WHERE EmpID = @EmpID;

            -- Assign Employee to his/her work place
            INSERT INTO BankBranchWorkers
            VALUES
                (@BranchID, @EmpID);

            -- Show Changes              
            SELECT *
            FROM BankBranchWorkers
            WHERE BranchID = @BranchID AND EmpID = @EmpID;
            EXEC spNotify_Add @typeAttribute = 'Bank Employee';
        -- PRINT CONCAT ('Employee ', @EmpID, ' has been moved into the branch');
        END;
        ELSE
        BEGIN
            PRINT CONCAT ('Employee ', @EmpID, ' is ALREADY in the branch');
        END;
    END;
    ELSE IF (@IsOfficeWorker = 1)
    BEGIN
        IF NOT EXISTS (SELECT *
        FROM BankOfficeWorkers
        WHERE BankOfficeWorkers.BranchID = @BranchID AND BankOfficeWorkers.EmpID = @EmpID)
        BEGIN

            -- Show Employee being moved
            SELECT *
            FROM BankEmployee
            WHERE EmpID = @EmpID;

            -- Assign Employee to his/her work place        
            INSERT INTO BankOfficeWorkers
            VALUES
                (@BranchID, @EmpID);

            -- Show Changes            
            SELECT *
            FROM BankOfficeWorkers
            WHERE BranchID = @BranchID AND EmpID = @EmpID
            EXEC spNotify_Add @typeAttribute = 'Bank Employee';
        -- PRINT CONCAT ('Employee ', @EmpID, ' has been moved into the office');
        END;
        ELSE
        BEGIN
            PRINT CONCAT ('Employee ', @EmpID, ' is ALREADY in the office');
        END;
    END;
END;
GO





-- 7. Add Bank Employee
-- NOTE: This needs a BranchID to work
GO
CREATE PROCEDURE Add_BankEmployee
    (@BranchID INT,
    @MgrID INT,
    @EmpType VARCHAR(50),
    @EmpName VARCHAR(50),
    @EmpAddress VARCHAR(50),
    @IsOfficeWorker BIT,
    @WorkStarted DATE)

AS
BEGIN
    IF NOT EXISTS (SELECT *
    FROM BankEmployee
    WHERE MgrID = @MgrID AND EmpType = @EmpType AND EmpName = @EmpName AND EmpAddress = @EmpAddress AND IsOfficeWorker = @IsOfficeWorker AND WorkStarted = @WorkStarted)
    BEGIN
        INSERT INTO BankEmployee
            (MgrID,
            EmpType,
            EmpName,
            EmpAddress,
            IsOfficeWorker,
            WorkStarted)

        VALUES
            (@MgrID,
                @EmpType,
                @EmpName,
                @EmpAddress,
                @IsOfficeWorker,
                @WorkStarted)

        -- Move Bank Employee
        DECLARE @EmpID AS INT = (SELECT EmpID
        FROM BankEmployee
        WHERE MgrID = @MgrID AND EmpType = @EmpType AND EmpName = @EmpName AND EmpAddress = @EmpAddress AND IsOfficeWorker = @IsOfficeWorker AND WorkStarted = @WorkStarted);
        EXEC Move_BankEmployee @BranchID, @EmpID;
    END;
    ELSE
    BEGIN
        PRINT 'This employee has already been hired.';
    END;
END;
GO





/*
    8. Add Bank Customer
*/
GO
CREATE PROCEDURE Add_BankCustomer
    @BranchID INT,
    @CustNameFirst VARCHAR(50),
    @CustNameLast VARCHAR(50),
    @CustAddress VARCHAR(50)
AS
BEGIN
    -- There can only be one person of the same, exact name in this database
    IF NOT EXISTS (SELECT *
    FROM BankCustomer
    WHERE BranchID = @BranchID
        AND CustNameFirst = @CustNameFirst
        AND CustNameLast = @CustNameLast)
    BEGIN
        INSERT INTO BankCustomer
            (BranchID,
            CustNameFirst,
            CustNameLast,
            CustAddress)
        VALUES
            (@BranchID,
                @CustNameFirst,
                @CustNameLast,
                @CustAddress)

        -- Show updates
        SELECT *
        FROM BankCustomer
        WHERE BranchID = @BranchID
            AND CustNameFirst = @CustNameFirst
            AND CustNameLast = @CustNameLast
        EXEC spNotify_Add @typeAttribute = 'Bank Customer';
    END;
    ELSE
    PRINT 'Bank Customer already exists. Please try again.';
END;
GO

GO
-- CREATE PROCEDURE Add_AccountSavings (@CustID INT, @SavingsBal MONEY, )
GO





-- 11. Relationship with Officer and Customer
GO
CREATE PROCEDURE Add_EmpCustRelationship
    (@EmpID AS INT,
    @CustID AS INT)
AS
BEGIN
    DECLARE @EmpType AS VARCHAR(12) = (SELECT IsOfficeWorker
    FROM BankEmployee
    WHERE EmpID = @EmpID)

    /*
        Bank Officer + Customer
    */
    IF (@EmpType = 'Bank Officer')
    BEGIN
        INSERT INTO RelationshipCustomerBanker
        VALUES
            (@EmpID, @CustID);
        -- Show updates            
        SELECT *
        FROM RelationshipCustomerBanker
        WHERE OfficerID = @EmpID
            AND CustID = @CustID;
        EXEC spNotify_Add @typeAttribute = 'Customer Banker Relationship';
    END;
    /*
        Loan Officer + Customer
    */
    ELSE IF (@EmpType = 'Loan Officer')
    BEGIN
        INSERT INTO RelationshipCustomerLoaner
        VALUES
            (@EmpID, @CustID);
        -- Show updates            
        SELECT *
        FROM RelationshipCustomerLoaner
        WHERE OfficerID = @EmpID
            AND CustID = @CustID;
        EXEC spNotify_Add @typeAttribute = 'Customer Loaner Relationship';
    END;
    ELSE
    BEGIN
        PRINT 'EmpID or CustID is missing. Please try again.'
    END;
END;
GO






-- -- 10. Find total amount of money of a bank branch 
-- GO
-- CREATE PROCEDURE FindTotal
--     (@BranchID AS INT)
-- AS
-- BEGIN
--     DECLARE @BankVaultValue AS MONEY = 0;

--     -- Get sum of all SAVINGS accounts' balances
--     SELECT @BankVaultValue += COALESCE(SUM(SavingsBal), 0)
--     FROM AccountSavings
--         INNER JOIN OwnerSavingsAccount ON AccountSavings.SavingsID = OwnerSavingsAccount.SavingsID
--         INNER JOIN BankCustomer ON OwnerSavingsAccount.CustID = BankCustomer.CustID
--     WHERE BankCustomer.BranchID = @BranchID;

--     -- Get sum of all CHECKING accounts' balances
--     SELECT @BankVaultValue += COALESCE(SUM(CheckingBal), 0)
--     FROM AccountChecking
--         INNER JOIN OwnerCheckingAccount ON AccountChecking.CheckingID = OwnerCheckingAccount.CheckingID
--         INNER JOIN BankCustomer ON OwnerCheckingAccount.CustID = BankCustomer.CustID
--     WHERE BankCustomer.BranchID = @BranchID;

--     -- Make updates
--     UPDATE BankBranch
--     SET BankVaultValue = @BankVaultValue
--     WHERE BranchID = @BranchID;

--     -- Show Updates
--     SELECT *
--     FROM BankBranch
--     WHERE BranchID = @BranchID;
-- END;
-- GO

-- -- 9. Remove Bank Manager

-- GO
-- CREATE PROCEDURE Remove_BManager
--     @MgrID AS INT
-- AS
-- BEGIN
--     DELETE FROM BankEmployee
-- 	WHERE MgrID = @MgrID;

--     DELETE FROM BankManager
-- 	WHERE MgrID = @MgrID;

--     EXEC spNotify_Remove @typeAttribute = 'Manager'
-- END;
-- GO

-- -- 10. Remove Employee
-- GO
-- CREATE PROCEDURE Remove_Employee
--     @EmpID AS INT
-- AS
-- BEGIN
--     DELETE FROM BankBranchWorkers
-- 	WHERE EmpID = @EmpID;

--     DELETE FROM BankOfficeWorkers
-- 	WHERE EmpID = @EmpID;

--     DELETE FROM BankEmployee
-- 	WHERE EmpID = @EmpID;

--     EXEC spNotify_Remove @typeAttribute = 'Employee'
-- END;
-- GO

--     Won't work without any of the following existing yet
--     —CHECKING ACCOUNT
--     —SAVINGS ACCOUNT
-- */
-- SELECT *
-- FROM AccountSavings;


-- EXEC spAdd_EmpCustRelationship @EmpID = 2, @CustID = 7;

-- Disconnect to current database for it to be easily dropped
USE master;
GO