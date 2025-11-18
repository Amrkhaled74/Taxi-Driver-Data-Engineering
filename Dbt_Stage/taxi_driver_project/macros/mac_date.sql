{% macro get_date_part(column_name) %}
    
    EXTRACT(YEAR FROM CAST({{ column_name }} AS DATE))         AS year,
    EXTRACT(MONTH FROM CAST({{ column_name }} AS DATE))        AS month,
    EXTRACT(DAY FROM CAST({{ column_name }} AS DATE))          AS day,
    EXTRACT(DAYOFWEEK FROM CAST({{ column_name }} AS DATE))    AS day_of_week,
    EXTRACT(DAYOFYEAR FROM CAST({{ column_name }} AS DATE))    AS day_of_year,
    EXTRACT(WEEK FROM CAST({{ column_name }} AS DATE))         AS week,
    EXTRACT(QUARTER FROM CAST({{ column_name }} AS DATE))      AS quarter

{% endmacro %}
