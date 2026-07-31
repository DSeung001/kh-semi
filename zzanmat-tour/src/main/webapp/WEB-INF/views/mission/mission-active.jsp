<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="수락한 여행 미션 진행 페이지">
    <title>진행 중인 미션 | 짠맛투어</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
</head>
<body>
<div class="zt-app">

    <!-- 상단 헤더 -->
    <header class="zt-mobile-header">
        <a class="zt-brand" href="${pageContext.request.contextPath}/home">
            <span>짠맛투어</span>
        </a>
        <div class="d-flex align-items-center gap-3">
            <!-- 실시간 보유 포인트 표시 -->
            <span class="badge bg-warning text-dark fw-bold px-3 py-2">
                <i class="bi bi-coin me-1"></i> <span id="headerPoint">1,000</span> P
            </span>
            <a href="${pageContext.request.contextPath}/login" class="fs-5 text-dark" aria-label="로그인"><i class="bi bi-box-arrow-in-right"></i></a>
        </div>
    </header>

    <!-- 하단 네비게이션 바 -->
    <nav class="zt-mobile-nav" aria-label="모바일 메뉴">
        <a href="${pageContext.request.contextPath}/home" aria-label="home"><i class="bi bi-house"></i></a>
        <a href="${pageContext.request.contextPath}/my-travel" aria-label="짠맛투어"><i class="bi bi-grid-3x3-gap"></i></a>
        <a href="${pageContext.request.contextPath}/new-post" aria-label="new"><i class="bi bi-plus-square"></i></a>
        <a href="${pageContext.request.contextPath}/chat" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
        <a href="${pageContext.request.contextPath}/profile" aria-label="profile"><i class="bi bi-person-circle"></i></a>
    </nav>

    <div class="zt-layout">

        <jsp:include page="/WEB-INF/views/components/sidebar.jsp">
            <jsp:param name="activePage" value="mission" />
        </jsp:include>

        <main class="zt-content p-4">

            <header class="zt-page-header mb-4">
                <!-- 동적으로 바뀔 미션 제목 및 설명 영역 -->
                <h1 class="fw-bold" id="missionTitle">미션 정보를 불러오는 중...</h1>
                <p class="text-muted" id="missionDesc">사용자의 미션 수행 상태를 실시간으로 확인하고 있습니다.</p>
            </header>

            <section class="zt-panel zt-profile-card card p-4 shadow-sm border-0 bg-white rounded-3">
                <div class="ratio ratio-21x9 rounded-3 overflow-hidden mb-4 bg-light">
                    <img src="${pageContext.request.contextPath}/assets/images/seoul.svg" class="object-fit-cover" alt="진행 중인 여행 미션" onerror="this.src='https://via.placeholder.com/800x300?text=Zzanmat+Tour'">
                </div>

                <!-- 실시간 프로그레스바 영역 -->
                <div class="mb-4">
                    <div class="d-flex justify-content-between mb-2">
                        <strong class="text-dark">전체 진행률</strong>
                        <span class="text-muted fw-bold" id="progressText">0 / 4 (0%)</span>
                    </div>

                    <div class="progress zt-mission-progress" role="progressbar" aria-label="미션 진행률" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="height: 12px; border-radius: 6px;">
                        <div class="progress-bar bg-warning progress-bar-striped progress-bar-animated" id="progressBar" style="width: 0%"></div>
                    </div>
                </div>

                <!-- 항목 1: 여행 후기 작성 -->
                <div class="card mb-2 p-3 border rounded-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="form-check">
                            <input class="form-check-input mission-checkbox" type="checkbox" id="checkReview" data-task-key="review" disabled>
                            <label class="form-check-label fw-semibold" for="checkReview">
                                여행 후기 작성하기
                            </label>
                            <p class="text-muted small mb-0">피드에 여행 동선과 경비를 공유 (게시글 작성 시 자동 완료)</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/new-post" class="btn btn-outline-warning btn-sm fw-bold">
                            작성하러 가기 <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>

                <!-- 항목 2: 맛집 방문/인증 -->
                <div class="card mb-2 p-3 border rounded-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="form-check">
                            <input class="form-check-input mission-checkbox" type="checkbox" id="checkMeal" data-task-key="meal" disabled>
                            <label class="form-check-label fw-semibold" for="checkMeal">
                                짠맛투어 맛집 방문 인증
                            </label>
                            <p class="text-muted small mb-0">제휴 맛집 방문 후 사진 업로드 시 자동 완료</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/new-post" class="btn btn-outline-warning btn-sm fw-bold">
                            인증하러 가기 <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>

                <!-- 항목 3: 셀카 업로드 -->
                <div class="card mb-2 p-3 border rounded-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="form-check">
                            <input class="form-check-input mission-checkbox" type="checkbox" id="checkLandmark" data-task-key="landmark" disabled>
                            <label class="form-check-label fw-semibold" for="checkLandmark">
                                여행지에서 셀카 찍어 업로드
                            </label>
                            <p class="text-muted small mb-0">여행지 풍경이나 셀카를 포함하여 게시글 작성</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/new-post" class="btn btn-outline-warning btn-sm fw-bold">
                            업로드하러 가기 <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>

                <!-- 항목 4: 첫 게시글 작성 -->
                <div class="card mb-2 p-3 border rounded-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="form-check">
                            <input class="form-check-input mission-checkbox" type="checkbox" id="checkTransit" data-task-key="transit" disabled>
                            <label class="form-check-label fw-semibold" for="checkTransit">
                                회원가입 후 게시글 1회 작성하기
                            </label>
                            <p class="text-muted small mb-0">첫 피드 글 작성 시 즉시 반영됩니다.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/new-post" class="btn btn-outline-warning btn-sm fw-bold">
                            작성하러 가기 <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>

                <!-- 인증 완료 및 보상 받기 버튼 -->
                <button class="btn btn-secondary zt-primary-btn w-100 py-3 fw-bold shadow-sm mt-3" id="completeBtn" type="button" disabled>
                    모든 미션 항목을 완료해주세요 (0/4)
                </button>
            </section>

        </main>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>

