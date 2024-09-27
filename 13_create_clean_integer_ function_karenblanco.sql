CREATE OR REPLACE FUNCTION keepcoding.clean_integer(value INT64)
RETURNS INT64
AS(
    CASE
    WHEN value IS NULL THEN -999999
    ELSE value
END
)