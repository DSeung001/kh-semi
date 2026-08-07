USE zad;
SET NAMES utf8mb4;

-- 발표용 게시글 좋아요 추가
INSERT INTO POST_LIKE (
    POST_ID,
    USER_ID,
    CREATE_AT
)
SELECT
    P.POST_ID,
    U.ID,
    DATE_ADD(P.CREATE_AT, INTERVAL U.ID MINUTE)
FROM POST P
JOIN `USER` U
    ON U.ID BETWEEN 1 AND 10
    AND U.ID <= MOD(P.POST_ID, 5) + 1
WHERE P.TITLE LIKE '[발표용]%'
  AND NOT EXISTS (
      SELECT 1
      FROM POST_LIKE PL
      WHERE PL.POST_ID = P.POST_ID
        AND PL.USER_ID = U.ID
  );


-- 발표용 게시글 댓글 추가
INSERT INTO `COMMENT` (
    USER_ID,
    POST_ID,
    PARENT_COMMENT_ID,
    CONTENT,
    CREATE_AT,
    UPDATE_AT
)
SELECT
    MOD(P.POST_ID + C.NUM - 1, 10) + 1,
    P.POST_ID,
    NULL,
    CONCAT(
        '[발표용 댓글 ',
        C.NUM,
        '] ',
        CASE C.NUM
            WHEN 1 THEN '여행 정보가 자세해서 도움이 되었습니다.'
            WHEN 2 THEN '비용까지 정리되어 있어서 참고하기 좋습니다.'
            ELSE '다음 여행 계획을 세울 때 참고하겠습니다.'
        END
    ),
    DATE_ADD(P.CREATE_AT, INTERVAL C.NUM MINUTE),
    DATE_ADD(P.CREATE_AT, INTERVAL C.NUM MINUTE)
FROM POST P
CROSS JOIN (
    SELECT 1 AS NUM
    UNION ALL
    SELECT 2
    UNION ALL
    SELECT 3
) C
WHERE P.TITLE LIKE '[발표용]%'
  AND C.NUM <= MOD(P.POST_ID, 3) + 1
  AND NOT EXISTS (
      SELECT 1
      FROM `COMMENT` EXISTING_COMMENT
      WHERE EXISTING_COMMENT.POST_ID = P.POST_ID
        AND EXISTING_COMMENT.CONTENT = CONCAT(
            '[발표용 댓글 ',
            C.NUM,
            '] ',
            CASE C.NUM
                WHEN 1 THEN '여행 정보가 자세해서 도움이 되었습니다.'
                WHEN 2 THEN '비용까지 정리되어 있어서 참고하기 좋습니다.'
                ELSE '다음 여행 계획을 세울 때 참고하겠습니다.'
            END
        )
  );


-- 추가된 좋아요 개수 확인
SELECT COUNT(*) AS PRESENTATION_LIKE_COUNT
FROM POST_LIKE PL
JOIN POST P
    ON P.POST_ID = PL.POST_ID
WHERE P.TITLE LIKE '[발표용]%';


-- 추가된 댓글 개수 확인
SELECT COUNT(*) AS PRESENTATION_COMMENT_COUNT
FROM `COMMENT` C
JOIN POST P
    ON P.POST_ID = C.POST_ID
WHERE P.TITLE LIKE '[발표용]%'
  AND C.CONTENT LIKE '[발표용 댓글%';