-- DELETE ALL OF THE TABLES IN CASE THEY WERE PREVIOUSLY CREATED
--
DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE ShippingAddresses CASCADE CONSTRAINTS;
DROP TABLE CreditCards CASCADE CONSTRAINTS;
DROP TABLE UserOrder CASCADE CONSTRAINTS;
DROP TABLE Category CASCADE CONSTRAINTS;
DROP TABLE Product CASCADE CONSTRAINTS;
DROP TABLE BelongsTo CASCADE CONSTRAINTS;
DROP TABLE OrderDetails CASCADE CONSTRAINTS;
DROP TABLE Review CASCADE CONSTRAINTS;
--
-- THIS IS THE CUSTOMER ENTITY
--
CREATE TABLE Customer (
cID INTEGER PRIMARY KEY,
lname varchar2(25),
fname varchar2(25),
email varchar2(25),
username varchar2(25),
password varchar2(25),
billingAddress varchar2(100)
);
--
-- Customer Shipping Addresses
--
Create Table ShippingAddresses (
cID INTEGER,
shippingAddress varchar2(100),
--
-- shIC1: Both customers and shipping addresses are stored
CONSTRAINT shIC1 PRIMARY KEY (cID, shippingAddress),
-- shIC2: Customers can have multiple shipping addresses
CONSTRAINT shIC2 FOREIGN KEY (cID) REFERENCES Customer(cID)
  ON DELETE CASCADE
);
--
-- Customer Credit Cards
--
Create Table CreditCards (
cID INTEGER,
creditCard varchar2(100),
--
-- ccIC1: Both customers and credit cards are stored
CONSTRAINT ccIC1 PRIMARY KEY (cID, creditCard),
-- ccIC2: Customers can have multiple credit cards
CONSTRAINT ccIC2 FOREIGN KEY (cID) REFERENCES Customer(cID)
            ON DELETE CASCADE
);
--
-- THIS IS THE ORDER ENTITY
--
CREATE TABLE UserOrder (
uoID INTEGER PRIMARY KEY,
cID INTEGER,
totalCost DECIMAL,
oDate DATE,
oTime TIMESTAMP,
--
-- oIC1: Only customers place orders
CONSTRAINT oIC1 FOREIGN KEY (cID) REFERENCES Customer(cID)
            ON DELETE CASCADE
);
--
-- THIS IS THE CATEGORY ENTITY
--
CREATE TABLE Category (
categoryID INTEGER PRIMARY KEY,
name varchar2(50),
description varchar2(100)
);
--
-- THIS IS THE PRODUCT ENTITY
-- NEED TO SHOW THAT CATEGORY BELONGS TO PRODUCT
CREATE TABLE Product (
pID INTEGER PRIMARY KEY,
name varchar2(50),
description varchar2(100),
stockQuantity INTEGER,
price DECIMAL,
weight DECIMAL
);
--
-- Category of Products Table
--
CREATE TABLE BelongsTo (
pID INTEGER,
CategoryID INTEGER,
--
-- btIC1: The product and its category are stored
CONSTRAINT btIC1 PRIMARY KEY (CategoryID, pID),
-- btcIC2: Many categories can be assigned to a product
CONSTRAINT btIC2 FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
            ON DELETE CASCADE,
-- btcIC3: Many products can be assigned to a category
CONSTRAINT btIC3 FOREIGN KEY (pID) REFERENCES Product(pID)
            ON DELETE CASCADE
);
--
-- THIS IS THE ORDER DETAILS ENTITY
--
CREATE TABLE OrderDetails (
-- If the order id is deleted,
-- then delete it from the order details
lineNum INTEGER,
uoID INTEGER,
quantity INTEGER,
shippingMethod varchar2(15),
shippingCost DECIMAL,
deliverDate DATE,
shippingDate DATE,
pID Integer,
--
-- odIC1: Next the shipping cost for next day shipping must be greater
-- than or equal to $20.
CONSTRAINT odIC1 CHECK (NOT(shippingMethod =
'Next Day' AND shippingCost < 20)),
-- odIC2: Order Details are unique to a particular order
CONSTRAINT odIC2 PRIMARY KEY (uoID, lineNum),
-- odIC3: The order must exist
CONSTRAINT odIC3 FOREIGN KEY (uoID) REFERENCES UserOrder(uoID)
            ON DELETE CASCADE,
-- odIC4: The order details consist of a particular product
CONSTRAINT odIC4 FOREIGN KEY (pID) REFERENCES Product(pID)
            ON DELETE CASCADE
);
--
-- THIS IS THE ORDER HISTORY WEAK ENTITY
--
-- CREATE TABLE OrderHistory (
-- cID INTEGER,
-- orderDate DATE,
-- orderTime TIMESTAMP,
--
--
-- PRIMARY KEY(orderTime, orderDate)
-- );
--
-- THIS IS THE REVIEW WEAK ENTITY
--
CREATE TABLE Review (
revDate DATE,
cID INTEGER,
pID INTEGER,
userComment varchar2(500),
rating INTEGER,
-- rIC1: Ratings are between and 1 and 5 inclusive
CONSTRAINT revIC1 CHECK (NOT(rating < 1 AND rating > 5)),
-- rIC2: Customers can make multiple reviews for a product, but only on
-- different dates
CONSTRAINT revIC2 PRIMARY KEY (cID, pID, revDate),
-- rIC3: A review is unique to a customer
CONSTRAINT revIC3 FOREIGN KEY (cID) REFERENCES Customer(cID)
            ON DELETE CASCADE,
-- rIC4: A review is unique to a product
CONSTRAINT revIC4 FOREIGN KEY (pID) REFERENCES Product(pID)
            ON DELETE CASCADE
);
--
--
--
-- TODO POPULATE THE DATABASE WITH EXAMPLES
--
insert into customer values (003, 'Hull', 'Nathan', 'HullMania@mail.com', 'reincarNATE', 'IamTHEgreatest', '321 Pineapple, New York, New York');
insert into customer values (004, 'Joozer', 'Michael', 'theJoozeyOne@mail.com', 'JoozyJoose', 'juiceIgot', '232 Anagram, San Franciso, California');
insert into customer values (666, 'Copper', 'Pierce', 'theBeach@mail.com', 'CopperB', 'RentOurApts', '10295 48th Ave, Allendale, Michigan');
insert into customer values (007, 'Bond', 'James', '007leet@secret.mail.com', 'bond', 'shakenNotStirred', '007 Lab, London, England');
insert into customer values (012, 'Hull', 'Nathan', 'HullMania@mail.com', 'reincarNATE', 'IamTHEgreatest', '321 Pineapple, New York, New York');
insert into customer values (052, 'Jobs', 'Steve', 'natural_remedies_only@mail.com', 'SoulSurvivor', 'appleisLIFE!', '695 Arastradero Rd, Palo Alto, CA');
insert into customer values (069, 'Trump', 'Donald', 'THEGREATEST@maga.com', 'America', 'password', '1100 S Ocean Blvd, Palm Beach, FL');
insert into customer values (001, 'Obama', 'Barack', 'black_mamba_lol@swag.com', 'BlackCaptainAmerica', 'ComeAtMeBro-_-', '1 President Court, Washington, D.C.');
insert into customer values (002, 'Biden', 'Joe', 'harvard_man@joebiden.com', 'Bucky', 'WeWillWin', '635 W 42nd St, New York, NY');
COMMIT;
