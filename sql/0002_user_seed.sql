-- 평문 비밀번호: 1234 (BCrypt 해시로 저장)
-- Spring Security BCryptPasswordEncoder와 동일한 방식으로 생성
USE zad;

INSERT INTO `USER` (USER_ID, USER_PASSWORD, EMAIL, NICKNAME)
VALUES
    ('user1',  '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user1@naver.com',  '게임마스터'),
    ('user2',  '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user2@naver.com',  '여행초보'),
    ('user3',  '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user3@naver.com',  '바다거북'),
    ('user4',  '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user4@naver.com',  '산책러'),
    ('user5',  '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user5@naver.com',  '맛집탐험가'),
    ('user6',  '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user6@naver.com',  '카메라맨'),
    ('user7',  '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user7@naver.com',  '자유여행자'),
    ('user8',  '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user8@naver.com',  '도시탐방'),
    ('user9',  '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user9@naver.com',  '휴양러'),
    ('user10', '$2a$10$QV5cLSald4ZjUF6ThFe.IOG9ZBaf5TUlNhcxzFBCsuQERC.Vkaihy', 'user10@naver.com', '여행인');
