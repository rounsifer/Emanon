-- DELETE ALL OF THE TABLES IN CASE THEY WERE PREVIOUSLY CREATES
--
DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE UserOrder CASCADE CONSTRAINTS;
DROP TABLE Category CASCADE CONSTRAINTS;
DROP TABLE Product CASCADE CONSTRAINTS;
DROP TABLE OrderDetails CASCADE CONSTRAINTS;
DROP TABLE OrderHistory CASCADE CONSTRAINTS;
DROP TABLE Review CASCADE CONSTRAINTS;
--
-- THIS IS THE CUSTOMER ENTITY
-- Still needs: SHIPPING ADDRESS AND CREDIT CARDS ADDED
CREATE TABLE Customer (
cID INTEGER PRIMARY KEY,
lname varchar2(25),
fname varchar2(25),
email varchar2(25),
username varchar2(25),
password varchar2(25),
billingAddress varchar2(100),
);
--
-- THIS IS THE ORDER ENTITY
--
CREATE TABLE UserOrder (
oID INTEGER PRIMARY KEY,
totalCost DECIMAL
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
-- THIS IS THE ORDER DETAILS ENTITY
--
CREATE TABLE OrderDetails (
-- If the order id is deleted,
-- then delete it from the order details
lineNum INTEGER PRIMARY KEY,
shippingMethod varchar2(15),
shippingCost DECIMAL,
deliverDate DATE,
shippingDate DATE
);
--
-- THIS IS THE ORDER HISTORY WEAK ENTITY
--
CREATE TABLE OrderHistory (
orderDate DATE,
orderTime TIMESTAMP,
PRIMARY KEY(orderTime, orderDate)
);
--
-- THIS IS THE REVIEW WEAK ENTITY
--
CREATE TABLE Review (
orderDate DATE PRIMARY KEY,
userComment varchar2(500),
rating INTEGER
);
--
-- ADDING FOREIGN KEYS
--
-- FK for the order detail's entity lineNum attribute
ALTER TABLE OrderDetails
ADD FOREIGN KEY (lineNum) references UserOrder(oID)
-- FK for the review entity's orderDate attribute
ALTER TABLE Review
ADD FOREIGN KEY (orderDate) references OrderHistory(orderDate)
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
