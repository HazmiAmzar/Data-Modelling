SELECT * FROM generate_series(1970,2021)

CREATE TYPE films AS (
film TEXT,
votes INTEGER,
rating REAL,
filmid TEXT)

CREATE TYPE quality_class AS ENUM ('star', 'good', 'average', 'bad')

--DROP TABLE IF EXISTS actors
CREATE TABLE IF NOT EXISTS actors(
actor TEXT,
actorid TEXT,
films films[],
quality_class quality_class,
is_active BOOLEAN,
year INTEGER,
PRIMARY KEY (actorid, year))