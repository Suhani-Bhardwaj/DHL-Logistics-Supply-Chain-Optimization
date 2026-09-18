Use dhl_logistics;

-- TASK 1

-- Query 1: Identify Duplicate Order Records
SELECT Order_ID, COUNT(*) AS Duplicate_Count
FROM Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;

-- Query 2: Identify Duplicate Shipment Records
SELECT Shipment_ID, COUNT(*) AS Duplicate_Count
FROM Shipments
GROUP BY Shipment_ID
HAVING COUNT(*) > 1;

-- Query 3: Check Missing Delay_Hours Values
SELECT *
FROM Shipments
WHERE Delay_Hours IS NULL;

-- Query 4: Calculate Average Delay Per Route
SELECT Route_ID,
       ROUND(AVG(Delay_Hours),2) AS Avg_Delay
FROM Shipments
GROUP BY Route_ID
ORDER BY Avg_Delay DESC;

-- Query 5: Replace Missing Delay_Hours Using Route Average
-- No missing Delay_Hours were detected; therefore imputation was not required.


-- Query 6: Verify Order Date Format
SELECT Order_Date
FROM Orders
LIMIT 5;

-- Query 7: Verify Shipment Date Format
SELECT Pickup_Date,
       Delivery_Date
FROM Shipments
LIMIT 5;

-- Query 8: Find Invalid Date Records
SELECT *
FROM Shipments
WHERE Delivery_Date < Pickup_Date;

-- Query 9: Validate Orders → Routes Relationship
SELECT *
FROM Orders o
LEFT JOIN Routes r
ON o.Route_ID = r.Route_ID
WHERE r.Route_ID IS NULL;

-- Query 10: Validate Orders → Warehouses Relationship
SELECT *
FROM Orders o
LEFT JOIN Warehouses w
ON o.Warehouse_ID = w.Warehouse_ID
WHERE w.Warehouse_ID IS NULL;

-- Query 11: Validate Shipments → Orders Relationship
SELECT *
FROM Shipments s
LEFT JOIN Orders o
ON s.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;

-- Query 12: Validate Shipments → Delivery Agents Relationship
SELECT *
FROM Shipments s
LEFT JOIN Delivery_Agents a
ON s.Agent_ID = a.Agent_ID
WHERE a.Agent_ID IS NULL;

-- TASK 2

-- Query 13: Average Transit Time by Warehouse
SELECT Shipment_ID,
       Pickup_Date,
       Delivery_Date,
       TIMESTAMPDIFF(
           HOUR,
           Pickup_Date,
           Delivery_Date
       ) AS Transit_Hours
FROM Shipments;

-- Query 14: Top 10 Delayed Routes
SELECT Route_ID,
       ROUND(AVG(Delay_Hours),2) AS Average_Delay_Hours
FROM Shipments
GROUP BY Route_ID
ORDER BY Average_Delay_Hours DESC
LIMIT 10;

-- Query 15: Rank Shipments by Delay Within Each Warehouse
SELECT Shipment_ID,
       Warehouse_ID,
       Delay_Hours,
       RANK() OVER(
           PARTITION BY Warehouse_ID
           ORDER BY Delay_Hours DESC
       ) AS Delay_Rank
FROM Shipments;

-- Query 16: Average Delay Per Delivery Type
SELECT o.Delivery_Type,
       ROUND(AVG(s.Delay_Hours),2) AS Average_Delay_Hours
FROM Orders o
JOIN Shipments s
ON o.Order_ID = s.Order_ID
GROUP BY o.Delivery_Type;

-- TASK 3

-- Query 17: Average Transit Time Per Route
SELECT Route_ID,
       ROUND(
           AVG(
               TIMESTAMPDIFF(
                   HOUR,
                   Pickup_Date,
                   Delivery_Date
               )
           ),
           2
       ) AS Avg_Transit_Time
FROM Shipments
GROUP BY Route_ID;


-- Query 18: Distance-to-Time Efficiency Ratio
SELECT Route_ID,
       Distance_KM,
       Avg_Transit_Time_Hours,
       ROUND(
           Distance_KM / Avg_Transit_Time_Hours,
           2
       ) AS Efficiency_Ratio
FROM Routes;

