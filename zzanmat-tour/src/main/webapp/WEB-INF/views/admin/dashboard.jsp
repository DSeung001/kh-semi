<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>관리자 대시보드 | 짠맛투어</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
  <style>
    .zt-admin-stat {
      border: 1px solid var(--zt-border, #e5e5e5);
      border-radius: 12px;
      padding: 18px 20px;
      background: #fff;
      height: 100%;
    }
    .zt-admin-stat .label { color: #6c757d; font-size: 0.875rem; }
    .zt-admin-stat .value { font-size: 1.75rem; font-weight: 700; margin-top: 4px; }
    .zt-admin-chart {
      border: 1px solid var(--zt-border, #e5e5e5);
      border-radius: 12px;
      padding: 20px;
      background: #fff;
      min-height: 320px;
    }
  </style>
</head>
<body>
<div class="zt-app">
  <header class="zt-mobile-header">
    <a class="zt-brand" href="${pageContext.request.contextPath}/home"><span>짠맛투어</span></a>
  </header>

  <div class="zt-layout">
    <jsp:include page="/WEB-INF/views/components/sidebar.jsp">
      <jsp:param name="activePage" value="admin"/>
    </jsp:include>

    <main class="zt-content">
      <header class="zt-page-header d-flex flex-wrap justify-content-between align-items-start gap-3">
        <div>
          <h1>관리자 대시보드</h1>
          <p class="mb-0">전체 유저 활동 요약</p>
        </div>
        <div class="d-flex gap-2">
          <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/missions">미션 관리</a>
          <a class="btn btn-warning fw-bold" href="${pageContext.request.contextPath}/admin/missions/new">미션 등록</a>
        </div>
      </header>

      <section class="row g-3 mb-4">
        <div class="col-6 col-lg-3">
          <div class="zt-admin-stat">
            <div class="label">회원 수</div>
            <div class="value">${memberCount}</div>
          </div>
        </div>
        <div class="col-6 col-lg-3">
          <div class="zt-admin-stat">
            <div class="label">게시글 수</div>
            <div class="value">${postCount}</div>
          </div>
        </div>
        <div class="col-6 col-lg-3">
          <div class="zt-admin-stat">
            <div class="label">댓글 수</div>
            <div class="value">${commentCount}</div>
          </div>
        </div>
        <div class="col-6 col-lg-3">
          <div class="zt-admin-stat">
            <div class="label">등록 미션</div>
            <div class="value">${missionCount}</div>
          </div>
        </div>
      </section>

      <section class="row g-3">
        <div class="col-12">
          <div class="zt-admin-chart">
            <h2 class="h6 mb-3">최근 14일 게시글·댓글 작성 추이</h2>
            <canvas id="activityChart" height="120"></canvas>
          </div>
        </div>
      </section>
    </main>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.8/dist/chart.umd.min.js"></script>
<script>
  new Chart(document.getElementById('activityChart'), {
    type: 'line',
    data: {
      labels: [
        <c:forEach var="label" items="${activityLabels}" varStatus="st">
          '${label}'<c:if test="${!st.last}">,</c:if>
        </c:forEach>
      ],
      datasets: [
        {
          label: '게시글',
          data: [
            <c:forEach var="value" items="${postDailyCounts}" varStatus="st">
              ${value}<c:if test="${!st.last}">,</c:if>
            </c:forEach>
          ],
          borderColor: '#0d6efd',
          tension: 0.3,
          fill: false
        },
        {
          label: '댓글',
          data: [
            <c:forEach var="value" items="${commentDailyCounts}" varStatus="st">
              ${value}<c:if test="${!st.last}">,</c:if>
            </c:forEach>
          ],
          borderColor: '#198754',
          tension: 0.3,
          fill: false
        }
      ]
    },
    options: {
      plugins: { legend: { position: 'bottom' } },
      scales: { y: { beginAtZero: true, ticks: { precision: 0 } } }
    }
  });
</script>
</body>
</html>
