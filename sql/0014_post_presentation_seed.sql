USE zad;
SET NAMES utf8mb4;

INSERT INTO POST (
    USER_ID,
    TITLE,
    CONTENT,
    VIEW_COUNT,
    CREATE_AT,
    IS_BLOCK,
    TRANSPORT_COST,
    FOOD_COST,
    OTHER_COST
)
SELECT
    MOD(N.SEQ - 1, 10) + 1,

    CONCAT(
        '[발표용] ',
        CASE MOD(N.SEQ - 1, 10)
            WHEN 0 THEN '서울 망원동'
            WHEN 1 THEN '부산 해운대'
            WHEN 2 THEN '제주 동쪽'
            WHEN 3 THEN '전주 한옥마을'
            WHEN 4 THEN '경주 자전거'
            WHEN 5 THEN '강릉 바다'
            WHEN 6 THEN '여수 야경'
            WHEN 7 THEN '춘천 호수'
            WHEN 8 THEN '대구 골목'
            ELSE '인천 차이나타운'
        END,
        ' 여행 기록 #',
        LPAD(N.SEQ, 3, '0')
    ),

    CONCAT(
        CASE MOD(N.SEQ - 1, 5)
            WHEN 0 THEN '대중교통을 이용해 주요 관광지를 둘러보았습니다.'
            WHEN 1 THEN '현지 맛집과 산책 코스를 중심으로 여행했습니다.'
            WHEN 2 THEN '비용을 아끼면서도 알차게 즐긴 당일치기 여행입니다.'
            WHEN 3 THEN '친구와 함께 사진을 찍으며 즐거운 시간을 보냈습니다.'
            ELSE '혼자 여유롭게 걷고 쉬면서 여행을 즐겼습니다.'
        END,
        ' 교통비와 식비, 기타 비용을 정리한 발표용 여행 기록입니다.'
    ),

    MOD(N.SEQ * 13, 500),

    DATE_SUB(
        '2026-08-07 12:00:00',
        INTERVAL (200 - N.SEQ) HOUR
    ),

    FALSE,

    3000 + MOD(N.SEQ * 1700, 50000),
    5000 + MOD(N.SEQ * 2300, 60000),
    MOD(N.SEQ * 1100, 30000)

FROM (
    SELECT
        ONES.NUM
        + TENS.NUM * 10
        + HUNDREDS.NUM * 100
        + 1 AS SEQ
    FROM (
        SELECT 0 AS NUM UNION ALL SELECT 1 UNION ALL SELECT 2
        UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
        UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
        UNION ALL SELECT 9
    ) ONES
    CROSS JOIN (
        SELECT 0 AS NUM UNION ALL SELECT 1 UNION ALL SELECT 2
        UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
        UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
        UNION ALL SELECT 9
    ) TENS
    CROSS JOIN (
        SELECT 0 AS NUM
        UNION ALL
        SELECT 1
    ) HUNDREDS
) N

WHERE NOT EXISTS (
    SELECT 1
    FROM POST P
    WHERE P.TITLE = CONCAT(
        '[발표용] ',
        CASE MOD(N.SEQ - 1, 10)
            WHEN 0 THEN '서울 망원동'
            WHEN 1 THEN '부산 해운대'
            WHEN 2 THEN '제주 동쪽'
            WHEN 3 THEN '전주 한옥마을'
            WHEN 4 THEN '경주 자전거'
            WHEN 5 THEN '강릉 바다'
            WHEN 6 THEN '여수 야경'
            WHEN 7 THEN '춘천 호수'
            WHEN 8 THEN '대구 골목'
            ELSE '인천 차이나타운'
        END,
        ' 여행 기록 #',
        LPAD(N.SEQ, 3, '0')
    )
);

SELECT COUNT(*) AS PRESENTATION_POST_COUNT
FROM POST
WHERE TITLE LIKE '[발표용]%';

SELECT
    POST_ID,
    USER_ID,
    TITLE,
    VIEW_COUNT,
    CREATE_AT
FROM POST
WHERE TITLE LIKE '[발표용]%'
ORDER BY POST_ID DESC
LIMIT 10;