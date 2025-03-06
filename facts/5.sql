--DROP TABLE hosts_cumulated

CREATE TABLE IF NOT EXISTS hosts_cumulated(
host TEXT,
host_activity_datelist DATE[],
date DATE,
PRIMARY KEY (host, date)
)

--SELECT * FROM events ;
--SELECT * FROM devices ;