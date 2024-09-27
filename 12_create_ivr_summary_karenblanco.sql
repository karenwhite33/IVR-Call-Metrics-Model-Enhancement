--clean_integer

CREATE OR REPLACE FUNCTION keepcoding.clean_integer(VALUE INT64)
RETURNS INT64
AS(
    CASE
    WHEN VALUE IS NULL THEN -999999
    ELSE VALUE
END
);

--Creacion de tabla ivr_summary con CTEs base_date con datos de ivr_detail

CREATE OR REPLACE TABLE keepcoding.ivr_summary AS
WITH base_data AS(
    SELECT 
    calls_ivr_id AS ivr_id,
    calls_phone_number AS phone_number,
    calls_ivr_result AS ivr_result,
    calls_start_date AS start_date,
    calls_end_date AS end_date,
    keepcoding.clean_integer(calls_total_duration) AS total_duration,
    COALESCE(NULLIF(calls_customer_segment, 'UNKNOWN'), 'DESCONOCIDO') AS customer_segment,
    COALESCE(NULLIF(calls_ivr_language, 'UNKNOWN'), 'DESCONOCIDO') AS ivr_language,
    calls_steps_module AS steps_module,
    calls_module_aggregation AS module_aggregation

FROM keepcoding.ivr_detail
),

--queries ejercicios 4 al 11

vdn_agg_cte AS(
    SELECT
    calls_ivr_id,
    MAX(CASE
            WHEN LEFT(calls_vdn_label, 3) = 'ATC' THEN 'FRONT'
            WHEN LEFT(calls_vdn_label, 4) = 'TECH' THEN 'TECH'
            WHEN calls_vdn_label = 'ABSORPTION' THEN 'ABSORPTION'
            ELSE 'RESTO'
        END) AS vdn_aggregation
    FROM keepcoding.ivr_detail
    GROUP BY calls_ivr_id

),

document_type_cte AS(
    SELECT
    calls_ivr_id,
    MAX(CASE
            WHEN document_type NOT IN ('UNKNOWN', 'DESCONOCIDO') THEN document_type
            ELSE 'DESCONOCIDO'
        END) AS document_type,

    MAX(CASE
            WHEN document_type NOT IN ('UNKNOWN', 'DESCONOCIDO') AND document_identification NOT IN ('UNKNOWN', 'DESCONOCIDO') THEN document_identification
            ELSE 'DESCONOCIDO'
        END) AS document_identification
    FROM keepcoding.ivr_detail
    GROUP BY calls_ivr_id
),

customer_phone_cte AS(
    SELECT
    calls_ivr_id,
    MAX(CASE
            WHEN customer_phone NOT IN ('UNKNOWN', 'DESCONOCIDO') THEN customer_phone
            ELSE 'DESCONOCIDO'
        END) AS customer_phone
    FROM keepcoding.ivr_detail
    GROUP BY calls_ivr_id
),

billing_account_id_cte AS(
    SELECT
    calls_ivr_id,
    MAX(CASE
            WHEN billing_account_id NOT IN ('UNKNOWN', 'DESCONOCIDO') THEN billing_account_id
            ELSE 'DESCONOCIDO'
        END) AS billing_account_id
    FROM keepcoding.ivr_detail
    GROUP BY calls_ivr_id
),

masiva_lg_cte AS(
    SELECT
    calls_ivr_id,
    MAX(CASE
            WHEN module_name = 'AVERIA_MASIVA' THEN 1 
            ELSE 0
        END) AS masiva_lg
    FROM keepcoding.ivr_detail
    GROUP BY calls_ivr_id
),

info_by_phone_lg_cte AS(
    SELECT
    calls_ivr_id,
    MAX(CASE
            WHEN step_name = 'CUSTOMERINFOBYPHONE.TX' AND step_result = 'OK' THEN 1
            ELSE 0
        END) AS info_by_phone_lg
    FROM keepcoding.ivr_detail
    GROUP BY calls_ivr_id

),

info_by_dni_lg_cte AS(
    SELECT
    calls_ivr_id,
    MAX(CASE
            WHEN step_name = 'CUSTOMERINFOBYDNI.TX' AND step_result = 'OK' THEN 1
            ELSE 0
        END) AS info_by_dni_lg
    FROM keepcoding.ivr_detail
    GROUP BY calls_ivr_id
),

repeated_phone_24H_cte AS(
    SELECT
    calls_ivr_id,
        (CASE WHEN TIMESTAMP_DIFF(LEAD(calls_start_date) OVER(PARTITION BY calls_phone_number ORDER BY calls_start_date), calls_start_date, HOUR)<=24
              THEN 1 
              ELSE 0 
         END) AS cause_recall_phone_24H,
        (CASE WHEN TIMESTAMP_DIFF(calls_start_date, LAG(calls_start_date) OVER(PARTITION BY calls_phone_number ORDER BY calls_start_date), HOUR) <=24 
              THEN 1
              ELSE 0
         END) AS repeated_phone_24H
    FROM keepcoding.ivr_detail
    GROUP BY calls_ivr_id, calls_start_date, calls_phone_number
)

SELECT

    base_data.ivr_id,
    base_data.phone_number,
    base_data.ivr_result,
    vdn_agg_cte.vdn_aggregation,
    base_data.start_date,
    base_data.end_date,
    base_data.total_duration,
    base_data.customer_segment,
    base_data.ivr_language,
    base_data.steps_module,
    base_data.module_aggregation,
    document_type_cte.document_type,
    document_type_cte.document_identification,
    customer_phone_cte.customer_phone,
    billing_account_id_cte.billing_account_id,
    masiva_lg_cte.masiva_lg,
    info_by_phone_lg_cte.info_by_phone_lg,
    info_by_dni_lg_cte.info_by_dni_lg,
    repeated_phone_24H_cte.repeated_phone_24H,
    repeated_phone_24H_cte.cause_recall_phone_24H,

FROM base_data
LEFT JOIN vdn_agg_cte ON base_data.ivr_id =  vdn_agg_cte.calls_ivr_id
LEFT JOIN document_type_cte ON base_data.ivr_id = document_type_cte.calls_ivr_id
LEFT JOIN customer_phone_cte ON base_data.ivr_id = customer_phone_cte.calls_ivr_id
LEFT JOIN billing_account_id_cte ON base_data.ivr_id = billing_account_id_cte.calls_ivr_id
LEFT JOIN masiva_lg_cte ON base_data.ivr_id = masiva_lg_cte.calls_ivr_id
LEFT JOIN info_by_phone_lg_cte ON base_data.ivr_id = info_by_phone_lg_cte.calls_ivr_id
LEFT JOIN info_by_dni_lg_cte ON base_data.ivr_id = info_by_dni_lg_cte.calls_ivr_id
LEFT JOIN repeated_phone_24H_cte ON base_data.ivr_id = repeated_phone_24H_cte.calls_ivr_id;





