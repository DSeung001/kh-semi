USE zad;
SET NAMES utf8mb4;

-- 회원 권한 컬럼 추가
ALTER TABLE `USER`
    ADD COLUMN role ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER'
        COMMENT '권한' AFTER login_type;

UPDATE `USER` SET role = 'USER';

-- 슈퍼유저: admin / admin (BCrypt)
INSERT INTO `USER` (USER_ID, USER_PASSWORD, EMAIL, NICKNAME, login_type, role)
VALUES (
    'admin',
    '$2a$10$2/zPlZkA6RqJvPhItIjOEeuT6UvKpWyfADUxwLCXquMIqCKl5.ed.',
    'admin@zzanmat.com',
    '슈퍼관리자',
    'LOCAL',
    'ADMIN'
);
