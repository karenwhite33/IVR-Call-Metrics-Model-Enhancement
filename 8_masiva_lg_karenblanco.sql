--por cada registro saber si paso por AVERIA_MASIVA CON UN 1 o SI NO PASO CON UN 0 - crear masiva_lg

SELECT
    calls_ivr_id,
    MAX(CASE
            WHEN module_name = 'AVERIA_MASIVA' THEN 1
            ELSE 0
        END) AS masiva_lg
FROM keepcoding.ivr_detail
GROUP BY calls_ivr_id