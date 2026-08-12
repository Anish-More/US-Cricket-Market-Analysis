-- Final one-row-per-market summary

CREATE OR REPLACE VIEW market_opportunity_summary AS
WITH yearly_ranks AS (
    SELECT
        ci.market_id,
        ci.year,
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
        m.total_population
)
SELECT
    m.market_id,
    m.metro_name,
    m.state_region,
    m.total_population,
    d.cricket_connected_foreign_born,
    d.cricket_connected_pct,
    ar.avg_interest_rank,
    infra.mlc_franchise_market,
    infra.mlc_matches_2026,
    infra.t20_wc_2024_host,
    infra.official_wc_fan_park_2024,
    infra.la28_cricket_host
FROM markets m
JOIN demographics d
    ON m.market_id = d.market_id
JOIN avg_ranks ar
    ON m.market_id = ar.market_id
JOIN cricket_infrastructure infra
    ON m.market_id = infra.market_id;

-- Quick check of the final view
SELECT *
FROM market_opportunity_summary
ORDER BY avg_interest_rank;
