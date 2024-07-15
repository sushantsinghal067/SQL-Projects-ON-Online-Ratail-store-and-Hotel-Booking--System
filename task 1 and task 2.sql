                                                        TASK--ONE(1)
Designing a database for an online retail store involves creating tables to manage products, customers, orders, and payments. Here’s a detailed design of the database schema and some SQL queries for handling customer orders and payment processing.

Database Schema Design:

Tables
Products

product_id (Primary Key)
name
description
price
stock_quantity
category
Customers

customer_id (Primary Key)
first_name
last_name
email
phone_number
address
city
state
zip_code
Orders

order_id (Primary Key)
customer_id (Foreign Key)
order_date
status
OrderDetails

order_detail_id (Primary Key)
order_id (Foreign Key)
product_id (Foreign Key)
quantity
price
Payments

payment_id (Primary Key)
order_id (Foreign Key)
payment_date
amount
payment_method

---Now we have to do sql queries in a following database

---First we have yo create tables related to online retail store
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL,
    stock_quantity INT NOT NULL,
    category VARCHAR(255)
);

CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    zip_code VARCHAR(10)
);

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50)
);

CREATE TABLE OrderDetails (
    order_detail_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    product_id INT REFERENCES Products(product_id),
    quantity INT,
    price NUMERIC(10, 2)
);

CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount NUMERIC(10, 2),
    payment_method VARCHAR(50)
);

---Now we insert a data into the following tables

-- Insert Products
INSERT INTO Products (name, description, price, stock_quantity, category) VALUES
('Laptop', 'A high-performance laptop', 999.99, 10, 'Electronics'),
('Smartphone', 'A latest model smartphone', 699.99, 15, 'Electronics'),
('Headphones', 'Noise-cancelling headphones', 199.99, 20, 'Accessories');

-- Insert Customers
INSERT INTO Customers (first_name, last_name, email, phone_number, address, city, state, zip_code) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890', '123 Elm Street', 'Springfield', 'IL', '62701'),
('Jane', 'Smith', 'jane.smith@example.com', '0987654321', '456 Oak Avenue', 'Chicago', 'IL', '60605');

-- Insert Orders
INSERT INTO Orders (customer_id, status) VALUES
(1, 'Pending'),
(2, 'Pending');

-- Insert OrderDetails
INSERT INTO OrderDetails (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 999.99),
(1, 3, 2, 199.99),
(2, 2, 1, 699.99);

-- Insert Payments
INSERT INTO Payments (order_id, amount, payment_method) VALUES
(1, 1399.97, 'Credit Card'),
(2, 699.99, 'PayPal');

---Retrieving valuable information about the  online retail store 
                                                 PART-1 Advanced queries
1. --Retrieve All Orders for a Customer


SELECT o.order_id, o.order_date, o.status, 
       od.product_id, od.quantity, od.price
FROM Orders o
JOIN OrderDetails od ON o.order_id = od.order_id
WHERE o.customer_id = 1;	

2 ---Retrieve Payment Details for an Order

SELECT p.payment_id, p.payment_date, p.amount, p.payment_method
FROM Payments p
WHERE p.order_id = 1;

3. ---Retrieve Products with Low Stock

SELECT * FROM Products
WHERE stock_quantity < 5;

4 ---Retrieve Customer Order History

SELECT c.customer_id, c.first_name, c.last_name, o.order_id, o.order_date, o.status, p.amount, p.payment_method
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Payments p ON o.order_id = p.order_id
ORDER BY o.order_date;

5 ---Retrieve a Combined List of Orders and Payments
This query uses UNION to combine data from the Orders and Payments tables into a single result set.


SELECT o.order_id, o.order_date AS date, 'Order' AS type, o.status AS details
FROM Orders o
UNION
SELECT p.order_id, p.payment_date AS date, 'Payment' AS type, p.amount::text AS details
FROM Payments p
ORDER BY date;

6  ---Retrieve Orders with Payment Information
This query uses INNER JOIN to retrieve orders along with their corresponding payment details.


SELECT o.order_id, o.order_date, o.status, p.payment_date, p.amount, p.payment_method
FROM Orders o
INNER JOIN Payments p ON o.order_id = p.order_id;

7. ---Retrieve Total Sales per Product
This query uses JOIN and aggregation to calculate the total sales amount for each product.


SELECT p.product_id, p.name, SUM(od.quantity * od.price) AS total_sales
FROM Products p
INNER JOIN OrderDetails od ON p.product_id = od.product_id
GROUP BY p.product_id, p.name
ORDER BY total_sales DESC;

8--Retrieve Orders with Product and Payment Information
This query combines JOIN operations to retrieve orders along with the details of the products ordered and the payment information.


SELECT o.order_id, o.order_date, c.first_name, c.last_name, p.name AS product_name, od.quantity, od.price, pay.payment_date, pay.amount, pay.payment_method
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
JOIN Payments pay ON o.order_id = pay.order_id
ORDER BY o.order_date;

9 ---Retrieve Products Never Ordered
This query uses LEFT JOIN and WHERE clause to find products that have never been ordered.


SELECT p.product_id, p.name, p.price, p.stock_quantity
FROM Products p
LEFT JOIN OrderDetails od ON p.product_id = od.product_id
WHERE od.order_detail_id IS NULL;

 10 ---Retrieve Customers Who Ordered Specific Product

SELECT DISTINCT c.customer_id, c.first_name, c.last_name, c.email
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
WHERE od.product_id = 1;

