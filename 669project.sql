
DROP TABLE CATEGORY;
DROP TABLE CardTransaction;
DROP TABLE CashTransaction;
DROP TABLE Store_Products;
DROP TABLE Transaction_Products;
DROP TABLE Products;
DROP TABLE Store;
DROP TABLE Store_Products;
DROP TABLE FreeUser;
DROP TABLE PaidUser;
DROP TABLE Transaction;
DROP TABLE BankAccount;
DROP TABLE AppUser;


CREATE TABLE AppUser( 
UserID DECIMAL(12) NOT NULL PRIMARY KEY,
UserName VARCHAR(60) NOT NULL,
UserPassword VARCHAR(60) NOT NULL,
FirstName VARCHAR(255) NOT NULL,
LastName VARCHAR(255) NOT NULL,
Email VARCHAR(255) NOT NULL);

CREATE TABLE FreeUser(
UserID DECIMAL(12) NOT NULL PRIMARY KEY,
UogradeReminder DATE NOT NULL,
FOREIGN KEY(UserID)REFERENCES AppUser(UserID));

CREATE TABLE PaidUser(
UserID DECIMAL(12) NOT NULL PRIMARY KEY,
AccountBalance DECIMAL(7,2) NOT NULL,
RenewDate DATE NOT NULL,
FOREIGN KEY(UserID)REFERENCES AppUser(UserID));

CREATE TABLE BankAccount(
BankAccountID DECIMAL(12) NOT NULL PRIMARY KEY,
UserID DECIMAL(12) NOT NULL,
BankName VARCHAR(30) NOT NULL,
AccountType VARCHAR(10) NOT NULL,
AccountNumber DECIMAL(20) NOT NULL,
BankUserName VARCHAR(30) NOT NULL,
BankPassword VARCHAR(30) NOT NULL,
FOREIGN KEY (UserID)REFERENCES AppUser(UserID));

CREATE TABLE Transaction(
TransactionID DECIMAL(12) NOT NULL PRIMARY KEY,
UserID DECIMAL(12) NOT NULL,
BankAccountID DECIMAL(12) NOT NULL,
Amount DECIMAL(12) NOT NULL,
DateOn Date NOT NULL,
Felling VARCHAR(1024) NOT NULL,
CategoryID DECIMAL(12) NOT NULL,
FOREIGN KEY (UserID)REFERENCES AppUser(UserID),
FOREIGN KEY (BankAccountID) REFERENCES BankAccount(BankAccountID),
FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID));

CREATE TABLE Category(
CategoryID DECIMAL(12) NOT NULL PRIMARY KEY,
CategoryType VARCHAR(10) NOT NULL);



CREATE TABLE CardTransaction(
TransactionID DECIMAL(12) NOT NULL PRIMARY KEY,
Tips DECIMAL(7,2),
FOREIGN KEY (TransactionID)REFERENCES Transaction(TransactionID));

CREATE TABLE CashTransaction(
TransactionID DECIMAL(12) NOT NULL PRIMARY KEY,
AddressOutofStore VARCHAR(255),
FOREIGN KEY (TransactionID)REFERENCES Transaction(TransactionID));

CREATE TABLE Products(
ProductID DECIMAL(12) NOT NULL PRIMARY KEY,
ProductName VARCHAR(255) NOT NULL,
ProductDescrtiption VARCHAR(1024) NOT NULL,
Quantity DECIMAL(7) NOT NULL);

CREATE TABLE Store(
StoreID DECIMAL(12) NOT NULL PRIMARY KEY,
TransactionID DECIMAL(12) NOT NULL,
StoreName VARCHAR(50) NOT NULL,
StoreAddress VARCHAR(255) NOT NULL,
StoreType VARCHAR(10) NOT NULL,
FOREIGN KEY (TransactionID)REFERENCES Transaction(TransactionID));

CREATE TABLE Transaction_Products(
TransactionID DECIMAL(12) NOT NULL,
ProductID DECIMAL(12) NOT NULL,
FOREIGN KEY (TransactionID)REFERENCES Transaction(TransactionID),
FOREIGN KEY (ProductID)REFERENCES Products(ProductID));

CREATE TABLE Store_Products(
StoreID DECIMAL(12) NOT NULL,
ProductID DECIMAL(12) NOT NULL,
FOREIGN KEY (ProductID)REFERENCES Products(ProductID),
FOREIGN KEY (StoreID)REFERENCES Store(StoreID));





