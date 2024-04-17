
-- name: GetCountRecord :one
SELECT * FROM `COUNT_RECORD`
WHERE id = ? LIMIT 1;

-- name: GetCountRecords :many
SELECT * FROM `COUNT_RECORD`;

-- name: CountCountRecords :one
SELECT count(*) FROM `COUNT_RECORD`;

-- name: CreateCountRecord :execresult
INSERT INTO `COUNT_RECORD` (
  `id`,
  `key`,
  `old_value`,
  `new_value`,
  `created_at`
) VALUES (
  ? ,
  ? ,
  ? ,
  ? ,
  ? 
);

-- name: UpdateCountRecord :exec
UPDATE `COUNT_RECORD`
SET 
  `id` = ? ,
  `key` = ? ,
  `old_value` = ? ,
  `new_value` = ? ,
  `created_at` = ? 
WHERE id = ?;

-- name: DeleteCountRecord :exec
DELETE FROM `COUNT_RECORD`
WHERE id = ?;
