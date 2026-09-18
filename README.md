# DHL Logistics Supply Chain Optimization Using SQL

## 📌 Project Overview

**DHL Logistics Supply Chain Optimization Using SQL** is a data analytics project focused on analyzing logistics and supply-chain operations to identify shipment delays, inefficient transportation routes, warehouse performance issues, and delivery-agent performance. The project uses structured logistics data across **Orders, Shipments, Routes, Warehouses, and Delivery Agents** and analyzes the relationships between these entities using **MySQL**. The objective is to transform raw operational data into meaningful insights that can help improve delivery efficiency, reduce delays, optimize warehouse operations, and enhance overall customer satisfaction.

---

## 🎯 Project Objectives

The main objectives of this project are to:

* Validate and assess the quality of logistics data.
* Identify routes with high shipment delays.
* Analyze transportation route efficiency.
* Identify routes requiring optimization.
* Evaluate warehouse performance and utilization.
* Analyze delivery-agent performance.
* Identify frequent shipment delay reasons.
* Monitor problematic and extremely delayed shipments.
* Calculate important logistics KPIs.
* Provide data-driven recommendations for improving operational efficiency.

---

## 🏢 Business Problem

DHL handles a large volume of shipments across different routes, warehouses, and delivery agents. Operational problems such as **shipment delays, inefficient routes, warehouse congestion, and inconsistent delivery-agent performance** can affect delivery reliability and customer satisfaction.

This project analyzes historical logistics data to answer questions such as:

* Which routes experience the highest delays?
* Which routes have lower transportation efficiency?
* Which routes should be prioritized for optimization?
* Which warehouses have higher delay levels?
* How efficiently are warehouses being utilized?
* Which delivery agents have better or poorer delivery performance?
* What are the most common reasons for shipment delays?
* How many shipments experience extreme delays?
* What is the overall on-time delivery percentage?

---

## 📊 Dataset

The project uses **5 Excel datasets** containing information about different aspects of DHL's logistics operations.

| Dataset                    | Records | Description                                                                       |
| -------------------------- | ------: | --------------------------------------------------------------------------------- |
| `DHL_orders.xlsx`          |     300 | Order, customer, route, warehouse, amount, delivery type, and payment information |
| `DHL_Shipments.xlsx`       |   1,000 | Shipment, pickup, delivery, status, delay, feedback, and delay-reason information |
| `DHL_routes.xlsx`          |      20 | Source/destination locations, distance, and average transit-time information      |
| `DHL_warehouses.xlsx`      |      10 | Warehouse location, daily capacity, and manager information                       |
| `DHL_delivery_agents.xlsx` |      50 | Delivery-agent information including zone, experience, and average rating         |

### Dataset Columns

#### Orders

* `Order_ID`
* `Customer_ID`
* `Order_Date`
* `Route_ID`
* `Warehouse_ID`
* `Order_Amount`
* `Delivery_Type`
* `Payment_Mode`

#### Shipments

* `Shipment_ID`
* `Order_ID`
* `Agent_ID`
* `Route_ID`
* `Warehouse_ID`
* `Pickup_Date`
* `Delivery_Date`
* `Delivery_Status`
* `Delay_Hours`
* `Delivery_Feedback`
* `Delay_Reason`
* `Expected_Delivery_Date`

#### Routes

* `Route_ID`
* `Source_City`
* `Source_Country`
* `Destination_City`
* `Destination_Country`
* `Distance_KM`
* `Avg_Transit_Time_Hours`

#### Warehouses

* `Warehouse_ID`
* `City`
* `Country`
* `Capacity_per_day`
* `Manager_Name`

#### Delivery Agents

* `Agent_ID`
* `Agent_Name`
* `Zone`
* `Zone_Country`
* `Experience_Years`
* `Avg_Rating`

---

## 🔗 Data Relationships

The datasets are connected through common identifiers.

```text
Orders
   │
   ├── Order_ID
   ├── Route_ID ──────────> Routes
   └── Warehouse_ID ──────> Warehouses
           
Shipments
   │
   ├── Order_ID ──────────> Orders
   ├── Route_ID ──────────> Routes
   ├── Warehouse_ID ──────> Warehouses
   └── Agent_ID ──────────> Delivery Agents
```

These relationships allow information from multiple tables to be combined for deeper analysis.

---

## 🛠️ Tools & Technologies

* **MySQL** — Database querying and analysis
* **Microsoft Excel** — Source datasets
* **Microsoft PowerPoint** — Project presentation and findings

### SQL Concepts Used

