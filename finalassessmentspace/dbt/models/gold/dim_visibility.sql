{{ config(
    materialized='view'
) }}

WITH source AS (
    SELECT DISTINCT
        visibility
    FROM {{ source('spacestation', 'silver_spacestation') }}
    WHERE visibility IS NOT NULL
)

SELECT
    MD5(COALESCE(CAST(visibility AS STRING), '_dbt_null_')) AS visibility_key,
    visibility
FROM source