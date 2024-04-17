CREATE TABLE COUNT (
                       key VARCHAR(50) PRIMARY KEY ,
                       value INT  NOT NULL DEFAULT 0,
                       updated_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE COUNT_RECORD(
                             id INT PRIMARY KEY,
                             key VARCHAR(50) NOT NULL  DEFAULT  '',
                             old_value INT,
                             new_value INT,
                             created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
