<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <c:set var="isEdit" value="${not empty param.missionId}"/>
  <title>${isEdit ? '미션 수정' : '미션 등록'} | 짠맛투어</title>
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
      <header class="zt-page-header">
        <h1>${isEdit ? '미션 수정' : '미션 등록'}</h1>
        <p>폼 퍼블리싱만 제공됩니다. 저장 시 DB에 반영되지 않습니다.</p>
      </header>

      <section class="zt-panel">
        <form id="missionForm" class="row g-3">
          <c:if test="${isEdit}">
            <div class="col-12">
              <label class="form-label">미션 ID</label>
              <input type="text" class="form-control" value="${param.missionId}" readonly>
            </div>
          </c:if>

          <div class="col-md-8">
            <label class="form-label" for="title">제목</label>
            <input type="text" class="form-control" id="title" name="title"
                   value="${isEdit ? '샘플 미션 제목' : ''}" placeholder="미션 제목" required>
          </div>

          <div class="col-md-4">
            <label class="form-label" for="rewardPoint">보상 포인트</label>
            <input type="number" class="form-control" id="rewardPoint" name="rewardPoint"
                   value="${isEdit ? '1000' : '500'}" min="0" required>
          </div>

          <div class="col-12">
            <label class="form-label" for="description">설명</label>
            <textarea class="form-control" id="description" name="description" rows="3"
                      placeholder="미션 설명">${isEdit ? '샘플 미션 설명입니다.' : ''}</textarea>
          </div>

          <div class="col-md-4">
            <label class="form-label" for="missionType">미션 유형</label>
            <select class="form-select" id="missionType" name="missionType">
              <option value="POST" selected>POST</option>
              <option value="PHOTO">PHOTO</option>
              <option value="VIDEO">VIDEO</option>
              <option value="SHORTS">SHORTS</option>
            </select>
          </div>

          <div class="col-md-4">
            <label class="form-label" for="triggerEvent">트리거</label>
            <select class="form-select" id="triggerEvent" name="triggerEvent">
              <option value="CREATE_POST" selected>CREATE_POST</option>
              <option value="UPLOAD_IMAGE">UPLOAD_IMAGE</option>
              <option value="UPLOAD_VIDEO">UPLOAD_VIDEO</option>
              <option value="UPLOAD_SHORTS">UPLOAD_SHORTS</option>
            </select>
          </div>

          <div class="col-md-4">
            <label class="form-label" for="targetCount">목표 횟수</label>
            <input type="number" class="form-control" id="targetCount" name="targetCount" value="1" min="1" required>
          </div>

          <div class="col-md-6">
            <label class="form-label" for="startAt">수행 시작</label>
            <input type="datetime-local" class="form-control" id="startAt" name="startAt">
          </div>

          <div class="col-md-6">
            <label class="form-label" for="endAt">수행 종료</label>
            <input type="datetime-local" class="form-control" id="endAt" name="endAt">
          </div>

          <div class="col-12 d-flex gap-2 pt-2">
            <button type="submit" class="btn btn-warning fw-bold">${isEdit ? '수정하기' : '등록하기'}</button>
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/missions">목록으로</a>
          </div>
        </form>
      </section>
    </main>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script>
  document.getElementById('missionForm').addEventListener('submit', function (e) {
    e.preventDefault();
    alert('${isEdit ? "수정" : "등록"} 기능은 아직 연결되지 않았습니다. (퍼블리싱만)');
  });
</script>
</body>
</html>
