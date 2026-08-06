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
          <p class="mb-0">등록·수정·삭제 화면 퍼블리싱 (실제 저장 없음)</p>
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
              <th>유형</th>
              <th>보상</th>
              <th>기간</th>
              <th class="text-end">관리</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td>1</td>
              <td>첫 여행 게시글 작성</td>
              <td><span class="zt-chip">POST</span></td>
              <td>2,000P</td>
              <td class="small text-secondary">2026-08-01 ~ 2027-08-01</td>
              <td class="text-end">
                <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/admin/missions/edit?missionId=1">수정</a>
                <button type="button" class="btn btn-sm btn-outline-danger" data-mission-delete>삭제</button>
              </td>
            </tr>
            <tr>
              <td>2</td>
              <td>여행 사진 업로드</td>
              <td><span class="zt-chip">PHOTO</span></td>
              <td>500P</td>
              <td class="small text-secondary">2026-08-01 ~ 2027-08-01</td>
              <td class="text-end">
                <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/admin/missions/edit?missionId=2">수정</a>
                <button type="button" class="btn btn-sm btn-outline-danger" data-mission-delete>삭제</button>
              </td>
            </tr>
            <tr>
              <td>3</td>
              <td>쇼츠 영상 업로드</td>
              <td><span class="zt-chip">SHORTS</span></td>
              <td>3,000P</td>
              <td class="small text-secondary">기간 종료</td>
              <td class="text-end">
                <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/admin/missions/edit?missionId=3">수정</a>
                <button type="button" class="btn btn-sm btn-outline-danger" data-mission-delete>삭제</button>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </section>
    </main>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script>
  document.querySelectorAll('[data-mission-delete]').forEach((btn) => {
    btn.addEventListener('click', () => {
      if (confirm('삭제하시겠습니까? (퍼블리싱용 — 실제 삭제되지 않습니다)')) {
        alert('삭제 기능은 아직 연결되지 않았습니다.');
      }
    });
  });
</script>
</body>
</html>
