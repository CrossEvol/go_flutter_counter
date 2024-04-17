
-- name: GetCount :one
SELECT * FROM `COUNT`
WHERE id = ? LIMIT 1;

-- name: GetCounts :many
SELECT * FROM `COUNT`;

-- name: CountCounts :one
SELECT count(*) FROM `COUNT`;

-- name: CreateCount :execresult
INSERT INTO `COUNT` (
  `key`,
  `value`,
  `updated_at`
) VALUES (
  ? ,
  ? ,
  ? 
);

-- name: UpdateCount :exec
UPDATE `COUNT`
SET 
  `key` = ? ,
  `value` = ? ,
  `updated_at` = ? 
WHERE id = ?;

-- name: DeleteCount :exec
DELETE FROM `COUNT`
WHERE id = ?;
