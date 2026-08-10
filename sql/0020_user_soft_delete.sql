USE `zad`;

-- 회원 soft-delete / 로그인 세션 (MemberMapper is_deleted, deleted_at, login_session_id)
ALTER TABLE `USER`
    ADD COLUMN `is_deleted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '삭제 여부' AFTER `role`,
    ADD COLUMN `deleted_at` DATETIME NULL COMMENT '삭제 시각' AFTER `is_deleted`,
    ADD COLUMN `login_session_id` VARCHAR(100) NULL COMMENT '로그인 세션 ID' AFTER `deleted_at`;
