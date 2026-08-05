USE zad;
SET NAMES utf8mb4;

-- 미션 수행 가능 기간 컬럼 추가
ALTER TABLE mission
    ADD COLUMN start_at DATETIME NULL COMMENT '수행 가능 시작' AFTER reward_point,
    ADD COLUMN end_at DATETIME NULL COMMENT '수행 가능 종료' AFTER start_at;

CREATE INDEX idx_mission_period ON mission (start_at, end_at);

-- 기존 시드 미션에 기간 부여
-- 1, 2: 진행 가능 / 3: 예정 / 4: 기간 종료
UPDATE mission
SET start_at = DATE_SUB(NOW(), INTERVAL 1 DAY),
    end_at = DATE_ADD(NOW(), INTERVAL 1 YEAR)
WHERE id IN (1, 2);

UPDATE mission
SET start_at = DATE_ADD(NOW(), INTERVAL 7 DAY),
    end_at = DATE_ADD(NOW(), INTERVAL 1 YEAR)
WHERE id = 3;

UPDATE mission
SET start_at = DATE_SUB(NOW(), INTERVAL 60 DAY),
    end_at = DATE_SUB(NOW(), INTERVAL 1 DAY)
WHERE id = 4;
