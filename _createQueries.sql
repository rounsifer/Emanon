-- File: _createQueries --
-- For CIS 353 Final Project --
/* By Kaylin Zaroukian, Sean Aubrey, Alan Sisouphone, Ronald Rounsifer */
SPOOL createQueries-a.out
SET ECHO ON

-- Joining 4 relations -- Q1
-- Finds the last name, email, and shipping date for all products purchased in quantities greater than 2
-- Order by last name
SELECT U.lname, U.email, D.shippingDate
FROM Customer U, OrderDetails D, Product P, UserOrder O
WHERE U.cID = O.cID AND D.uoID = O.uoID AND
      P.pID =  D.pID AND D.quantity > 2
ORDER BY U.lname;

-- Self Join -- Q2
-- Finds the product ID, name and cost of products with the same price
-- No repeats
SELECT P1.pID, P2.pID, P1.price, P2.price, P1.pname, p2.pname
FROM Product P1, Product P2
WHERE P1.price = P2.price AND P1.pid < p2.pid;

-- Union -- Q3
-- Finds the product ID of all computer products that do not have reviews
Select P.pid
FROM Product P, BelongsTo B, Category C
WHERE P.pid = B.pid AND B.categoryID = C.categoryID AND
      C.cname = 'Computers'
MINUS
Select pid
FROM Review;

-- AVG -- Q4
-- Finds the product ID, product name and average rating for all the products reviewed
-- Order by product ID
Select P.pid, P.pname, AVG(R.rating) "Average Rating"
FROM Product P, Review R
WHERE P.pid = R.pid
GROUP BY P.pid, P.pname
ORDER BY P.pid;

-- GROUP BY, HAVING, ORDER BY -- Q5
-- Finds the last name and ID of every customer(s) who has ordered more than 2 products from the 'Food' Category
-- Order by customer last name
SELECT U.lname, U.cID, COUNT(*) "Food Count"
FROM Customer U, Product P, UserOrder O, OrderDetails D, BelongsTo B, Category T
WHERE U.cID = O.cID AND D.uoID = O.uoID AND
      D.pID = P.pID AND P.pID = B.pID AND
      B.CategoryID = T.CategoryID AND T.cname = 'Food'
GROUP BY U.lname, U.cID
HAVING COUNT(*) > 2
ORDER BY U.lname;

-- CORRELATED SUBQUERY -- Q6
-- Finds customer ID and last name of the customers who have not made a review
SELECT C.cid, C.lname
FROM Customer C
WHERE NOT EXISTS (Select *
                  FROM Review R
                  WHERE R.cid = C.cid);

-- NON-CORRELATED SUBQUERY -- Q7
-- Finds the product ID and product name for all the products that don't have reviews
SELECT P.pid, P.pname
FROM Product P
WHERE P.pid NOT IN (SELECT R.pid
                    FROM Review R);

-- RELATION DIVISION -- Q8
-- Find the customer ID and last name of the customer(s) who have reviewed ALL the award winning products
SELECT C.cid, C.lname
FROM Customer C
WHERE NOT EXISTS ((Select A.pid
                  FROM Award A
                  WHERE A.pid IS NOT NULL)
                  MINUS
                  (SELECT R.pid
                   FROM Review R
                   WHERE C.cid = R.cid));

-- OUTER JOIN -- Q9
-- Find the line number and order ID for all orders and products included in that order detail
SELECT D.lineNum, D.uoID, P.pID, P.pname
FROM OrderDetails D LEFT OUTER JOIN Product P ON D.pID = P.PID
WHERE pname = 'Apple Apple';

-- RANK QUERY -- Q10
-- Find the rank of $1000 among the product pricing from largest to smallest
SELECT Rank(1000) Within Group (Order by price DESC) "Pricing Rank"
FROM Product;

-- TOP-N Query -- Q11
-- Find the 3 most expensive products
SELECT pid, pname, price
FROM (SELECT *
      FROM Product
      ORDER BY price DESC)
WHERE ROWNUM < 4;
