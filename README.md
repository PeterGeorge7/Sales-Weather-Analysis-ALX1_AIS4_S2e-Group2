<p align="center">
  <img src="https://github.com/PeterGeorge7/Sales-Weather-Analysis-ALX1_AIS4_S2e-Group2/blob/main/Project%20Architecture.png" alt=""/>
</p>

# Sales Analysis Weather

## Project Overview
The **Sales Analysis Weather** project aims to explore the relationship between weather conditions and our sales performance, providing valuable insights to drive better business decisions. This solution integrates weather data with sales data to help understand how external factors, like weather, affect product demand and store performance.

## Technologies Used
The project was developed using the following technologies:
- **Azure Synapse Analytics** for data warehousing and pipelines.
- **Databricks** for processing data across Bronze, Silver, and Gold layers.
- **Azure SQL Database** for CDC (Change Data Capture) implementation.
- **Azure Data Lake Gen2** for data storage.
- **Delta Lake** format for data processing and storage optimization in Silver and Gold layers.
- **Power BI** for visualizing the results.
- **Azure Active Directory (AAD)** for security and access management.
- **SSIS** for certain data integration processes.
- **Azure Pipelines** for orchestrating workflows.

> **Note:** Configurations for setting up each tool required significant effort due to the intricacies of linking services securely and effectively.

## Data Sources
1. **Weather Data:** Obtained through an API.
2. **Sales and Business Data:** CSV files stored in Azure Data Lake Gen2, containing details of sales transactions, product information, customer demographics, and store data.

## Data Flow
The data flows through multiple layers in the pipeline:
1. **Bronze Layer (Raw Data):** This layer stores the raw parquet data collected from the API and CSV files. No transformations are applied at this stage.
2. **Silver Layer (Processed Data):** Data in the silver layer is processed using Databricks notebooks. We apply necessary transformations like cleaning, filtering, and adding metadata. Data is stored in Delta format.
3. **Gold Layer (Ready for Consumption):** In this layer, the cleaned and fully processed data is prepared for consumption, i.e., analytics, reporting, and machine learning models. Data is stored in Delta format for efficiency and ease of querying.

## CDC & SCD Type 2 Implementation
We implemented **Change Data Capture (CDC)** to track changes in the Azure SQL database and ensure that updates, inserts, and deletions are reflected in the data lake's raw layer.

For handling historical data, we employed **Slowly Changing Dimensions (SCD) Type 2**, which allows for maintaining a full history of changes in the data warehouse. This ensures that we can track how data changes over time. Although there were some issues in the final stages, the CDC and SCD solutions were designed to function smoothly under normal circumstances.

## Security
We ensured secure access to all resources through **Azure Active Directory (AAD)**. A dedicated security group for **Data Engineers** was created to manage access control, ensuring that only authorized personnel can view, edit, and manage sensitive data.

## Future Enhancements
While the project has been successfully implemented, we plan to enhance it further by:
1. **Incremental Data Loads:** Ensuring only changed or new data is processed in each pipeline run, which will optimize processing time and resource utilization.
2. **Streaming Data Processing:** Implementing a streaming solution to handle real-time weather data and instantaneously reflect its impact on sales.

## Conclusion
This project highlights the power of combining internal business data with external factors such as weather, to gain deeper insights. The end-to-end pipeline from data ingestion to reporting is robust, scalable, and ready for future enhancements, allowing the business to make more informed, data-driven decisions.
