SELECT
    calls_ivr_id,
    MAX(CASE 
            WHEN billing_account_id NOT IN ('UNKNOWN' , 'DESCONOCIDO') THEN billing_account_id
            ELSE NULL
        END) AS billing_account_id

FROM keepcoding.ivr_detail
GROUP BY calls_ivr_id