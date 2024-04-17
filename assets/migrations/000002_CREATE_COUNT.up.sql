CREATE TABLE COUNT (
                       value INT  NOT NULL DEFAULT 0,
                       updated_at  TEXT
);

CREATE TABLE COUNT_RECORD(
                             id INT PRIMARY KEY,
                             old_value INT,
                             new_value INT,
                             created_at TEXT
);
