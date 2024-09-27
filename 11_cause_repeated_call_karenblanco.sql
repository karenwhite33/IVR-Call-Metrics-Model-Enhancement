SELECT
    ivr_id,
    (CASE
        WHEN TIMESTAMP_DIFF(LEAD (start_date) OVER(PARTITION BY phone_number ORDER BY start_date), start_date, HOUR) <= 24
        THEN 1
        ELSE 0
    END) AS cause_recall_phone_24H,

    (CASE
        WHEN TIMESTAMP_DIFF(start_date, LAG(start_date) OVER(PARTITION BY phone_number ORDER BY start_date), HOUR) <= 24
        THEN 1
        ELSE 0
    END) AS repeated_phone_24H

FROM keepcoding.ivr_calls
GROUP BY ivr_id, start_date, phone_number
