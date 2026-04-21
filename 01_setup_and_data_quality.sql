-- The Setup And Data Quality:- Import verification, Primary Keys & Foreign Keys(PK/FK), NULL checks, duplicates

CREATE DATABASE OlistEcommerce;
GO

USE OlistEcommerce;
GO

--Verifying All 4 Tables That I Have Imported

SELECT 'Orders'    AS TableName, COUNT(*) AS TotalRows FROM Orders
UNION ALL
SELECT 'Customers' AS TableName, COUNT(*) AS TotalRows FROM Customers
UNION ALL
SELECT 'OrderItems' AS TableName, COUNT(*) AS TotalRows FROM OrderItems
UNION ALL
SELECT 'Payments'  AS TableName, COUNT(*) AS TotalRows FROM Payments;
GO

--Adding Primary Keys & Foreign Keys

-- PRIMARY KEYS
ALTER TABLE Customers
ADD CONSTRAINT PK_Customers PRIMARY KEY (customer_id);
GO

ALTER TABLE Orders
ADD CONSTRAINT PK_Orders PRIMARY KEY (order_id);
GO

-- FOREIGN KEY — Orders references Customers
ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Customers 
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id);
GO

-- FOREIGN KEY — OrderItems references Orders
ALTER TABLE OrderItems
ADD CONSTRAINT FK_OrderItems_Orders 
FOREIGN KEY (order_id) REFERENCES Orders(order_id);
GO

-- FOREIGN KEY — Payments references Orders
ALTER TABLE Payments
ADD CONSTRAINT FK_Payments_Orders 
FOREIGN KEY (order_id) REFERENCES Orders(order_id);
GO

-- CHECK 1: NULL values in Orders
SELECT 
    'Orders' AS TableName,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS Null_order_id,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS Null_customer_id,
    SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS Null_order_status,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS Null_purchase_date,
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS Null_approved_at,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS Null_delivery_date
FROM Orders;
GO

-- CHECK 2: Duplicate order_ids in Orders
SELECT 
    order_id,
    COUNT(*) AS Occurrences
FROM Orders
GROUP BY order_id
HAVING COUNT(*) > 1;
GO

-- CHECK 3: Duplicate customer_ids in Customers
SELECT 
    customer_id,
    COUNT(*) AS Occurrences
FROM Customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
GO

-- CHECK 4: Order status distribution
SELECT 
    order_status,
    COUNT(*) AS TotalOrders,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS Percentage
FROM Orders
GROUP BY order_status
ORDER BY TotalOrders DESC;
GO

-- CHECK 5: Payment type distribution
SELECT 
    payment_type,
    COUNT(*) AS TotalPayments,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS Percentage
FROM Payments
GROUP BY payment_type
ORDER BY TotalPayments DESC;
GO

-- Handling The NULLs

-- APPROACH 1: Exclude NULLs for delivery analysis
-- Only analyse orders that were actually delivered
SELECT 
    COUNT(*) AS DeliveredOrders,
    AVG(DATEDIFF(DAY, 
        order_purchase_timestamp, 
        order_delivered_customer_date)) AS AvgDeliveryDays
FROM Orders
WHERE order_delivered_customer_date IS NOT NULL
AND order_status = 'delivered';
GO

-- APPROACH 2: Flag NULLs with CASE WHEN instead of excluding
SELECT 
    order_status,
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN order_delivered_customer_date IS NULL 
        THEN 1 ELSE 0 END) AS UndeliveredOrders,
    SUM(CASE WHEN order_delivered_customer_date IS NOT NULL 
        THEN 1 ELSE 0 END) AS DeliveredOrders
FROM Orders
GROUP BY order_status
ORDER BY TotalOrders DESC;
GO

-- APPROACH 3: ISNULL to replace NULLs with a default value
SELECT TOP 10
    order_id,
    order_status,
    ISNULL(CAST(order_approved_at AS VARCHAR(50)), 
        'Not Approved') AS ApprovalStatus
FROM Orders
WHERE order_status != 'delivered'
ORDER BY order_purchase_timestamp DESC;
GO
