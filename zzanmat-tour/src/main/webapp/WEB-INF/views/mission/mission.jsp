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

            <!-- DB에서 미션 데이터를 비동기로 불러와 동적으로 렌더링할 영역 -->
            <section class="zt-panel zt-mission-list" id="missionListSection">
                <div class="text-center text-muted py-5">
                    <div class="spinner-border text-primary mb-2" role="status"></div>
                    <p class="mb-0">미션 목록을 불러오는 중입니다...</p>
                </div>
            </section>

        </main>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const contextPath = "${pageContext.request.contextPath}";
        const missionListSection = document.getElementById("missionListSection");

        // 미션 타입에 따른 아이콘 매핑 함수
        function getMissionIcon(missionType) {
            switch (missionType) {
                case 'POST': return 'bi-wallet2';
                case 'PHOTO': return 'bi-camera';
                case 'VIDEO': return 'bi-camera-video';
                case 'SHORTS': return 'bi-film';
                default: return 'bi-bookmark-check';
            }
        }

        // 백엔드 DB와 연동된 미션 목록 API 호출
        fetch(contextPath + "/mission/api/list")
            .then(response => {
                if (!response.ok) {
                    throw new Error("미션 데이터를 불러오는데 실패했습니다.");
                }
                return response.json();
            })
            .then(res => {
                const missions = Array.isArray(res) ? res : (res.data || []);
                missionListSection.innerHTML = "";

                if (missions.length === 0) {
                    missionListSection.innerHTML = '<p class="text-center text-muted py-4">등록된 미션이 없습니다.</p>';
                    return;
                }

                // DB에서 가져온 미션들을 순회하며 카드 생성
                missions.forEach(mission => {
                    const iconClass = getMissionIcon(mission.missionType);
                    const rawId = mission.missionId || mission.id;
                    const missionId = rawId ? rawId.toString().trim().split(/[:?#]/)[0].replace(/[^0-9]/g, '') : '';

                    const redirectUrl = contextPath + "/mission/active?missionId=" + missionId;

                    const article = document.createElement("article");
                    article.className = "zt-mission-card";

                    article.innerHTML = `
                        <div class="zt-mission-icon"><i class="bi \${iconClass}"></i></div>
                        <div>
                            <div class="d-flex flex-wrap gap-2 align-items-center mb-1">
                                <h2 class="h6 fw-bold mb-0">\${mission.title}</h2>
                                <span class="zt-chip">\${mission.missionType}</span>
                                <span class="badge bg-success-subtle text-success border border-success-subtle">+\${mission.rewardPoint ? mission.rewardPoint.toLocaleString() : 0}P</span>
                            </div>
                            <p class="zt-muted small mb-0">\${mission.description || ''}</p>
                        </div>
                        <button class="btn btn-warning fw-bold" type="button"
                                data-mission-accept
                                data-mission-id="\${missionId}"
                                data-redirect="\${redirectUrl}">
                            미션 수락
                        </button>
                    `;

                    missionListSection.appendChild(article);
                });
            })
            .catch(error => {
                console.error("미션 연동 에러:", error);
                missionListSection.innerHTML = '<p class="text-center text-danger py-4">미션 목록을 불러오지 못했습니다. 잠시 후 다시 시도해주세요.</p>';
            });

        // 미션 수락 버튼 클릭 이벤트 처리
        document.addEventListener("click", function (e) {
            const btn = e.target.closest("[data-mission-accept]");
            if (btn) {
                const redirectUrl = btn.getAttribute("data-redirect");
                const missionId = btn.getAttribute("data-mission-id");

                if (!missionId || isNaN(missionId)) {
                    alert("유효하지 않은 미션입니다.");
                    return;
                }

                if (redirectUrl) {
                    window.location.href = redirectUrl;
                }
            }
        });
    });
</script>

</body>
</html>