-- File: _createQueries --
-- For CIS 353 Final Project --
/* By Kaylin Zaroukian, Sean Aubrey, Alan Sisouphone, Ronald Rounsifer */
SPOOL createQueries-a.out
SET ECHO ON

-- Joining 4 relations --
-- Finds the last name, email, and shipping date for all products purchased in quantities > 1
-- Order by last name
SELECT U.lname, U.email
FROM Customer U, OrderDetails D, Product P, UserOrder O
WHERE U.cID = O.cID AND D.uoID = O.uoID AND 
      P.pID =  D.pID AND D.quantity > 1
ORDER BY U.lname;

-- Self Join --
-- For products with the same cost, finds the pID, category and cost of each product
SELECT P1.pID, P2.pID, T1.cname, T2.cname, P1.price, P2.price
FROM Product P1, Product P2, Category T1, Category T2, BelongsTo B1, BelongsTo B2
WHERE P1.price = P2.price AND P1.pID = B1.pID AND
      P2.pID = B2.pID AND T1.CategoryID = B1.CategoryID AND 
      T2.CategoryID = B2.CategoryID;

-- Union --
-- Find the pID and pname of every product that has the same price OR is in the same category
SELECT P1.pID, P1.pname
FROM Product P1, Product P2
WHERE P1.price != P2.price
UNION
SELECT P1.pID, P1.pname
FROM Product P1, Product P2, Category C1, Category C2, BelongsTo B1, BelongsTo B2
WHERE P1.pID = B1.pID AND B1.CategoryID = C1.CategoryID AND
	  P2.pID = B2.pID AND B2.CategoryID = C2.CategoryID AND
	  C2.CategoryID = C1.CategoryID;

-- SUM --
-- Find the customer name and total cost of all products order by James Bond
SELECT U.fname, U.lname, SUM(P.price)
FROM Customer U, Product P, UserOrder O, OrderDetails D
WHERE U.fname = 'James' AND U.lname = 'Bond' AND
      U.cID = O.cID AND P.pID = D.pID AND
      D.uoID = O.uoID
GROUP BY U.fname, U.lname;

-- GROUP BY, HAVING, ORDER BY --
-- Find the last name and CID of every customer who has ordered more than 2 products from the 'Office' Category
-- Order by customer last name
SELECT U.lname, U.cID, COUNT(*)
FROM Customer U, Product P, UserOrder O, OrderDetails D, BelongsTo B, Category T
WHERE U.cID = O.cID AND D.uoID = O.uoID AND
      D.pID = P.pID AND P.pID = B.pID AND
      B.CategoryID = T.CategoryID
GROUP BY U.lname, U.cID
HAVING COUNT(*) > 2
ORDER BY U.lname;

-- CORRELATED SUBQUERY --
-- Find the customers who have not made a review
SELECT C.cid, C.lname
FROM Customer C
WHERE NOT EXISTS (Select *
                  FROM Review R
                  WHERE R.cid = C.cid);
-- NON-CORRELATED SUBQUERY --
-- Find all the products that don't have reviews
SELECT P.pid, P.name
FROM Product P
WHERE P.pid NOT IN (SELECT R.pid
                    FROM Review R);
-- RELATION DIVISION --
-- Find the customer(s) who have reviewed ALL the award winning products
SELECT C.cid, C.lname
FROM Customer C
WHERE NOT EXISTS ((Select A.pid
                  FROM Award A
                  WHERE A.pid IS NOT NULL)
                  MINUS
                  (SELECT R.pid
                   FROM Review R
                   WHERE C.cid = R.cid));

-- OUTER JOIN --
-- Find the customers who ordered computers and also their reviews if they have one
-- SELECT C.cid, C.lname, R.Description
-- FROM Customer C, UserOrder O, OrderDetails D, BelongsTo B, Category C, Review R
-- WHERE C.cid = O.cid AND O.oid = D.oid AND D.pid = P.pid AND P.pid = B.pid AND
--       B.categoryID = B.categoryID;

-- Find the line num and order ID for all orders and products included in that order detail
SELECT D.lineNum, D.uoID, P.pID, P.pname
FROM OrderDetails D LEFT OUTER JOIN Product P ON D.pID = P.PID;


-- RANK QUERY --
-- Find the rank of $1000 among the product pricing from largest to smallest
SELECT Rank(1000) Within Group (Order by price DESC) "Pricing Rank"
From Product;

-- TOP-N Query --
-- Find 3 most expensive products
SELECT pid, name, price
FROM (SELECT *
      FROM Product
      ORDER BY price)
Where ROWNUM < 4;  