CREATE INDEX BankAccountUserID 
ON BankAccount(UserID);

CREATE INDEX TransactionUserID
ON Transaction(UserID);

CREATE INDEX TransactionBankAccountID
ON Transaction(BankAccountID);


CREATE INDEX TransactionDateon
ON Transaction(DateON);


CREATE INDEX PaidUserRenew
ON PaidUser(RenewDate);

CREATE INDEX BankAccountBankUserName
ON BankAccount(BankUserName);



CREATE INDEX ProductStore
ON Store_Products(StoreID);

CREATE INDEX StoreProduct
ON Store_Products(ProductID);

CREATE INDEX TransactionProduct
ON Transaction_Products(ProductID);

CREATE INDEX ProductTransaction
ON Transaction_Products(TransactionID);



CREATE OR REPLACE PROCEDURE AddAppUser(UserID IN DECIMAL, UserName IN VARCHAR, UserPassword IN VARCHAR, 
FirstName IN VARCHAR, LastName in VARCHAR, Email IN VARCHAR) 
AS 
BEGIN 
    INSERT INTO AppUser(UserID, UserName, UserPassword, FirstName, LastName, Email)
    VALUES(UserID, UserName,UserPassword,FirstName,LastName,Email);
END;

BEGIN 
    AddAppUser(1,'rodger','rd323','rodger','sun','rodger@gamil.com');
    COMMIT;
END;




CREATE OR REPLACE PROCEDURE AddAccountInfo(UserID IN DECIMAL, UogradeReminder IN DATE, BankAccountID IN DECIMAL, BankName IN VARCHAR,
AccountType IN VARCHAR, AccountNumer in DECIMAL, BankUserName IN VARCHAR, BankPassWord IN VARCHAR)
AS
BEGIN
    INSERT INTO FreeUser(UserID, UogradeReminder)
    VALUES(UserID, UogradeReminder);
    
    INSERT INTO BankAccount(BankAccountID,UserID,BankName,AccountType,AccountNumber,BankUserName,BankPassword)
    VALUES(BankAccountID,UserID, BankName,AccountType,AccountNumer,BankUserName,BankPassWord);
END;




BEGIN
    addaccountinfo(1,'01-APR-2016','1','BOA','Checking','111122223333','rboa','r1234');
    COMMIT;
END;









CREATE OR REPLACE PROCEDURE AddTransactions(TransactionID IN DECIMAL, UserID IN DECIMAL, BankAccountID IN DECIMAL, Amount IN DECIMAL, DateOn IN Date, 
Felling IN VARCHAR, CategoryID IN DECIMAL,CategoryType IN VARCHAR)
AS
BEGIN
    INSERT INTO Category(CategoryID, CategoryType)
    VALUES(CategoryID, CategoryType);
        
    INSERT INTO Transaction(TransactionID,UserID,BankAccountID,Amount, DateOn,Felling,CategoryID)
    VALUES(TransactionID,UserID,BankAccountID,Amount, DateOn,Felling,CategoryID);    
END;








BEGIN 
    addtransactions( '1', '1','1','2.34','02-APR-2016','good','1','Food');
    COMMIT;
END;



CREATE TABLE UserNameChange(
UserNameChangeID DECIMAL(12) NOT NULL PRIMARY KEY,
OldUserName VARCHAR(60) NOT NULL,
NewUserName VARCHAR(60) NOT NULL,
UserID DECIMAL(12) NOT NULL,
ChangeDate DATE NOT NULL,
FOREIGN KEY (UserID) REFERENCES AppUser(UserID))






CREATE OR REPLACE TRIGGER NameChangeTrigger
BEFORE UPDATE OF UserName ON AppUser
FOR EACH ROW
BEGIN 
    INSERT INTO UserNameChange(usernamechangeid,
    oldusername,
    newusername,
    userid,
    changedate)
    VALUES(NVL((SELECT MAX(usernamechangeid)+1 FROM UserNameChange), 1),
    :OLD.UserName, 
    :NEW.UserName, 
    :NEW.UserID, 
    trunc(sysdate));
END;




UPDATE AppUser
SET UserName = 'rodgersun'
WHERE userid = 1;











