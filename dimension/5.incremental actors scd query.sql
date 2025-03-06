--CREATE TYPE actors_scd_type AS (
--quality_class quality_class,
--is_active boolean,
--start_date INTEGER,
--end_date INTEGER)

WITH last_season_scd AS (
SELECT * 
FROM actors_history_scd 
WHERE current_year = 2020
AND end_date = 2020
),

historical_scd AS (
SELECT actor, actorid, quality_class, is_active, start_date, end_date
FROM actors_history_scd
WHERE current_year = 2020
AND end_date < 2020),

this_season_data AS (
SELECT *
FROM actors
WHERE YEAR = 2021),

unchanged_records AS (
SELECT ts.actor, ts.actorid, ts.quality_class, ts.is_active, ls.start_date, ts.year AS end_date
FROM this_season_data ts
JOIN last_season_scd ls
ON ts.actorid = ls.actorid
WHERE ts.quality_class = ls.quality_class
AND ts.is_active = ls.is_active),

changed_records AS (
SELECT ts.actor, ts.actorid, UNNEST(ARRAY[ROW(ls.quality_class, ls.is_active, ls.start_date, ls.end_date)::actors_scd_type, ROW(ts.quality_class, ts.is_active, ts.year, ts.year )::actors_scd_type]) AS records
FROM this_season_data ts
LEFT JOIN last_season_scd ls
ON ts.actorid = ls.actorid
WHERE ts.quality_class <> ls.quality_class
OR ts.is_active <> ls.is_active),

unnest_changed_records AS (
SELECT actor, actorid, (records::actors_scd_type).quality_class, (records::actors_scd_type).is_active, (records::actors_scd_type).start_date, (records::actors_scd_type).end_date
FROM changed_records),

new_records AS (
SELECT ts.actor, ts.actorid, ts.quality_class, ts.is_active, ts.year AS start_date, ts.year AS end_date
FROM this_season_data ts
LEFT JOIN last_season_scd ls
ON ts.actorid = ls.actorid
WHERE ls.actorid IS NULL )

SELECT *, 2021 AS current_year
FROM (
		SELECT * FROM historical_scd
		
		UNION ALL
		
		SELECT * FROM unchanged_records
		
		UNION ALL 
		
		SELECT * FROM unnest_changed_records
		
		UNION ALL 
		
		SELECT * FROM new_records)
