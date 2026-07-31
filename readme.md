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

## Code Convention

### 레이어

```
Controller → Service → Mapper
```

- 별도 DAO 계층은 두지 않는다. MyBatis `@Mapper`가 데이터 접근(DAO) 역할을 한다.
- Mapper 메서드명은 Spring Data Repository 관례를 따른다.

### Mapper 네이밍

| 역할 | prefix | 예 |
|------|--------|----|
| 단건 조회 | `findBy...` | `findByMemberId` |
| 목록 조회 | `find...` / `findAll` | `findUserMissionsByUserId` |
| 존재/개수 | `existsBy...` / `countBy...` | `countByMemberId` |
| 저장 | `save` | `save` |
| 수정 | `update` / `update...` | `updateStatus` |
| 삭제 | `deleteBy...` | `deleteById` |

**금지**: Mapper에서 `insert*`, `select*`처럼 SQL 동사를 그대로 쓰지 않는다.

```
# before → after
insertMember          → save
selectByMemberId      → findByMemberId
selectUser            → findById
updateUser            → update
deleteMember          → deleteByMemberId
insertMessage         → save
selectRecent          → findRecent
insertMission         → save
selectUserMissions    → findUserMissionsByUserId
updateMissionStatus   → updateStatus
```

- Java 인터페이스 메서드명과 XML `id`는 항상 동일하게 맞춘다.
- Mapper XML 파일명은 `*Mapper.xml` 단수형으로 통일한다. (예: `PostMapper.xml`)
- soft delete도 메서드명은 `deleteById`로 두고, 논리삭제는 XML SQL에서 처리한다.

### MyBatis 연결

인터페이스 ↔ XML ↔ 설정을 아래 규칙으로 맞춘다.

#### 파일 / 패키지

| 구분 | 규칙 | 예 |
|------|------|----|
| Mapper 인터페이스 | `com.zzanmat.tour.{domain}.mapper.{Domain}Mapper` | `...member.mapper.MemberMapper` |
| Mapper XML | `src/main/resources/mappers/{Domain}Mapper.xml` (단수) | `mappers/MemberMapper.xml` |
| 어노테이션 | 인터페이스에 `@Mapper` | — |
| namespace | 인터페이스 FQCN과 **완전 동일** | `com.zzanmat.tour.member.mapper.MemberMapper` |
| statement `id` | 자바 메서드명과 **완전 동일** | `findByMemberId` |

```
MemberMapper.java  ←── namespace ──→  MemberMapper.xml
     findByMemberId()        id="findByMemberId"
```

#### application.properties

```properties
mybatis.type-aliases-package=com.zzanmat.tour
mybatis.mapper-locations=classpath:mappers/**/*.xml
mybatis.configuration.map-underscore-to-camel-case=true
```

- `type-aliases-package`: 도메인 전체를 스캔해 XML에서 `MemberDto`, `PostDto`처럼 **단순 클래스명**을 쓴다. FQCN은 쓰지 않는다.
- `mapper-locations`: `mappers/` 아래 `*Mapper.xml`만 둔다.
- `map-underscore-to-camel-case`: DB `user_id` ↔ Java `userId` 자동 매핑.

#### XML 타입 / resultMap

| 속성 | 규칙 | 예 |
|------|------|----|
| `parameterType` / `resultType` | type alias 단순명 | `parameterType="MemberDto"` |
| 기본형 | `int`, `long`, `string` | `resultType="int"` |
| `resultMap` id | `{domain}ResultMap` | `postResultMap` |
| `resultMap` type | type alias 단순명 | `type="PostDto"` |

단순 컬럼↔필드 매핑은 `resultType` + camelCase 설정을 쓰고, 조인·커스텀 매핑이 필요할 때만 `resultMap`을 쓴다.

#### `@Param` / `#{}` 이름

| 경우 | 규칙 |
|------|------|
| 단일 DTO/엔티티 파라미터 | `@Param` 생략, XML은 프로퍼티명 (`#{userId}`) |
| 기본형·다중 파라미터 | `@Param("이름")` 필수, XML `#{이름}`과 **동일** |
| PK 삭제/조회 | 의미가 드러나는 이름 (`postId`, `userId`, `id`) |

```java
// OK
MemberDto findByMemberId(@Param("userId") String userId);
int save(@Param("userId") Long userId, @Param("content") String content);
void save(MemberDto memberDto); // DTO 단일 → @Param 불필요
```

```xml
WHERE user_id = #{userId}
```

#### 연결 체크리스트 (새 Mapper 추가 시)

1. `{Domain}Mapper.java`에 `@Mapper` 추가
2. `mappers/{Domain}Mapper.xml` 생성, `namespace` = 인터페이스 FQCN
3. 메서드명 = XML `id`
4. `@Param` 이름 = `#{}` 이름
5. DTO는 type alias 단순명으로 `parameterType` / `resultType` 지정

### Service 네이밍

- Mapper의 SQL성 이름을 Service에 그대로 올리지 않는다.
- 비즈니스 동사를 사용한다. (`join`, `login`, `withdraw`, `createMission`, `getUserMissions`)
- 단순 CRUD 위임은 `findById`, `save`, `deleteById`를 허용한다.

### API 요청 / 응답

#### Request DTO

- JSON API(`/api/**`) 본문은 `@RequestBody` + DTO로 받는다.
- 폼 화면(`@Controller`)은 커맨드 객체(DTO) 바인딩을 사용한다. `@RequestParam`을 나열하지 않는다.
- Request는 기존 `XxxDto` 재사용 또는 `XxxRequest`, 응답 전용은 `XxxResponse`를 쓴다.

#### ApiResponse

모든 REST(JSON) 응답은 `ApiResponse<T>`로 감싼다.

```json
{
  "success": true,
  "message": "optional",
  "data": {}
}
```

```java
ApiResponse.success(data);
ApiResponse.success("메시지", data);
ApiResponse.fail("실패 메시지");
```

#### 전역 예외 처리

`@RestControllerAdvice`의 `GlobalExceptionHandler`에서 예외를 `ApiResponse.fail(...)`로 변환한다.

| 예외 | HTTP |
|------|------|
| `MethodArgumentNotValidException` | 400 |
| `IllegalArgumentException` | 400 |
| `IllegalStateException` | 409 |
| 그 외 | 500 |

뷰 Controller(redirect / flash)는 기존 방식을 유지한다.
