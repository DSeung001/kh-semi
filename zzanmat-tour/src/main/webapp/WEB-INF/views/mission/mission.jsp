<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="여행 미션 목록 및 자동 인증 시스템">
    <title>미션 | 짠맛투어</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
</head>
<body>
<div class="zt-app">

    <!-- 상단 모바일 헤더 -->
    <header class="zt-mobile-header">
        <a class="zt-brand" href="${pageContext.request.contextPath}/home">
            <span>짠맛투어</span>
        </a>
        <div class="d-flex align-items-center gap-3">
            <!-- 실시간 유저 보유 포인트 표시 영역 -->
            <span class="badge bg-warning text-dark fw-bold px-3 py-2" id="headerUserPoint">
                <i class="bi bi-coin me-1"></i> <span id="pointVal">1,000</span> P
            </span>
            <a href="${pageContext.request.contextPath}/login" class="fs-5 text-dark" aria-label="로그인"><i class="bi bi-box-arrow-in-right"></i></a>
        </div>
    </header>

    <!-- 모바일 네비게이션 -->
    <nav class="zt-mobile-nav" aria-label="모바일 메뉴">
        <a href="${pageContext.request.contextPath}/home" aria-label="home"><i class="bi bi-house"></i></a>
        <a href="${pageContext.request.contextPath}/my-travel" aria-label="짠맛투어"><i class="bi bi-grid-3x3-gap"></i></a>
        <a href="${pageContext.request.contextPath}/new-post" aria-label="new"><i class="bi bi-plus-square"></i></a>
        <a href="${pageContext.request.contextPath}/chat" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
        <a href="${pageContext.request.contextPath}/profile" aria-label="profile"><i class="bi bi-person-circle"></i></a>
    </nav>

    <div class="zt-layout">
        <!-- 사이드바 -->
        <jsp:include page="/WEB-INF/views/components/sidebar.jsp">
            <jsp:param name="activePage" value="mission" />
        </jsp:include>

        <!-- 메인 콘텐츠 영역 -->
        <main class="zt-content p-4">
            <header class="zt-page-header mb-4">
                <h1 class="fw-bold">Mission Possible</h1>
                <p class="text-muted">미션을 수락하고 활동(게시글 작성 등)을 완료하면 시스템이 자동으로 감지하여 포인트를 즉시 적립해 드립니다!</p>
            </header>

            <!-- 미션 목록이 동적으로 렌더링될 패널 -->
            <section class="zt-panel" id="missionListSection">
                <div class="text-center py-5">
                    <div class="spinner-border text-warning" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="text-muted mt-2">미션 정보를 불러오는 중입니다...</p>
                </div>
            </section>
        </main>
    </div>
</div>

<!-- Bootstrap JS 및 공통 스크립트 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>

