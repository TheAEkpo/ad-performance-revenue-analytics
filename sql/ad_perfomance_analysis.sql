/* ============================================================
   Created by : Agnes Ekpo
   Created on : 2025-04-15
   Purpose    : Transform and analyse ad performance data
   Tables     : performance_data, site_lookup
   Outputs    :
       1. revenue / impressions by date and site
       2. top ad units on Decoist (desktop)
       3. CPM by site/device for March
       4. seven-day revenue trend by site
   ============================================================ */


/*--------------------------------------------------------------
  Q1 – Daily revenue and impressions by site
  Business use: tracks monetisation trends and flags anomalies.
--------------------------------------------------------------*/

SELECT 
	date,
	site_name,
	SUM(revenue) AS total_revenue,
	SUM(impressions) AS total_impressions
FROM 
	performance_data
GROUP BY 
	date, site_name
ORDER BY 
	date, site_name;


/*--------------------------------------------------------------
  Q2 – Top-grossing ad units on Decoist (desktop only)
  Business use: identifies the placements that drive the most
  revenue, informing bid strategy and creative rotation.
--------------------------------------------------------------*/

SELECT
	ad_unit,
	SUM(revenue) AS total_revenue,
	SUM(impressions) AS total_impressions
FROM
	performance_data 
WHERE
	site_name = 'Decoist'
	AND device_category = 'Desktop'
GROUP BY  
	ad_unit 
ORDER BY 
	total_revenue DESC;


/*--------------------------------------------------------------
  Q3 – CPM, revenue, and impressions by site and device (March)
  Business use: normalises performance across inventory scale,
  surfaces the highest-ROI site-device pairs, and informs both
  pricing negotiations and device-specific creative strategy for
  upcoming monthly or seasonal budget reallocations.
--------------------------------------------------------------*/
-- Bind variables let analysts rerun the query for any window
-- Example in Snowflake-style syntax:
--   SET start_date = '2022-03-23';
--   SET end_date   = '2022-04-01';

SELECT 
	site_name,
	device_category,
	SUM(revenue) AS total_revenue,
	SUM(impressions) AS total_impressions,
	 /* CPM normalises revenue per 1 000 impressions.
       Rounded to four decimals for dashboard consistency. */
	ROUND(SUM(revenue)/ SUM(impressions) * 1000, 4) AS cpm
FROM
	performance_data
WHERE
	date>='2022-03-23' AND date <'2022-04-01'
GROUP BY 
	site_name,
	device_category 
ORDER BY
	site_name,
	device_category;


/*--------------------------------------------------------------
  Q4 – Seven-day revenue by site name (lookup join)
  Business use: powers rolling weekly dashboards, highlights early
  shifts in property performance, and enables rapid budget or
  traffic-routing decisions before small dips turn into revenue
  losses. Ideal for executive reporting and agile optimisation.
--------------------------------------------------------------*/

CREATE TABLE site_lookup ( -- If table does not exist.
    abbreviation TEXT,
    site_name TEXT
);

INSERT INTO site_lookup (abbreviation, site_name) VALUES 
('as', 'AbandonedSpaces'),
('dc', 'Decoist'),
('hp', 'HigherPerspective'),
('ip', 'IloveWWIIPlanes'),
('iw', 'Iwastesomuchtime'),
('or', 'OutdoorRevival'),
('mm', 'ManmadeDIY'),
('sr', 'SlowRobot'),
('wo', 'WarHistoryOnline'),
('ws', 'WallsWithStories'),
('to', 'TankRoar'),
('vn', 'TheVintageNews');
-- Lookup table ready

WITH max_date AS ( -- Filters for records in the last 7 days from the latest date in the table using CTE
    SELECT MAX(date) AS latest_date 
    FROM performance_data
),
last_7_days AS (
    SELECT *
    FROM performance_data, max_date
    WHERE date >= DATE(latest_date, '-6 days')
)
SELECT -- Join with site_lookup and Return Revenue by Site Name
    l.site_name,
    SUM(p.revenue) AS total_revenue
FROM 
    last_7_days p
JOIN 
    site_lookup l 
    ON p.site_abbreviation = l.abbreviation
GROUP BY 
    l.site_name
ORDER BY 
    total_revenue DESC;
