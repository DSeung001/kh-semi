USE zad;
SET NAMES utf8mb4;

SET FOREIGN_KEY_CHECKS = 0;

-- 0001에서 만든 대문자 테이블 + 재실행 대비 소문자 테이블 모두 정리
DROP TABLE IF EXISTS point_history;
DROP TABLE IF EXISTS mission_history;
DROP TABLE IF EXISTS mission_progress;
DROP TABLE IF EXISTS MISSION_PROGRESS;
DROP TABLE IF EXISTS mission;
DROP TABLE IF EXISTS MISSION;

SET FOREIGN_KEY_CHECKS = 1;


-- 1. 미션 정의 테이블 --

CREATE TABLE mission (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL COMMENT '미션 제목',
    description TEXT COMMENT '미션 설명',
    mission_type ENUM('POST', 'PHOTO', 'VIDEO', 'SHORTS') NOT NULL,
    trigger_event ENUM('CREATE_POST', 'UPLOAD_IMAGE', 'UPLOAD_VIDEO', 'UPLOAD_SHORTS') NOT NULL,
    target_count INT NOT NULL DEFAULT 1 COMMENT '필요 수행 횟수',
    reward_point INT NOT NULL DEFAULT 0 COMMENT '획득 포인트',
    auto_complete BOOLEAN NOT NULL DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. 회원별 미션 진행 상태 --
-- 0001의 `USER`(ID)를 외래 키로 참조

CREATE TABLE mission_progress (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    mission_id BIGINT NOT NULL,
    current_count INT DEFAULT 0 COMMENT '현재 진행 수',
    progress INT DEFAULT 0 CHECK(progress BETWEEN 0 AND 100),
    status ENUM('READY', 'IN_PROGRESS', 'DONE') DEFAULT 'READY',
    reward_received BOOLEAN DEFAULT FALSE COMMENT '보상 지급 여부',
    completed_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE(user_id, mission_id),
    FOREIGN KEY(user_id) REFERENCES `USER`(ID) ON DELETE CASCADE,
    FOREIGN KEY(mission_id) REFERENCES mission(id) ON DELETE CASCADE
);

-- 3. 미션 기록 --
CREATE TABLE mission_history (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    mission_id BIGINT NOT NULL,
    post_id BIGINT COMMENT '게시글 ID',
    action_type VARCHAR(50) COMMENT 'CREATE_POST 등',
    completed_at DATETIME NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES `USER`(ID) ON DELETE CASCADE,
    FOREIGN KEY(mission_id) REFERENCES mission(id) ON DELETE CASCADE
);

-- 4. 포인트 내역 --
CREATE TABLE point_history (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    mission_id BIGINT,
    point INT NOT NULL,
    reason ENUM('MISSION', 'EVENT', 'ADMIN', 'PURCHASE'),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES `USER`(ID) ON DELETE CASCADE,
    FOREIGN KEY(mission_id) REFERENCES mission(id)
);

-- 5. 인덱스 --
CREATE INDEX idx_progress_user_status ON mission_progress(user_id, status);
CREATE INDEX idx_history_user ON mission_history(user_id);
CREATE INDEX idx_mission_trigger ON mission(trigger_event);
CREATE INDEX idx_history_user_mission ON mission_history(user_id, mission_id);
CREATE INDEX idx_point_history_user ON point_history(user_id);

-- 6. 기본 미션 데이터 등록 --
START TRANSACTION;

INSERT INTO mission (title, description, mission_type, trigger_event, target_count, reward_point)
VALUES
('첫 여행 게시글 작성', '여행 게시글 1개 작성하기', 'POST', 'CREATE_POST', 1, 2000),
('여행 사진 업로드', '사진이 포함된 게시글 작성', 'PHOTO', 'UPLOAD_IMAGE', 1, 500),
('여행 영상 업로드', '영상 게시글 작성', 'VIDEO', 'UPLOAD_VIDEO', 1, 1000),
('쇼츠 영상 업로드', '짧은 여행 영상 작성', 'SHORTS', 'UPLOAD_SHORTS', 1, 3000);

COMMIT;
