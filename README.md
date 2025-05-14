# Ad Performance & Revenue Analytics

This project analyses advertising data for a digital media and publishing company. The aim is to pinpoint which ad formats, channels, and sites drive revenue, understand delivery gaps, and recommend budget shifts that improve return on spend.

## Project objectives

1. **Data preparation**  
   - Parse the *Ad Unit* string to extract site abbreviations.  
   - Map abbreviations to full site names using the lookup table and remove unmatched rows.  
   - Save the cleaned file in `/data/ad_performance_clean.xlsx`. 

2. **Exploratory analysis**  
   - Identify top and bottom revenue sites for the last 7 days and the full month.  
   - Calculate each site’s share of monthly revenue.  
   - Compute CPM by site and device and measure fill rate.  
   - Detect the site with the largest CPM lift over 30 days and check for metric correlations.
     
3. **Executive visuals**  
   - Bar chart: nominal revenue by device.  
   - Stacked bar: daily impression mix by site.  
   - Line chart: daily CPM trend for the month. 

4. **Performance insight and recommendations**  
   - Flag any date where performance shifted and describe KPI impact.  
   - Summarise revenue, CPM, and fill-rate findings into clear optimisation actions.

5. **SQL reproducibility**  
   - Recreate core metrics in Snowflake-style SQL to validate results at warehouse scale.  
   - Include four queries: site revenue by date, desktop ad units on Decoist, March CPM by site and device, and seven-day revenue joined to site names. 

## Data and methods

| Step | Description | Tools |
|------|-------------|-------|
| Extraction | Ad server and billing tables exported to Excel | SQL |
| Cleaning | Site parsing, lookup join, error removal | SQL, Excel |
| Analysis | Pivot tables, custom metrics, correlation checks | Excel |
| Visualisation | Management charts for revenue and delivery | Excel (pivot charts) |
| Validation | Snowflake queries mirror Excel calculations | SQL |

## Folder guide

- **`data/`** Raw and cleaned datasets  
- **`sql/`** All transformation and aggregation scripts  
- **`notebooks/`** Optional step-by-step walk-through (Jupyter)  
- **`visuals/`** Charts referenced in this README  
- **`docs/`** One-page executive summary for quick review

## Author
Agnes Ekpo 
