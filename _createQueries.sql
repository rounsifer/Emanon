-- File: _createQueries --
-- For CIS 353 Final Project --
/* By Kaylin Zaroukian, Sean Aubrey, Alan S, Ron R */
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
FROM Customer U, Price P, UserOrder O, OrderDetails D
WHERE U.fname = 'James' AND U.lname = 'Bond' AND
      U.cID = O.cID AND P.pID = D.pID AND
      D.uoID = O.uoID
GROUP BY U.fname, U.lname;

-- GROUP BY, HAVING, ORDER BY --
-- Find the last name and CID of every customer who has ordered more than 2 products from the 'Office' Category
-- Order by customer last name
SELECT U.lname, U.cID, COUNT(*)
FROM Customers U, Product P, UserOrder O, OrderDetails D, BelongsTo B, Category T
WHERE U.cID = O.cID AND D.uoID = O.uoID AND
      D.pID = P.pID AND P.pID = B.pID AND
      B.CategoryID = T.CategoryID
GROUP BY U.lname, U.cID
HAVING COUNT(*) > 2
ORDER BY U.lname;      