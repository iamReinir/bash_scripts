SELECT
    rowid AS id,
    strftime('%d/%m', created_at) AS created_at,
    series,
    detail,
    result
FROM todo
WHERE status = 'PEND'
;
