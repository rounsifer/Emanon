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
billingAddress CHAR(100),
shippingAddress CHAR(100),
lname CHAR(50),
fname CHAR(50),
password CHAR(50),
email CHAR(50),
username CHAR(50)
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
name CHAR(100),
description char(500)
);
--
-- THIS IS THE PRODUCT ENTITY
-- NEED TO SHOW THAT CATEGORY BELONGS TO PRODUCT
CREATE TABLE Product (
pID INTEGER PRIMARY KEY,
name CHAR(100),
description char(500),
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
shippingMethod CHAR(10),
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
userComment CHAR(500),
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
