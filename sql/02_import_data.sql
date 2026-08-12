-- Import the cleaned CSV files
-- Run this from the repository root in psql.
-- I used DBeaver for my own imports, but the same files can be loaded here.

\copy markets (
    market_id,
    census_metro_code,
    metro_name,
    state_region,
    total_population
)
FROM 'data/markets.csv'
WITH (FORMAT csv, HEADER true);

-- markets.csv already has market IDs, so reset the SERIAL sequence afterward.
SELECT setval(
    pg_get_serial_sequence('markets', 'market_id'),
    (SELECT MAX(market_id) FROM markets)
);

\copy foreign_born_population (
    market_id,
    year,
    country,
    cricket_region,
    population,
    acs_variable
)
FROM 'data/foreign_born_population.csv'
WITH (FORMAT csv, HEADER true);

\copy cricket_interest (
    market_id,
    year,
    trends_dma,
    interest_index
)
FROM 'data/cricket_interest_2023_2025.csv'
WITH (FORMAT csv, HEADER true);

\copy cricket_infrastructure (
    market_id,
    mlc_franchise_market,
    mlc_matches_2026,
    t20_wc_2024_host,
    official_wc_fan_park_2024,
    la28_cricket_host
)
FROM 'data/cricket_infrastructure.csv'
WITH (FORMAT csv, HEADER true);

\copy national_cricket_interest (
    week_date,
    year,
    interest_index
)
FROM 'data/national_cricket_interest_2023_2025.csv'
WITH (FORMAT csv, HEADER true);

-- Quick row-count check after the imports
SELECT COUNT(*) AS markets_rows FROM markets;                           -- 24
SELECT COUNT(*) AS foreign_born_rows FROM foreign_born_population;     -- 360
SELECT COUNT(*) AS market_trends_rows FROM cricket_interest;            -- 72
SELECT COUNT(*) AS infrastructure_rows FROM cricket_infrastructure;     -- 24
SELECT COUNT(*) AS national_weekly_rows FROM national_cricket_interest; -- 159
