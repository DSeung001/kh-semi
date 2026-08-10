<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>상점 관리 | 짠맛투어</title>
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
          <h1>상점 관리</h1>
          <p class="mb-0">포인트 상점 상품을 관리합니다.</p>
        </div>
        <div class="d-flex gap-2 flex-wrap">
          <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin">
            <i class="bi bi-arrow-left me-1"></i>관리자 대시보드
          </a>
          <a class="btn btn-warning fw-bold" href="${pageContext.request.contextPath}/admin/shop/new">상품 등록</a>
        </div>
      </header>

      <section class="zt-panel">
        <div class="table-responsive">
          <table class="table align-middle mb-0 zt-admin-table">
            <thead>
            <tr>
              <th>번호</th>
              <th>상품명</th>
              <th>카테고리</th>
              <th>포인트</th>
              <th>재고</th>
              <th>상태</th>
              <th class="text-end">관리</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
              <c:when test="${not empty items}">
                <c:forEach var="item" items="${items}" varStatus="st">
                  <tr>
                    <td>${st.count}</td>
                    <td>
                      <div class="fw-semibold">${item.name}</div>
                      <c:if test="${not empty item.description}">
                        <div class="small text-secondary text-truncate" style="max-width: 16rem;">${item.description}</div>
                      </c:if>
                    </td>
                    <td><span class="zt-chip">${item.categoryLabel}</span></td>
                    <td>${item.costPoint}P</td>
                    <td>
                      <c:choose>
                        <c:when test="${item.stock == null}">무제한</c:when>
                        <c:otherwise>${item.stock}</c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${item.active}">
                          <span class="badge bg-primary-subtle text-primary border border-primary-subtle">판매중</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge bg-secondary">비활성</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td class="text-end">
                      <a class="btn btn-sm btn-outline-primary"
                         href="${pageContext.request.contextPath}/admin/shop/edit?itemId=${item.itemId}">수정</a>
                      <c:if test="${item.active}">
                        <button type="button" class="btn btn-sm btn-outline-danger"
                                onclick="deactivateItem(${item.itemId})">비활성</button>
                      </c:if>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="7" class="text-center py-4 text-secondary">등록된 상품이 없습니다.</td>
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
  const contextPath = '${pageContext.request.contextPath}';

  function deactivateItem(itemId) {
    if (!confirm('이 상품을 비활성화할까요? 유저 상점에서는 더 이상 보이지 않습니다.')) return;

    fetch(contextPath + `/api/admin/shop/items/\${itemId}`, {
      method: 'DELETE',
      credentials: 'include'
    })
      .then(res => res.json().then(body => ({ ok: res.ok, body })))
      .then(({ ok, body }) => {
        if (ok) {
          alert(body.message || '상품이 비활성화되었습니다.');
          location.reload();
        } else {
          alert(body.message || '상품 비활성화에 실패했습니다.');
        }
      })
      .catch(err => {
        console.error(err);
        alert('상품 비활성화 중 오류가 발생했습니다.');
      });
  }
</script>
</body>
</html>
