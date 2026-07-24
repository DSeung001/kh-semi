-- 아직　비밀번호　암호화기능이　없어　１２３４로　들어가도록　설정
-- 추후　회원가입시　비밀번호　암호화　기능을　통해　평문값이　안들어가도록　하여　수정할　예정
INSERT INTO `user` (user_id, user_password, email, nickname)
VALUES
    ('user1',  '1234', 'user1@naver.com',  '게임마스터'),
    ('user2',  '1234', 'user2@naver.com',  '여행초보'),
    ('user3',  '1234', 'user3@naver.com',  '바다거북'),
    ('user4',  '1234', 'user4@naver.com',  '산책러'),
    ('user5',  '1234', 'user5@naver.com',  '맛집탐험가'),
    ('user6',  '1234', 'user6@naver.com',  '카메라맨'),
    ('user7',  '1234', 'user7@naver.com',  '자유여행자'),
    ('user8',  '1234', 'user8@naver.com',  '도시탐방'),
    ('user9',  '1234', 'user9@naver.com',  '휴양러'),
    ('user10', '1234', 'user10@naver.com', '여행인');