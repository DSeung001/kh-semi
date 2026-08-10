-- 미션 4유형에 맞게 mission_type / trigger_event ENUM 정리
-- POST+CREATE_POST, COMMENT+CREATE_COMMENT, LIKE+LIKE, CHAT+OPEN_CHAT

USE `zad`;
SET NAMES utf8mb4;

-- 1) ENUM 전환 전 구값 정리 (PHOTO/VIDEO/SHORTS, UPLOAD_* 등)
UPDATE `mission`
   SET `mission_type` = 'POST',
       `trigger_event` = 'CREATE_POST'
 WHERE `mission_type` NOT IN ('POST', 'COMMENT', 'LIKE', 'CHAT')
    OR `trigger_event` NOT IN ('CREATE_POST', 'CREATE_COMMENT', 'LIKE', 'OPEN_CHAT');

-- 2) ENUM으로 변경
ALTER TABLE `mission`
    MODIFY COLUMN `mission_type`
        ENUM('POST', 'COMMENT', 'LIKE', 'CHAT') NOT NULL DEFAULT 'POST'
        COMMENT '미션 방식',
    MODIFY COLUMN `trigger_event`
        ENUM('CREATE_POST', 'CREATE_COMMENT', 'LIKE', 'OPEN_CHAT') NOT NULL DEFAULT 'CREATE_POST'
        COMMENT '트리거 이벤트';
