WITH yesterday AS (
    SELECT *
    FROM host_activity_reduced
    WHERE date_partition = '2022-12-31'
),
     today AS (
         SELECT host,
                DATE_TRUNC('day', DATE(event_time)) AS today_date,
                COUNT(1) as num_hits,
                count(DISTINCT(user_id)) AS unique_visitor
         FROM events
         WHERE DATE_TRUNC('day', DATE(event_time)) = DATE('2023-01-01')
         AND host IS NOT NULL
         GROUP BY host, DATE_TRUNC('day', DATE(event_time))
     )

INSERT INTO host_activity_reduced

SELECT
	DATE('2023-01-01') as month_start,    	
	COALESCE(y.host, t.host) AS host,
    COALESCE(y.hit_array, array_fill(NULL::BIGINT, ARRAY[DATE('2023-01-01') - DATE('2022-12-31')])) || ARRAY[t.num_hits] AS hits_array,
    t.unique_visitor,
	DATE('2023-01-01') AS date_partition
FROM yesterday y
FULL OUTER JOIN today t
ON y.host = t.host