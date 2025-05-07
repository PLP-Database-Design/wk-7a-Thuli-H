create database Normalization
use Normalization

-- Question 1
-- Created the initial table first from the question
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);
-- Inserted Sample Data
INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone'); 
select * FROM ProductDetail

--  Now transforming the ProductDetail table into 1NF: 
create table NormalizedProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

INSERT INTO NormalizedProductDetail (OrderID, CustomerName, Product)
SELECT OrderID, CustomerName, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', numbers.n), ',', -1)) AS Product
FROM ProductDetail
INNER JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
) numbers ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= numbers.n - 1
ORDER BY OrderID, Product;
select * FROM NormalizedProductDetail

-- Question 2
-- First create the given table
CREATE TABLE OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT
);

-- Inserted the Sample Data into OrderDetails
INSERT INTO OrderDetails (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Get  2NF by creating the Customers table and normalizing OrderDetails:
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Insert unique customer names
INSERT INTO Customers (CustomerName)
SELECT DISTINCT CustomerName FROM OrderDetails;
select * FROM Customers

-- Create the NormalizedOrderDetails table:
CREATE TABLE NormalizedOrderDetails (
    OrderID INT,
    CustomerID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Populate the NormalizedOrderDetails table:
INSERT INTO NormalizedOrderDetails (OrderID, CustomerID, Product, Quantity)
SELECT od.OrderID, c.CustomerID, od.Product, od.Quantity
FROM OrderDetails od
JOIN Customers c ON od.CustomerName = c.CustomerName; 
select * FROM NormalizedOrderDetails

SHOW TABLES;