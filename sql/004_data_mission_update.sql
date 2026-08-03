SET FOREIGN_KEY_CHECKS = 0;

USE zad;

-- 기존 테이블 초기화 (외래 키 관계로 인해 역순으로 삭제)
DROP TABLE IF EXISTS point_history;
DROP TABLE IF EXISTS mission_post;
DROP TABLE IF EXISTS mission_progress;
DROP TABLE IF EXISTS mission_image;
DROP TABLE IF EXISTS mission;
DROP TABLE IF EXISTS transit_auth;
DROP TABLE IF EXISTS landmark_auth;
DROP TABLE IF EXISTS user;

-- USER 테이블 생성
CREATE TABLE user (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '회원 고유 ID',
    point INT DEFAULT 0 COMMENT '보유 포인트',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '가입일시'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='회원 정보 테이블';

-- MISSION 테이블 생성 (mission_type 포함)
CREATE TABLE mission (
    mission_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '미션 고유 ID',
    title VARCHAR(255) NOT NULL COMMENT '미션 제목',
    description TEXT COMMENT '미션 설명',
    mission_type VARCHAR(50) NOT NULL COMMENT '미션 유형 (예: GENERAL, DAILY 등)',
    trigger_event VARCHAR(100) COMMENT '트리거 이벤트명',
    target_count INT DEFAULT 1 COMMENT '목표 횟수',
    reward_points INT DEFAULT 0 COMMENT '보상 포인트',
    auto_complete TINYINT(1) DEFAULT 0 COMMENT '자동 완료 여부 (0 또는 1)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='미션 기본 정보 테이블';

-- TRANSIT_AUTH 테이블 생성
CREATE TABLE transit_auth (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='대중교통 인증 테이블';

-- LANDMARK_AUTH 테이블 생성 (누락되었던 테이블 추가)
CREATE TABLE landmark_auth (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='랜드마크 인증 테이블';

-- MISSION_IMAGE 테이블 생성
CREATE TABLE mission_image (
    image_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '이미지 고유 ID',
    mission_id BIGINT NOT NULL COMMENT '미션 ID (FK)',
    origin_name VARCHAR(255) COMMENT '원본 파일명',
    saved_name VARCHAR(255) COMMENT '서버 저장 파일명',
    file_path VARCHAR(500) COMMENT '파일 접근 경로',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    CONSTRAINT fk_mission_image_mission 
        FOREIGN KEY (mission_id) REFERENCES mission(mission_id) 
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='미션 첨부 이미지 테이블';

-- MISSION_PROGRESS 테이블 생성
CREATE TABLE mission_progress (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '유저 미션 진행 고유 ID',
    user_id BIGINT NOT NULL COMMENT '회원 ID',
    mission_id BIGINT NOT NULL COMMENT '미션 ID',
    status VARCHAR(50) DEFAULT 'READY' COMMENT '상태 (READY, IN_PROGRESS, DONE)',
    current_count INT DEFAULT 0 COMMENT '현재 진행 횟수',
    progress INT DEFAULT 0 COMMENT '진행률 (%)',
    reward_received TINYINT(1) DEFAULT 0 COMMENT '보상 수령 여부 (0: 미수령, 1: 수령완료)',
    completed_at DATETIME DEFAULT NULL COMMENT '완료일시',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    CONSTRAINT fk_progress_mission 
        FOREIGN KEY (mission_id) REFERENCES mission(mission_id) 
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='유저별 미션 진행 상황 테이블';

-- MISSION_POST 테이블 생성
CREATE TABLE mission_post (
    post_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '게시글 고유 ID',
    user_mission_id BIGINT NOT NULL COMMENT '유저 미션 진행 ID (FK)',
    title VARCHAR(255) NOT NULL COMMENT '인증글 제목',
    content TEXT COMMENT '인증글 내용',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '작성일시',
    CONSTRAINT fk_mission_post_progress 
        FOREIGN KEY (user_mission_id) REFERENCES mission_progress(id) 
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='미션 인증 게시글 테이블';

-- POINT_HISTORY 테이블 생성
CREATE TABLE point_history (
    history_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '포인트 이력 고유 ID',
    user_id BIGINT NOT NULL COMMENT '회원 ID',
    mission_id BIGINT DEFAULT NULL COMMENT '관련 미션 ID',
    point INT NOT NULL COMMENT '변동 포인트 양',
    reason VARCHAR(255) COMMENT '포인트 지급/차감 사유',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '발생일시'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='포인트 적립 및 사용 이력 테이블';

SET FOREIGN_KEY_CHECKS = 1;

-- 테스트용 더미 데이터 삽입
INSERT INTO user (user_id, point) VALUES (1, 1000);

INSERT INTO mission (mission_id, title, description, mission_type, trigger_event, target_count, reward_points, auto_complete) 
VALUES (1, '첫 회원가입 후 로그인 미션', '사이트에 처음 회원가입하세요.', 'Normal', 'SIGN UP', 1, 1000, 1);