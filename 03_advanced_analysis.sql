-- Advanced Analysis:- Multi-table JOINs, state analysis, customer frequency

USE OlistEcommerce;
GO

-- ANALYSIS 4: Full picture — Orders + Customers + Payments joined

WITH OrderRevenue AS (
    SELECT 
        o.order_id,
        o.order_status,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date,
        c.customer_state,
        SUM(p.payment_value) AS OrderValue,
        DATEDIFF(DAY, o.order_purchase_timestamp, 
                 o.order_delivered_customer_date) AS DeliveryDays
    FROM Orders o
    INNER JOIN Customers c ON o.customer_id = c.customer_id
    INNER JOIN Payments p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
    GROUP BY 
        o.order_id,
        o.order_status,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date,
        c.customer_state
),
StateSummary AS (
    SELECT 
        customer_state,
        COUNT(*)                AS TotalOrders,
        SUM(OrderValue)         AS TotalRevenue,
        AVG(OrderValue)         AS AvgOrderValue,
        AVG(DeliveryDays)       AS AvgDeliveryDays
    FROM OrderRevenue
    GROUP BY customer_state
)
SELECT 
    customer_state,
    TotalOrders,
    CAST(TotalRevenue AS DECIMAL(12,2))     AS TotalRevenue,
    CAST(AvgOrderValue AS DECIMAL(8,2))     AS AvgOrderValue,
    CAST(AvgDeliveryDays AS DECIMAL(5,1))   AS AvgDeliveryDays,
    RANK() OVER (ORDER BY TotalRevenue DESC) AS RevenueRank,
    RANK() OVER (ORDER BY AvgDeliveryDays ASC) AS DeliveryRank
FROM StateSummary
ORDER BY RevenueRank;
GO

-- ANALYSIS 5: Customer Purchase Frequency
WITH CustomerOrders AS (
    SELECT 
        c.customer_state,
        o.customer_id,
        COUNT(o.order_id) AS OrderCount
    FROM Orders o
    INNER JOIN Customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_state, o.customer_id
)
SELECT 
    OrderCount                          AS PurchaseFrequency,
    COUNT(*)                            AS TotalCustomers,
    CAST(COUNT(*) * 100.0 / 
        SUM(COUNT(*)) OVER() 
        AS DECIMAL(5,2))                AS Percentage
FROM CustomerOrders
GROUP BY OrderCount
ORDER BY OrderCount;
GO