use classicmodels;

-- Question 1
-- Total sales per product line
SELECT pl.productLine, SUM(od.quantityOrdered * od.priceEach) AS totalSales
FROM orderdetails od
JOIN products p ON od.productCode = p.productCode
JOIN productlines pl ON p.productLine = pl.productLine
GROUP BY pl.productLine;

-- Total sales per customer
SELECT c.customerName, SUM(od.quantityOrdered * od.priceEach) AS totalSales
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
JOIN customers c ON o.customerNumber = c.customerNumber
GROUP BY c.customerName;

/*Sub query to filter total sales to above total sales average */
SELECT c.customerName, 
       SUM(od.quantityOrdered * od.priceEach) AS totalSales
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
JOIN customers c ON o.customerNumber = c.customerNumber
GROUP BY c.customerName
HAVING totalSales > (
    SELECT AVG(totalSales)
    FROM (
        SELECT SUM(od2.quantityOrdered * od2.priceEach) AS totalSales
        FROM orders o2
        JOIN orderdetails od2 ON o2.orderNumber = od2.orderNumber
        JOIN products p2 ON od2.productCode = p2.productCode
        JOIN customers c2 ON o2.customerNumber = c2.customerNumber
        GROUP BY c2.customerName
    ) AS subquery
);

-- Total orders and total amount per month
SELECT DATE_FORMAT(o.orderDate, '%Y-%m') AS month, 
       COUNT(o.orderNumber) AS totalOrders,
       SUM(od.quantityOrdered * od.priceEach) AS totalAmount
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY month;

-- Question 2

-- Total number of employees
SELECT COUNT(employeeNumber) AS totalEmployees
FROM employees;

-- Staff per country
SELECT o.country, COUNT(e.employeeNumber) AS staffCount
FROM employees e
JOIN offices o ON e.officeCode = o.officeCode
GROUP BY o.country;

-- Question 3 - Python

-- Example query to fetch data for regression analysis
/*numberOfOrders and totalPayments*/
SELECT c.customerNumber,
       COUNT(o.orderNumber) AS numberOfOrders,
       SUM(p.amount) AS totalPayments
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY c.customerNumber;

/*buyPrice and priceEach*/
SELECT p.buyPrice, od.priceEach
FROM orderdetails od
JOIN products p ON od.productCode = p.productCode;

-- Question 4 Stock available per line of products

SELECT pl.productLine, SUM(p.quantityInStock) AS totalStock
FROM products p
JOIN productlines pl ON p.productLine = pl.productLine
GROUP BY pl.productLine;

-- Question 5 Current order’s status

SELECT status, COUNT(orderNumber) AS totalOrders
FROM orders
GROUP BY status;

-- Question 6 Nationalities buying cars in different offices

SELECT c.country AS customerCountry, 
       o.officeCode, 
       o.country AS officeCountry, 
       COUNT(ord.orderNumber) AS totalOrders
FROM customers c
JOIN orders ord ON c.customerNumber = ord.customerNumber
JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN offices o ON e.officeCode = o.officeCode
GROUP BY customerCountry, officeCountry, o.officeCode
ORDER BY customerCountry;

