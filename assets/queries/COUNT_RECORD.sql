-- name: GetCounterRecords :many
SELECT * FROM COUNT_RECORD WHERE `key` = 'counter';

-- name: CountCounterRecords :one
SELECT count(*) FROM COUNT_RECORD WHERE `key` = 'counter';

-- name: CreateCounterRecord :execresult
INSERT INTO COUNT_RECORD (
  `key`,
  old_value,
  new_value,
  `created_at`
) VALUES (
  'counter',
  (SELECT value FROM COUNT WHERE `key` = 'counter' LIMIT 1) ,
  ? ,
  CURRENT_TIMESTAMP
);
