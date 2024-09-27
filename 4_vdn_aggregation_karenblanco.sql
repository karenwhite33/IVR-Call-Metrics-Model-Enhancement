--PARA INFO BASICA POR LLAMADA: QUERY DESDE TABLA ivr_calls

SELECT 
    cal.ivr_id AS calls_ivr_id,
    CASE
        WHEN LEFT(cal.vdn_label, 3) = 'ATC' THEN 'FRONT'
        WHEN LEFT(cal.vdn_label, 4) = 'TECH' THEN 'TECH'
        WHEN cal.vdn_label = 'ABSORPTION' THEN 'ABSORPTION'
        ELSE 'RESTO'
    END AS vdn_aggregation
FROM keepcoding.ivr_calls cal;


--PARA INFO DETALLADA DENTRO DE CADA LLAMADA: PASO POR MODULOS, STEPS ETC DESDE TABLA ivr_detail
SELECT  
    calls_ivr_id,
    CASE
        WHEN LEFT(calls_vdn_label,3) = 'ATC' THEN 'FRONT'
        WHEN LEFT(calls_vdn_label,4) = 'TECH' THEN 'TECH'   
        WHEN calls_vdn_label = 'ABSORPTION' THEN 'ABSORPTION'
        ELSE 'RESTO'
      END AS vdn_aggregation
FROM `keepcoding.ivr_detail` 
