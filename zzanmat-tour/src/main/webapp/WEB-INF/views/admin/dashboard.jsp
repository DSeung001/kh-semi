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
      position: relative;
      overflow: hidden;
      border: 1px solid var(--zt-border);
      border-radius: var(--zt-radius);
      padding: 18px 20px;
      background: var(--zt-surface);
      box-shadow: var(--zt-shadow);
      height: 100%;
      transition: transform .18s ease, box-shadow .18s ease;
    }
    .zt-admin-stat:hover {
      transform: translateY(-2px);
      box-shadow: 0 14px 34px rgba(0, 0, 0, .07);
    }
    .zt-admin-stat::before {
      content: "";
      position: absolute;
      inset: 0 auto 0 0;
      width: 4px;
      background: var(--stat-accent, var(--zt-primary));
    }
    .zt-admin-stat .stat-top {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 10px;
    }
    .zt-admin-stat .label {
      color: var(--zt-muted);
      font-size: 0.8125rem;
      font-weight: 600;
      letter-spacing: -0.02em;
    }
    .zt-admin-stat .stat-icon {
      width: 34px;
      height: 34px;
      border-radius: 10px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      font-size: 1rem;
      color: var(--stat-accent, var(--zt-primary));
      background: color-mix(in srgb, var(--stat-accent, var(--zt-primary)) 12%, white);
    }
    .zt-admin-stat .value {
      font-size: 1.85rem;
      font-weight: 750;
      letter-spacing: -0.04em;
      margin-top: 10px;
      line-height: 1.1;
    }
    .zt-admin-stat.is-members { --stat-accent: #0095f6; }
    .zt-admin-stat.is-posts { --stat-accent: #0d6efd; }
    .zt-admin-stat.is-comments { --stat-accent: #198754; }
    .zt-admin-stat.is-missions { --stat-accent: #f59e0b; }

    .zt-admin-chart {
      border: 1px solid var(--zt-border);
      border-radius: var(--zt-radius);
      padding: 18px 18px 14px;
      background:
        linear-gradient(180deg, #ffffff 0%, #fcfcfd 100%);
      box-shadow: var(--zt-shadow);
      min-height: 340px;
      height: 100%;
      display: flex;
      flex-direction: column;
    }
    .zt-admin-chart-head {
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      gap: 12px;
      margin-bottom: 14px;
    }
    .zt-admin-chart-head h2 {
      margin: 0;
      font-size: 0.95rem;
      font-weight: 700;
      letter-spacing: -0.02em;
    }
    .zt-admin-chart-head p {
      margin: 4px 0 0;
      color: var(--zt-muted);
      font-size: 0.75rem;
    }
    .zt-admin-chart-badge {
      flex-shrink: 0;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 6px 10px;
      border-radius: 999px;
      font-size: 0.72rem;
      font-weight: 700;
      letter-spacing: -0.02em;
      background: var(--zt-soft);
      color: var(--zt-muted);
    }
    .zt-admin-chart-badge .dot {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background: currentColor;
    }
    .zt-admin-chart-badge.is-activity {
      color: #0d6efd;
      background: rgba(13, 110, 253, 0.08);
    }
    .zt-admin-chart-badge.is-point {
      color: #ea580c;
      background: rgba(234, 88, 12, 0.08);
    }
    .zt-admin-chart-body {
      flex: 1;
      min-height: 260px;
      position: relative;
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
          <div class="zt-admin-stat is-members">
            <div class="stat-top">
              <div class="label">회원 수</div>
              <span class="stat-icon"><i class="bi bi-people"></i></span>
            </div>
            <div class="value">${memberCount}</div>
          </div>
        </div>
        <div class="col-6 col-lg-3">
          <div class="zt-admin-stat is-posts">
            <div class="stat-top">
              <div class="label">게시글 수</div>
              <span class="stat-icon"><i class="bi bi-images"></i></span>
            </div>
            <div class="value">${postCount}</div>
          </div>
        </div>
        <div class="col-6 col-lg-3">
          <div class="zt-admin-stat is-comments">
            <div class="stat-top">
              <div class="label">댓글 수</div>
              <span class="stat-icon"><i class="bi bi-chat-dots"></i></span>
            </div>
            <div class="value">${commentCount}</div>
          </div>
        </div>
        <div class="col-6 col-lg-3">
          <div class="zt-admin-stat is-missions">
            <div class="stat-top">
              <div class="label">활성 미션</div>
              <span class="stat-icon"><i class="bi bi-flag"></i></span>
            </div>
            <div class="value">${missionCount}</div>
          </div>
        </div>
      </section>

      <section class="row g-3">
        <div class="col-12 col-lg-6">
          <div class="zt-admin-chart">
            <div class="zt-admin-chart-head">
              <div>
                <h2>게시글 · 댓글 추이</h2>
                <p>최근 14일 활동량</p>
              </div>
              <span class="zt-admin-chart-badge is-activity"><span class="dot"></span>활동</span>
            </div>
            <div class="zt-admin-chart-body">
              <canvas id="activityChart"></canvas>
            </div>
          </div>
        </div>
        <div class="col-12 col-lg-6">
          <div class="zt-admin-chart">
            <div class="zt-admin-chart-head">
              <div>
                <h2>지급 포인트 추이</h2>
                <p>최근 14일 포인트 지급량</p>
              </div>
              <span class="zt-admin-chart-badge is-point"><span class="dot"></span>포인트</span>
            </div>
            <div class="zt-admin-chart-body">
              <canvas id="pointChart"></canvas>
            </div>
          </div>
        </div>
      </section>
    </main>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.8/dist/chart.umd.min.js"></script>
<script>
  const activityLabels = [
    <c:forEach var="label" items="${activityLabels}" varStatus="st">
      '${label}'<c:if test="${!st.last}">,</c:if>
    </c:forEach>
  ];

  const chartDefaults = {
    responsive: true,
    maintainAspectRatio: false,
    interaction: { mode: 'index', intersect: false },
    plugins: {
      legend: {
        position: 'bottom',
        labels: {
          usePointStyle: true,
          pointStyle: 'circle',
          boxWidth: 8,
          padding: 16,
          color: '#737373',
          font: { size: 12, weight: '600' }
        }
      },
      tooltip: {
        backgroundColor: 'rgba(38, 38, 38, 0.92)',
        titleFont: { size: 12, weight: '600' },
        bodyFont: { size: 12 },
        padding: 10,
        cornerRadius: 10,
        displayColors: true,
        boxPadding: 4
      }
    },
    scales: {
      x: {
        grid: { display: false },
        ticks: {
          color: '#8e8e8e',
          font: { size: 11 },
          maxRotation: 0
        },
        border: { display: false }
      },
      y: {
        beginAtZero: true,
        ticks: {
          precision: 0,
          color: '#8e8e8e',
          font: { size: 11 },
          padding: 8
        },
        grid: {
          color: 'rgba(0, 0, 0, 0.05)',
          drawBorder: false
        },
        border: { display: false }
      }
    }
  };

  const activityCtx = document.getElementById('activityChart').getContext('2d');
  const postGradient = activityCtx.createLinearGradient(0, 0, 0, 260);
  postGradient.addColorStop(0, 'rgba(13, 110, 253, 0.18)');
  postGradient.addColorStop(1, 'rgba(13, 110, 253, 0)');

  const commentGradient = activityCtx.createLinearGradient(0, 0, 0, 260);
  commentGradient.addColorStop(0, 'rgba(25, 135, 84, 0.16)');
  commentGradient.addColorStop(1, 'rgba(25, 135, 84, 0)');

  new Chart(activityCtx, {
    type: 'line',
    data: {
      labels: activityLabels,
      datasets: [
        {
          label: '게시글',
          data: [
            <c:forEach var="value" items="${postDailyCounts}" varStatus="st">
              ${value}<c:if test="${!st.last}">,</c:if>
            </c:forEach>
          ],
          borderColor: '#0d6efd',
          backgroundColor: postGradient,
          borderWidth: 2.5,
          pointRadius: 3,
          pointHoverRadius: 5,
          pointBackgroundColor: '#fff',
          pointBorderColor: '#0d6efd',
          pointBorderWidth: 2,
          tension: 0.35,
          fill: true
        },
        {
          label: '댓글',
          data: [
            <c:forEach var="value" items="${commentDailyCounts}" varStatus="st">
              ${value}<c:if test="${!st.last}">,</c:if>
            </c:forEach>
          ],
          borderColor: '#198754',
          backgroundColor: commentGradient,
          borderWidth: 2.5,
          pointRadius: 3,
          pointHoverRadius: 5,
          pointBackgroundColor: '#fff',
          pointBorderColor: '#198754',
          pointBorderWidth: 2,
          tension: 0.35,
          fill: true
        }
      ]
    },
    options: {
      ...chartDefaults,
      scales: {
        ...chartDefaults.scales,
        y: {
          ...chartDefaults.scales.y,
          title: {
            display: true,
            text: '건수',
            color: '#8e8e8e',
            font: { size: 11, weight: '600' }
          }
        }
      }
    }
  });

  const pointCtx = document.getElementById('pointChart').getContext('2d');
  const pointGradient = pointCtx.createLinearGradient(0, 0, 0, 260);
  pointGradient.addColorStop(0, 'rgba(234, 88, 12, 0.22)');
  pointGradient.addColorStop(1, 'rgba(234, 88, 12, 0)');

  new Chart(pointCtx, {
    type: 'line',
    data: {
      labels: activityLabels,
      datasets: [
        {
          label: '지급 포인트',
          data: [
            <c:forEach var="value" items="${pointDailyCounts}" varStatus="st">
              ${value}<c:if test="${!st.last}">,</c:if>
            </c:forEach>
          ],
          borderColor: '#ea580c',
          backgroundColor: pointGradient,
          borderWidth: 2.5,
          pointRadius: 3.5,
          pointHoverRadius: 6,
          pointBackgroundColor: '#fff',
          pointBorderColor: '#ea580c',
          pointBorderWidth: 2,
          tension: 0.35,
          fill: true
        }
      ]
    },
    options: {
      ...chartDefaults,
      scales: {
        ...chartDefaults.scales,
        y: {
          ...chartDefaults.scales.y,
          title: {
            display: true,
            text: '포인트',
            color: '#8e8e8e',
            font: { size: 11, weight: '600' }
          }
        }
      }
    }
  });
</script>
</body>
</html>
