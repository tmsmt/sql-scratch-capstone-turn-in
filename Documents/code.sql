
-- 1.1.sql

SELECT COUNT(DISTINCT utm_campaign) as 'Distinct campaigns'
FROM page_visits;

SELECT COUNT(DISTINCT utm_source) as 'Distinct sources'
FROM page_visits;

SELECT DISTINCT utm_source, 
      			utm_campaign
FROM page_visits;

-- 1.2.sql

SELECT DISTINCT page_name
FROM page_visits;

-- 2.1.sql

WITH first_touch AS (
	SELECT user_id,
           MIN(timestamp) AS first_touch_at
    FROM page_visits
    GROUP BY user_id),
first_touch2 AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM   first_touch ft
  JOIN   page_visits pv
    ON   ft.user_id = pv.user_id
   AND   ft.first_touch_at = pv.timestamp)
    
SELECT first_touch2.utm_campaign AS 'Campaign',
	   first_touch2.utm_source   AS 'Source',
       COUNT(*)
FROM   first_touch2
GROUP BY 1
ORDER BY 3 DESC;

-- 2.2.sql

WITH last_touch AS (
  SELECT user_id,
         MAX(timestamp) as last_touch_at
  FROM page_visits
  GROUP BY user_id),
last_touch2 AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_campaign,
         pv.utm_source,
         pv.page_name
  FROM   last_touch lt
  JOIN   page_visits pv
    ON   lt.user_id = pv.user_id
   AND   lt.last_touch_at = pv.timestamp)

SELECT last_touch2.utm_campaign AS 'Campaign',
	   last_touch2.utm_source   AS 'Source',
       COUNT(*)
FROM   last_touch2
GROUP BY 1
ORDER BY 3 DESC;

-- 2.3.sql

select page_name,
       count(distinct user_id)
from page_visits
where page_name = '4 - purchase';

-- 2.4.sql

WITH last_touch AS (
  SELECT user_id,
         MAX(timestamp) as last_touch_at
  FROM page_visits
  WHERE page_name = '4 - purchase'
  GROUP BY user_id),
last_touch2 AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_campaign,
         pv.utm_source,
         pv.page_name
  FROM   last_touch lt
  JOIN   page_visits pv
    ON   lt.user_id = pv.user_id
   AND   lt.last_touch_at = pv.timestamp
   )

SELECT last_touch2.utm_campaign AS 'Campaign',
	   last_touch2.utm_source   AS 'Source',
       COUNT(*)
FROM   last_touch2
GROUP BY 1
ORDER BY 3 DESC;

