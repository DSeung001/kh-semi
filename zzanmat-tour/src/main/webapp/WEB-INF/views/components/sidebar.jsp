<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<aside class="zt-sidebar">
  <a class="zt-brand" href="${pageContext.request.contextPath}/home">
    <img class="zt-bran-logo"
         src="${pageContext.request.contextPath}/assets/images/zzanmat-logo-trimmed.png"
         alt="짠맛투어">
  </a>

  <nav class="zt-nav" aria-label="주요 메뉴">
    <a class="zt-nav-link ${param.activePage eq 'home' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/home"
       aria-current="${param.activePage eq 'home' ? 'page' : 'false'}">
      <i class="bi bi-house"></i><span>홈</span>
    </a>
    <a class="zt-nav-link ${param.activePage eq 'my-travel' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/my-travel"
       aria-current="${param.activePage eq 'my-travel' ? 'page' : 'false'}">
      <i class="bi bi-grid-3x3-gap"></i><span>나만의 여행실</span>
    </a>
    <a class="zt-nav-link ${param.activePage eq 'chat' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/chat"
       aria-current="${param.activePage eq 'chat' ? 'page' : 'false'}">
      <i class="bi bi-chat-dots"></i><span>실시간 톡</span>
    </a>
    <a class="zt-nav-link ${param.activePage eq 'mission' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/mission"
       aria-current="${param.activePage eq 'mission' ? 'page' : 'false'}">
      <i class="bi bi-flag"></i><span>Mission Possible</span>
    </a>
    <c:if test="${not empty loginMember and loginMember.role eq 'ADMIN'}">
      <a class="zt-nav-link ${param.activePage eq 'admin' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/admin"
         aria-current="${param.activePage eq 'admin' ? 'page' : 'false'}">
        <i class="bi bi-shield-lock"></i><span>관리자</span>
      </a>
    </c:if>
    <c:choose>
      <c:when test="${not empty loginMember}">
      <a class="zt-nav-link ${param.activePage eq 'profile' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/member/profile"
         aria-current="${param.activePage eq 'profile' ? 'page' : 'false'}">
        <i class="bi bi-person-circle"></i><span>내 정보</span>
      </a>
      </c:when>
      <c:otherwise>
        <a class="zt-nav-link ${param.activePage eq 'profile' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/member/login"
           aria-current="${param.activePage eq 'profile' ? 'page' : 'false'}">
          <i class="bi bi-person-circle"></i><span>로그인</span>
        </a>
      </c:otherwise>
    </c:choose>
    <c:if test="${not empty loginMember}">
    <a class="zt-nav-link ${param.activePage eq 'new-post' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/new-post"
       aria-current="${param.activePage eq 'new-post' ? 'page' : 'false'}">
      <i class="bi bi-plus-square"></i>
      <span>게시물 만들기</span>
    </a>
    </c:if>
  </nav>
<script>
  console.log("${pageContext.request.contextPath}");
</script>
  <div class="zt-sidebar-footer">
    <a href="#">이용약관</a><br>
    <a href="#">개인정보처리방침</a><br>
    <span>&copy; 2026 짠맛투어</span>
  </div>
</aside>
