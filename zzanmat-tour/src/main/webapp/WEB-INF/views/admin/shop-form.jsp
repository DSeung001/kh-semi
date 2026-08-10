<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <c:set var="isEdit" value="${not empty param.itemId}"/>
  <title>${isEdit ? '상품 수정' : '상품 등록'} | 짠맛투어</title>
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
        <h1>${isEdit ? '상품 수정' : '상품 등록'}</h1>
        <p class="mb-0">포인트 상점 상품 정보를 입력합니다.</p>
      </header>

      <section class="zt-panel">
        <form id="shopForm">
          <div class="row g-3">
            <c:if test="${isEdit}">
              <div class="col-12">
                <label class="form-label">상품 ID</label>
                <input type="text" class="form-control" value="${param.itemId}" readonly>
              </div>
            </c:if>

            <div class="col-md-8">
              <label class="form-label" for="name">상품명</label>
              <input type="text" class="form-control" id="name" name="name" maxlength="100" required>
            </div>

            <div class="col-md-4">
              <label class="form-label" for="costPoint">필요 포인트</label>
              <input type="number" class="form-control" id="costPoint" name="costPoint" value="1000" min="0" required>
            </div>

            <div class="col-12">
              <label class="form-label" for="description">설명</label>
              <textarea class="form-control" id="description" name="description" rows="3"
                        placeholder="상품 설명"></textarea>
            </div>

            <div class="col-md-4">
              <label class="form-label" for="category">카테고리</label>
              <select class="form-select" id="category" name="category" required>
                <option value="GIFT_CARD">상품권</option>
                <option value="TRAVEL">여행</option>
                <option value="FLIGHT">항공</option>
                <option value="TRAIN">기차</option>
              </select>
            </div>

            <div class="col-md-4">
              <label class="form-label" for="stock">재고</label>
              <input type="number" class="form-control" id="stock" name="stock" min="0" placeholder="비우면 무제한">
              <div class="form-text">비우면 무제한 재고로 등록됩니다.</div>
            </div>

            <div class="col-md-4">
              <label class="form-label d-block">판매 상태</label>
              <div class="form-check form-switch mt-2">
                <input class="form-check-input" type="checkbox" id="active" name="active" checked>
                <label class="form-check-label" for="active">판매중</label>
              </div>
            </div>

            <div class="col-12 d-flex gap-2 pt-2">
              <button type="submit" class="btn btn-warning fw-bold">${isEdit ? '수정하기' : '등록하기'}</button>
              <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/shop">목록으로</a>
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
  const itemId = "${param.itemId}";

  if (isEdit) {
    fetch(contextPath + `/api/admin/shop/items/\${itemId}`)
      .then(res => {
        if (!res.ok) throw new Error('load failed');
        return res.json();
      })
      .then(item => {
        const data = item.data || item;
        document.getElementById('name').value = data.name || '';
        document.getElementById('description').value = data.description || '';
        document.getElementById('category').value = data.category || 'GIFT_CARD';
        document.getElementById('costPoint').value = data.costPoint != null ? data.costPoint : 0;
        document.getElementById('stock').value = data.stock != null ? data.stock : '';
        document.getElementById('active').checked = data.active !== false;
      })
      .catch(err => {
        console.error(err);
        alert('상품 정보를 불러오지 못했습니다.');
      });
  }

  document.getElementById('shopForm').addEventListener('submit', async function (e) {
    e.preventDefault();

    const stockRaw = document.getElementById('stock').value;
    const payload = {
      name: document.getElementById('name').value.trim(),
      description: document.getElementById('description').value.trim(),
      category: document.getElementById('category').value,
      costPoint: Number(document.getElementById('costPoint').value),
      stock: stockRaw === '' ? null : Number(stockRaw),
      active: document.getElementById('active').checked
    };

    const url = isEdit
      ? contextPath + `/api/admin/shop/items/\${itemId}`
      : contextPath + '/api/admin/shop/items';
    const method = isEdit ? 'PUT' : 'POST';

    try {
      const response = await fetch(url, {
        method: method,
        headers: {'Content-Type': 'application/json'},
        credentials: 'include',
        body: JSON.stringify(payload)
      });

      const text = await response.text();
      let result = {};
      try {
        result = text ? JSON.parse(text) : {};
      } catch (err) {
        console.log('JSON 파싱 스킵');
      }

      if (response.ok) {
        alert(result.message || (isEdit ? '상품이 수정되었습니다.' : '상품이 등록되었습니다.'));
        location.href = contextPath + '/admin/shop';
      } else {
        alert('처리 실패: ' + (result.message || '알 수 없는 오류'));
      }
    } catch (error) {
      console.error(error);
      alert('서버 통신 중 오류가 발생했습니다.');
    }
  });
</script>
</body>
</html>