-- Query 19: Worst 3 Routes Based on Efficiency Ratio
SELECT Route_ID,
       ROUND(
           Distance_KM / Avg_Transit_Time_Hours,
           2
       ) AS Efficiency_Ratio
FROM Routes
ORDER BY Efficiency_Ratio ASC
LIMIT 3;

-- Query 20: Routes With More Than 20% Delayed Shipments
SELECT Route_ID,
       ROUND(
           SUM(
               CASE
                   WHEN Delay_Hours > 0 THEN 1
                   ELSE 0
               END
           ) * 100.0 / COUNT(*),
           2
       ) AS Delay_Percentage
FROM Shipments
GROUP BY Route_ID
HAVING Delay_Percentage > 20;

-- Query 21: Routes Recommended for Optimization
SELECT
    Route_ID,
    ROUND(AVG(Delay_Hours),2) AS Avg_Delay,
    COUNT(*) AS Shipment_Count
FROM Shipments
GROUP BY Route_ID
ORDER BY Avg_Delay DESC
LIMIT 5;

-- TASK 4

-- Query 22: Top 3 Warehouses With Highest Average Delay
SELECT Warehouse_ID,
       ROUND(AVG(Delay_Hours),2) AS Avg_Delay
FROM Shipments
GROUP BY Warehouse_ID
ORDER BY Avg_Delay DESC
LIMIT 3;

-- Query 23: Total Shipments, Delayed Shipments & Delay Percentage
SELECT Warehouse_ID,
       COUNT(*) AS Total_Shipments,
       SUM(
           CASE
               WHEN Delay_Hours > 0 THEN 1
               ELSE 0
           END
       ) AS Delayed_Shipments,
       ROUND(
           SUM(
               CASE
                   WHEN Delay_Hours > 0 THEN 1
                   ELSE 0
               END
           ) * 100.0 / COUNT(*),
           2
       ) AS Delay_Percentage
FROM Shipments
GROUP BY Warehouse_ID
ORDER BY Delay_Percentage DESC;

-- Query 24: Warehouses Above Global Average Delay Using CTE
WITH WarehouseDelay AS (
    SELECT Warehouse_ID,
           AVG(Delay_Hours) AS AvgDelay
    FROM Shipments
    GROUP BY Warehouse_ID
)
SELECT *
FROM WarehouseDelay
WHERE AvgDelay >
(
    SELECT AVG(Delay_Hours)
    FROM Shipments
);

-- Query 25: Rank Warehouses By On-Time Delivery Percentage

SELECT Warehouse_ID,
       ROUND(
           SUM(
               CASE
                   WHEN Delay_Hours <= 2 THEN 1
                   ELSE 0
               END
           ) * 100.0 / COUNT(*),
           2
       ) AS OnTimePercent,
       RANK() OVER(
           ORDER BY
           SUM(
               CASE
                   WHEN Delay_Hours <= 2 THEN 1
                   ELSE 0
               END
           ) * 100.0 / COUNT(*) DESC
       ) AS WarehouseRank
FROM Shipments
GROUP BY Warehouse_ID;


-- TASK 5

-- Query 26: Rank Delivery Agents Per Route By On-Time Delivery Percentage

SELECT Route_ID,
       Agent_ID,
       ROUND(
           SUM(
               CASE
                   WHEN Delay_Hours <= 2 THEN 1
                   ELSE 0
               END
           ) * 100.0 / COUNT(*),
           2
       ) AS OnTimePercent,
       RANK() OVER(
           PARTITION BY Route_ID
           ORDER BY
           SUM(
               CASE
                   WHEN Delay_Hours <= 2 THEN 1
                   ELSE 0
               END
           ) * 100.0 / COUNT(*) DESC
       ) AS AgentRank
FROM Shipments
GROUP BY Route_ID, Agent_ID;

-- Query 27: Agents With On-Time Percentage Below 85%

SELECT Agent_ID,
       ROUND(
           SUM(
               CASE
                   WHEN Delay_Hours <= 2 THEN 1
                   ELSE 0
               END
           ) * 100.0 / COUNT(*),
           2
       ) AS OnTimePercent
FROM Shipments
GROUP BY Agent_ID
HAVING OnTimePercent < 85;

-- Query 28: Top 5 Agents
SELECT Agent_ID,
       ROUND(AVG(Delay_Hours),2) AS AvgDelay
