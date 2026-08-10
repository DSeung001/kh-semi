<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>팔로잉 관리 | 짠맛투어</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
  <style>
    .zt-following-breadcrumb { color: var(--zt-muted); font-size: .875rem; }
    .zt-following-breadcrumb strong { color: var(--zt-text); }
    .zt-following-stat { position: relative; height: 100%; overflow: hidden; padding: 20px; border: 1px solid var(--zt-border); border-radius: 12px; background: var(--zt-surface); box-shadow: 0 4px 14px rgba(0, 0, 0, .025); }
    .zt-following-stat::before { position: absolute; top: 0; left: 0; width: 4px; height: 100%; background: var(--zt-primary); content: ""; }
    .zt-following-stat-follower::before { background: #7c5ce0; }
    .zt-following-stat-followed::before { background: #17a673; }
    .zt-following-stat span { color: var(--zt-muted); font-size: .875rem; }
    .zt-following-stat strong { display: block; margin-top: 6px; color: var(--zt-text); font-size: 1.9rem; line-height: 1; }
    .zt-following-list { overflow: hidden; box-shadow: var(--zt-shadow); }
    .zt-following-list-header { padding: 18px 20px; border-bottom: 1px solid var(--zt-border); background: #fcfcfd; }
    .zt-following-list-header h2 { margin: 0; font-size: 1rem; font-weight: 700; }
    .zt-following-search { display: flex; flex: 0 1 330px; flex-wrap: nowrap; gap: 8px; }
    .zt-following-search .form-control { min-width: 0; height: 38px; flex: 1 1 auto; }
    .zt-following-search .btn { display: inline-flex; flex: 0 0 auto; align-items: center; justify-content: center; min-width: 66px; height: 38px; padding: 0 13px; white-space: nowrap; }
    .zt-following-list .table { margin: 0; }
    .zt-following-list th { padding: 13px 20px; border-bottom: 1px solid var(--zt-border); color: var(--zt-muted); background: #fafafa; font-size: .8rem; font-weight: 700; }
    .zt-following-list td { padding: 15px 20px; border-color: #eeeeee; }
    .zt-following-list tbody tr { transition: background-color .18s ease; }
    .zt-following-list tbody tr:hover { background: #f7fbff; }
    .zt-following-member-id { display: block; color: var(--zt-text); font-size: .92rem; }
    .zt-following-member-name { display: block; margin-top: 3px; color: var(--zt-muted); font-size: .8rem; }
    .zt-following-badge { display: inline-flex; align-items: center; gap: 5px; padding: 6px 9px; border: 1px solid #cce8ff; border-radius: 99px; color: #0877bd; background: #f0f9ff; font-size: .78rem; font-weight: 700; }
    .zt-following-empty { padding: 48px 20px; color: var(--zt-muted); text-align: center; }
    .zt-following-pagination { gap: 8px; }
    .zt-following-pagination .page-item { margin: 0; }
    .zt-following-pagination .page-link { display: inline-flex; align-items: center; justify-content: center; width: 36px; height: 36px; padding: 0; border: 1px solid var(--zt-border); border-radius: 50%; color: var(--zt-muted); background: #fff; font-size: .82rem; font-weight: 600; box-shadow: 0 2px 7px rgba(0, 0, 0, .06); }
    .zt-following-pagination .page-link:hover { border-color: var(--zt-primary); color: var(--zt-primary); background: #f8fbff; }
    .zt-following-pagination .page-item.active .page-link { border-color: var(--zt-primary); color: #fff; background: var(--zt-primary); box-shadow: 0 4px 10px rgba(0, 0, 0, .12); }
    .zt-following-pagination .zt-page-group-link { width: auto; min-width: 82px; padding: 0 14px; border-radius: 999px; gap: 7px; }
    .zt-following-pagination .zt-page-group-link i { font-size: .72rem; }
    @media (max-width: 575.98px) { .zt-following-list-header { align-items: stretch !important; } .zt-following-search { flex-basis: 100%; } .zt-following-list th, .zt-following-list td { padding-right: 14px; padding-left: 14px; } }
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
          <h1>회원 관리</h1>
          <p class="mb-0">회원 간 팔로우 관계를 조회하고 관리합니다.</p>
        </div>
        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin">
          <i class="bi bi-arrow-left me-1"></i>관리자 대시보드
        </a>
      </header>

      <nav class="zt-following-breadcrumb mb-3" aria-label="현재 위치">
        관리자 <i class="bi bi-chevron-right mx-1"></i> 회원 관리 <i class="bi bi-chevron-right mx-1"></i> <strong>팔로잉 관리</strong>
      </nav>

      <section class="row g-3 mb-4">
        <div class="col-12 col-md-4">
          <div class="zt-following-stat">
            <span>전체 팔로우 관계</span>
            <strong><c:out value="${totalFollowRelations}" default="0"/></strong>
          </div>
        </div>
        <div class="col-12 col-md-4">
          <div class="zt-following-stat zt-following-stat-follower">
            <span>팔로우한 회원</span>
            <strong><c:out value="${distinctFollowerCount}" default="0"/></strong>
          </div>
        </div>
        <div class="col-12 col-md-4">
          <div class="zt-following-stat zt-following-stat-followed">
            <span>팔로우된 회원</span>
            <strong><c:out value="${distinctFollowingCount}" default="0"/></strong>
          </div>
        </div>
      </section>

      <section class="zt-panel zt-following-list">
        <div class="zt-following-list-header d-flex flex-wrap justify-content-between align-items-center gap-3">
          <h2>팔로우 관계 목록 <span class="text-muted fw-normal">(<c:out value="${filteredCount}" default="0"/>건)</span></h2>
          <form class="zt-following-search" method="get" action="${pageContext.request.contextPath}/admin/following">
            <label class="visually-hidden" for="following-keyword">회원 검색</label>
            <input id="following-keyword" class="form-control form-control-sm" name="keyword" type="search" value="<c:out value='${keyword}'/>" placeholder="아이디 또는 닉네임 검색">
            <button class="btn btn-sm btn-outline-secondary" type="submit">검색</button>
          </form>
        </div>

        <div class="table-responsive">
          <table class="table align-middle mb-0">
            <thead>
              <tr>
                <th scope="col">팔로우한 회원</th>
                <th scope="col">팔로우된 회원</th>
                <th scope="col">관계</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${empty followRelations}">
                  <tr><td class="zt-following-empty" colspan="3">조회된 팔로우 관계가 없습니다.</td></tr>
                </c:when>
                <c:otherwise>
                  <c:forEach var="relation" items="${followRelations}">
                    <tr>
                      <td><strong class="zt-following-member-id"><c:out value="${relation.followerUserId}"/></strong><span class="zt-following-member-name"><c:out value="${relation.followerNickname}"/></span></td>
                      <td><strong class="zt-following-member-id"><c:out value="${relation.followingUserId}"/></strong><span class="zt-following-member-name"><c:out value="${relation.followingNickname}"/></span></td>
                      <td><span class="zt-following-badge"><i class="bi bi-arrow-right"></i>팔로우</span></td>
                    </tr>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>

        <c:if test="${totalPages > 1}">
          <nav class="py-3 px-3 border-top" aria-label="팔로우 관계 목록 페이지">
            <ul class="pagination pagination-sm justify-content-center align-items-center mb-0 zt-following-pagination">
              <c:if test="${startPage > 1}">
                <c:url var="previousPageGroupUrl" value="/admin/following">
                  <c:param name="page" value="${startPage - 1}"/>
                  <c:param name="keyword" value="${keyword}"/>
                </c:url>
                <li class="page-item">
                  <a class="page-link zt-page-group-link" href="${previousPageGroupUrl}" aria-label="이전 페이지 그룹">
                    <i class="bi bi-chevron-left" aria-hidden="true"></i>이전
                  </a>
                </li>
              </c:if>

              <c:forEach var="pageNumber" begin="${startPage}" end="${endPage}">
                <c:url var="pageUrl" value="/admin/following">
                  <c:param name="page" value="${pageNumber}"/>
                  <c:param name="keyword" value="${keyword}"/>
                </c:url>
                <li class="page-item ${pageNumber == currentPage ? 'active' : ''}">
                  <a class="page-link" href="${pageUrl}" aria-current="${pageNumber == currentPage ? 'page' : 'false'}"><c:out value="${pageNumber}"/></a>
                </li>
              </c:forEach>

              <c:if test="${endPage < totalPages}">
                <c:url var="nextPageGroupUrl" value="/admin/following">
                  <c:param name="page" value="${endPage + 1}"/>
                  <c:param name="keyword" value="${keyword}"/>
                </c:url>
                <li class="page-item">
                  <a class="page-link zt-page-group-link" href="${nextPageGroupUrl}" aria-label="다음 페이지 그룹">
                    다음<i class="bi bi-chevron-right" aria-hidden="true"></i>
                  </a>
                </li>
              </c:if>
            </ul>
          </nav>
        </c:if>
      </section>
    </main>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
