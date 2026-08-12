-- Create the tables used in the project

DROP VIEW IF EXISTS market_opportunity_summary;

DROP TABLE IF EXISTS national_cricket_interest CASCADE;
DROP TABLE IF EXISTS cricket_infrastructure CASCADE;
DROP TABLE IF EXISTS cricket_interest CASCADE;
DROP TABLE IF EXISTS foreign_born_population CASCADE;
DROP TABLE IF EXISTS markets CASCADE;

CREATE TABLE markets (
    market_id SERIAL PRIMARY KEY,
    metro_name VARCHAR(100) NOT NULL,
    state_region VARCHAR(100) NOT NULL,
    census_metro_code VARCHAR(10) UNIQUE,
    total_population INTEGER NOT NULL
);

CREATE TABLE foreign_born_population (
    population_id SERIAL PRIMARY KEY,
    market_id INTEGER NOT NULL,
    year INTEGER NOT NULL,
    country VARCHAR(100) NOT NULL,
    cricket_region VARCHAR(50) NOT NULL,
    population INTEGER,
    acs_variable VARCHAR(20),
    FOREIGN KEY (market_id)
        REFERENCES markets(market_id)
);

CREATE TABLE cricket_interest (
    interest_id SERIAL PRIMARY KEY,
    market_id INTEGER NOT NULL,
    year INTEGER NOT NULL,
    trends_dma VARCHAR(150) NOT NULL,
    interest_index INTEGER,
    FOREIGN KEY (market_id)
        REFERENCES markets(market_id)
);

CREATE TABLE cricket_infrastructure (
    infrastructure_id SERIAL PRIMARY KEY,
    market_id INTEGER NOT NULL UNIQUE,
    mlc_franchise_market BOOLEAN NOT NULL,
    mlc_matches_2026 BOOLEAN NOT NULL,
    t20_wc_2024_host BOOLEAN NOT NULL,
    official_wc_fan_park_2024 BOOLEAN NOT NULL,
    la28_cricket_host BOOLEAN NOT NULL,
    FOREIGN KEY (market_id)
        REFERENCES markets(market_id)
);

CREATE TABLE national_cricket_interest (
    weekly_interest_id SERIAL PRIMARY KEY,
    week_date DATE NOT NULL,
    year INTEGER NOT NULL,
    interest_index INTEGER NOT NULL
);