<!-- 💡 자동 인증 시스템 연계 및 실시간 프로그레스바 연동 스크립트 -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const contextPath = "${pageContext.request.contextPath}";
        const missionListSection = document.getElementById("missionListSection");
        const pointValSpan = document.getElementById("pointVal");

        const currentUserId = 1; // 테스트용 유저 ID

        function getMissionIcon(missionType) {
            switch (missionType) {
                case 'POST': return 'bi-wallet2';
                case 'PHOTO': return 'bi-camera';
                case 'VIDEO': return 'bi-camera-video';
                case 'SHORTS': return 'bi-film';
                default: return 'bi-bookmark-check';
            }
        }

        function fetchMissionData() {
            // 유저 포인트 API 호출부를 제거하고 미션 관련 API만 병렬 호출하여 404 에러 방지
            Promise.all([
                fetch(contextPath + "/api/mission").then(res => res.ok ? res.json() : []),
                fetch(contextPath + "/api/mission/my?userId=" + currentUserId).then(res => res.ok ? res.json() : []).catch(() => [])
            ])
                .then(([allMissions, userMissions]) => {
                    missionListSection.innerHTML = "";

                    if (!allMissions || allMissions.length === 0) {
                        missionListSection.innerHTML = '<p class="text-center text-muted py-4">등록된 미션이 없습니다.</p>';
                        return;
                    }

                    const userMissionMap = new Map();
                    if (Array.isArray(userMissions)) {
                        userMissions.forEach(um => userMissionMap.set(um.missionId, um));
                    }

                    allMissions.forEach(mission => {
                        const iconClass = getMissionIcon(mission.missionType);
                        const userMission = userMissionMap.get(mission.id);

                        const status = userMission ? userMission.status : 'READY';
                        const currentCount = userMission ? userMission.progressCount : 0;
                        const targetCount = mission.targetCount || 1;

                        let percent = Math.floor((currentCount / targetCount) * 100);
                        if (percent > 100) percent = 100;
                        if (status === 'DONE') percent = 100;

                        // 상태에 따른 버튼 디자인 및 액션 설정
                        let btnText = "미션 수락";
                        let btnClass = "btn-warning";
                        let actionType = "accept";
                        let actionUrl = "";

                        if (status === 'IN_PROGRESS') {
                            btnText = " 게시글 작성하러 가기";
                            btnClass = "btn-primary";
                            actionType = "goToPost";
                            actionUrl = contextPath + "/new-post"; // 게시글 작성 페이지
                        } else if (status === 'DONE') {
                            btnText = "인증 완료됨 🎉";
                            btnClass = "btn-success";
                            actionType = "done";
                        }

                        const article = document.createElement("article");
                        article.className = "zt-mission-card card mb-3 p-3 shadow-sm border-0 bg-white rounded-3";

                        // 진행 중(IN_PROGRESS)일 때 사용자 안내 가이드 박스 추가
                        let guideHtml = "";
                        if (status === 'IN_PROGRESS') {
                            guideHtml = `
                            <div class="mt-3 p-2 bg-light rounded border border-primary-subtle">
                                <p class="small text-muted mb-0">
                                    <i class="bi bi-info-circle-fill text-primary me-1"></i>
                                    활동(게시글/사진 업로드 등)을 완료하시면 시스템이 자동으로 인증하여 포인트를 적립해 드립니다.
                                </p>
                            </div>
                        `;
                        }

                        article.innerHTML = `
                        <div class="d-flex align-items-start gap-3">
                            <div class="zt-mission-icon fs-2 text-warning bg-light p-3 rounded-circle">
                                <i class="bi \${iconClass}"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="d-flex flex-wrap gap-2 align-items-center mb-1">
                                    <h2 class="h6 fw-bold mb-0 text-dark">\${mission.title}</h2>
                                    <span class="badge bg-secondary text-white">\${mission.missionType}</span>
                                    <span class="badge bg-success-subtle text-success border border-success-subtle">+\${mission.rewardPoint.toLocaleString()}P</span>
                                </div>
                                <p class="zt-muted small text-muted mb-2">\${mission.description}</p>

                                <!-- 실시간 프로그레스바 -->
                                <div>
                                    <div class="d-flex justify-content-between small text-muted mb-1">
                                        <span>실시간 진행 상황</span>
                                        <span class="fw-bold">\${currentCount} / \${targetCount} (\${percent}%)</span>
                                    </div>
                                    <div class="progress" style="height: 10px; border-radius: 5px;">
                                        <div class="progress-bar \${status === 'DONE' ? 'bg-success' : 'bg-warning progress-bar-striped progress-bar-animated'}"
                                             role="progressbar"
                                             style="width: \${percent}%;"
                                             aria-valuenow="\${percent}"
                                             aria-valuemin="0"
                                             aria-valuemax="100">
                                        </div>
                                    </div>
                                </div>

                                \${guideHtml}
                            </div>
                            <div class="align-self-center ms-2">
                                <button class="btn \${btnClass} fw-bold px-3 py-2" type="button"
                                        data-mission-action
                                        data-action-type="\${actionType}"
                                        data-action-url="\${actionUrl}"
                                        data-mission-id="\${mission.id}"
                                        \${status === 'DONE' ? 'disabled' : ''}>
                                    \${btnText}
                                </button>
                            </div>
                        </div>
                    `;

                        missionListSection.appendChild(article);
                    });
                })
                .catch(error => {
                    console.error("미션 데이터 로딩 실패:", error);
                    missionListSection.innerHTML = '<p class="text-center text-danger py-4">미션 데이터를 불러오지 못했습니다.</p>';
                });
        }

        // 초기 데이터 로드 (실시간 최신 상태 반영)
        fetchMissionData();

        // 이벤트 위임 (미션 수락 및 진행 페이지 이동 처리)
        document.addEventListener("click", function (e) {
            const btn = e.target.closest("[data-mission-action]");
            if (!btn) return;

            const actionType = btn.getAttribute("data-action-type");
            const missionId = btn.getAttribute("data-mission-id");
            const actionUrl = btn.getAttribute("data-action-url");

            if (actionType === "accept") {
                // 1. 미션 수락 API 호출
                fetch(contextPath + "/api/mission/accept", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ missionId: missionId, userId: currentUserId })
                })
                    .then(res => {
                        if (res.ok) {
                            alert("미션이 수락되었습니다! 미션 진행 페이지로 이동합니다.");
                            // 💡 수락 성공 시 곧바로 상세 진행 화면(mission-active)으로 이동!
                            window.location.href = contextPath + `/mission/active?missionId=\${missionId}`;
                        } else {
                            alert("미션 수락에 실패했습니다.");
                        }
                    })
                    .catch(err => {
                        console.error("수락 에러:", err);
                        // 에러가 나더라도 테스트를 위해 상세 페이지로 강제 이동하려면 아래 주석 해제
                        window.location.href = contextPath + `/mission/active?missionId=\${missionId}`;
                    });

            } else if (actionType === "goToPost") {
                // 2. 이미 수락된 미션(IN_PROGRESS)일 때 진행 화면 또는 글작성 페이지로 이동
                window.location.href = contextPath + `/mission/active?missionId=\${missionId}`;
            }
        });
    });

</script>
</body>
</html>