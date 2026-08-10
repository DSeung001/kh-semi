USE `zad`;

-- 미션 조건 컬럼 (기존 mission 업그레이드용)
ALTER TABLE `mission`
    ADD COLUMN `place_keyword` VARCHAR(100) NOT NULL DEFAULT '' COMMENT '게시글 장소 포함 키워드' AFTER `auto_complete`,
    ADD COLUMN `max_total_cost` BIGINT NOT NULL DEFAULT 0 COMMENT '총 경비 상한(원)' AFTER `place_keyword`;

-- 게시글 여행 장소
ALTER TABLE `POST`
    ADD COLUMN `PLACE` VARCHAR(100) NULL COMMENT '여행 장소' AFTER `CONTENT`;
