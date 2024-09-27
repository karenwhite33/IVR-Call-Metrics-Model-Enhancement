SELECT 
    calls_ivr_id, 
    
-- para obtener el tipo de documento válido, si existe
    MAX(CASE 
            WHEN document_type NOT IN ('UNKNOWN', 'DESCONOCIDO') 
            THEN document_type 
            ELSE NULL 
        END) AS document_type, 

-- Opara obtener el número de identificación solo si el tipo de documento es válido en la misma fila
    MAX(CASE 
            WHEN document_type NOT IN ('UNKNOWN', 'DESCONOCIDO') 
                AND document_identification NOT IN ('UNKNOWN', 'DESCONOCIDO') 
            THEN document_identification 
            ELSE NULL 
        END) AS document_identification

FROM keepcoding.ivr_detail
GROUP BY calls_ivr_id;