FROM Shipments
GROUP BY Agent_ID
ORDER BY AvgDelay ASC
LIMIT 5;

-- Query 29: Bottom 5 Agents
SELECT Agent_ID,
       ROUND(AVG(Delay_Hours),2) AS AvgDelay
FROM Shipments
GROUP BY Agent_ID
ORDER BY AvgDelay DESC
LIMIT 5;

-- Query 30: Compare Top 5 vs Bottom 5 Agent Experience and Rating
WITH Top5 AS (
    SELECT Agent_ID
    FROM Shipments
    GROUP BY Agent_ID
    ORDER BY AVG(Delay_Hours) ASC
    LIMIT 5
),

Bottom5 AS (
    SELECT Agent_ID
    FROM Shipments
    GROUP BY Agent_ID
    ORDER BY AVG(Delay_Hours) DESC
    LIMIT 5
)

SELECT 'Top 5 Agents' AS Agent_Group,
       ROUND(AVG(Avg_Rating),2) AS Avg_Rating,
       ROUND(AVG(Experience_Years),2) AS Avg_Experience
FROM Delivery_Agents
WHERE Agent_ID IN (
    SELECT Agent_ID
    FROM Top5
)

UNION ALL

SELECT 'Bottom 5 Agents',
       ROUND(AVG(Avg_Rating),2),
       ROUND(AVG(Experience_Years),2)
FROM Delivery_Agents
WHERE Agent_ID IN (
    SELECT Agent_ID
    FROM Bottom5
);


-- TASK 6

-- Query 31: Latest Shipment Status
SELECT Route_ID,
       ROUND(
           SUM(
               CASE
                   WHEN Delivery_Status IN ('In Transit','Returned')
                   THEN 1
                   ELSE 0
               END
           ) * 100.0 / COUNT(*),
           2
       ) AS Problem_Shipment_Percentage
FROM Shipments
GROUP BY Route_ID
HAVING Problem_Shipment_Percentage > 50;

-- Query 32: Routes With Majority In Transit or Returned Shipments
SELECT Route_ID,
       Delivery_Status,
       COUNT(*) AS Shipment_Count
FROM Shipments
WHERE Delivery_Status IN ('In Transit','Returned')
GROUP BY Route_ID, Delivery_Status
ORDER BY Shipment_Count DESC;

-- Query 33: Most Frequent Delay Reasons
SELECT Delay_Reason,
       COUNT(*) AS Occurrences
FROM Shipments
GROUP BY Delay_Reason
ORDER BY Occurrences DESC;

-- Query 34: Shipments Delayed More Than 120 Hours
SELECT *
FROM Shipments
WHERE Delay_Hours > 120;

-- TASK 7

-- Query 35: Average Delivery Delay Per Source Country
SELECT r.Source_Country,
       ROUND(AVG(s.Delay_Hours),2) AS Avg_Delay
FROM Routes r
JOIN Shipments s
ON r.Route_ID = s.Route_ID
GROUP BY r.Source_Country;

-- Query 36: On-Time Delivery Percentage (Within 2 Hours Delay)
SELECT ROUND(
           SUM(
               CASE
                   WHEN Delay_Hours <= 2 THEN 1
                   ELSE 0
               END
           ) * 100.0 / COUNT(*),
           2
       ) AS OnTimeDeliveryPercent
FROM Shipments;


-- Query 37: Average Daily Warehouse Utilization Percentage

SELECT w.Warehouse_ID,
       w.Capacity_per_day,
       ROUND(
           COUNT(s.Shipment_ID) /
           NULLIF(
               COUNT(DISTINCT DATE(s.Pickup_Date)),
               0
           ),
           2
       ) AS Avg_Shipments_Per_Day,
       ROUND(
           (
               COUNT(s.Shipment_ID) /
               NULLIF(
                   COUNT(DISTINCT DATE(s.Pickup_Date)),
                   0
               )
           ) * 100.0 /
           w.Capacity_per_day,
           2
       ) AS Avg_Utilization_Percentage
FROM Warehouses w
LEFT JOIN Shipments s
ON w.Warehouse_ID = s.Warehouse_ID
GROUP BY w.Warehouse_ID,
         w.Capacity_per_day
ORDER BY Avg_Utilization_Percentage DESC;