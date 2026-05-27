{{ config(
    materialized='view'
) }}

WITH source AS (
    SELECT DISTINCT
        iss_id,
        iss_name
    FROM {{ source('spacestation', 'silver_spacestation') }}
    WHERE iss_id IS NOT NULL
)

SELECT
    MD5(COALESCE(CAST(iss_id AS STRING), '_dbt_null_')) AS station_key,
    iss_id,
    iss_name
FROM source