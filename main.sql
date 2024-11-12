WITH airport_details AS (
  SELECT
    lookup_region.country_iso_code_2 AS country_code, 
    lookup_region.region_description, 
    airport_traffic.date, 
    airport_traffic.airport_name
  FROM
    `bigquery-public-data.covid19_geotab_mobility_impact_eu.lookup_region` AS lookup_region
  LEFT JOIN
    `bigquery-public-data.covid19_geotab_mobility_impact_eu.airport_traffic` AS airport_traffic
  ON
    lookup_region.country_iso_code_2 = airport_traffic.country_iso_code_2
  WHERE
    airport_traffic.date BETWEEN '2021-08-01' AND '2021-08-10'
),
percent_baseline AS (
  SELECT
    country_iso_code_2, 
    percent_of_baseline, 
    date
  FROM
    `bigquery-public-data.covid19_geotab_mobility_impact_eu.airport_traffic`
  WHERE
    date BETWEEN '2021-08-01' AND '2021-08-10'
)
SELECT
  airport_details.country_code,
  airport_details.region_description,
  airport_details.airport_name,
  IFNULL(CAST(percent_baseline.percent_of_baseline AS STRING), '> 50%') AS percent_of_baseline,
  airport_details.date
FROM
  airport_details
LEFT JOIN
  percent_baseline
ON
  airport_details.country_code = percent_baseline.country_iso_code_2
  AND airport_details.date = percent_baseline.date
  AND percent_baseline.percent_of_baseline <= 50
ORDER BY 
  percent_baseline.percent_of_baseline DESC,
  airport_details.date
LIMIT 1000;