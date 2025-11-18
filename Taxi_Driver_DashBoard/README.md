📊 Power BI Analytics & Reporting

This directory contains the Power BI Dashboard (.pbix) file, which serves as the front-end analytics layer for the NYC Taxi Data Pipeline. It connects directly to the Snowflake Star Schema transformed by dbt.

💡 Dashboard Overview

The dashboard provides interactive insights into taxi operations, revenue trends, and driver performance. It helps stakeholders answer questions like:

Which locations generate the highest revenue?

What are the peak hours for taxi trips?

How does payment type affect tip amounts?

📑 Pages & Features

🏠 Executive Overview

High-level summary for business stakeholders.

KPI Cards: Total Revenue, Total Trips, Average Trip Distance, Average Fare.

Trend Analysis: Monthly and weekly revenue trends.

Vendor Performance: Comparison between Creative Mobile Technologies vs. VeriFone Inc.

🚕 Operations & Logistics

Detailed drill-down into trip specifics.

Trip Distribution: Analysis of long vs. short trips.

Payment Breakdown: Cash vs. credit card usage ratios.

🔌 Data Connection

Connects to Snowflake using Import mode.

Source: Snowflake Data Warehouse (TAXI_DRIVER_DB)

Schema: Taxi (Transformed Star Schema)

Data Warehouse: Taxi_driver_wh

DATABASE: TAXI_DRIVER_DB


🛠 Setup & Usage

Prerequisites

Microsoft Power BI Desktop installed

Snowflake ODBC Driver (ensure it’s up to date)

Opening the Dashboard

Clone the repository

Navigate to the power_bi/ folder

Open NYC_Taxi_Analytics.pbix

Updating Credentials

Go to File → Options and settings → Data source settings

Select the Snowflake entry

Edit credentials with your Snowflake username and password

Click Refresh on the Home ribbon to load the latest data

🎨 Color Palette & Design

Background: Dark Slate (#0F172A)

Accents: Cyan (#36BCF7), Warning Orange (#F2C811), Success Green (#4EAA25)

High-contrast dark theme for better visibility and readability