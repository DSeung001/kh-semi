# kh-semi

## Git Convention

### 브랜치

기능 단위로 `feat/` 브랜치를 만듭니다.

```
feat/기능명
```

- 기준 브랜치: `main`
- 이름: 소문자 kebab-case (예: `feat/login-page`, `feat/feed-ui`)
- 작업 흐름: `main` → `feat/기능명` → PR → `main` 머지

### 커밋

[Conventional Commits](https://www.conventionalcommits.org/) 기반입니다.

```
type: 제목

상세 내용
```

| type | 용도 |
|------|------|
| feat | 기능 추가 |
| fix | 버그 수정 |
| refactor | 리팩토링 (동작 변경 없음) |
| docs | 문서 수정 |
| style | 포맷·CSS·UI 스타일 (동작 변경 없음) |
| chore | 설정·빌드·기타 잡무 |

버그·문서·설정 작업도 브랜치는 `feat/`로 통일하고, 커밋 `type`으로 구분합니다.

### 예시

브랜치: `feat/login-page`

```
feat: 로그인 페이지 추가

- 이메일/비밀번호 입력 폼 구현
- 유효성 검사 추가
```

```
fix: 로그인 유효성 검사 오류 수정
```
