--SELECT * FROM actors_history_scd where actor = 'Fred Astaire'

INSERT INTO actors_history_scd
WITH with_previous AS (
SELECT 
	actor,
	actorid,
	year,
	quality_class,
	is_active,
	LAG(quality_class, 1) OVER (PARTITION BY actorid ORDER BY year) AS previous_quality_class,
	LAG(is_active, 1) OVER (PARTITION BY actorid ORDER BY year) AS previous_is_active
FROM actors
WHERE year <= 2020),

with_indicators AS (
SELECT *, 
		CASE WHEN quality_class <> previous_quality_class THEN 1
			 WHEN is_active <> previous_is_active THEN 1	 
			 ELSE 0
		END AS change_indicator
FROM with_previous),

with_streaks AS (
SELECT *, 
SUM(change_indicator) OVER (PARTITION BY actorid ORDER BY year) AS streak_identifier
FROM with_indicators)

SELECT 
	actor,
	actorid,
	quality_class,
	is_active, 
	min(year) AS start_date, 
	max(year) AS end_date,
	2020 AS current_year
FROM with_streaks
GROUP BY actor, actorid, streak_identifier, is_active, quality_class
ORDER BY actor, actorid, streak_identifier
