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
billingAddress varchar2(30),
shippingAddress varchar2(30),
lname varchar2(15),
fname varchar2(15),
password varchar2(15),
email varchar2(25),
username varchar2(15)
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
name varchar2(30),
description varchar2(100)
);
--
-- THIS IS THE PRODUCT ENTITY
-- NEED TO SHOW THAT CATEGORY BELONGS TO PRODUCT
CREATE TABLE Product (
pID INTEGER PRIMARY KEY,
name varchar2(30),
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
