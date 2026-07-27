CREATE DATABASE IF NOT EXISTS zzanmat_tour
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;


USE zzanmat_tour;


SET FOREIGN_KEY_CHECKS = 0;


DROP TABLE IF EXISTS point_history;
DROP TABLE IF EXISTS mission_history;
DROP TABLE IF EXISTS mission_progress;
DROP TABLE IF EXISTS post_file;
DROP TABLE IF EXISTS post;
DROP TABLE IF EXISTS mission;
DROP TABLE IF EXISTS users;


SET FOREIGN_KEY_CHECKS = 1;

-- 1. 회원 테이블 --

CREATE TABLE users (

    id BIGINT AUTO_INCREMENT PRIMARY KEY,


    nickname VARCHAR(50) NOT NULL,


    email VARCHAR(100) UNIQUE NOT NULL,


    password VARCHAR(255) NOT NULL,


    point INT NOT NULL DEFAULT 0
    COMMENT '현재 보유 포인트',


    profile_image VARCHAR(500),


    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,


    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP

);

-- 2. 미션 정의 테이블 --

CREATE TABLE mission (

    id BIGINT AUTO_INCREMENT PRIMARY KEY,


    title VARCHAR(100) NOT NULL
    COMMENT '미션 제목',


    description TEXT
    COMMENT '미션 설명',


    mission_type ENUM(

        'POST',
        'PHOTO',
        'VIDEO',
        'SHORTS'
	) NOT NULL,

   trigger_event ENUM(
   'CREATE_POST',
   'UPLOAD_IMAGE', 
   'UPLOAD_VIDEO',
   'UPLOAD_SHORTS'
   ) NOT NULL ,


    target_count INT NOT NULL DEFAULT 1
    COMMENT '필요 수행 횟수',


    reward_point INT NOT NULL DEFAULT 0
    COMMENT '획득 포인트',


    auto_complete BOOLEAN NOT NULL DEFAULT TRUE,


    created_at DATETIME DEFAULT CURRENT_TIMESTAMP

);

-- 3. 회원별 미션 진행 상태 --

CREATE TABLE mission_progress (

    id BIGINT AUTO_INCREMENT PRIMARY KEY,


    user_id BIGINT NOT NULL,


    mission_id BIGINT NOT NULL,


    current_count INT DEFAULT 0
    COMMENT '현재 진행 수',


    progress INT DEFAULT 0
    CHECK(progress BETWEEN 1 AND 4 ),
    
    status ENUM(

        'READY',

        'IN_PROGRESS',

        'DONE'

    )
    DEFAULT 'READY',


    reward_received BOOLEAN DEFAULT FALSE
    COMMENT '보상 지급 여부',


    completed_at DATETIME,


    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,


    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,


    UNIQUE(user_id,mission_id),


    FOREIGN KEY(user_id)
    REFERENCES users(id)
    ON DELETE CASCADE,


    FOREIGN KEY(mission_id)
    REFERENCES mission(id)
    ON DELETE CASCADE

);

-- 4. 게시글 --

CREATE TABLE post (

    id BIGINT AUTO_INCREMENT PRIMARY KEY,


    user_id BIGINT NOT NULL,


    title VARCHAR(200),


    content TEXT,


    status ENUM(

        'TEMP',

        'PUBLIC',

        'DELETE'

    )
    DEFAULT 'TEMP',


    view_count INT NOT NULL DEFAULT 0,


    like_count INT  NOT NULL DEFAULT 0,


    comment_count INT NOT NULL DEFAULT 0,


    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,


    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,


    FOREIGN KEY(user_id)
    REFERENCES users(id)
    ON DELETE CASCADE

);


-- 5. 게시글 --

CREATE TABLE post_file (

    id BIGINT AUTO_INCREMENT PRIMARY KEY,


    post_id BIGINT NOT NULL,

   content_type VARCHAR(100),

    file_type ENUM(

        'IMAGE',

        'VIDEO',

        'SHORTS'

    ),


    original_name VARCHAR(255),


    stored_name VARCHAR(255),


    file_path VARCHAR(500),


    thumbnail_path VARCHAR(500),


    file_size BIGINT,


    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,


    FOREIGN KEY(post_id)
    REFERENCES post(id)
    ON DELETE CASCADE

);

-- 6. 미션기록 -- 

