CREATE USER postgres;
CREATE ROLE postgres;
CREATE DATABASE hosts;
GRANT ALL PRIVILEGES ON DATABASE hosts TO postgres;

CREATE TABLE IF NOT EXISTS hosts (
  id SERIAL PRIMARY KEY,
  host_name varchar(45),
  ip_address varchar(45),
  uptime varchar(45)
)
