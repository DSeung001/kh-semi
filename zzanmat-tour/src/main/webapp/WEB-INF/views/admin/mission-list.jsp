<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>미션 관리 | 짠맛투어</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
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
          <h1>미션 관리</h1>
          <p class="mb-0">DB와 연동된 미션 목록을 관리합니다.</p>
        </div>
        <div class="d-flex gap-2">
          <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin">대시보드</a>
          <a class="btn btn-warning fw-bold" href="${pageContext.request.contextPath}/admin/missions/new">미션 등록</a>
        </div>
      </header>

      <section class="zt-panel">
        <div class="table-responsive">
          <table class="table align-middle mb-0">
            <thead>
            <tr>
              <th>ID</th>
              <th>제목</th>
              <th>상태</th>
              <th>장소 키워드</th>
              <th>경비 상한</th>
              <th>보상</th>
              <th>기간</th>
              <th class="text-end">관리</th>
            </tr>
            </thead>
            <tbody>
            <!-- 컨트롤러에서 전달된 missions 변수명으로 매칭 (사용자 /mission 과 동일: ACTIVE → UPCOMING → EXPIRED) -->
            <c:choose>
              <c:when test="${not empty missions}">
                <c:forEach var="mission" items="${missions}">
                  <tr>
                    <td>${mission.id}</td>
                    <td>${mission.title}</td>
                    <td>
                      <c:choose>
                        <c:when test="${mission.periodStatus == 'EXPIRED'}">
                          <span class="badge bg-secondary">기간 종료</span>
                        </c:when>
                        <c:when test="${mission.periodStatus == 'UPCOMING'}">
                          <span class="badge bg-info-subtle text-info border border-info-subtle">예정</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge bg-primary-subtle text-primary border border-primary-subtle">진행 가능</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty mission.placeKeyword}">
                          <span class="zt-chip">${mission.placeKeyword}</span>
                        </c:when>
                        <c:otherwise>-</c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${mission.maxTotalCost != null and mission.maxTotalCost > 0}">${mission.maxTotalCost}원</c:when>
                        <c:otherwise>-</c:otherwise>
                      </c:choose>
                    </td>
                    <td>${mission.rewardPoint}P</td>
                    <td class="small text-secondary">${mission.startAt} ~ ${mission.endAt}</td>
                    <td class="text-end">
                      <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/admin/missions/edit?missionId=${mission.id}">수정</a>
                      <button type="button" class="btn btn-sm btn-outline-danger" onclick="deleteMission(${mission.id})">삭제</button>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="8" class="text-center py-4 text-secondary">등록된 미션이 없습니다.</td>
                </tr>
              </c:otherwise>
            </c:choose>
            </tbody>
          </table>
        </div>
      </section>
    </main>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // 실제 DB와 연동되어 미션을 삭제하는 함수

  function deleteMission(missionId) {
    if (!confirm("정말 이 미션을 삭제하시겠습니까?")) return;

    fetch(`/api/admin/missions/\${missionId}`, {
      method: 'DELETE',
      credentials: 'include'
    })
            .then(res => res.json())
            .then(result => {
              alert("미션이 성공적으로 삭제되었습니다.");
              location.reload(); // 성공 시 새로고침하여 DB 반영 결과 확인
            })
            .catch(err => {
              console.error("삭제 오류:", err);
              alert("미션 삭제 중 오류가 발생했습니다.");
            });
  }
</script>
</body>
</html>