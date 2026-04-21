-- The Core Analysis:- Monthly trends, Revenue by payment, Delivery bands

USE OlistEcommerce;
GO

-- ANALYSIS 1: Monthly Order Trends

SELECT 
    YEAR(order_purchase_timestamp)      AS OrderYear,
    MONTH(order_purchase_timestamp)     AS OrderMonth,
    COUNT(*)                            AS TotalOrders,
    SUM(COUNT(*)) OVER (
        ORDER BY YEAR(order_purchase_timestamp), 
                 MONTH(order_purchase_timestamp)
    )                                   AS RunningTotal
FROM Orders
WHERE order_status = 'delivered'
GROUP BY 
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp)
ORDER BY OrderYear, OrderMonth;
GO

-- ANALYSIS 2: Revenue by Payment Type
SELECT 
    p.payment_type,
    COUNT(DISTINCT p.order_id)          AS TotalOrders,
    SUM(p.payment_value)                AS TotalRevenue,
    AVG(p.payment_value)                AS AvgOrderValue,
    CAST(SUM(p.payment_value) * 100.0 / 
        SUM(SUM(p.payment_value)) OVER() 
        AS DECIMAL(5,2))                AS RevenueShare
FROM Payments p
GROUP BY p.payment_type
ORDER BY TotalRevenue DESC;
GO

-- ANALYSIS 3: Delivery Performance
SELECT 
    CASE 
        WHEN DATEDIFF(DAY, order_purchase_timestamp, 
            order_delivered_customer_date) <= 7  THEN '1 — Within 1 Week'
        WHEN DATEDIFF(DAY, order_purchase_timestamp, 
            order_delivered_customer_date) <= 14 THEN '2 — Within 2 Weeks'
        WHEN DATEDIFF(DAY, order_purchase_timestamp, 
            order_delivered_customer_date) <= 30 THEN '3 — Within 1 Month'
        ELSE '4 — Over 1 Month'
    END AS DeliveryBand,
    COUNT(*) AS TotalOrders,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() 
        AS DECIMAL(5,2)) AS Percentage
FROM Orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY 
    CASE 
        WHEN DATEDIFF(DAY, order_purchase_timestamp, 
            order_delivered_customer_date) <= 7  THEN '1 — Within 1 Week'
        WHEN DATEDIFF(DAY, order_purchase_timestamp, 
            order_delivered_customer_date) <= 14 THEN '2 — Within 2 Weeks'
        WHEN DATEDIFF(DAY, order_purchase_timestamp, 
            order_delivered_customer_date) <= 30 THEN '3 — Within 1 Month'
        ELSE '4 — Over 1 Month'
    END
ORDER BY DeliveryBand;
GO