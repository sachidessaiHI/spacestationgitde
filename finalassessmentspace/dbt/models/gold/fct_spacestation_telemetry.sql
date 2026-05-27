{{ config(
    materialized='view',
    unique_key='measure_timestamp'
) }}

WITH silver AS (
    SELECT * FROM {{ source('spacestation', 'silver_spacestation') }}
    {% if is_incremental() %}
        WHERE load_timestamp >= (SELECT MAX(load_timestamp) FROM {{ this }})
    {% endif %}
)

SELECT
    MD5(COALESCE(CAST(iss_id AS STRING), '_dbt_null_')) AS station_key,
    MD5(COALESCE(CAST(visibility AS STRING), '_dbt_null_')) AS visibility_key,
    measure_timestamp,
    source_file,
    units,
    latitude,
    longitude,
    altitude_km,
    velocity_kmh,
    footprint_km,
    daynum,
    solar_lat,
    solar_lon,
    load_timestamp
FROM silver