-- ============================================================
-- Vancouver Business Landscape Analysis
-- 03 - Business Analysis
--
-- Purpose:
-- Analyse business activity across categories, licence years,
-- and Vancouver neighbourhoods using the cleaned analytical view.
-- ============================================================


-- 1. Top business categories
SELECT
    business_type,
    COUNT(*) AS licence_count
FROM business_licences_latest
GROUP BY business_type
ORDER BY licence_count DESC
LIMIT 15;


-- 2. Business activity by neighbourhood
SELECT
    localarea,
    COUNT(*) AS licence_count
FROM business_licences_latest
WHERE localarea IS NOT NULL
GROUP BY localarea
ORDER BY licence_count DESC;


-- 3. Issued licences by folder year
SELECT
    folderyear,
    COUNT(*) AS issued_licences
FROM business_licences_latest
WHERE status = 'Issued'
GROUP BY folderyear
ORDER BY folderyear;

-- 4. Issued licences by actual issue year
SELECT
    EXTRACT(YEAR FROM issueddate)::INTEGER AS issue_year,
    COUNT(*) AS issued_licences
FROM business_licences_latest
WHERE status = 'Issued'
  AND issueddate IS NOT NULL
GROUP BY issue_year
ORDER BY issue_year;

-- 5. Year-to-date comparison: 2025 vs 2026
-- Uses the dataset extraction date (August 16, 2026)
-- to ensure an equal comparison period.

SELECT
    EXTRACT(YEAR FROM issueddate)::INTEGER AS issue_year,
    COUNT(*) AS issued_licences
FROM business_licences_latest
WHERE status = 'Issued'
  AND (
        issueddate BETWEEN DATE '2025-01-01' AND DATE '2025-08-16'
        OR
        issueddate BETWEEN DATE '2026-01-01' AND DATE '2026-08-16'
      )
GROUP BY issue_year
ORDER BY issue_year;

-- 6. Overall YTD growth: 2025 vs 2026
WITH ytd_licences AS (
    SELECT
        EXTRACT(YEAR FROM issueddate)::INTEGER AS issue_year,
        COUNT(*) AS licence_count
    FROM business_licences_latest
    WHERE status = 'Issued'
      AND (
          issueddate BETWEEN DATE '2025-01-01' AND DATE '2025-08-16'
          OR
          issueddate BETWEEN DATE '2026-01-01' AND DATE '2026-08-16'
      )
    GROUP BY EXTRACT(YEAR FROM issueddate)
),
year_comparison AS (
    SELECT
        MAX(CASE WHEN issue_year = 2025 THEN licence_count END) AS licences_2025_ytd,
        MAX(CASE WHEN issue_year = 2026 THEN licence_count END) AS licences_2026_ytd
    FROM ytd_licences
)
SELECT
    licences_2025_ytd,
    licences_2026_ytd,
    licences_2026_ytd - licences_2025_ytd AS absolute_change,
    ROUND(
        (licences_2026_ytd - licences_2025_ytd) * 100.0
        / licences_2025_ytd,
        2
    ) AS percentage_change
FROM year_comparison;

-- 7. YTD growth by business category: 2025 vs 2026
WITH category_ytd AS (
    SELECT
        business_type,
        EXTRACT(YEAR FROM issueddate)::INTEGER AS issue_year,
        COUNT(*) AS licence_count
    FROM business_licences_latest
    WHERE status = 'Issued'
      AND (
          issueddate BETWEEN DATE '2025-01-01' AND DATE '2025-08-16'
          OR
          issueddate BETWEEN DATE '2026-01-01' AND DATE '2026-08-16'
      )
    GROUP BY
        business_type,
        EXTRACT(YEAR FROM issueddate)
),
category_comparison AS (
    SELECT
        business_type,
        COALESCE(MAX(CASE WHEN issue_year = 2025
                          THEN licence_count END), 0) AS licences_2025_ytd,
        COALESCE(MAX(CASE WHEN issue_year = 2026
                          THEN licence_count END), 0) AS licences_2026_ytd
    FROM category_ytd
    GROUP BY business_type
)
SELECT
    business_type,
    licences_2025_ytd,
    licences_2026_ytd,
    licences_2026_ytd - licences_2025_ytd AS absolute_change,
    CASE
        WHEN licences_2025_ytd > 0 THEN
            ROUND(
                (licences_2026_ytd - licences_2025_ytd) * 100.0
                / licences_2025_ytd,
                2
            )
        ELSE NULL
    END AS percentage_change
FROM category_comparison
ORDER BY absolute_change DESC
LIMIT 15;

