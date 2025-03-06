WITH last_year AS (
  SELECT * 
  FROM actors
  WHERE year = 2020
),
this_year AS (
  SELECT *
  FROM actor_films
  WHERE year = 2021
)

--DROP TABLE IF EXISTS actors 
INSERT INTO actors
SELECT DISTINCT 
  COALESCE(ly.actor, ty.actor) AS actor,
  COALESCE(ly.actorid, ty.actorid) AS actor_id,
  COALESCE(ly.films,ARRAY[]::films[]) || COALESCE(ARRAY_AGG(ROW(ty.film, ty.votes, ty.rating, ty.filmid)::films) FILTER (WHERE ty.film IS NOT NULL) OVER (PARTITION BY ty.actor, ty.actorid, ty.year),
												  ARRAY[]::films[]
												) AS films,
    CASE 
      WHEN ty.year IS NOT NULL THEN
        CASE 
          WHEN AVG(ty.rating) OVER (PARTITION BY ty.actor, ty.actorid, ty.year) > 8 THEN 'star'
          WHEN AVG(ty.rating) OVER (PARTITION BY ty.actor, ty.actorid, ty.year) > 7 THEN 'good'
          WHEN AVG(ty.rating) OVER (PARTITION BY ty.actor, ty.actorid, ty.year) > 6 THEN 'average'
          ELSE 'bad'
        END::quality_class
      ELSE ly.quality_class
    END AS quality_class,
  ty.year IS NOT NULL AS is_active,
  COALESCE(ly.year + 1, ty.year) AS year
FROM last_year ly
FULL OUTER JOIN this_year ty
ON ly.actorid = ty.actorid;

--SELECT * FROM actors WHERE actor = 'Dario Argento' AND YEAR = 1970
--DELETE FROM actors WHERE year = 1999;
--SELECT * FROM actors WHERE  actor = 'Brigitte Bardot' --YEAR = 2021