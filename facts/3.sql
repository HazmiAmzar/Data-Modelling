WITH yesterday AS (
SELECT *
FROM user_devices_cumulated
WHERE date = DATE('2023-01-30')
),
	today AS (
	SELECT CAST(e.user_id AS TEXT) AS user_id, e.device_id AS device_id, d.browser_type AS browser_type, DATE(CAST(e.event_time AS TIMESTAMP)) AS date_active, ROW_NUMBER () OVER (PARTITION BY e.user_id, d.browser_type, e.event_time) AS row_num
	FROM events e
	JOIN devices d
	ON e.device_id = d.device_id 
	WHERE DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-31')
	AND e.user_id IS NOT NULL
	)

INSERT INTO user_devices_cumulated
SELECT DISTINCT COALESCE(t.user_id, y.user_id) AS user_id,
		COALESCE(t.browser_type, y.browser_type) AS browser_type,
		COALESCE(y.device_activity_datelist, ARRAY[]::DATE[]) || CASE WHEN t.user_id IS NOT NULL THEN ARRAY[t.date_active]
                										  			  ELSE ARRAY[]::DATE[]
                									 			 END AS device_activity_datelist,
		DATE(COALESCE(t.date_active, y.date + INTERVAL '1 day')) AS date
FROM today t
FULL OUTER JOIN yesterday y
ON t.user_id = y.user_id
WHERE t.row_num = 1;

--SELECT * FROM user_devices_cumulated
--WHERE user_id = '17358702759623100000'