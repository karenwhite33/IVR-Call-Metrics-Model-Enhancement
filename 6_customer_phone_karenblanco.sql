--Para obtener un unico registro por cada ivr_call_id, identificar el # de telefono que no sea unknow o desconocido o pondra un null.

SELECT
    calls_ivr_id,
    MAX(CASE 
            WHEN customer_phone NOT IN ('UNKNOWN', 'DESCONOCIDO') THEN customer_phone
            ELSE NULL
        END) AS customer_phone

FROM keepcoding.ivr_detail
GROUP BY calls_ivr_id