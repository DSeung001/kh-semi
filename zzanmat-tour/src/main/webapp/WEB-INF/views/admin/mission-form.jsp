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
        <p>미션 정보를 입력하고 등록하거나 수정할 수 있습니다.</p>
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
                   placeholder="미션 제목" required>
          </div>

          <div class="col-md-4">
            <label class="form-label" for="rewardPoint">보상 포인트</label>
            <input type="number" class="form-control" id="rewardPoint" name="rewardPoint"
                   value="500" min="0" required>
          </div>

          <div class="col-12">
            <label class="form-label" for="description">설명</label>
            <textarea class="form-control" id="description" name="description" rows="3"
                      placeholder="미션 설명"></textarea>
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
  const isEdit = ${isEdit};
  const missionId = "${param.missionId}";

  // 수정 모드일 경우, 기존 데이터 로드
  if (isEdit) {
    fetch(`/api/admin/missions/\${missionId}`)
            .then(res => res.json())
            .then(result => {
              const m = result.data || result;
              if (m) {
                document.getElementById('title').value = m.title || '';
                document.getElementById('rewardPoint').value = m.rewardPoint || 0;
                document.getElementById('description').value = m.description || '';
                document.getElementById('missionType').value = m.missionType || 'POST';
                document.getElementById('triggerEvent').value = m.triggerEvent || 'CREATE_POST';
                document.getElementById('targetCount').value = m.targetCount || 1;

                if (m.startAt) document.getElementById('startAt').value = m.startAt.substring(0, 16);
                if (m.endAt) document.getElementById('endAt').value = m.endAt.substring(0, 16);
              }
            }).catch(err => console.log("상세 정보 로드 생략 또는 오류", err));
  }

  // 미션 등록 및 수정 폼 제출 핸들러

  document.getElementById('missionForm').addEventListener('submit', async function (e) {
    e.preventDefault();

    const startVal = document.getElementById('startAt').value;
    const endVal = document.getElementById('endAt').value;

    const missionData = {
      title: document.getElementById('title').value,
      description: document.getElementById('description').value,
      rewardPoint: Number(document.getElementById('rewardPoint').value),
      missionType: document.getElementById('missionType').value,
      triggerEvent: document.getElementById('triggerEvent').value,
      targetCount: Number(document.getElementById('targetCount').value),
      // datetime-local 값에 초(:00)를 붙여주어 서버 LocalDateTime 매핑 오류 방지
      startAt: startVal ? startVal + ':00' : null,
      endAt: endVal ? endVal + ':00' : null
    };

    const url = isEdit ? `/api/admin/missions/\${missionId}` : '/api/admin/missions';
    const method = isEdit ? 'PUT' : 'POST';

    try {
      const response = await fetch(url, {
        method: method,
        headers: {'Content-Type': 'application/json'},
        credentials: 'include',
        body: JSON.stringify(missionData)
      });

      const text = await response.text();
      let result = {};
      try {
        result = text ? JSON.parse(text) : {};
      } catch (err) {
        console.log("JSON 파싱 스킵");
      }

      if (response.ok) {
        const msg = result.message || result.msg || (isEdit ? '미션이 성공적으로 수정되었습니다.' : '미션이 성공적으로 등록되었습니다.');
        alert(msg);
        location.href = '${pageContext.request.contextPath}/admin/missions';
      } else {
        const errorMsg = result.message || result.msg || '알 수 없는 오류가 발생했습니다.';
        alert('처리 실패: ' + errorMsg);
      }
    } catch (error) {
      console.error('Error:', error);
      alert('서버 통신 중 오류가 발생했습니다.');
    }
  });
</script>
</body>
</html>