<!-- 💡 서버 액션 기반 실시간 자동 인증 및 프로그레스바 동기화 스크립트 -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const contextPath = "${pageContext.request.contextPath}";
        const currentUserId = 1; // 실제 로그인한 유저 ID 연동 구간

        const urlParams = new URLSearchParams(window.location.search);
        const missionId = urlParams.get("missionId") || 1;

        const missionTitleEl = document.getElementById("missionTitle");
        const missionDescEl = document.getElementById("missionDesc");
        const progressBar = document.getElementById("progressBar");
        const progressText = document.getElementById("progressText");
        const headerPoint = document.getElementById("headerPoint");
        const completeBtn = document.getElementById("completeBtn");
        const checkboxes = document.querySelectorAll(".mission-checkbox");

        // 1. 미션 기본 정보 불러오기 (유저 API 호출 제거로 404 에러 방지)
        function loadMissionMeta() {
            fetch(contextPath + "/api/mission")
                .then(res => res.ok ? res.json() : [])
                .then(missions => {
                    if (Array.isArray(missions) && missions.length > 0) {
                        const currentMission = missions.find(m => m.id == missionId) || missions[0];
                        if (currentMission) {
                            missionTitleEl.textContent = currentMission.title;
                            missionDescEl.textContent = currentMission.description;
                        }
                    } else {
                        missionTitleEl.textContent = "진행 중인 여행 미션";
                        missionDescEl.textContent = "미션 항목을 완료하고 포인트를 받아보세요!";
                    }
                })
                .catch(err => {
                    console.error("미션 메타 정보 로딩 실패:", err);
                    missionTitleEl.textContent = "진행 중인 여행 미션";
                    missionDescEl.textContent = "미션 항목을 완료하고 포인트를 받아보세요!";
                });
        }

        // 2. 서버에서 유저의 행동/인증 상태를 조회하여 체크박스와 프로그레스바 자동 동기화
        function fetchAndUpdateAutoProgress() {
            fetch(contextPath + `/api/mission/progress?userId=\${currentUserId}&missionId=\${missionId}`)
                .then(res => res.ok ? res.json() : {})
                .then(statusMap => {
                    let checkedCount = 0;
                    const totalCount = checkboxes.length;

                    checkboxes.forEach(cb => {
                        const taskKey = cb.getAttribute("data-task-key"); // review, meal, landmark, transit
                        if (statusMap && statusMap[taskKey] === true) {
                            cb.checked = true; // 서버 행동 감지 시 자동 체크!
                        } else {
                            cb.checked = false;
                        }

                        if (cb.checked) checkedCount++;
                    });

                    // 프로그레스바 및 버튼 UI 업데이트
                    updateProgressBarUI(checkedCount, totalCount);
                })
                .catch(err => console.error("자동 인증 상태 동기화 실패:", err));
        }

        // 3. 프로그레스바 및 완료 버튼 상태 제어 함수
        function updateProgressBarUI(checkedCount, totalCount) {
            let percent = Math.floor((checkedCount / totalCount) * 100);

            progressBar.style.width = percent + "%";
            progressText.textContent = `\${checkedCount} / \${totalCount} (\${percent}%)`;
            progressBar.setAttribute("aria-valuenow", percent);

            if (percent === 100) {
                progressBar.classList.remove("bg-warning");
                progressBar.classList.add("bg-success");

                completeBtn.classList.remove("btn-secondary");
                completeBtn.classList.add("btn-primary");
                completeBtn.removeAttribute("disabled");
                completeBtn.textContent = "미션 인증 완료 및 보상 받기 🎉";
            } else {
                progressBar.classList.remove("bg-success");
                progressBar.classList.add("bg-warning");

                completeBtn.classList.remove("btn-primary");
                completeBtn.classList.add("btn-secondary");
                completeBtn.setAttribute("disabled", "true");
                completeBtn.textContent = `모든 미션 항목을 완료해주세요 (\${checkedCount}/\${totalCount})`;
            }
        }

        // 초기 실행
        loadMissionMeta();
        fetchAndUpdateAutoProgress();

        // 💡 4. 실시간 동기화: 3초마다 서버 상태 자동 확인
        setInterval(fetchAndUpdateAutoProgress, 3000);

        // 5. '미션 인증 완료 및 보상 받기' 버튼 클릭 이벤트
        completeBtn.addEventListener("click", function () {
            fetch(contextPath + "/api/mission/complete", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ missionId: Number(missionId), userId: Number(currentUserId) })
            })
                .then(res => {
                    if (res.ok) {
                        alert("🎉 모든 미션이 성공적으로 인증되어 보상이 지급되었습니다!");
                        window.location.href = contextPath + "/my-travel";
                    } else {
                        alert("보상 지급 처리 중 오류가 발생했습니다.");
                    }
                })
                .catch(err => {
                    console.error("완료 요청 에러:", err);
                    alert("마이페이지로 이동합니다.");
                    window.location.href = contextPath + "/my-travel";
                });
        });
    });
</script>
</body>
</html>