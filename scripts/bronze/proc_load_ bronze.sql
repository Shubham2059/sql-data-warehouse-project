/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.lond_bronze AS
BEGIN
	DECLARE @start_time DATETIME,@end_time DATETIME,@bronze_start_time DATETIME, @bronze_end_time DATETIME;
	SET @bronze_start_time = GETDATE();
	BEGIN TRY
		PRINT '=======================================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '=======================================================================';
		PRINT '-----------------------------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '-----------------------------------------------------------------------';
	---BULK INSERT into CSV info
	
		SET @start_time = GETDATE();
		PRINT '>>Truncation Table: [bronze].[crm_cust_info]';
	--1. CRM : cust_info
		Truncate TABLE [bronze].[crm_cust_info];
		PRINT '>>Inserting data into Table: [bronze].[crm_cust_info]';
		BULK INSERT [bronze].[crm_cust_info]
		FROM 'C:\Users\user\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: '+ CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-----------------------------------------------------------------------------------------------------------------';



		SET @start_time = GETDATE();
		--2. CRM: prd_info
		PRINT '>>Truncation Table: [bronze].[crm_prd_info]';
		Truncate table [bronze].[crm_prd_info]
		PRINT '>>Inserting data into Table: [bronze].[crm_prd_info]';
		BULK INSERT [bronze].[crm_prd_info]
		FROM 'C:\Users\user\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: '+ CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-----------------------------------------------------------------------------------------------------------------';


		SET @start_time = GETDATE();
		PRINT '>>Truncation Table: [bronze].[crm_sales_details]';
		--3. CRM: sales_details
		TRUNCATE TABLE [bronze].[crm_sales_details]
		PRINT '>>Inserting data into Table: [bronze].[crm_sales_details]';
		BULK INSERT [bronze].[crm_sales_details]
		FROM 'C:\Users\user\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: '+ CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-----------------------------------------------------------------------------------------------------------------';



		PRINT '-----------------------------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '-----------------------------------------------------------------------';
	
		
		SET @start_time = GETDATE();
		PRINT '>>Truncation Table: [bronze].[erp_cust_aZ12]';
		--1.0: ERP: CUST_AZ12
		TRUNCATE TABLE [bronze].[erp_cust_aZ12]
		PRINT '>>Inserting data into Table: [bronze].[erp_cust_aZ12]';
		BULK INSERT [bronze].[erp_cust_aZ12]
		FROM 'C:\Users\user\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: '+ CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-----------------------------------------------------------------------------------------------------------------';


		SET @start_time = GETDATE();
		PRINT '>>Truncation Table: [bronze].[erp_loc_a101]';
		--1.1: ERP: LOC_A101
		TRUNCATE TABLE [bronze].[erp_loc_a101]
		PRINT '>>Inserting data into Table: [bronze].[erp_loc_a101]';
		BULK INSERT [bronze].[erp_loc_a101]
		FROM 'C:\Users\user\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: '+ CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-----------------------------------------------------------------------------------------------------------------';


		SET @start_time = GETDATE();
		PRINT '>>Truncation Table: [bronze].[erp_px_cat_g1v2]';
		--1.2: PX_CAT_G1V2
		TRUNCATE TABLE [bronze].[erp_px_cat_g1v2]
		PRINT '>>Inserting data into Table: bronze].[erp_px_cat_g1v2]';
		BULK INSERT [bronze].[erp_px_cat_g1v2]
		FROM 'C:\Users\user\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: '+ CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-----------------------------------------------------------------------------------------------------------------';

		SET @bronze_end_time = GETDATE();
		PRINT '===========================================================================';
		PRINT 'LOADING BRONZE LAYER IS COMPLETED';
		PRINT ' - TOTAL LOAD DURATION: ' + CAST(DATEDIFF(second, @bronze_start_time, @bronze_end_time) AS NVARCHAR) + ' seconds';
		PRINT '===========================================================================';

	END TRY

	BEGIN CATCH
		PRINT '===========================================================================';
		PRINT 'ERROR OCCURED DURING LOADING THE BRONZE LAYER';
		PRINT 'ERROR MESSAGE:' + ERROR_MESSAGE();
		PRINT 'ERROR MESSAGE:' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR MESSAGE:' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '===========================================================================';
	END CATCH

END
