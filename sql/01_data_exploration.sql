-- ============================================================
-- Vancouver Business Landscape Analysis
-- 01 - Data Exploration
--
-- Purpose:
-- Perform initial validation and exploration of the
-- City of Vancouver Business Licences dataset.
-- ============================================================


-- 1. Dataset size
SELECT COUNT(*) AS total_rows
FROM business_licences;


-- 2. Dataset overview
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT licencenumber) AS unique_licences,
    COUNT(DISTINCT business_type) AS business_types,
    COUNT(DISTINCT localarea) AS neighbourhoods
FROM business_licences;


-- 3. Records by licence year
SELECT
    folderyear,
    COUNT(*) AS licences
FROM business_licences
GROUP BY folderyear
ORDER BY folderyear;


-- 4. Date coverage
SELECT
    MIN(folderyear) AS min_year,
    MAX(folderyear) AS max_year,
    MIN(issueddate) AS earliest_issue,
    MAX(issueddate) AS latest_issue
FROM business_licences;


-- 5. Missing values in key analytical fields
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(businessname) AS missing_business_name,
    COUNT(*) - COUNT(business_type) AS missing_business_type,
    COUNT(*) - COUNT(localarea) AS missing_localarea,
    COUNT(*) - COUNT(issueddate) AS missing_issued_date,
    COUNT(*) - COUNT(numberofemployees) AS missing_employees,
    COUNT(*) - COUNT(feepaid) AS missing_fee
FROM business_licences;


-- 6. Licence status distribution
SELECT
    status,
    COUNT(*) AS licence_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM business_licences
GROUP BY status
ORDER BY licence_count DESC;


-- 7. Revision number distribution
SELECT
    licences_revision_number,
    COUNT(*) AS records
FROM business_licences
GROUP BY licences_revision_number
ORDER BY licences_revision_number;


-- 8. Licences with multiple revisions
SELECT
    licencenumber,
    COUNT(*) AS records,
    MAX(licences_revision_number) AS latest_revision
FROM business_licences
GROUP BY licencenumber
HAVING COUNT(*) > 1
ORDER BY records DESC
LIMIT 20;


-- 9. Employee field validation
SELECT
    COUNT(*) FILTER (WHERE numberofemployees = 0) AS zero_employees,
    COUNT(*) FILTER (WHERE numberofemployees > 0) AS positive_employees,
    MIN(numberofemployees) AS min_employees,
    MAX(numberofemployees) AS max_employees,
    ROUND(AVG(numberofemployees), 2) AS avg_employees
FROM business_licences;