* `SELECT`
* `WHERE`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* `LIMIT`
* `COUNT()`
* `SUM()`
* `AVG()`
* `ROUND()`
* `CASE WHEN`
* `INNER JOIN`
* `LEFT JOIN`
* `CTE (Common Table Expressions)`
* `RANK()`
* `PARTITION BY`
* `TIMESTAMPDIFF()`
* `NULLIF()`
* `UNION ALL`

---

## 🔄 Project Methodology

The project follows the following analytical workflow:

```text
Excel Datasets
      ↓
Load Data into MySQL
      ↓
Data Cleaning & Validation
      ↓
Delay Analysis
      ↓
Route Optimization
      ↓
Warehouse Analysis
      ↓
Delivery-Agent Performance Analysis
      ↓
Shipment Monitoring
      ↓
KPI Calculation
      ↓
Business Insights
      ↓
Recommendations
```

---

# 🔍 Analysis Performed

## 1. Data Cleaning & Validation

Before performing business analysis, the data was validated to ensure that the results would be reliable.

The following checks were performed:

* Duplicate Order IDs
* Duplicate Shipment IDs
* Missing `Delay_Hours`
* Invalid pickup and delivery dates
* Orders with invalid route relationships
* Orders with invalid warehouse relationships
* Shipments with invalid order relationships
* Shipments with invalid delivery-agent relationships

### Findings

* **No duplicate order records were identified.**
* **No duplicate shipment records were identified.**
* **No missing `Delay_Hours` values were identified.**
* **No invalid shipment dates were identified.**
* **All checked table relationships were valid.**

Since no missing delay values were found, delay-value imputation was not required.

---

## 2. Shipment Delay Analysis

Shipment delays were analyzed at the route level to identify routes with higher average delays.

### Analysis Performed

* Average delay per route
* Top 10 delayed routes
* Shipment transit time
* Delay ranking within warehouses
* Average delay by delivery type

The average delay was calculated using:

```sql
AVG(Delay_Hours)
```

Routes were then ordered by average delay to identify areas requiring attention.

### Key Finding

**Route R002 was identified as an important high-delay route requiring optimization.**

---

## 3. Route Optimization Analysis

Route performance was evaluated using three main metrics:

### Average Delay

Measures the average number of hours by which shipments are delayed on a route.

### Efficiency Ratio

The project calculates route efficiency as:

```text
Efficiency Ratio = Distance_KM / Avg_Transit_Time_Hours
```

This provides a distance-per-hour measure based on the route's distance and average transit time.

### Delay Percentage

The percentage of shipments with a delay greater than zero was calculated for each route.

Routes with a delay percentage greater than **20%** were also identified.

### Lowest-Efficiency Routes

The three routes with the lowest efficiency ratio identified in the analysis were:

* **R002**
* **R007**
* **R020**

These routes were highlighted for further investigation and optimization.

### Routes Recommended for Optimization

The project also identified the **top 5 routes by average shipment delay** as routes requiring optimization.

---

## 4. Warehouse Performance Analysis

Warehouse performance was analyzed using:

* Average shipment delay
* Number of shipments
* Number of delayed shipments
* Delay percentage
* On-time delivery percentage
* Average daily shipment volume
* Average warehouse utilization

### Warehouse Utilization

Average daily utilization was calculated by comparing the average number of shipments processed per day with the warehouse's daily capacity.

```text
Average Utilization %
=
Average Shipments Per Day / Capacity Per Day × 100
```

### Key Insight

Warehouses operating at high utilization levels may face greater operational pressure and potential congestion.

The analysis therefore provides a basis for monitoring warehouse workloads and balancing capacity where necessary.

---

## 5. Delivery-Agent Performance Analysis

Delivery-agent performance was analyzed using:

* Average delay
* On-time delivery percentage
* Experience in years
* Average rating

The project performed several analyses, including:

* Ranking agents by on-time delivery percentage within each route
* Identifying agents with on-time delivery below 85%
* Identifying the top 5 agents based on average delay
* Identifying the bottom 5 agents based on average delay
* Comparing the experience and ratings of the top and bottom groups

### Key Insight

The project observed that agents with higher experience and ratings **generally showed better performance in the analyzed dataset**.

This observation represents an association in the dataset and does not by itself establish that experience or rating causes better performance.

---

## 6. Shipment Monitoring

Shipment status and delay information were analyzed to identify potentially problematic shipments and routes.

The analysis included:

* Shipment-status monitoring
* Routes with a high proportion of `In Transit` or `Returned` shipments
* Frequency of different delay reasons
* Shipments with extreme delays

### Key Findings

