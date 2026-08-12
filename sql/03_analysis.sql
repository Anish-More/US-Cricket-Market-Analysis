-- U.S. Cricket Market Analysis
-- Main SQL analysis for the 24-market study

-- Data checks

SELECT COUNT(*) AS market_count
FROM markets;

SELECT COUNT(*) AS foreign_born_row_count
FROM foreign_born_population;

SELECT COUNT(*) AS cricket_interest_row_count
FROM cricket_interest;

SELECT COUNT(*) AS infrastructure_row_count
FROM cricket_infrastructure;

SELECT COUNT(*) AS national_weekly_row_count
FROM national_cricket_interest;


-- Demographics

-- Check the birthplace categories included in my cricket-connected measure.
SELECT DISTINCT country
FROM foreign_born_population
ORDER BY country;

-- Compare markets by total cricket-connected foreign-born population.
SELECT
    m.metro_name,
    SUM(fbp.population) AS cricket_connected_foreign_born
FROM markets m
JOIN foreign_born_population fbp
    ON m.market_id = fbp.market_id
GROUP BY
    m.market_id,
    m.metro_name
ORDER BY cricket_connected_foreign_born DESC;

-- I also wanted the share of each metro, since raw population favors larger cities.
SELECT
    m.metro_name,
    SUM(fbp.population) AS cricket_connected_foreign_born,
    m.total_population,
    ROUND(
        100.0 * SUM(fbp.population) / m.total_population,
        2
    ) AS cricket_connected_pct
FROM markets m
JOIN foreign_born_population fbp
    ON m.market_id = fbp.market_id
GROUP BY
    m.market_id,
    m.metro_name,
    m.total_population
ORDER BY cricket_connected_pct DESC;


-- Google Trends by market

-- 2024 rankings
SELECT
    m.metro_name,
    ci.interest_index
FROM markets m
JOIN cricket_interest ci
    ON m.market_id = ci.market_id
WHERE ci.year = 2024
ORDER BY ci.interest_index DESC;

-- Put the three yearly scores next to each other.
SELECT
    m.metro_name,
    MAX(CASE WHEN ci.year = 2023 THEN ci.interest_index END) AS interest_2023,
    MAX(CASE WHEN ci.year = 2024 THEN ci.interest_index END) AS interest_2024,
    MAX(CASE WHEN ci.year = 2025 THEN ci.interest_index END) AS interest_2025
FROM markets m
JOIN cricket_interest ci
    ON m.market_id = ci.market_id
GROUP BY m.metro_name
ORDER BY m.metro_name;

-- I rank markets within each year because the yearly Trends exports
-- were normalized separately.
SELECT
    m.metro_name,
    ci.year,
    ci.interest_index,
    RANK() OVER (
        PARTITION BY ci.year
        ORDER BY ci.interest_index DESC
    ) AS interest_rank
FROM markets m
JOIN cricket_interest ci
    ON m.market_id = ci.market_id
ORDER BY
    ci.year,
    interest_rank,
    m.metro_name;


-- Demographics vs. search interest

-- This lets me compare each market's demographic rank with its search-interest rank.
WITH demographics AS (
    SELECT
        m.market_id,
        m.metro_name,
        m.total_population,
        SUM(fbp.population) AS cricket_connected_foreign_born,
        ROUND(
            100.0 * SUM(fbp.population) / m.total_population,
            2
        ) AS cricket_connected_pct
    FROM markets m
    JOIN foreign_born_population fbp
        ON m.market_id = fbp.market_id
    GROUP BY
        m.market_id,
        m.metro_name,
        m.total_population
),
ranked_markets AS (
    SELECT
        d.market_id,
        d.metro_name,
        d.cricket_connected_pct,
        ci.year,
        ci.interest_index,
        RANK() OVER (
            PARTITION BY ci.year
            ORDER BY d.cricket_connected_pct DESC
        ) AS demographic_rank,
        RANK() OVER (
            PARTITION BY ci.year
            ORDER BY ci.interest_index DESC
        ) AS interest_rank
    FROM demographics d
    JOIN cricket_interest ci
        ON d.market_id = ci.market_id
)
SELECT
    metro_name,
    year,
    cricket_connected_pct,
    interest_index,
    demographic_rank,
    interest_rank,
    demographic_rank - interest_rank AS rank_gap
FROM ranked_markets
ORDER BY
    metro_name,
    year;


-- Multi-year interest and infrastructure

