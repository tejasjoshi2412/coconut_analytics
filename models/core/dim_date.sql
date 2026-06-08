WITH date_spine AS (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="'2010-01-01'::DATE",
        end_date="'2031-01-01'::DATE"
    ) }}
),

date_details AS (
    SELECT
        date_day,
        YEAR(date_day) AS year,
        QUARTER(date_day) AS quarter,
        MONTH(date_day) AS month,
        MONTHNAME(date_day) AS month_name,
        DAYOFYEAR(date_day) AS day_of_year,
        DAYOFMONTH(date_day) AS day_of_month,
        DAYOFWEEK(date_day) AS day_of_week,
        DAYNAME(date_day) AS day_name,
        WEEKOFYEAR(date_day) AS week_of_year,
        DAYOFWEEK(date_day) IN (0, 6) AS is_weekend,
        CASE
            WHEN DAYOFWEEK(date_day) = 0 THEN 'Sunday'
            WHEN DAYOFWEEK(date_day) = 1 THEN 'Monday'
            WHEN DAYOFWEEK(date_day) = 2 THEN 'Tuesday'
            WHEN DAYOFWEEK(date_day) = 3 THEN 'Wednesday'
            WHEN DAYOFWEEK(date_day) = 4 THEN 'Thursday'
            WHEN DAYOFWEEK(date_day) = 5 THEN 'Friday'
            WHEN DAYOFWEEK(date_day) = 6 THEN 'Saturday'
        END AS day_of_week_name,
        DATE_TRUNC('WEEK', date_day) AS week_start_date,
        DATEADD(DAY, 6, DATE_TRUNC('WEEK', date_day)) AS week_end_date,
        DATE_TRUNC('MONTH', date_day) AS month_start_date,
        DATEADD(DAY, -1, DATEADD(MONTH, 1, DATE_TRUNC('MONTH', date_day))) AS month_end_date,
        DATE_TRUNC('QUARTER', date_day) AS quarter_start_date,
        DATEADD(DAY, -1, DATEADD(QUARTER, 1, DATE_TRUNC('QUARTER', date_day))) AS quarter_end_date,
        DATE_TRUNC('YEAR', date_day) AS year_start_date,
        DATEADD(DAY, -1, DATEADD(YEAR, 1, DATE_TRUNC('YEAR', date_day))) AS year_end_date,
        CASE
            WHEN DAYOFWEEK(date_day) IN (0, 6) THEN 0
            ELSE 1
        END AS is_business_day
    FROM date_spine
)

SELECT
    TO_NUMBER(TO_CHAR(date_day, 'YYYYMMDD')) AS date_key,
    date_day AS full_date,
    year,
    quarter,
    CONCAT('Q', quarter) AS quarter_label,
    month,
    month_name,
    CONCAT(month_name, ' ', year) AS month_label,
    day_of_year,
    day_of_month,
    day_of_week,
    day_of_week_name,
    day_name,
    week_of_year,
    week_start_date,
    week_end_date,
    month_start_date,
    month_end_date,
    quarter_start_date,
    quarter_end_date,
    year_start_date,
    year_end_date,
    is_weekend,
    is_business_day
FROM date_details
ORDER BY date_day
