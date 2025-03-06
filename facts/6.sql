WITH yesterday AS (
	SELECT *
	FROM hosts_cumulated
	WHERE date = DATE('2023-01-30')
),
	today AS (
	SELECT e.host AS host, DATE(CAST(e.event_time AS TIMESTAMP)) AS date_active, ROW_NUMBER () OVER (PARTITION BY e.user_id, e.event_time) AS row_num
	FROM events e
	WHERE DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-31')
	AND e.user_id IS NOT NULL
	)
	
INSERT INTO hosts_cumulated
SELECT DISTINCT COALESCE(t.host, y.host) AS host,
		COALESCE(y.host_activity_datelist, ARRAY[]::DATE[]) || CASE WHEN t.host IS NOT NULL THEN ARRAY[t.date_active]
                										  			  ELSE ARRAY[]::DATE[]
                									 			 END AS host_activity_datelist,
		DATE(COALESCE(t.date_active, y.date + INTERVAL '1 day')) AS date
FROM today t
FULL OUTER JOIN yesterday y
ON t.host = y.host
WHERE t.row_num = 1;

SELECT * FROM hosts_cumulated;