-- 8. Business categories with the largest YTD decline: 2025 vs 2026
WITH category_ytd AS (
    SELECT
        business_type,
        EXTRACT(YEAR FROM issueddate)::INTEGER AS issue_year,
        COUNT(*) AS licence_count
    FROM business_licences_latest
    WHERE status = 'Issued'
      AND (
          issueddate BETWEEN DATE '2025-01-01' AND DATE '2025-08-16'
          OR
          issueddate BETWEEN DATE '2026-01-01' AND DATE '2026-08-16'
      )
    GROUP BY
        business_type,
        EXTRACT(YEAR FROM issueddate)
),
category_comparison AS (
    SELECT
        business_type,
        COALESCE(
            MAX(CASE WHEN issue_year = 2025 THEN licence_count END),
            0
        ) AS licences_2025_ytd,
        COALESCE(
            MAX(CASE WHEN issue_year = 2026 THEN licence_count END),
            0
        ) AS licences_2026_ytd
    FROM category_ytd
    GROUP BY business_type
)
SELECT
    business_type,
    licences_2025_ytd,
    licences_2026_ytd,
    licences_2026_ytd - licences_2025_ytd AS absolute_change,
    CASE
        WHEN licences_2025_ytd > 0 THEN
            ROUND(
                (licences_2026_ytd - licences_2025_ytd) * 100.0
                / licences_2025_ytd,
                2
            )
        ELSE NULL
    END AS percentage_change
FROM category_comparison
ORDER BY absolute_change ASC
LIMIT 15;

-- 9. YTD licence growth by neighbourhood: 2025 vs 2026
WITH neighbourhood_ytd AS (
    SELECT
        localarea,
        EXTRACT(YEAR FROM issueddate)::INTEGER AS issue_year,
        COUNT(*) AS licence_count
    FROM business_licences_latest
    WHERE status = 'Issued'
      AND localarea IS NOT NULL
      AND localarea NOT IN ('Out of Town', 'UBC')
      AND (
          issueddate BETWEEN DATE '2025-01-01' AND DATE '2025-08-16'
          OR
          issueddate BETWEEN DATE '2026-01-01' AND DATE '2026-08-16'
      )
    GROUP BY
        localarea,
        EXTRACT(YEAR FROM issueddate)
),
neighbourhood_comparison AS (
    SELECT
        localarea,
        COALESCE(
            MAX(CASE WHEN issue_year = 2025 THEN licence_count END),
            0
        ) AS licences_2025_ytd,
        COALESCE(
            MAX(CASE WHEN issue_year = 2026 THEN licence_count END),
            0
        ) AS licences_2026_ytd
    FROM neighbourhood_ytd
    GROUP BY localarea
)
SELECT
    localarea,
    licences_2025_ytd,
    licences_2026_ytd,
    licences_2026_ytd - licences_2025_ytd AS absolute_change,
    CASE
        WHEN licences_2025_ytd > 0 THEN
            ROUND(
                (licences_2026_ytd - licences_2025_ytd) * 100.0
                / licences_2025_ytd,
                2
            )
        ELSE NULL
    END AS percentage_change
FROM neighbourhood_comparison
ORDER BY absolute_change DESC;

-- 10. Top business categories within each neighbourhood
WITH neighbourhood_categories AS (
    SELECT
        localarea,
        business_type,
        COUNT(*) AS licence_count
    FROM business_licences_latest
    WHERE status = 'Issued'
      AND localarea IS NOT NULL
      AND localarea NOT IN ('Out of Town', 'UBC')
    GROUP BY
        localarea,
        business_type
),
ranked_categories AS (
    SELECT
        localarea,
        business_type,
        licence_count,
        RANK() OVER (
            PARTITION BY localarea
            ORDER BY licence_count DESC
        ) AS category_rank
    FROM neighbourhood_categories
)
SELECT
    localarea,
    business_type,
    licence_count,
    category_rank
FROM ranked_categories
WHERE category_rank <= 3
ORDER BY localarea, category_rank;

-- 11. Employment profile by business category
SELECT
    business_type,
    COUNT(*) AS licence_count,
    SUM(numberofemployees) AS reported_employees,
    ROUND(AVG(numberofemployees), 2) AS avg_employees,
    PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY numberofemployees) AS median_employees
FROM business_licences_latest
WHERE status = 'Issued'
  AND numberofemployees > 0
GROUP BY business_type
HAVING COUNT(*) >= 100
ORDER BY reported_employees DESC
LIMIT 15;
PERCENTILE_CONT(0.5)