CREATE TABLE mission_history (

    id BIGINT AUTO_INCREMENT PRIMARY KEY,


    user_id BIGINT NOT NULL,


    mission_id BIGINT NOT NULL,


    post_id BIGINT,


    action_type VARCHAR(50)
    COMMENT 'CREATE_POST 등',

    completed_at DATETIME NOT NULL, 


    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,


    FOREIGN KEY(user_id)
    REFERENCES users(id)
    ON DELETE CASCADE,


    FOREIGN KEY(mission_id)
    REFERENCES mission(id)
    ON DELETE CASCADE,


    FOREIGN KEY(post_id)
    REFERENCES post(id)
    ON DELETE CASCADE

);

-- 7. 포인트 내역 -- 

CREATE TABLE point_history (

    id BIGINT AUTO_INCREMENT PRIMARY KEY,


    user_id BIGINT NOT NULL,


    mission_id BIGINT,


    point INT NOT NULL,


    reason ENUM( 
    'MISSION', 
    'EVENT', 
    'ADMIN', 
    'PURCHASE'
    ),


    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,


    FOREIGN KEY(user_id)
    REFERENCES users(id)
    ON DELETE CASCADE,


    FOREIGN KEY(mission_id)
    REFERENCES mission(id)

);

-- 8. 인덱스 --

CREATE INDEX idx_progress_user_status
ON mission_progress(user_id, status);


CREATE INDEX idx_post_user
ON post(user_id);


CREATE INDEX idx_history_user
ON mission_history(user_id);


-- 9. 기본 미션 등록 -- 

START TRANSACTION; 

INSERT INTO mission
(
title,
description,
mission_type,
trigger_event,
target_count,
reward_point
)

VALUES


(
'첫 여행 게시글 작성',
'여행 게시글 1개 작성하기',
'POST',
'CREATE_POST',
1,
2000
),


(
'여행 사진 업로드',
'사진이 포함된 게시글 작성',
'PHOTO',
'UPLOAD_IMAGE',
1,
500
),


(
'여행 영상 업로드',
'영상 게시글 작성',
'VIDEO',
'UPLOAD_VIDEO',
1,
1000
),


(
'쇼츠 영상 업로드',
'짧은 여행 영상 작성',
'SHORTS',
'UPLOAD_SHORTS',
1,
3000
);

-- 10. 테스트 회원 --

INSERT INTO users
(
nickname,
email,
password
)

VALUES

(
'짠맛투어',
'test@test.com',
'1234'
);

-- 11.회원가입 --

INSERT INTO mission_progress
(
user_id,
mission_id
)

SELECT

1,

id

FROM mission;

SET @userId = LAST_INSERT_ID();

INSERT INTO post
(
user_id,
title,
content,
status
)

VALUES

(
1,
'부산 여행 후기',
'해운대 여행 기록',
'PUBLIC'
);

-- 12. 미션 진행도 업데이트 -- 

UPDATE mission_progress mp

JOIN mission m

ON mp.mission_id=m.id


SET

mp.current_count =
mp.current_count + 1,


mp.progress = 100,


mp.status='DONE',


mp.completed_at= NOW()


WHERE

mp.user_id=1

AND

m.trigger_event='CREATE_POST'

AND

mp.status!='DONE';


-- 13. 미션 히스토리 저장

INSERT INTO mission_history
(
    user_id,
    mission_id,
    post_id,
    action_type,
    completed_at
)
VALUES
(
    @userId,
    1,
    @postId,
    'CREATE_POST',
    NOW()
);



-- 14. 포인트 지급 중복 지급 방지 --


UPDATE users u

JOIN mission_progress mp

ON u.id=mp.user_id


JOIN mission m

ON mp.mission_id=m.id


SET

u.point =
u.point + m.reward_point,


mp.reward_received = TRUE


WHERE

u.id= @userId

AND

mp.status='DONE'


AND

mp.reward_received= false;



-- 15 포인트 기록 저장 --

INSERT INTO point_history
(
user_id,
mission_id,
point,
reason
)

VALUES

(
@userId,
1,
2000,
'첫 게시글 작성 완료 보상'
);



-- 16미션 페이지 조회 --

SELECT

m.id,

m.title,

m.description,

m.reward_point,

mp.progress,

mp.status,

mp.reward_received


FROM mission_progress mp


JOIN mission m

ON mp.mission_id=m.id


WHERE mp.user_id= @userId;