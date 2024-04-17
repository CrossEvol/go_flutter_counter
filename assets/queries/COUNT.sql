-- name: GetCountValue :one
SELECT value FROM COUNT WHERE `key` = 'counter' LIMIT 1;

-- name: InitCountValue :execresult
INSERT INTO COUNT (
  `key`,
  value,
  `updated_at`
) VALUES (
 'counter',
  0 ,
  CURRENT_TIMESTAMP
);

-- name: IncrementCountValue :exec
UPDATE COUNT
SET 
  value = value + 1 ,
  `updated_at` = CURRENT_TIMESTAMP
WHERE `key` = 'counter';

-- name: DecrementCountValue :exec
UPDATE COUNT
SET
    value = value - 1 ,
    `updated_at` = CURRENT_TIMESTAMP
WHERE `key` = 'counter';

-- name: ResetCountValue :exec
UPDATE COUNT
SET
    value = 0 ,
    `updated_at` = CURRENT_TIMESTAMP
WHERE `key` = 'counter';