-- 1. 데이터베이스 생성 및 선택
CREATE DATABASE IF NOT EXISTS `zad` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `zad`;

-- 기존 트리거 삭제 (존재할 경우)
DROP TRIGGER IF EXISTS `trg_mission_after_insert`;
DROP TRIGGER IF EXISTS `trg_mission_before_update`;
DROP TRIGGER IF EXISTS `trg_mission_before_delete`;

-- 기존 테이블들 삭제 (외래키 제약 조건을 고려한 올바른 역순 삭제)
DROP TABLE IF EXISTS `mission_progress`;
DROP TABLE IF EXISTS `mission_delete_archive`;
DROP TABLE IF EXISTS `mission_update_history`;
DROP TABLE IF EXISTS `mission_create_history`;
DROP TABLE IF EXISTS `mission_create`;


-- 2. 미션 등록(생성) 원본 테이블

CREATE TABLE `mission_create` (
    `mission_id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '등록된 미션 고유 ID',
    `title` VARCHAR(255) NOT NULL COMMENT '미션 제목',
    `description` TEXT COMMENT '미션 설명',
    `mission_type` VARCHAR(50) COMMENT '미션 타입',
    `trigger_event` VARCHAR(100) COMMENT '트리거 이벤트',
    `target_count` INT DEFAULT 0 COMMENT '목표 횟수',
    `reward_point` INT NOT NULL DEFAULT 0 COMMENT '보상 포인트',
    `auto_complete` TINYINT(1) DEFAULT 0 COMMENT '자동 완료 여부',
    `start_at` DATETIME(6) NULL COMMENT '시작 일시',
    `end_at` DATETIME(6) NULL COMMENT '종료 일시',
    `created_at` DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6) COMMENT '등록(생성) 일시'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='미션 등록 테이블';

-- 3. 회원별 미션 진행 상황 테이블

CREATE TABLE `mission_progress` (
    `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '진행 상황 고유 ID',
    `user_id` BIGINT NOT NULL COMMENT '회원 ID',
    `mission_id` BIGINT NOT NULL COMMENT '미션 ID',
    `current_count` INT DEFAULT 0 COMMENT '현재 진행 횟수',
    `progress` INT DEFAULT 0 COMMENT '진행률(%)',
    `status` VARCHAR(50) DEFAULT 'READY' COMMENT '진행 상태 (READY, IN_PROGRESS, COMPLETED 등)',
    `reward_received` TINYINT(1) DEFAULT 0 COMMENT '보상 수령 여부',
    `completed_at` DATETIME(6) NULL COMMENT '완료 일시',
    `created_at` DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6) COMMENT '생성 일시',
    `updated_at` DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '수정 일시',
    CONSTRAINT `fk_mission_progress_mission` FOREIGN KEY (`mission_id`) REFERENCES `mission_create` (`mission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='회원별 미션 진행 상황 테이블';


-- 4. 미션 생성 이력 테이블

CREATE TABLE `mission_create_history` (
    `history_id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '생성 이력 고유 ID',
    `mission_id` BIGINT NOT NULL COMMENT '생성된 미션 ID',
    `title` VARCHAR(255) NOT NULL COMMENT '미션 제목',
    `description` TEXT COMMENT '미션 설명',
    `mission_type` VARCHAR(50) COMMENT '미션 타입',
    `trigger_event` VARCHAR(100) COMMENT '트리거 이벤트',
    `target_count` INT DEFAULT 0 COMMENT '목표 횟수',
    `reward_point` INT NOT NULL DEFAULT 0 COMMENT '보상 포인트',
    `auto_complete` TINYINT(1) DEFAULT 0 COMMENT '자동 완료 여부',
    `start_at` DATETIME(6) NULL COMMENT '시작 일시',
    `end_at` DATETIME(6) NULL COMMENT '종료 일시',
    `created_at` DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6) COMMENT '최초 생성 일시'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='미션 생성 이력 테이블';


-- 5. 미션 수정 이력 테이블