-- Average each market's yearly search-interest rank, then compare it with infrastructure.
WITH yearly_ranks AS (
    SELECT
        ci.market_id,
        ci.year,
        ci.interest_index,
        RANK() OVER (
            PARTITION BY ci.year
            ORDER BY ci.interest_index DESC
        ) AS interest_rank
    FROM cricket_interest ci
),
avg_ranks AS (
    SELECT
        market_id,
        ROUND(AVG(interest_rank), 2) AS avg_interest_rank
    FROM yearly_ranks
    GROUP BY market_id
),
demographics AS (
    SELECT
        m.market_id,
        ROUND(
            100.0 * SUM(fbp.population) / m.total_population,
            2
        ) AS cricket_connected_pct
    FROM markets m
    JOIN foreign_born_population fbp
        ON m.market_id = fbp.market_id
    GROUP BY
        m.market_id,
        m.total_population
)
SELECT
    m.metro_name,
    d.cricket_connected_pct,
    ar.avg_interest_rank,
    infra.mlc_franchise_market,
    infra.mlc_matches_2026,
    infra.t20_wc_2024_host,
    infra.official_wc_fan_park_2024,
    infra.la28_cricket_host
FROM avg_ranks ar
JOIN markets m
    ON ar.market_id = m.market_id
JOIN demographics d
    ON ar.market_id = d.market_id
JOIN cricket_infrastructure infra
    ON ar.market_id = infra.market_id
ORDER BY ar.avg_interest_rank;


-- Which high-interest markets did not have an MLC franchise in 2024?
WITH demographics AS (
    SELECT
        m.market_id,
        m.metro_name,
        ROUND(
            100.0 * SUM(fbp.population) / m.total_population,
            2
        ) AS cricket_connected_pct
    FROM markets m
    JOIN foreign_born_population fbp
        ON m.market_id = fbp.market_id
    GROUP BY
        m.market_id,
        m.metro_name,
        m.total_population
)
SELECT
    d.metro_name,
    d.cricket_connected_pct,
    ci.interest_index,
    infra.mlc_franchise_market,
    infra.mlc_matches_2026,
    infra.t20_wc_2024_host,
    infra.official_wc_fan_park_2024,
    infra.la28_cricket_host
FROM demographics d
JOIN cricket_interest ci
    ON d.market_id = ci.market_id
JOIN cricket_infrastructure infra
    ON d.market_id = infra.market_id
WHERE
    ci.year = 2024
    AND infra.mlc_franchise_market = FALSE
ORDER BY ci.interest_index DESC;


-- Which high-interest markets do not have 2026 MLC matches?
WITH demographics AS (
    SELECT
        m.market_id,
        m.metro_name,
        ROUND(
            100.0 * SUM(fbp.population) / m.total_population,
            2
        ) AS cricket_connected_pct
    FROM markets m
    JOIN foreign_born_population fbp
        ON m.market_id = fbp.market_id
    GROUP BY
        m.market_id,
        m.metro_name,
        m.total_population
)
SELECT
    d.metro_name,
    d.cricket_connected_pct,
    ci.interest_index,
    infra.mlc_franchise_market,
    infra.mlc_matches_2026,
    infra.t20_wc_2024_host,
    infra.official_wc_fan_park_2024,
    infra.la28_cricket_host
FROM demographics d
JOIN cricket_interest ci
    ON d.market_id = ci.market_id
JOIN cricket_infrastructure infra
    ON d.market_id = infra.market_id
WHERE
    ci.year = 2024
    AND infra.mlc_matches_2026 = FALSE
ORDER BY ci.interest_index DESC;


-- National weekly Google Trends

-- Summary within each separately normalized yearly series.
SELECT
    year,
    ROUND(AVG(interest_index), 2) AS avg_interest,
    MIN(interest_index) AS minimum_interest,
    MAX(interest_index) AS peak_interest
FROM national_cricket_interest
GROUP BY year
ORDER BY year;

-- Find the peak week(s) for each year.
SELECT
    year,
    week_date,
    interest_index
FROM national_cricket_interest
WHERE interest_index = 100
ORDER BY
    year,
    week_date;

-- Compare each year's peak with that same year's average weekly level.
SELECT
    year,
    ROUND(AVG(interest_index), 2) AS avg_interest,
    MAX(interest_index) AS peak_interest,
    ROUND(
        MAX(interest_index) / AVG(interest_index),
        2
    ) AS peak_to_average_ratio
FROM national_cricket_interest
GROUP BY year
ORDER BY year;
