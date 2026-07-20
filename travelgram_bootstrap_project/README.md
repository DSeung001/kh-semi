# Travelgram Bootstrap Frontend

첨부한 와이어프레임을 기반으로 구성한 정적 프론트엔드 프로젝트입니다.

## 사용 기술
- Bootstrap 5.3.8 CDN
- Bootstrap Icons 1.13.1 CDN
- 공용 스타일: `assets/css/common.css`
- 공용 동작: `assets/js/common.js`

## 실행 방법
1. 압축을 해제합니다.
2. `index.html`을 브라우저에서 엽니다.
3. 파일 링크로 각 페이지를 이동할 수 있습니다.

## 페이지 목록
- `index.html`: 메인 인스타그램형 피드
- `chat.html`: 실시간 여행 채팅
- `travelgram.html`: 나만의 여행 일기 사진 그리드
- `profile.html`: 내 정보
- `login.html`: 로그인
- `signup.html`: 회원가입
- `forgot-password.html`: 아이디/비밀번호 찾기
- `mission.html`: 미션 목록
- `mission-active.html`: 수락한 미션 진행
- `tag.html`: 태그 피드
- `feed-text.html`: 텍스트 중심 피드 상세
- `post-detail.html`: 사진 피드 상세 및 댓글
- `new-post.html`: 새 게시물 작성

## 참고
이 프로젝트는 화면 시안입니다. 로그인, 회원가입, 채팅, 이미지 업로드,
좋아요, 댓글, 미션 저장 등은 실제 서버와 데이터베이스 연결이 필요합니다.

## 공용 레이아웃 규칙
- 모든 HTML 페이지의 왼쪽 메뉴는 동일한 `<aside class="tg-sidebar">` 마크업을 사용합니다.
- 모든 HTML 페이지의 본문은 `<main class="tg-content">`를 사용합니다.
- 모든 페이지의 바깥 레이아웃은 `<div class="tg-layout">` 하나로 통일했습니다.
- 회원가입, 로그인, 비밀번호 찾기 페이지도 다른 페이지와 같은 열 위치를 사용합니다.
- 현재 메뉴의 `active` 표시는 `assets/js/common.js`가 파일명을 확인해 자동 적용합니다.