* **Traffic was identified as the most frequent delay reason.**
* Some shipments experienced delays of **more than 120 hours**.
* Certain routes showed conditions requiring additional monitoring.

Shipments delayed by more than 120 hours were specifically extracted for further investigation.

---

# 📈 Key Performance Indicators

The project identified the following headline KPIs:

| KPI                                 | Result |
| ----------------------------------- | -----: |
| Duplicate Records                   |      0 |
| Missing Delay Hours                 |      0 |
| Invalid Dates                       |      0 |
| Highest-Delay Route                 |   R002 |
| On-Time Delivery                    |    54% |
| Routes Recommended for Optimization |      5 |

### On-Time Delivery Definition

For this project, a shipment is considered **on-time when `Delay_Hours <= 2`**.

The overall on-time delivery percentage was calculated using this definition and resulted in **54%**.

---

# 💡 Key Insights

The analysis produced several important operational insights:

1. **R002 was identified as a high-delay route** and requires further investigation and optimization.

2. **R002, R007, and R020** were identified among the lowest-efficiency routes based on the distance-to-transit-time efficiency ratio.

3. Some routes had a relatively high percentage of delayed shipments, indicating the need for closer monitoring.

4. Warehouse performance varies based on average delay, delay percentage, on-time delivery, and utilization.

5. Delivery-agent performance can be compared using average delay and on-time delivery percentage.

6. **Traffic was the most frequently occurring delay reason** in the analyzed shipment data.

7. Some shipments experienced **extreme delays exceeding 120 hours**, making them important cases for investigation.

8. Overall on-time delivery was **54%** based on the project's two-hour delay threshold.

---

# 📌 Business Recommendations

Based on the analysis, the following recommendations were proposed:

### 1. Optimize High-Delay Routes

Prioritize routes with consistently high average delays, particularly **R002**, for operational investigation.

Possible areas for investigation include route planning, scheduling, traffic conditions, and alternative transportation options.

### 2. Monitor Warehouse Utilization

Monitor warehouses with high utilization and balance shipment workloads where required to reduce potential congestion.

### 3. Improve Delivery-Agent Performance

Identify agents with lower on-time delivery percentages and provide appropriate operational support or training.

### 4. Investigate Extreme Delays

Shipments delayed by more than **120 hours** should be reviewed individually to identify the underlying operational causes.

### 5. Implement Predictive Monitoring

A future analytics solution could use historical shipment data to predict the probability of delay before a shipment becomes significantly delayed, allowing earlier intervention.

---

# 🚀 Future Scope

The current project focuses primarily on SQL-based descriptive and diagnostic analytics. It can be extended further by incorporating:

* Real-time shipment tracking
* Live traffic information
* Weather data
* Transportation costs
* Historical time-series analysis
* Customer-level service metrics
* Predictive delay modeling
* Machine learning
* Interactive BI dashboards

A future predictive system could follow this workflow:

```text
Historical Logistics Data
          ↓
Feature Engineering
          ↓
Machine Learning Model
          ↓
Delay Risk Prediction
          ↓
High-Risk Shipment Identification
          ↓
Early Operational Intervention
```

This would move the analysis from primarily **reactive monitoring toward predictive logistics management**.

---

# 📁 Repository Structure

```text
DHL-Logistics-Supply-Chain-Optimization/
│
├── README.md
│
├── SQL/
│   └── DHL_Logistics_Analysis.sql
│
├── Dataset/
│   ├── DHL_orders.xlsx
│   ├── DHL_Shipments.xlsx
│   ├── DHL_routes.xlsx
│   ├── DHL_warehouses.xlsx
│   └── DHL_delivery_agents.xlsx
│
└── Presentation/
    └── DHL_Logistics_Project.pptx
```

---

# 🧠 Key Learning Outcomes

Through this project, I gained practical experience in:

* Working with relational logistics datasets
* Data validation using SQL
* Joining multiple tables
* Aggregating operational metrics
* Calculating business KPIs
* Conditional aggregation using `CASE WHEN`
* Using CTEs for intermediate analysis
* Using window functions and ranking
* Analyzing logistics delays
* Evaluating route efficiency
* Analyzing warehouse utilization
* Comparing delivery-agent performance
* Translating SQL results into business insights and recommendations

---

# 📄 Project Files

* **SQL Analysis:** `SQL/DHL_Logistics_Analysis.sql`
* **Datasets:** `Dataset/`
* **Project Presentation:** `Presentation/DHL_Logistics_Project.pptx`

---

## 👩‍💻 Author

**Suhani**

This project was created as a SQL-based logistics and supply-chain analytics project to demonstrate practical data analysis, SQL querying, and business-insight generation.
