CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
SELECT 
    cal.ivr_id AS calls_ivr_id,
    cal.phone_number AS calls_phone_number,
    cal.ivr_result AS calls_ivr_result,
    cal.vdn_label AS calls_vdn_label,
    cal.start_date AS calls_start_date, 
    FORMAT_DATE('%Y%m%d', DATE(TIMESTAMP(cal.start_date))) AS calls_start_date_id,
    cal.end_date AS calls_end_date, 
    FORMAT_DATE('%Y%m%d', DATE(TIMESTAMP(cal.end_date))) AS calls_end_date_id,
    IFNULL(cal.total_duration, 0) AS calls_total_duration, 
    IFNULL(cal.customer_segment, 'UNKNOWN') AS calls_customer_segment, 
    IFNULL(cal.ivr_language, 'UNKNOWN') AS calls_ivr_language, 
    cal.steps_module AS calls_steps_module,
    cal.module_aggregation AS calls_module_aggregation,

    IFNULL(modu.module_sequece, -999999) AS  module_sequece,
    IFNULL(modu.module_name, 'UNKNOWN') AS module_name,
    IFNULL(modu.module_duration, 0) AS module_duration,
    IFNULL(modu.module_result, 'UNKNOWN') AS module_result,

    IFNULL(st.step_sequence, -999999) AS step_sequence, 
    COALESCE(NULLIF(st.step_name, 'NULL'), 'UNKNOWN') AS step_name, 
    COALESCE(NULLIF(st.step_result, 'NULL'),'UNKNOWN') AS step_result, 
    IFNULL(st.step_description_error, 'UNKNOWN') AS step_description_error, 
    IFNULL(st.document_type,'UNKNOWN')  AS document_type, 
    IFNULL(st.document_identification,'UNKNOWN')  AS document_identification, 
    IFNULL(st.customer_phone, 'UNKNOWN')  AS customer_phone, 
    IFNULL(st.billing_account_id, 'UNKNOW') AS billing_account_id


FROM `keepcoding.ivr_calls` cal
LEFT
JOIN `keepcoding.ivr_modules` modu
ON cal.ivr_id = modu.ivr_id
LEFT
JOIN `keepcoding.ivr_steps` st
ON  modu.ivr_id = st.ivr_id
AND modu.module_sequece = st.module_sequece
