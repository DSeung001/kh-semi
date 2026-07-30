<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="여행 미션 목록">
    <title>미션 | 짠맛투어</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
</head>
<body>
<div class="zt-app">

    <header class="zt-mobile-header">
        <a class="zt-brand" href="${pageContext.request.contextPath}/home">
            <span>짠맛투어</span>
        </a>
        <a href="${pageContext.request.contextPath}/login" class="fs-5" aria-label="로그인"><i class="bi bi-box-arrow-in-right"></i></a>
    </header>
    <nav class="zt-mobile-nav" aria-label="모바일 메뉴">
        <a href="${pageContext.request.contextPath}/home" class="" aria-label="home"><i class="bi bi-house"></i></a>
        <a href="${pageContext.request.contextPath}/my-travel" class="" aria-label="짠맛투어"><i class="bi bi-grid-3x3-gap"></i></a>
        <a href="${pageContext.request.contextPath}/new-post" class="" aria-label="new"><i class="bi bi-plus-square"></i></a>
        <a href="${pageContext.request.contextPath}/chat" class="" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
        <a href="${pageContext.request.contextPath}/profile" class="" aria-label="profile"><i class="bi bi-person-circle"></i></a>
    </nav>
    <div class="zt-layout">

        <jsp:include page="/WEB-INF/views/components/sidebar.jsp">
            <jsp:param name="activePage" value="mission" />
        </jsp:include>

        <main class="zt-content">

            <header class="zt-page-header">
                <h1>Mission Possible</h1>
                <p>재미있는 여행 미션에 도전하고 인증 기록을 남겨보세요.</p>
            </header>

            <!-- [추가] 실시간 프로그레스바 및 요약 영역 -->
            <section class="zt-panel mb-3 p-3 bg-white shadow-sm rounded-4">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <span class="fw-bold text-dark"><i class="bi bi-trophy text-warning me-1"></i> 나의 미션 진행 상황</span>
                    <span id="progressText" class="text-primary fw-bold">
            <!-- 초기값은 서버에서 EL표기법으로 렌더링 가능 -->
            ${completedCount} / ${totalCount} 완료 (${progressPercent}%)
        </span>
                </div>
                <div class="progress" style="height: 12px; border-radius: 6px;">
                    <div id="missionProgressBar"
                         class="progress-bar bg-success progress-bar-striped progress-bar-animated"
                         role="progressbar"
                         style="width: ${progressPercent}%;">
                    </div>
                </div>
            </section>

            <!-- 미션 목록이 동적으로 들어갈 영역 -->
            <section class="zt-panel zt-mission-list" id="missionListSection">

            </section>

        </main>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>

<!-- API 호출 및 동적 렌더링 스크립트 -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const contextPath = "${pageContext.request.contextPath}";
        const missionListSection = document.getElementById("missionListSection");

        // 미션 타입(missionType)에 따라 어울리는 아이콘을 매핑해주는 함수

        function getMissionIcon(missionType) {
            switch (missionType) {
                case 'POST': return 'bi-wallet2';
                case 'PHOTO': return 'bi-camera';
                case 'VIDEO': return 'bi-camera-video';
                case 'SHORTS': return 'bi-film';
                default: return 'bi-bookmark-check';
            }
        }

        // API 호출
        fetch(contextPath + "/api/mission")
            .then(response => {
                if (!response.ok) {
                    throw new Error("네트워크 응답에 문제가 있습니다.");
                }
                return response.json();
            })
            .then(missions => {
                missionListSection.innerHTML = ""; // 기존 내용 초기화

                if (missions.length === 0) {
                    missionListSection.innerHTML = '<p class="text-center text-muted py-4">등록된 미션이 없습니다.</p>';
                    return;
                }

                // 데이터 순회하며 카드 생성
                missions.forEach(mission => {
                    const iconClass = getMissionIcon(mission.missionType);

                    const redirectUrl = contextPath + "/mission/active?missionId=" + mission.id;

                    const article = document.createElement("article");
                    article.className = "zt-mission-card";

                    article.innerHTML = `
                        <div class="zt-mission-icon"><i class="bi \${iconClass}"></i></div>
                        <div>
                            <div class="d-flex flex-wrap gap-2 align-items-center mb-1">
                                <h2 class="h6 fw-bold mb-0">\${mission.title}</h2>
                                <span class="zt-chip">\${mission.missionType}</span>
                                <span class="badge bg-success-subtle text-success border border-success-subtle">\+\${mission.rewardPoint.toLocaleString()}P</span>
                            </div>
                            <p class="zt-muted small mb-0">\${mission.description}</p>
                        </div>
                        <button class="btn btn-warning fw-bold" type="button"
                                data-mission-accept
                                data-mission="\${mission.title}"
                                data-redirect="\${redirectUrl}">
                            미션 수락
                        </button>
                    `;

                    missionListSection.appendChild(article);
                });
            })
            .catch(error => {
                console.error("미션 데이터를 불러오는 중 에러 발생:", error);
                missionListSection.innerHTML = '<p class="text-center text-danger py-4">미션 목록을 불러오지 못했습니다.</p>';
            });

        // 수락 버튼 클릭 이벤트 위임 (동적으로 생성된 버튼 대응)
        document.addEventListener("click", function (e) {
            const btn = e.target.closest("[data-mission-accept]");
            if (btn) {
                const redirectUrl = btn.getAttribute("data-redirect");
                const missionTitle = btn.getAttribute("data-mission");

                console.log(`[\${missionTitle}] 미션 수락됨. 이동 경로: \${redirectUrl}`);
                if (redirectUrl) {
                    window.location.href = redirectUrl;
                }
            }
        });
    });
</script>

</body>
</html>