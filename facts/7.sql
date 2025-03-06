--DROP TABLE host_activity_reduced

CREATE TABLE IF NOT EXISTS host_activity_reduced
(
	month_start      DATE,   
	host			 TEXT,
    hit_array        BIGINT[],
    unique_visitor	 BIGINT,
    date_partition 	 DATE,
    PRIMARY KEY (month_start, host, date_partition)
);