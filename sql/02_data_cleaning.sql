-- ============================================================
-- Vancouver Business Landscape Analysis
-- 02 - Data Cleaning
--
-- Purpose:
-- Create an analytical view containing only the latest
-- revision of each business licence.
--
-- Raw source data remains unchanged.
-- ============================================================


CREATE OR REPLACE VIEW business_licences_latest AS
WITH ranked_licences AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY licencenumber
            ORDER BY licences_revision_number DESC
        ) AS revision_rank
    FROM business_licences
)
SELECT *
FROM ranked_licences
WHERE revision_rank = 1;


-- Validate the analytical view
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT licencenumber) AS unique_licences
FROM business_licences_latest;