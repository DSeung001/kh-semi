<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="포인트로 쿠폰을 교환하는 짠맛투어 상점">
  <title>포인트 상점 | 짠맛투어</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
</head>
<body>
<div class="zt-app">

  <header class="zt-mobile-header">
    <a class="zt-brand" href="${pageContext.request.contextPath}/home">
      <span>짠맛투어</span>
    </a>
    <a href="${pageContext.request.contextPath}/login" class="fs-5" aria-label="로그인"><i class="bi bi-box-arrow-in-right"></i></a>
  </header>
  <nav class="zt-mobile-nav" aria-label="모바일 메뉴">
    <a href="${pageContext.request.contextPath}/home" class="" aria-label="home"><i class="bi bi-house"></i></a>
    <a href="${pageContext.request.contextPath}/my-travel" class="" aria-label="짠맛투어"><i class="bi bi-grid-3x3-gap"></i></a>
    <a href="${pageContext.request.contextPath}/new-post" class="" aria-label="new"><i class="bi bi-plus-square"></i></a>
    <a href="${pageContext.request.contextPath}/chat" class="" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
    <a href="${pageContext.request.contextPath}/member/profile" class="" aria-label="profile"><i class="bi bi-person-circle"></i></a>
  </nav>

  <div class="zt-layout">
    <jsp:include page="/WEB-INF/views/components/sidebar.jsp">
      <jsp:param name="activePage" value="shop"/>
    </jsp:include>

    <main class="zt-content">
      <c:if test="${not empty message}">
        <script>alert("<c:out value='${message}'/>");</script>
      </c:if>
      <c:if test="${not empty error}">
        <script>alert("<c:out value='${error}'/>");</script>
      </c:if>

      <header class="zt-page-header d-flex flex-wrap justify-content-between align-items-start gap-3">
        <div>
          <h1>포인트 상점</h1>
          <p class="mb-0">모은 포인트로 상품권·할인권을 교환해요.</p>
        </div>
        <div class="zt-shop-balance">
          <span class="label">보유 포인트</span>
          <strong><fmt:formatNumber value="${pointBalance}" type="number"/>P</strong>
        </div>
      </header>

      <section class="zt-panel zt-mission-list zt-panel-shadow mb-3">
        <div class="d-flex align-items-center justify-content-between mb-3">
          <h2 class="h6 mb-0 fw-bold">교환 상품</h2>
        </div>

        <c:choose>
          <c:when test="${empty items}">
            <p class="text-center text-muted py-4 mb-0">등록된 상품이 없습니다.</p>
          </c:when>
          <c:otherwise>
            <c:forEach var="item" items="${items}">
              <c:set var="soldOut" value="${item.soldOut}"/>
              <article class="zt-mission-card ${soldOut ? 'is-expired' : ''}">
                <div class="zt-mission-icon zt-shop-icon is-${item.category}">
                  <i class="bi
                    <c:choose>
                      <c:when test='${item.category == "GIFT_CARD"}'>bi-gift</c:when>
                      <c:when test='${item.category == "TRAVEL"}'>bi-suitcase-lg</c:when>
                      <c:when test='${item.category == "FLIGHT"}'>bi-airplane</c:when>
                      <c:when test='${item.category == "TRAIN"}'>bi-train-front</c:when>
                      <c:otherwise>bi-ticket-perforated</c:otherwise>
                    </c:choose>
                  "></i>
                </div>
                <div>
                  <div class="d-flex flex-wrap gap-2 align-items-center mb-1">
                    <h3 class="h6 fw-bold mb-0">${item.name}</h3>
                    <span class="zt-chip">${item.categoryLabel}</span>
                    <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle">
                      <fmt:formatNumber value="${item.costPoint}" type="number"/>P
                    </span>
                    <c:choose>
                      <c:when test="${soldOut}">
                        <span class="badge bg-secondary">품절</span>
                      </c:when>
                      <c:when test="${item.stock != null}">
                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                          재고 ${item.stock}
                        </span>
                      </c:when>
                      <c:otherwise>
                        <span class="badge bg-success-subtle text-success border border-success-subtle">상시</span>
                      </c:otherwise>
                    </c:choose>
                  </div>
                  <p class="zt-muted small mb-0">${item.description}</p>
                </div>
                <c:choose>
                  <c:when test="${empty loginMember}">
                    <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/member/login">
                      로그인 후 교환
                    </a>
                  </c:when>
                  <c:when test="${soldOut}">
                    <button type="button" class="btn btn-secondary btn-sm" disabled>품절</button>
                  </c:when>
                  <c:when test="${pointBalance < item.costPoint}">
                    <button type="button" class="btn btn-outline-secondary btn-sm" disabled>포인트 부족</button>
                  </c:when>
                  <c:otherwise>
                    <form method="post" action="${pageContext.request.contextPath}/shop/purchase"
                          onsubmit="return confirm('이 상품을 포인트로 교환할까요?');">
                      <input type="hidden" name="itemId" value="${item.itemId}">
                      <button type="submit" class="btn btn-warning btn-sm fw-bold">교환하기</button>
                    </form>
                  </c:otherwise>
                </c:choose>
              </article>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </section>

      <c:if test="${not empty loginMember}">
        <section class="zt-panel zt-mission-list zt-panel-shadow">
          <div class="d-flex align-items-center justify-content-between mb-3">
            <h2 class="h6 mb-0 fw-bold">내 쿠폰</h2>
            <span class="zt-muted small"><c:out value="${myCoupons.size()}"/>개 보유</span>
          </div>

          <c:choose>
            <c:when test="${empty myCoupons}">
              <p class="text-center text-muted py-4 mb-0">아직 교환한 쿠폰이 없어요.</p>
            </c:when>
            <c:otherwise>
              <c:forEach var="coupon" items="${myCoupons}">
                <article class="zt-mission-card ${coupon.status != 'AVAILABLE' ? 'is-expired' : ''}">
                  <div class="zt-mission-icon zt-shop-icon is-${coupon.category}">
                    <i class="bi bi-ticket-perforated"></i>
                  </div>
                  <div>
                    <div class="d-flex flex-wrap gap-2 align-items-center mb-1">
                      <h3 class="h6 fw-bold mb-0">${coupon.itemName}</h3>
                      <span class="zt-chip">${coupon.categoryLabel}</span>
                      <span class="badge ${coupon.status == 'AVAILABLE' ? 'bg-success' : 'bg-secondary'}">
                        ${coupon.statusLabel}
                      </span>
                    </div>
                    <p class="small mb-1 fw-medium font-monospace">${coupon.couponCode}</p>
                    <p class="zt-muted small mb-0">
                      사용 포인트 <fmt:formatNumber value="${coupon.costPoint}" type="number"/>P
                      · ${coupon.purchasedAt}
                    </p>
                  </div>
                </article>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </section>
      </c:if>
    </main>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
