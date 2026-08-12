-- ============================================================
-- 짠맛투어 누락 시드 복구 스크립트
-- 실행 전제: 0001_zzanmat-tour_init.sql, 0002_zzanmat-tour_insert.sql 적용 후
-- 91f1fbda 통합 과정에서 빠진 관리자 계정·기본 미션을 복구합니다.
-- 재실행해도 기존 admin 계정·미션 데이터가 있으면 중복 생성하지 않습니다.
-- ============================================================

USE `ZAD`;
SET NAMES UTF8MB4;
START TRANSACTION;

-- ============================================================================
-- 01. 관리자 계정
--     로그인: admin / admin (BCrypt)
--     일반 회원(USER1~USER30)과 별도로 관리자 페이지 접근용 계정을 둡니다.
-- ============================================================================

INSERT INTO `USER` (
    `USER_ID`, `USER_PASSWORD`, `EMAIL`, `NICKNAME`, `USER_NAME`,
    `BIO`, `LOGIN_TYPE`, `ROLE`, `CREATE_AT`
)
SELECT
    'admin',
    '$2a$10$2/zPlZkA6RqJvPhItIjOEeuT6UvKpWyfADUxwLCXquMIqCKl5.ed.',
    'admin@zzanmat.com',
    '슈퍼관리자',
    '관리자',
    '시스템 관리자 계정입니다.',
    'LOCAL',
    'ADMIN',
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM `USER` WHERE `USER_ID` = 'admin'
);

-- ============================================================================
-- 02. 기본 미션 데이터
--     POST / COMMENT / LIKE / CHAT 4유형 기본 미션을 등록합니다.
--     기간: 1·2번 진행 가능, 3번 예정, 4번 종료
-- ============================================================================

INSERT INTO `MISSION` (
    `TITLE`,
    `DESCRIPTION`,
    `MISSION_TYPE`,
    `TRIGGER_EVENT`,
    `TARGET_COUNT`,
    `REWARD_POINT`,
    `AUTO_COMPLETE`,
    `PLACE_KEYWORD`,
    `MAX_TOTAL_COST`,
    `START_AT`,
    `END_AT`
)
SELECT * FROM (
    SELECT
        '첫 여행 게시글 작성' AS TITLE,
        '여행 게시글 1개 작성하기' AS DESCRIPTION,
        'POST' AS MISSION_TYPE,
        'CREATE_POST' AS TRIGGER_EVENT,
        1 AS TARGET_COUNT,
        2000 AS REWARD_POINT,
        0 AS AUTO_COMPLETE,
        '' AS PLACE_KEYWORD,
        0 AS MAX_TOTAL_COST,
        DATE_SUB(NOW(), INTERVAL 1 DAY) AS START_AT,
        DATE_ADD(NOW(), INTERVAL 1 YEAR) AS END_AT
    UNION ALL
    SELECT
        '여행 댓글 남기기',
        '게시글에 댓글 1개 작성하기',
        'COMMENT',
        'CREATE_COMMENT',
        1,
        500,
        0,
        '',
        0,
        DATE_SUB(NOW(), INTERVAL 1 DAY),
        DATE_ADD(NOW(), INTERVAL 1 YEAR)
    UNION ALL
    SELECT
        '좋아요 누르기',
        '게시글 또는 댓글에 좋아요 1회',
        'LIKE',
        'LIKE',
        1,
        300,
        0,
        '',
        0,
        DATE_ADD(NOW(), INTERVAL 7 DAY),
        DATE_ADD(NOW(), INTERVAL 1 YEAR)
    UNION ALL
    SELECT
        '오픈 채팅 메시지 보내기',
        '오픈 채팅에 메시지 1회 전송하기',
        'CHAT',
        'OPEN_CHAT',
        1,
        500,
        0,
        '',
        0,
        DATE_SUB(NOW(), INTERVAL 60 DAY),
        DATE_SUB(NOW(), INTERVAL 1 DAY)
) AS SEED
WHERE NOT EXISTS (
    SELECT 1 FROM `MISSION` LIMIT 1
);

-- ============================================================================
-- 03. 생성 결과 확인
-- ============================================================================

SELECT `ID`, `USER_ID`, `NICKNAME`, `ROLE`
  FROM `USER`
 WHERE `USER_ID` = 'admin';

SELECT `MISSION_ID`, `TITLE`, `MISSION_TYPE`, `TRIGGER_EVENT`,
       `TARGET_COUNT`, `REWARD_POINT`, `START_AT`, `END_AT`
  FROM `MISSION`
 ORDER BY `MISSION_ID`;

-- ============================================================================
-- 04. 최종 정리 및 트랜잭션 반영
-- ============================================================================

COMMIT;
