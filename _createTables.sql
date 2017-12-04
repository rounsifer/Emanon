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
DROP TABLE Award CASCADE CONSTRAINTS;
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
cname varchar2(50),
description varchar2(100)
);
--
-- THIS IS THE PRODUCT ENTITY
-- NEED TO SHOW THAT CATEGORY BELONGS TO PRODUCT
CREATE TABLE Product (
pID INTEGER PRIMARY KEY,
pname varchar2(50),
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
CONSTRAINT btIC1 PRIMARY KEY (pID, CategoryID),
-- btIC2: Many categories can be assigned to a product
CONSTRAINT btIC2 FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
            ON DELETE CASCADE,
-- btIC3: Many products can be assigned to a category
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
CONSTRAINT revIC1 CHECK (rating >= 1 AND rating <= 5),
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
-- Awards for Products Table
--
CREATE TABLE Award (
name varchar2(30) PRIMARY KEY,
description varchar2(100),
pID INTEGER,
--
-- awIC1: An award can be assigned to a product that exists
CONSTRAINT awIC1 FOREIGN KEY (pID) REFERENCES Product(pID)
            ON DELETE SET NULL,
-- awIC2: A product can't have more than one award
CONSTRAINT awIC2 UNIQUE (pID)
);
--
--
--
-- TODO POPULATE THE DATABASE WITH EXAMPLES
--
insert into customer values (001, 'Obama', 'Barack', 'Obobo@whitehouse.com', 'CaptainAmerica', 'ComeAtMeBro-_-', '1 President Court, Washington, D.C.');
insert into customer values (002, 'Biden', 'Joe', 'harvard_man@joebiden.com', 'Bucky', 'WeWillWin', '635 W 42nd St, New York, NY');
insert into customer values (003, 'Hull', 'Nathan', 'HullMania@mail.com', 'reincarNATE', 'IamTHEgreatest', '321 Pineapple, New York, New York');
insert into customer values (004, 'Joozer', 'Michael', 'theJoozeyOne@mail.com', 'JoozyJoose', 'juiceIgot', '232 Anagram, San Franciso, California');
insert into customer values (007, 'Bond', 'James', '007leet@secret.mail.com', 'bond', 'shakenNotStirred', '007 Lab, London, England');
insert into customer values (042, 'Copper', 'Pierce', 'theBeach@mail.com', 'CopperB', 'RentOurApts', '10295 48th Ave, Allendale, Michigan');
insert into customer values (052, 'Jobs', 'Steve', 'applesAreGood@apple.com', 'SoulSurvivor', 'appleisLIFE!', '695 Apple, Apple, CA');
insert into customer values (069, 'Trump', 'Donald', 'THEGREATEST@maga.com', 'America', 'password', '1100 S Ocean Blvd, Palm Beach, FL');
--
-- Inserting Shipping Addresses
-- Hull
insert into ShippingAddresses values (003, '111 ThisStreet, Orlando, Florda');
insert into ShippingAddresses values (003, '111 ThisStreet, Chicago, Illinois');
-- Joozer
insert into ShippingAddresses values (004, '232 Anagram, San Franciso, California');
-- Copper
insert into ShippingAddresses values (042, '10295 48th Ave, Allendale, Michigan');
-- Bond
insert into ShippingAddresses values (007, '007 Lab, London, England');
-- Barack
insert into ShippingAddresses values (001, '1 President Court, Washington, D.C.');
-- Biden
insert into ShippingAddresses values (002, '635 W 42nd St, New York, NY');
-- Jobs
insert into ShippingAddresses values (052, '695 Apple, Apple, CA');
-- Trump
insert into ShippingAddresses values (069, '1100 S Ocean Blvd, Palm Beach, FL');
--
--
-- Inserting CreditCards
--
-- Barack
insert into CreditCards values (001, 1111111111111111);
insert into CreditCards values (002, 2222222222222222);
insert into CreditCards values (003, 3333333333333333);
insert into CreditCards values (004, 4444444444444444);
insert into CreditCards values (007, 0007000700070007);
insert into CreditCards values (042, 5555555555555555);
insert into CreditCards values (052, 6666666666666666);
insert into CreditCards values (069, 7777777777777777);
--
-- Inserting Categories
--
insert into Category values (001, 'Kitchen', 'Products used in the kitchen');
insert into Category values (002, 'Office', 'Appliances for office use');
insert into Category values (003, 'Sports', 'Equipment for sports!');
insert into Category values (004, 'Computers', 'Laptops, desktops, and more!');
insert into Category values (005, 'Food', 'Perishable yummy goods');
insert into Category values (006, 'Mobile Devices', 'Phones, tablets and etc');
--
-- Inserting Products
--
insert into Product values (001, 'BlendTec Blender', 'Very strong blender', 30, 100.00, 5.00);
insert into Product values (002, 'Apple Smart Fridge', 'Modern fridge with wifi capabilities', 5, 1000.00, 100.00);
insert into Product values (003, 'Sharpie Pen', 'Very smooth pen', 60, 3.00, 0.20);
insert into Product values (004, 'Google Pencil', 'Smart Pencil that keeps track of everything', 20, 120.00, 0.50);
insert into Product values (005, 'Wilson Valleyball', 'Durable volleyball and a favorite of Tom Hanks', 25, 15.00, 1.00);
insert into Product values (006, 'FitByte', 'Like a FitBit, but has more storage', 18, 100.00, 1.50);
insert into Product values (007, 'Dell XPS 30', 'Dell Laptop. The bezels are smaller than the pixels!', 15, 950.00, 4.00);
insert into Product values (008, 'Macbook Pro S+', 'Apples newest laptop', 8, 1800.00, 3.00);
insert into Product values (009, 'Not Hotdog', 'Vegetarian hotdog', 14, 3.00, 0.50);
insert into Product values (010, 'Shin Ramen', 'Korean style instant ramen. Perfect for college students!', 30, 0.60, 0.30);
insert into Product values (011, 'Apple Apple', 'Apple Branded Apple. Very minimal and delicious', 22, 30.00, 0.50);
insert into Product values (012, 'Apple Watch', 'Portable smartwatch by Apple', 26, 300.00, 2.00);
insert into Product values (013, 'iPhone x-x', 'The newest smartphone by Apple', 44, 999.99, 2.50);
--
-- Inserting BelongsTo Values
--
insert into BelongsTo values (001, 001);
insert into BelongsTo values (002, 001);
insert into BelongsTo values (002, 004);
insert into BelongsTo values (003, 002);
insert into BelongsTo values (004, 002);
insert into BelongsTo values (004, 004);
insert into BelongsTo values (004, 006);
insert into BelongsTo values (005, 003);
insert into BelongsTo values (006, 003);
insert into BelongsTo values (006, 004);
insert into BelongsTo values (007, 004);
insert into BelongsTo values (008, 004);
insert into BelongsTo values (009, 005);
insert into BelongsTo values (010, 005);
insert into BelongsTo values (011, 005);
insert into BelongsTo values (012, 006);
insert into BelongsTo values (013, 006);
--
-- Query to find the names
-- Select P.name, C.name
-- From Product P, Category C, BelongsTo B
-- Where B.pid = P.pid AND C.categoryID = B.categoryID;
--
-- Inserting Awards
--
insert into Award values ('Best Blender Award', 'Awarded to the blender', 001);
insert into Award values ('Best Mobile Tech Award', 'Awarded to the most innovated mobile device', 006);
insert into Award values ('Best New Food Award', 'Awarded to the best food product', 009);
-- Test
insert into Award values ('Best Computer Award', 'Awarded to the best laptop computer', NULL);
insert into Award values ('Best Random Award', 'Awarded to the best ???', 009);
--
-- Inserting Reviews
--
-- Review
-- revDate DATE,
-- cID INTEGER,
-- pID INTEGER,
-- userComment varchar2(500),
-- rating INTEGER,
insert into Review values ('01-OCT-17', 001, 001, 'The people of America deserve a blender this good', 5);
insert into Review values ('02-OCT-17', 001, 001, 'Did I mention this is a good blender?', 5);
insert into Review values ('05-OCT-17', 002, 011, 'Why is this apple so expensive?', 2);
insert into Review values ('20-APR-17', 069, 009, 'What is in this hotdog?', 3);
insert into Review values ('07-JUL-07', 007, 002, 'I think it is watching me', 3);
insert into Review values ('11-NOV-15', 004, 009, 'I like it!', 5);
insert into Review values ('08-SEP-16', 052, 008, 'Its okay', 3);
--
--
Select * From Customer;
Select * From ShippingAddresses;
Select * From CreditCards;
Select * From UserOrder;
Select * From Category;
Select * From Product;
Select * From BelongsTo;
Select * From OrderDetails;
Select * From Review;
Select * From Award;
COMMIT;
