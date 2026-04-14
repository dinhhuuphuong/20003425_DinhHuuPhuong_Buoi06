/*
Bai 2 - Vi du Vertical partition (MariaDB)
Y tuong: tach cot hay dung va cot it dung
*/

USE partition_demo_db;

DROP TABLE IF EXISTS user_profile;
DROP TABLE IF EXISTS user_core;

CREATE TABLE user_core (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    status TINYINT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_profile (
    user_id INT PRIMARY KEY,
    address VARCHAR(200) NULL,
    bio VARCHAR(500) NULL,
    avatar_url VARCHAR(300) NULL,
    note VARCHAR(1000) NULL,
    CONSTRAINT fk_user_profile_user_core FOREIGN KEY (user_id)
        REFERENCES user_core(user_id)
);

INSERT INTO user_core(username, status)
VALUES ('tung.dev', 1),
       ('linh.data', 1),
       ('minh.ops', 0);

INSERT INTO user_profile(user_id, address, bio, avatar_url, note)
VALUES
(1, 'Ha Noi', 'Backend dev', 'https://example.com/a1.png', 'Ghi chu dai...'),
(2, 'Da Nang', 'Data engineer', 'https://example.com/a2.png', 'Ghi chu dai...'),
(3, 'HCM', 'DevOps', 'https://example.com/a3.png', 'Ghi chu dai...');

/* Query nhanh man hinh danh sach user: chi can bang nhe */
SELECT user_id, username, status, created_at
FROM user_core
WHERE status = 1;

/* Query chi tiet profile: join khi can */
SELECT c.user_id, c.username, c.status, p.address, p.bio, p.avatar_url
FROM user_core c
JOIN user_profile p ON c.user_id = p.user_id
WHERE c.user_id = 1;
