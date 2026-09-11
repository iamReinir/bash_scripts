SELECT
    rowid AS id,
    CASE 
        WHEN status = 'PEND' THEN ''
        WHEN status = 'DEFR' THEN 'D'
        WHEN status = 'FAIL' THEN 'F'
        ELSE 'x' END AS '[ ]',
    strftime('%d/%m', created_at) AS created_at,
    detail,
    result
FROM todo
LIMIT 20
;
-- WHERE status = 'PEND';
