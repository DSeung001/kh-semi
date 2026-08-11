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
        <p id="formHint">미션 수행 방식을 선택한 뒤 조건을 설정합니다.</p>
      </header>

      <section class="zt-panel">
        <form id="missionForm">
          <div class="row g-3">
          <c:if test="${isEdit}">
            <div class="col-12">
              <label class="form-label">미션 ID</label>
              <input type="text" class="form-control" value="${param.missionId}" readonly>
            </div>
          </c:if>

          <div class="col-12">
            <label class="form-label d-block">미션 방식</label>
            <div class="d-flex flex-wrap gap-3">
              <div class="form-check">
                <input class="form-check-input" type="radio" name="missionMode" id="modePost"
                       value="POST" checked>
                <label class="form-check-label" for="modePost">포스트</label>
              </div>
              <div class="form-check">
                <input class="form-check-input" type="radio" name="missionMode" id="modeComment"
                       value="COMMENT">
                <label class="form-check-label" for="modeComment">댓글</label>
              </div>
              <div class="form-check">
                <input class="form-check-input" type="radio" name="missionMode" id="modeLike"
                       value="LIKE">
                <label class="form-check-label" for="modeLike">좋아요</label>
              </div>
              <div class="form-check">
                <input class="form-check-input" type="radio" name="missionMode" id="modeChat"
                       value="CHAT">
                <label class="form-check-label" for="modeChat">오픈 채팅</label>
              </div>
            </div>
            <div class="form-text" id="modeHint">게시글 작성 시 장소·경비 조건으로 진행됩니다.</div>
          </div>

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

          <div id="postConditionFields" class="contents">
            <div class="col-md-6">
              <label class="form-label" for="placeKeyword">장소 키워드 (선택)</label>
              <input type="text" class="form-control" id="placeKeyword" name="placeKeyword"
                     placeholder="예: 서울" maxlength="100">
              <div class="form-text">입력 시 게시글 장소에 이 키워드가 포함되어야 진행됩니다.</div>
            </div>

            <div class="col-md-6">
              <label class="form-label" for="maxTotalCost">총 경비 상한 (원, 선택)</label>
              <input type="number" class="form-control" id="maxTotalCost" name="maxTotalCost"
                     placeholder="예: 50000" min="0">
              <div class="form-text">비우면 경비 제한 없음. 입력 시 교통비+식비+기타 합계가 상한 이하일 때만 인정됩니다.</div>
            </div>
            <div class="col-12">
              <div class="form-text">포스트 미션은 장소 키워드 또는 총 경비 상한 중 하나 이상 입력해야 합니다.</div>
            </div>
          </div>

          <div class="col-md-4">
            <label class="form-label" for="targetCount">목표 횟수</label>
            <input type="number" class="form-control" id="targetCount" name="targetCount" value="1" min="1" required>
          </div>

          <div class="col-md-4">
            <label class="form-label" for="startAt">수행 시작</label>
            <input type="datetime-local" class="form-control" id="startAt" name="startAt">
          </div>

          <div class="col-md-4">
            <label class="form-label" for="endAt">수행 종료</label>
            <input type="datetime-local" class="form-control" id="endAt" name="endAt">
          </div>

          <div class="col-12 d-flex gap-2 pt-2">
            <button type="submit" class="btn btn-warning fw-bold">${isEdit ? '수정하기' : '등록하기'}</button>
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/missions">목록으로</a>
          </div>
          </div>
        </form>
      </section>
    </main>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script>
  const contextPath = '${pageContext.request.contextPath}';
  const isEdit = ${isEdit};
  const missionId = "${param.missionId}";

  const MODE_MAP = {
    POST: { type: 'POST', trigger: 'CREATE_POST', hint: '게시글 작성 시 장소·경비 조건으로 진행됩니다.' },
    COMMENT: { type: 'COMMENT', trigger: 'CREATE_COMMENT', hint: '댓글을 작성하면 진행됩니다. 추가 조건은 없습니다.' },
    LIKE: { type: 'LIKE', trigger: 'LIKE', hint: '게시글·댓글에 좋아요를 누르면 진행됩니다. 추가 조건은 없습니다.' },
    CHAT: { type: 'CHAT', trigger: 'OPEN_CHAT', hint: '오픈 채팅에 메시지를 보내면 진행됩니다. 추가 조건은 없습니다.' }
  };

  function selectedMode() {
    const checked = document.querySelector('input[name="missionMode"]:checked');
    return checked ? checked.value : 'POST';
  }

  function syncModeUi() {
    const mode = selectedMode();
    const meta = MODE_MAP[mode] || MODE_MAP.POST;
    document.getElementById('modeHint').innerText = meta.hint;
    document.getElementById('formHint').innerText = meta.hint;
    document.getElementById('postConditionFields').style.display = mode === 'POST' ? 'contents' : 'none';
    if (mode !== 'POST') {
      document.getElementById('placeKeyword').value = '';
      document.getElementById('maxTotalCost').value = '';
    }
  }

  function setMode(mode) {
    const target = document.querySelector('input[name="missionMode"][value="' + mode + '"]');
    if (target) target.checked = true;
    syncModeUi();
  }

  document.querySelectorAll('input[name="missionMode"]').forEach(el => {
    el.addEventListener('change', syncModeUi);
  });
  syncModeUi();

  if (isEdit) {
    fetch(contextPath + `/api/admin/missions/\${missionId}`)
            .then(res => res.json())
            .then(result => {
              const m = result.data || result;
              if (m) {
                document.getElementById('title').value = m.title || '';
                document.getElementById('rewardPoint').value = m.rewardPoint || 0;
                document.getElementById('description').value = m.description || '';
                document.getElementById('placeKeyword').value = m.placeKeyword || '';
                document.getElementById('maxTotalCost').value =
                        (m.maxTotalCost != null && m.maxTotalCost > 0) ? m.maxTotalCost : '';
                document.getElementById('targetCount').value = m.targetCount || 1;

                if (m.startAt) document.getElementById('startAt').value = m.startAt.substring(0, 16);
                if (m.endAt) document.getElementById('endAt').value = m.endAt.substring(0, 16);

                const type = (m.missionType || 'POST').toUpperCase();
                const mode = (type === 'COMMENT' || type === 'LIKE' || type === 'CHAT') ? type : 'POST';
                setMode(mode);
              }
            }).catch(err => console.log("상세 정보 로드 생략 또는 오류", err));
  }

  document.getElementById('missionForm').addEventListener('submit', async function (e) {
    e.preventDefault();

    const mode = selectedMode();
    const meta = MODE_MAP[mode] || MODE_MAP.POST;
    const startVal = document.getElementById('startAt').value;
    const endVal = document.getElementById('endAt').value;
    let placeKeyword = document.getElementById('placeKeyword').value.trim();
    const maxTotalCostRaw = document.getElementById('maxTotalCost').value;
    let maxTotalCost = maxTotalCostRaw === '' ? 0 : Number(maxTotalCostRaw);

    if (mode === 'POST') {
      if (!placeKeyword && !(maxTotalCost > 0)) {
        alert('포스트 미션은 장소 키워드 또는 총 경비 상한 중 하나 이상 입력해 주세요.');
        return;
      }
    } else {
      placeKeyword = '';
      maxTotalCost = 0;
    }

    const missionData = {
      title: document.getElementById('title').value,
      description: document.getElementById('description').value,
      rewardPoint: Number(document.getElementById('rewardPoint').value),
      placeKeyword: placeKeyword,
      maxTotalCost: maxTotalCost,
      targetCount: Number(document.getElementById('targetCount').value),
      missionType: meta.type,
      triggerEvent: meta.trigger,
      startAt: startVal ? startVal + ':00' : null,
      endAt: endVal ? endVal + ':00' : null
    };

    const url = isEdit
            ? contextPath + `/api/admin/missions/\${missionId}`
            : contextPath + '/api/admin/missions';
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
        location.href = contextPath + '/admin/missions';
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
