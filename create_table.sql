/* The date format in the CSV file is DD-MM-YY, 
so I need to parse it when importing data into SQL Server. */

-- Create the main table
CREATE TABLE amazon_sales_2025 (
    order_id VARCHAR(20),
    date DATE,
    product VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2),
    quantity INT,
    total_sales DECIMAL(10, 2),
    customer_name VARCHAR(100),
    customer_location VARCHAR(100),
    payment_method VARCHAR(50),
    status VARCHAR(30)
);

-- Create a staging table
CREATE TABLE amazon_sales_staging (
    order_id VARCHAR(20),
    date VARCHAR(20),
    product VARCHAR(100),
    category VARCHAR(50),
    price VARCHAR(20),
    quantity VARCHAR(20),
    total_sales VARCHAR(20),
    customer_name VARCHAR(100),
    customer_location VARCHAR(100),
    payment_method VARCHAR(50),
    status VARCHAR(30)
);

-- Load data into the staging table
BULK INSERT amazon_sales_staging
FROM '/var/opt/mssql/data/amazon_sales_data 2025.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- Insert into the main table, parsing the date
INSERT INTO amazon_sales_2025
SELECT
    order_id,
    CONVERT(DATE, date, 3),
    product,
    category,
    CAST(price AS DECIMAL(10,2)),
    CAST(quantity AS INT),
    CAST(total_sales AS DECIMAL(12,2)),
    customer_name,
    customer_location,
    payment_method,
    REPLACE(REPLACE(status, CHAR(13), ''), CHAR(10), '') AS status
FROM amazon_sales_staging;

-- Clean up the staging table
DROP TABLE amazon_sales_staging;