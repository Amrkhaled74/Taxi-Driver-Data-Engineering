# 🚕 NYC Taxi dbt Transformation Layer

This dbt Layer handles the **Transformation step** of the ELT pipeline for NYC Taxi data. It transforms raw CSV data loaded into Snowflake into an **analytics-ready Star Schema** for Power BI.

---

## 📂 Project Structure

The project follows a **Bronze → Silver → Gold** approach:

- **Staging (`models/staging`)**: Cleans raw field names, casts data types, and applies initial filtering.  
- **Core/Dimensions (`models/core`)**: Creates dimension tables (Passenger_Count, Vendor, Trip Distance, Date, Location, Rate Code, Trip Type, Payment Type).  
- **Mart/Facts (`models/mart`)**: Joins dimensions and calculates metrics (Fare, MTA Tax, Tip, Tolls, Improvement Surcharge, Total Amount).

---

## 🌟 Data Model (Star Schema)

### **Dimension Tables**

| Table Name | Primary Key | Columns |
|------------|------------|---------|
| **Passenger_Count_Dim** | Passenger_Count_Id_sk | Passenger_Count |
| **Vendor_Dim** | Vendor_Id_sk | VendorId, Vendor_Name |
| **Trip_Distance_Dim** | Trip_Distance_Id_sk | Trip_Distance |
| **Date_Dim** | Date_Time_Id_sk | Year, Month, Day, Pickup_Datetime, Dropoff_Datetime |
| **Location_Dim** | Location_Id_sk | Pickup_Location, Dropoff_Location |
| **Rate_Code_Dim** | Ratecode_Id_sk | Ratecodeid, Ratecode_Name |
| **Trip_Type_Dim** | Trip_Type_Id_sk | Trip_Type, Trip_Type_Name |
| **Payment_Type_Dim** | Payment_Type_Id_sk | Payment_Type, Payment_Type_Name |

### **Fact Table**

| Table Name | Foreign Keys | Measures / Columns |
|------------|--------------|------------------|
| **Taxi_Driver_Fact** | Vendor_Id (FK), Passenger_Count_Id (FK), Date_Time_Id (FK), Trip_Distance_Id (FK), Location_Id (FK), Ratecode_Id (FK), Payment_Type_Id (FK), Trip_Type_Id (FK) | Fare_Amount, Mta_Tax, Tip_Amount, Tolls_Amount, Improvement_Surcharge, Total_Amount |

✅ **Notes**:  

- All **FKs** point to the respective dimension tables.  
- Fact table combines metrics (fare, tips, taxes, total amount) with dimensions to support analytics.  
- This schema supports a **star schema design** optimized for Power BI and analytics.  

---

## ⚙️ Setup & Configuration

### Prerequisites

- Python 3.x
- `dbt-snowflake` installed:
```bash
pip install dbt-snowflake