CREATE TABLE `mission_update_history` (
    `history_id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '수정 이력 고유 ID',
    `mission_id` BIGINT NOT NULL COMMENT '수정된 원본 미션 ID',
    `title` VARCHAR(255) NOT NULL COMMENT '수정된 제목',
    `description` TEXT COMMENT '수정된 설명',
    `mission_type` VARCHAR(50) COMMENT '수정된 미션 타입',
    `trigger_event` VARCHAR(100) COMMENT '수정된 트리거 이벤트',
    `target_count` INT DEFAULT 0 COMMENT '목표 횟수',
    `reward_point` INT NOT NULL DEFAULT 0 COMMENT '수정된 보상 포인트',
    `auto_complete` TINYINT(1) DEFAULT 0 COMMENT '수정된 자동 완료 여부',
    `start_at` DATETIME(6) NULL COMMENT '수정된 시작 일시',
    `end_at` DATETIME(6) NULL COMMENT '수정된 종료 일시',
    `updated_at` DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6) COMMENT '수정된 일시'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='미션 수정 이력 테이블';


-- 6. 미션 삭제 아카이브(휴지통) 테이블

CREATE TABLE `mission_delete_archive` (
    `archive_id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '아카이브 고유 ID',
    `mission_id` BIGINT NOT NULL COMMENT '삭제된 원본 미션 ID',
    `title` VARCHAR(255) NOT NULL COMMENT '삭제된 미션 제목',
    `description` TEXT COMMENT '삭제된 미션 설명',
    `mission_type` VARCHAR(50) COMMENT '삭제된 미션 타입',
    `trigger_event` VARCHAR(100) COMMENT '삭제된 트리거 이벤트',
    `target_count` INT DEFAULT 0 COMMENT '삭제된 목표 횟수',
    `reward_point` INT NOT NULL DEFAULT 0 COMMENT '삭제된 보상 포인트',
    `auto_complete` TINYINT(1) DEFAULT 0 COMMENT '삭제된 자동 완료 여부',
    `start_at` DATETIME(6) NULL COMMENT '삭제된 시작 일시',
    `end_at` DATETIME(6) NULL COMMENT '삭제된 종료 일시',
    `deleted_at` DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6) COMMENT '삭제된 일시'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='미션 삭제 아카이브 테이블';


-- 7. 자동화 트리거 (Trigger) 설정

DELIMITER $$

-- [Trigger 1] 미션 생성(INSERT) 시 -> 생성 이력 테이블에 자동 적재
CREATE TRIGGER `trg_mission_after_insert`
AFTER INSERT ON `mission_create`
FOR EACH ROW
BEGIN
    INSERT INTO `mission_create_history` (
        `mission_id`, `title`, `description`, `mission_type`, 
        `trigger_event`, `target_count`, `reward_point`, 
        `auto_complete`, `start_at`, `end_at`, `created_at`
    ) VALUES (
        NEW.mission_id, NEW.title, NEW.description, NEW.mission_type, 
        NEW.trigger_event, NEW.target_count, NEW.reward_point, 
        NEW.auto_complete, NEW.start_at, NEW.end_at, NEW.created_at
    );
END$$

-- [Trigger 2] 미션 수정(UPDATE) 시 -> 수정 이력 테이블에 변경 후 데이터 적재
CREATE TRIGGER `trg_mission_before_update`
BEFORE UPDATE ON `mission_create`
FOR EACH ROW
BEGIN
    INSERT INTO `mission_update_history` (
        `mission_id`, `title`, `description`, `mission_type`, 
        `trigger_event`, `target_count`, `reward_point`, 
        `auto_complete`, `start_at`, `end_at`, `updated_at`
    ) VALUES (
        OLD.mission_id, NEW.title, NEW.description, NEW.mission_type, 
        NEW.trigger_event, NEW.target_count, NEW.reward_point, 
        NEW.auto_complete, NEW.start_at, NEW.end_at, NOW(6)
    );
END$$

-- [Trigger 3] 미션 삭제(DELETE) 시 -> 삭제 아카이브 테이블에 영구 보존용 백업
CREATE TRIGGER `trg_mission_before_delete`
BEFORE DELETE ON `mission_create`
FOR EACH ROW
BEGIN
    INSERT INTO `mission_delete_archive` (
        `mission_id`, `title`, `description`, `mission_type`, 
        `trigger_event`, `target_count`, `reward_point`, 
        `auto_complete`, `start_at`, `end_at`, `deleted_at`
    ) VALUES (
        OLD.mission_id, OLD.title, OLD.description, OLD.mission_type, 
        OLD.trigger_event, OLD.target_count, OLD.reward_point, 
        OLD.auto_complete, OLD.start_at, OLD.end_at, NOW(6)
    );
END$$

DELIMITER ;