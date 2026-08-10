-- 0001~0013 적용 후 가정: mission / mission_progress / point_history 존재
-- 앱이 쓰는 mission(mission_id) 스키마로 ALTER, 미사용 mission_history 제거
USE `zad`;
SET NAMES utf8mb4;

-- ---------------------------------------------------------------------------
-- 0) 미사용 mission_history 제거
-- ---------------------------------------------------------------------------
DROP TABLE IF EXISTS `mission_history`;

-- ---------------------------------------------------------------------------
-- 1) mission(id) 참조 FK 제거
-- ---------------------------------------------------------------------------
SET @fk := (
    SELECT CONSTRAINT_NAME FROM information_schema.KEY_COLUMN_USAGE
     WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'mission_progress'
       AND COLUMN_NAME = 'mission_id' AND REFERENCED_TABLE_NAME IS NOT NULL
     LIMIT 1
);
SET @sql := IF(@fk IS NOT NULL, CONCAT('ALTER TABLE `mission_progress` DROP FOREIGN KEY `', @fk, '`'), 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @fk := (
    SELECT CONSTRAINT_NAME FROM information_schema.KEY_COLUMN_USAGE
     WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'point_history'
       AND COLUMN_NAME = 'mission_id' AND REFERENCED_TABLE_NAME IS NOT NULL
     LIMIT 1
);
SET @sql := IF(@fk IS NOT NULL, CONCAT('ALTER TABLE `point_history` DROP FOREIGN KEY `', @fk, '`'), 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- ---------------------------------------------------------------------------
-- 2) mission: PK id → mission_id, 타입 정리 (start_at/end_at 은 0011에서 이미 존재)
-- ---------------------------------------------------------------------------
ALTER TABLE `mission`
    CHANGE COLUMN `id` `mission_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '미션 고유 ID';

ALTER TABLE `mission`
    MODIFY COLUMN `title` VARCHAR(255) NOT NULL COMMENT '미션 제목',
    MODIFY COLUMN `mission_type` VARCHAR(50) NOT NULL DEFAULT 'POST' COMMENT '미션 타입',
    MODIFY COLUMN `trigger_event` VARCHAR(100) NOT NULL DEFAULT 'CREATE_POST' COMMENT '트리거 이벤트',
    MODIFY COLUMN `auto_complete` TINYINT(1) DEFAULT 0 COMMENT '자동 완료 여부',
    MODIFY COLUMN `start_at` DATETIME(6) NULL COMMENT '시작 일시',
    MODIFY COLUMN `end_at` DATETIME(6) NULL COMMENT '종료 일시';

ALTER TABLE `mission` COMMENT = '미션 정의 테이블';

-- ---------------------------------------------------------------------------
-- 3) mission_progress 상태 기본값/타입을 앱과 맞춤
-- ---------------------------------------------------------------------------
ALTER TABLE `mission_progress`
    MODIFY COLUMN `status` VARCHAR(50) DEFAULT 'IN_PROGRESS' COMMENT '진행 상태 (IN_PROGRESS, DONE)';

-- ---------------------------------------------------------------------------
-- 4) mission(mission_id) 로 FK 재연결
-- ---------------------------------------------------------------------------
ALTER TABLE `mission_progress`
    ADD CONSTRAINT `fk_mission_progress_mission`
        FOREIGN KEY (`mission_id`) REFERENCES `mission` (`mission_id`) ON DELETE CASCADE;

ALTER TABLE `point_history`
    ADD CONSTRAINT `fk_point_history_mission`
        FOREIGN KEY (`mission_id`) REFERENCES `mission` (`mission_id`);
