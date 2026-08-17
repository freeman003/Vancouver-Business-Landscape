# Vancouver Business Landscape Analysis

## Overview

This project analyzes Vancouver business licence activity using open data from the City of Vancouver.

The project combines **PostgreSQL** for data cleaning and analysis with **Power BI** for interactive visualization. The cleaned dataset contains **199,204 licence records**, with the latest revision retained for each licence.

Data was analyzed through **August 16, 2026**.

---

## Objectives & Key Questions

The project focuses on understanding Vancouver's business landscape and recent licence activity.

Key questions include:

- Which business categories account for the most issued licences?
- Which Vancouver neighbourhoods have the highest licence activity?
- How did issued licence activity change between equivalent periods in 2025 and 2026?
- Which business categories contributed most to recent growth?
- How does the business mix differ across neighbourhoods?
- Which business categories report the highest employment?

---

## Potential Stakeholders

The analysis may be useful for:

- **City planners and economic development teams** monitoring local business activity.
- **Business associations** evaluating industry and neighbourhood trends.
- **Entrepreneurs and investors** exploring business concentrations across Vancouver.
- **Commercial real estate professionals** assessing areas with high business activity.
- **Researchers and policy analysts** studying Vancouver's local economy.

---

## Tools

- **PostgreSQL & SQL** — cleaning, transformation and analysis
- **Power BI** — dashboards and interactive visualization
- **DAX** — KPIs and YTD calculations
- **GitHub** — project documentation and version control

---

## Methodology

### 1. Data Exploration & Cleaning
The raw dataset contained multiple revisions of some business licences. SQL window functions were used to retain only the **latest revision per licence**, producing **199,204 analytical records**.

### 2. Business & Neighbourhood Analysis
SQL aggregations were used to analyze licence activity by:

- Business category
- Vancouver neighbourhood
- Licence status and year
- Reported employment

Window functions were also used to identify the leading business categories within individual neighbourhoods.

### 3. YTD Comparison
Because 2026 is incomplete, the analysis compares equivalent periods:

**Jan 1 – Aug 16, 2025 vs Jan 1 – Aug 16, 2026**

This avoids comparing a full year with a partial year.

### 4. Employment Analysis
Reported employee counts were analyzed using both averages and medians. `PERCENTILE_CONT()` was used to calculate median employment because large employers can strongly influence averages.

### 5. Power BI
The cleaned PostgreSQL view was connected to Power BI, where DAX measures and interactive dashboards were created.

---

## Key Findings

- The analytical dataset contains **199,204 licences**, of which **167,505** have an Issued status.
- Issued licence activity increased from **15,884 in 2025 YTD** to **22,272 in 2026 YTD**, an increase of approximately **40.2%**.
- **Long-term Rental** is the largest licence category, while Health Care, General Contractors and Short-term Rental Operators are also prominent.
- **Downtown** has the highest concentration of business licences, followed by areas including Fairview, Kitsilano and Mount Pleasant.
- Business composition varies substantially across neighbourhoods. For example, Legal Services are particularly prominent Downtown, while Health Care has a strong presence in Fairview.
- Reported employment is highly skewed in several categories, making median employment an important complement to the average.

> **Note:** Licence activity should not be interpreted directly as business formation or overall economic growth. A business may hold multiple licences, and licensing practices can affect year-to-year comparisons. Business licences are generally renewed periodically, so licence issuance does not necessarily represent new business formation.

---

## Power BI Dashboard

### Executive Overview

High-level KPIs and the leading business categories and Vancouver neighbourhoods.

![executive_overview](images/executive_overview.png)

### Business Trends & Insights

Comparison of 2025 and 2026 YTD activity, reported employment, and interactive Business Type and Neighbourhood filters.

![business_trends_insights](images/business_trends_insights.png)

---

## Repository Structure

```text
Vancouver-Business-Landscape/
├── images/
├── powerbi/
│   └── Vancouver_Business_Landscape.pbix
├── sql/
│   ├── 01_data_exploration.sql
│   ├── 02_data_cleaning.sql
│   └── 03_business_analysis.sql
└── README.md
```

---

## SQL Skills Demonstrated

`CTEs` • `GROUP BY` • `CASE WHEN` • `Window Functions` • `ROW_NUMBER()` • `RANK()` • `PERCENTILE_CONT()` • `Conditional Aggregation` • `Date Filtering` • `YTD Analysis`

---

## Project Workflow

**City of Vancouver Open Data → PostgreSQL → SQL Cleaning & Analysis → Power BI → DAX → Interactive Dashboard**
