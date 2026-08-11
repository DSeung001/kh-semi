-- ============================================================
-- 짠맛투어 초기 데이터: USER1~USER30 회원·팔로우 관계,
-- USER1~USER10 게시글·이미지·댓글·좋아요 데이터
-- 실행 전제: 0050_init.sql 실행 직후 데이터가 없는 상태에서 실행합니다.
-- 이미지 실파일: C:/zzan/uploads/post/seed-ai-0051/
-- 이미지 웹경로: /uploads/post/seed-ai-0051/
-- ============================================================

USE `ZAD`;
SET NAMES UTF8MB4;
START TRANSACTION;

-- ============================================================================
-- 01. 회원 데이터: USER1~USER30
--     게시글, 댓글, 좋아요, 팔로우 데이터보다 회원 데이터를 먼저 생성합니다.
--     모든 일반 회원의 테스트 비밀번호: 1234
-- ============================================================================

-- USER1~USER10 회원 생성
INSERT IGNORE INTO `USER` (
    `USER_ID`, `USER_PASSWORD`, `EMAIL`, `NICKNAME`, `USER_NAME`,
    `BIO`, `LOGIN_TYPE`, `ROLE`, `CREATE_AT`
) VALUES
('user1',  '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user1@naver.com',  '게임마스터', '김여행', '가성비 좋은 여행 동선과 비용을 기록합니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 280 DAY)),
('user2',  '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user2@naver.com',  '여행초보', '이초보', '처음 떠나는 여행자에게 도움이 되는 정보를 모읍니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 271 DAY)),
('user3',  '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user3@naver.com',  '바다거북', '박바다', '바다와 해안 산책로가 있는 여행지를 좋아합니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 262 DAY)),
('user4',  '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user4@naver.com',  '산책러', '최산책', '천천히 걸으며 즐길 수 있는 여행 코스를 공유합니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 253 DAY)),
('user5',  '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user5@naver.com',  '맛집탐험가', '정맛집', '여행지의 가성비 좋은 맛집을 찾아다닙니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 244 DAY)),
('user6',  '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user6@naver.com',  '카메라맨', '윤사진', '사진으로 남기기 좋은 여행 장소를 기록합니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 235 DAY)),
('user7',  '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user7@naver.com',  '자유여행자', '임자유', '계획에 얽매이지 않는 자유로운 국내 여행을 즐깁니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 226 DAY)),
('user8',  '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user8@naver.com',  '도시탐방', '오도시', '도시의 골목과 문화 공간을 찾아다닙니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 217 DAY)),
('user9',  '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user9@naver.com',  '휴양러', '강휴양', '조용하게 쉬어갈 수 있는 여행지를 소개합니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 208 DAY)),
('user10', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user10@naver.com', '여행인', '서여행', '직접 다녀온 여행의 동선과 경비를 정리합니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 199 DAY));

-- USER11~USER30 회원 생성
INSERT IGNORE INTO `USER` (
    `USER_ID`, `USER_PASSWORD`, `EMAIL`, `NICKNAME`, `USER_NAME`,
    `BIO`, `LOGIN_TYPE`, `ROLE`, `CREATE_AT`
) VALUES
('user11', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user11@naver.com', '골목여행가', '김골목', '유명 관광지보다 조용한 골목과 동네를 좋아합니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 190 DAY)),
('user12', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user12@naver.com', '주말뚜벅이', '이주말', '주말마다 대중교통으로 갈 수 있는 여행지를 찾습니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 181 DAY)),
('user13', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user13@naver.com', '시장먹방러', '박시장', '전통시장 먹거리와 지역 맛집을 기록합니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 172 DAY)),
('user14', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user14@naver.com', '노을수집가', '최노을', '노을이 아름다운 바다와 전망대를 찾아다닙니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 165 DAY)),
('user15', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user15@naver.com', '가성비숙소', '정숙소', '가격 대비 만족도가 높은 숙소 정보를 공유합니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 157 DAY)),
('user16', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user16@naver.com', '혼행일기', '한혼행', '혼자 떠나는 여행의 동선과 비용을 정리합니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 149 DAY)),
('user17', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user17@naver.com', '기차창밖', '윤기차', '기차를 타고 떠나는 국내 소도시 여행을 좋아합니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 141 DAY)),
('user18', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user18@naver.com', '카페지도', '임카페', '여행지의 조용한 카페와 디저트를 소개합니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 133 DAY)),
('user19', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user19@naver.com', '새벽출발', '오새벽', '이른 아침 출발하는 알찬 당일치기 여행을 즐깁니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 125 DAY)),
('user20', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user20@naver.com', '섬마을산책', '강섬길', '배를 타고 들어가는 섬과 해안 산책로를 좋아합니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 117 DAY)),
('user21', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user21@naver.com', '만원여행', '서만원', '적은 비용으로 충분히 즐기는 여행 방법을 찾습니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 109 DAY)),
('user22', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user22@naver.com', '사진한장', '문사진', '여행에서 만난 풍경과 사진 촬영 장소를 공유합니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 101 DAY)),
('user23', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user23@naver.com', '버스여행자', '신버스', '시외버스와 지역버스로 이동하는 여행을 기록합니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 93 DAY)),
('user24', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user24@naver.com', '동네탐험대', '권동네', '익숙한 도시의 새로운 동네를 천천히 둘러봅니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 85 DAY)),
('user25', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user25@naver.com', '계절여행', '황계절', '계절마다 가장 아름다운 국내 여행지를 찾습니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 77 DAY)),
('user26', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user26@naver.com', '야경산책', '안야경', '밤에 걷기 좋은 야경 명소와 안전한 동선을 소개합니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 69 DAY)),
('user27', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user27@naver.com', '맛따라여행', '송맛길', '지역 음식을 중심으로 여행 계획을 세웁니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 61 DAY)),
('user28', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user28@naver.com', '느린여행자', '전느림', '바쁘게 이동하지 않고 한 장소에 오래 머무릅니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 53 DAY)),
('user29', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user29@naver.com', '지도밖여행', '고지도', '잘 알려지지 않은 장소와 새로운 길을 찾아갑니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 45 DAY)),
('user30', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user30@naver.com', '퇴근후여행', '유퇴근', '퇴근 후 출발할 수 있는 가까운 여행지를 공유합니다.', 'LOCAL', 'USER', DATE_SUB(NOW(), INTERVAL 37 DAY));

-- USER1~USER30 생성 결과 확인
SELECT COUNT(*) AS `INSERTED_USER_COUNT`
  FROM `USER`
 WHERE `USER_ID` REGEXP '^user([1-9]|[12][0-9]|30)$';

-- ============================================================================
-- 02. 게시글 데이터 생성용 회원 매핑
--     USER1~USER10의 실제 PK를 게시글 작성자 번호와 연결합니다.
-- ============================================================================

CREATE TEMPORARY TABLE `TMP_0051_USERS` AS
SELECT `ID`, ROW_NUMBER() OVER (ORDER BY CAST(SUBSTRING(`USER_ID`, 5) AS UNSIGNED)) AS `USER_NO`
  FROM `USER`
 WHERE `USER_ID` IN ('user1', 'user2', 'user3', 'user4', 'user5',
                     'user6', 'user7', 'user8', 'user9', 'user10')
   AND `IS_DELETED` = 0;

-- 반드시 10명이 조회되어야 합니다.
SELECT COUNT(*) AS `seed_user_count` FROM `TMP_0051_USERS`;

-- ============================================================================
-- 03. 게시글·댓글 생성용 순번 데이터
--     1부터 400까지의 반복 가능한 순번을 임시로 생성합니다.
-- ============================================================================

CREATE TEMPORARY TABLE `TMP_0051_SEQUENCE` (`N` INT NOT NULL PRIMARY KEY);
INSERT INTO `TMP_0051_SEQUENCE` (`N`)
SELECT O.`N` + T.`N` * 10 + H.`N` * 100 + 1
  FROM (
      SELECT 0 AS `N` UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
      UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
  ) O
 CROSS JOIN (
      SELECT 0 AS `N` UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
      UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
  ) T
 CROSS JOIN (
      SELECT 0 AS `N` UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
  ) H;

-- ============================================================================
-- 04. 게시글 이미지 원본 데이터
--     게시글에 순환 연결할 이미지 40개의 파일 정보를 준비합니다.
-- ============================================================================

CREATE TEMPORARY TABLE `TMP_0051_IMAGES` (
    `IMAGE_NO` INT NOT NULL PRIMARY KEY,
    `ORIGIN_NAME` VARCHAR(255) NOT NULL,
    `RELATIVE_PATH` VARCHAR(300) NOT NULL
);

INSERT INTO `TMP_0051_IMAGES` (`IMAGE_NO`, `ORIGIN_NAME`, `RELATIVE_PATH`) VALUES
(1, 'travel-destinations-01.png', '01_travel-destinations/travel-destinations-01.png'),
(2, 'travel-destinations-02.png', '01_travel-destinations/travel-destinations-02.png'),
(3, 'travel-destinations-03.png', '01_travel-destinations/travel-destinations-03.png'),
(4, 'travel-destinations-04.png', '01_travel-destinations/travel-destinations-04.png'),
(5, 'travel-destinations-05.png', '01_travel-destinations/travel-destinations-05.png'),
(6, 'travel-destinations-06.png', '01_travel-destinations/travel-destinations-06.png'),
(7, 'travel-destinations-07.png', '01_travel-destinations/travel-destinations-07.png'),
(8, 'travel-destinations-08.png', '01_travel-destinations/travel-destinations-08.png'),
(9, 'travel-destinations-09.png', '01_travel-destinations/travel-destinations-09.png'),
(10, 'travel-destinations-10.png', '01_travel-destinations/travel-destinations-10.png'),
(11, 'travel-destinations-11.png', '01_travel-destinations/travel-destinations-11.png'),
(12, 'travel-destinations-12.png', '01_travel-destinations/travel-destinations-12.png'),
(13, 'travel-destinations-13.png', '01_travel-destinations/travel-destinations-13.png'),
(14, 'travel-destinations-14.png', '01_travel-destinations/travel-destinations-14.png'),
(15, 'travel-destinations-15.png', '01_travel-destinations/travel-destinations-15.png'),
(16, 'travel-destinations-16.png', '01_travel-destinations/travel-destinations-16.png'),
(17, 'travel-destinations-17.png', '01_travel-destinations/travel-destinations-17.png'),
(18, 'travel-destinations-18.png', '01_travel-destinations/travel-destinations-18.png'),
(19, 'travel-destinations-19.png', '01_travel-destinations/travel-destinations-19.png'),
(20, 'travel-destinations-20.png', '01_travel-destinations/travel-destinations-20.png'),
(21, 'food-01.png', '02_food/food-01.png'),
(22, 'food-02.png', '02_food/food-02.png'),
(23, 'food-03.png', '02_food/food-03.png'),
(24, 'food-04.png', '02_food/food-04.png'),
(25, 'food-05.png', '02_food/food-05.png'),
(26, 'scenery-01.png', '03_scenery/scenery-01.png'),
(27, 'scenery-02.png', '03_scenery/scenery-02.png'),
(28, 'scenery-03.png', '03_scenery/scenery-03.png'),
(29, 'scenery-04.png', '03_scenery/scenery-04.png'),
(30, 'scenery-05.png', '03_scenery/scenery-05.png'),
(31, 'transport-01.png', '04_transport/transport-01.png'),
(32, 'transport-02.png', '04_transport/transport-02.png'),
(33, 'transport-03.png', '04_transport/transport-03.png'),
(34, 'transport-04.png', '04_transport/transport-04.png'),
(35, 'transport-05.png', '04_transport/transport-05.png'),
(36, 'accommodation-01.png', '05_accommodation/accommodation-01.png'),
(37, 'accommodation-02.png', '05_accommodation/accommodation-02.png'),
(38, 'accommodation-03.png', '05_accommodation/accommodation-03.png'),
(39, 'accommodation-04.png', '05_accommodation/accommodation-04.png'),
(40, 'accommodation-05.png', '05_accommodation/accommodation-05.png');

-- ============================================================================
-- 05. 게시글 데이터
--     USER1~USER10이 작성한 여행 게시글 250개를 생성합니다.
-- ============================================================================

-- 게시글 250개: 10명의 회원에게 균등 배분됩니다.
INSERT INTO `POST` (
    `USER_ID`, `TITLE`, `CONTENT`, `PLACE`, `VIEW_COUNT`,
    `TRANSPORT_COST`, `FOOD_COST`, `OTHER_COST`, `CREATE_AT`
)
SELECT
    U.`ID`,
    CONCAT(
        ELT(MOD(S.`N` - 1, 10) + 1, '서울', '부산', '제주', '전주', '경주', '강릉', '여수', '속초', '인천', '통영'),
        ' ',
        ELT(MOD(S.`N` * 3 - 1, 10) + 1, '당일치기 가성비 여행', '뚜벅이 여행 코스', '주말 여행 기록', '숨은 명소 추천', '맛집과 함께한 여행', '혼자 떠난 힐링 여행', '대중교통 여행 팁', '사진 스팟 정리', '비 오는 날 여행', '다시 가고 싶은 여행')
    ),
    CONCAT(
        ELT(MOD(S.`N` - 1, 5) + 1,
            '교통과 식비를 미리 정하고 알차게 다녀온 여행 기록입니다. ',
            '걷기 좋은 동선으로 구성해서 하루 동안 여유롭게 둘러봤어요. ',
            '현지에서 먹은 음식과 풍경이 특히 기억에 남는 코스였습니다. ',
            '대중교통으로도 어렵지 않게 이동할 수 있어 추천하고 싶습니다. ',
            '사진 찍기 좋은 장소와 쉬어가기 좋은 카페를 함께 정리했습니다. '
        ),
        '다음 여행을 준비하는 분들께 작은 도움이 되면 좋겠습니다.'
    ),
    ELT(MOD(S.`N` - 1, 20) + 1, '서울 종로', '부산 해운대', '제주 성산', '전주 한옥마을', '경주 황리단길', '강릉 안목해변', '여수 돌산', '속초 영랑호', '인천 개항장', '통영 동피랑', '서울 망원동', '부산 광안리', '제주 협재', '전주 남부시장', '경주 보문단지', '강릉 경포대', '여수 오동도', '속초 중앙시장', '인천 월미도', '통영 미륵도'),
    15 + MOD(S.`N` * 37, 985),
    1500 + MOD(S.`N` * 1700, 28000),
    5000 + MOD(S.`N` * 2300, 45000),
    1000 + MOD(S.`N` * 1100, 18000),
    DATE_SUB(NOW(), INTERVAL (250 - S.`N`) * 3 HOUR)
FROM `TMP_0051_SEQUENCE` S
JOIN `TMP_0051_USERS` U ON U.`USER_NO` = MOD(S.`N` - 1, 10) + 1
WHERE S.`N` <= 250;

SET @FIRST_POST_ID := LAST_INSERT_ID();

-- ============================================================================
-- 06. 게시글 이미지 및 연결 데이터
--     IMAGE_UPLOAD과 POST_UPLOAD 데이터를 생성합니다.
-- ============================================================================

-- 게시글마다 이미지 한 장씩 연결하며, 준비한 40장을 순환 사용합니다.
INSERT INTO `IMAGE_UPLOAD` (`ORIGIN_NAME`, `UPLOAD_PATH`, `IMAGE_ORDER`)
SELECT I.`ORIGIN_NAME`, CONCAT('/uploads/post/seed-ai-0051/', I.`RELATIVE_PATH`), 1
  FROM `TMP_0051_SEQUENCE` S
  JOIN `TMP_0051_IMAGES` I ON I.`IMAGE_NO` = MOD(S.`N` - 1, 40) + 1
 WHERE S.`N` <= 250;

SET @FIRST_UPLOAD_ID := LAST_INSERT_ID();

INSERT INTO `POST_UPLOAD` (`POST_ID`, `UPLOAD_ID`)
SELECT @FIRST_POST_ID + S.`N` - 1, @FIRST_UPLOAD_ID + S.`N` - 1
  FROM `TMP_0051_SEQUENCE` S
 WHERE S.`N` <= 250;

-- ============================================================================
-- 07. 댓글 및 답글 데이터
--     일반 댓글 400개와 답글 80개를 생성합니다.
-- ============================================================================

-- 일반 댓글 400개와 답글 80개를 생성합니다.
INSERT INTO `COMMENT` (`USER_ID`, `POST_ID`, `CONTENT`, `CREATE_AT`)
SELECT
    U.`ID`,
    @FIRST_POST_ID + MOD(S.`N` * 7 - 1, 250),
    ELT(MOD(S.`N` - 1, 8) + 1,
        '사진이 정말 멋지네요. 다음에 꼭 가보고 싶어요!',
        '교통비 정보가 특히 도움이 됐습니다.',
        '동선이 좋아 보여서 주말에 참고하겠습니다.',
        '맛집 추천도 궁금합니다. 좋은 기록 감사합니다!',
        '계절이 바뀌면 또 다른 분위기일 것 같아요.',
        '혼자 여행하기에도 괜찮은 코스인가요?',
        '가성비 좋게 다녀오셨네요. 저장해 둡니다!',
        '다음 여행지 후보로 추가했습니다.'
    ),
    DATE_ADD(DATE_SUB(NOW(), INTERVAL 30 DAY), INTERVAL S.`N` * 90 MINUTE)
FROM `TMP_0051_SEQUENCE` S
JOIN `TMP_0051_USERS` U ON U.`USER_NO` = MOD(S.`N` * 3 - 1, 10) + 1
WHERE S.`N` <= 400;

SET @FIRST_COMMENT_ID := LAST_INSERT_ID();

INSERT INTO `COMMENT` (`USER_ID`, `POST_ID`, `PARENT_COMMENT_ID`, `CONTENT`, `CREATE_AT`)
SELECT
    U.`ID`,
    @FIRST_POST_ID + MOD((S.`N` * 5 * 7) - 1, 250),
    @FIRST_COMMENT_ID + (S.`N` * 5) - 1,
    ELT(MOD(S.`N` - 1, 4) + 1,
        '좋게 봐주셔서 감사합니다!',
        '저도 다음 계절에 다시 가보려고요.',
        '대중교통으로 충분히 가능했습니다.',
        '방문 전에 영업시간만 확인해 보세요!'
    ),
    DATE_ADD(DATE_SUB(NOW(), INTERVAL 20 DAY), INTERVAL S.`N` * 4 HOUR)
FROM `TMP_0051_SEQUENCE` S
JOIN `TMP_0051_USERS` U ON U.`USER_NO` = MOD(S.`N` * 9 - 1, 10) + 1
WHERE S.`N` <= 80;

-- ============================================================================
-- 08. 게시글·댓글 좋아요 데이터
--     중복되지 않는 게시글 좋아요와 댓글 좋아요를 생성합니다.
-- ============================================================================

-- 중복 없이 게시글 좋아요 약 1,000개를 생성합니다.
INSERT INTO `POST_LIKE` (`POST_ID`, `USER_ID`, `CREATE_AT`)
SELECT
    @FIRST_POST_ID + S.`N` - 1,
    U.`ID`,
    DATE_SUB(NOW(), INTERVAL MOD(S.`N` * U.`USER_NO`, 720) HOUR)
FROM `TMP_0051_SEQUENCE` S
CROSS JOIN `TMP_0051_USERS` U
WHERE S.`N` <= 250
  AND MOD(S.`N` * 17 + U.`USER_NO` * 11, 5) < 2;

-- 일반 댓글과 답글(총 480개)에 댓글 좋아요 약 960개를 생성합니다.
INSERT INTO `COMMENT_LIKE` (`USER_ID`, `COMMENT_ID`, `POST_ID`, `CREATE_AT`)
SELECT
    U.`ID`,
    C.`COMMENT_ID`,
    C.`POST_ID`,
    DATE_SUB(NOW(), INTERVAL MOD(C.`COMMENT_ID` * U.`USER_NO`, 600) HOUR)
FROM `COMMENT` C
CROSS JOIN `TMP_0051_USERS` U
WHERE C.`COMMENT_ID` BETWEEN @FIRST_COMMENT_ID AND @FIRST_COMMENT_ID + 479
  AND MOD(C.`COMMENT_ID` * 13 + U.`USER_NO` * 7, 5) < 2;

-- ============================================================================
-- 09. 게시글 생성 결과 확인 및 임시 테이블 정리
-- ============================================================================

DROP TEMPORARY TABLE `TMP_0051_IMAGES`;
DROP TEMPORARY TABLE `TMP_0051_SEQUENCE`;
DROP TEMPORARY TABLE `TMP_0051_USERS`;

-- 실행 결과 확인
SELECT COUNT(*) AS `inserted_posts`
  FROM `POST`
 WHERE `POST_ID` BETWEEN @FIRST_POST_ID AND @FIRST_POST_ID + 249;
SELECT COUNT(*) AS `inserted_post_images`
  FROM `POST_UPLOAD`
 WHERE `POST_ID` BETWEEN @FIRST_POST_ID AND @FIRST_POST_ID + 249;
SELECT COUNT(*) AS `inserted_comments`
  FROM `COMMENT`
 WHERE `COMMENT_ID` BETWEEN @FIRST_COMMENT_ID AND @FIRST_COMMENT_ID + 479;

-- ============================================================
-- 10. 팔로우 관계 생성용 회원 매핑
--     USER1~USER30의 실제 PK와 회원 번호를 연결합니다.
-- ============================================================================

-- USER1~USER30의 실제 PK와 회원 번호를 매핑합니다.
DROP TEMPORARY TABLE IF EXISTS `TMP_0051_FOLLOW_USERS`;
CREATE TEMPORARY TABLE `TMP_0051_FOLLOW_USERS` AS
SELECT `ID`, CAST(SUBSTRING(`USER_ID`, 5) AS UNSIGNED) AS `USER_NO`
  FROM `USER`
 WHERE `USER_ID` REGEXP '^user([1-9]|[12][0-9]|30)$'
   AND `IS_DELETED` = 0;

-- 30명이 모두 준비되었는지 확인합니다. 결과가 30이 아니면 USER1~USER10 데이터를 먼저 확인하세요.
SELECT COUNT(*) AS `SEED_USER_COUNT`
  FROM `TMP_0051_FOLLOW_USERS`;

-- ============================================================================
-- 11. 팔로우 관계 데이터
--     실제 사용자처럼 분산된 팔로잉 관계를 중복 없이 생성합니다.
-- ============================================================================

-- 팔로우 관계 생성 기준
-- 1. 모든 회원이 가까운 두 계정을 기본 팔로우
-- 2. USER1, USER3, USER7은 상대적으로 팔로워가 많은 인기 계정
-- 3. 나머지는 결정적 분산식으로 관심 관계를 추가해 실행할 때마다 결과가 바뀌지 않도록 구성
-- 4. 자기 자신 및 기존 중복 관계는 제외
INSERT IGNORE INTO `FOLLOWE` (`FOLLOWER_ID`, `FOLLOWERING_ID`, `CREATE_AT`)
SELECT FOLLOWER.`ID`, FOLLOWING_MEMBER.`ID`,
       DATE_SUB(
           NOW(),
           INTERVAL MOD(
               CAST(SUBSTRING(FOLLOWER.`USER_ID`, 5) AS UNSIGNED) * 13
               + CAST(SUBSTRING(FOLLOWING_MEMBER.`USER_ID`, 5) AS UNSIGNED) * 7,
               120
           ) DAY
       )
  FROM `USER` FOLLOWER
 CROSS JOIN `USER` FOLLOWING_MEMBER
 WHERE FOLLOWER.`ID` <> FOLLOWING_MEMBER.`ID`
   AND FOLLOWER.`USER_ID` REGEXP '^user([1-9]|[12][0-9]|30)$'
   AND FOLLOWING_MEMBER.`USER_ID` REGEXP '^user([1-9]|[12][0-9]|30)$'
   AND FOLLOWER.`IS_DELETED` = 0
   AND FOLLOWING_MEMBER.`IS_DELETED` = 0
   AND (
       CAST(SUBSTRING(FOLLOWING_MEMBER.`USER_ID`, 5) AS UNSIGNED)
           = MOD(CAST(SUBSTRING(FOLLOWER.`USER_ID`, 5) AS UNSIGNED), 30) + 1
       OR CAST(SUBSTRING(FOLLOWING_MEMBER.`USER_ID`, 5) AS UNSIGNED)
           = MOD(CAST(SUBSTRING(FOLLOWER.`USER_ID`, 5) AS UNSIGNED) + 4, 30) + 1
       OR (
           CAST(SUBSTRING(FOLLOWING_MEMBER.`USER_ID`, 5) AS UNSIGNED) = 1
           AND MOD(CAST(SUBSTRING(FOLLOWER.`USER_ID`, 5) AS UNSIGNED), 3) <> 0
       )
       OR (
           CAST(SUBSTRING(FOLLOWING_MEMBER.`USER_ID`, 5) AS UNSIGNED) = 3
           AND MOD(CAST(SUBSTRING(FOLLOWER.`USER_ID`, 5) AS UNSIGNED), 4) IN (0, 1)
       )
       OR (
           CAST(SUBSTRING(FOLLOWING_MEMBER.`USER_ID`, 5) AS UNSIGNED) = 7
           AND MOD(CAST(SUBSTRING(FOLLOWER.`USER_ID`, 5) AS UNSIGNED), 5) IN (0, 1)
       )
       OR MOD(
           CAST(SUBSTRING(FOLLOWER.`USER_ID`, 5) AS UNSIGNED) * 37
           + CAST(SUBSTRING(FOLLOWING_MEMBER.`USER_ID`, 5) AS UNSIGNED) * 17,
           100
       ) < 7
   );

-- ============================================================================
-- 12. 포인트 상점 상품 데이터
--     상점 상품이 없을 때만 기본 상품을 등록합니다.
-- ============================================================================

INSERT INTO `SHOP_ITEM` (`NAME`, `DESCRIPTION`, `CATEGORY`, `COST_POINT`, `STOCK`, `IS_ACTIVE`)
SELECT * FROM (
    SELECT '올리브영 상품권 5천원' AS name,
           '올리브영 오프라인/온라인에서 사용 가능한 5,000원 상품권입니다.' AS description,
           'GIFT_CARD' AS category, 5000 AS cost_point, 100 AS stock, 1 AS is_active
    UNION ALL
    SELECT '올리브영 상품권 1만원',
           '올리브영에서 사용 가능한 10,000원 상품권입니다.',
           'GIFT_CARD', 10000, 80, 1
    UNION ALL
    SELECT '올리브영 상품권 3만원',
           '올리브영에서 사용 가능한 30,000원 상품권입니다.',
           'GIFT_CARD', 28000, 50, 1
    UNION ALL
    SELECT '여행 상품권 5만원',
           '국내 여행 예약에 사용 가능한 50,000원 상품권입니다.',
           'TRAVEL', 45000, 40, 1
    UNION ALL
    SELECT '여행 상품권 10만원',
           '국내 여행 예약에 사용 가능한 100,000원 상품권입니다.',
           'TRAVEL', 85000, 20, 1
    UNION ALL
    SELECT '국내선 비행기 할인권 1만원',
           '국내선 항공권 결제 시 10,000원 할인되는 쿠폰입니다.',
           'FLIGHT', 9000, 60, 1
    UNION ALL
    SELECT '국내선 비행기 할인권 3만원',
           '국내선 항공권 결제 시 30,000원 할인되는 쿠폰입니다.',
           'FLIGHT', 25000, 30, 1
    UNION ALL
    SELECT '기차 할인권 5천원',
           'KTX/SRT 등 기차 예매 시 5,000원 할인되는 쿠폰입니다.',
           'TRAIN', 4500, 100, 1
    UNION ALL
    SELECT '기차 할인권 1만원',
           'KTX/SRT 등 기차 예매 시 10,000원 할인되는 쿠폰입니다.',
           'TRAIN', 9000, 80, 1
) AS seed
WHERE NOT EXISTS (SELECT 1 FROM `SHOP_ITEM` LIMIT 1);

-- ============================================================================
-- 13. 생성 결과 확인
--     전체 팔로우 관계와 회원별 팔로워·팔로잉 수를 확인합니다.
-- ============================================================================

-- 생성 결과 확인: 전체 관계 수, 회원별 팔로잉 및 팔로워 수
SELECT COUNT(*) AS `TOTAL_FOLLOW_RELATIONS`
  FROM `FOLLOWE`;

SELECT U.`USER_ID`,
       COUNT(DISTINCT OUTGOING.`FOLLOWERING_ID`) AS `FOLLOWING_COUNT`,
       COUNT(DISTINCT INCOMING.`FOLLOWER_ID`) AS `FOLLOWER_COUNT`
  FROM `USER` U
  LEFT JOIN `FOLLOWE` OUTGOING ON OUTGOING.`FOLLOWER_ID` = U.`ID`
  LEFT JOIN `FOLLOWE` INCOMING ON INCOMING.`FOLLOWERING_ID` = U.`ID`
 WHERE U.`USER_ID` REGEXP '^user([1-9]|[12][0-9]|30)$'
 GROUP BY U.`ID`, U.`USER_ID`
 ORDER BY CAST(SUBSTRING(U.`USER_ID`, 5) AS UNSIGNED);

-- ============================================================================
-- 14. 최종 정리 및 트랜잭션 반영
-- ============================================================================

DROP TEMPORARY TABLE IF EXISTS `TMP_0051_FOLLOW_USERS`;
COMMIT;
