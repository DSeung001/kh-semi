<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<aside class="zt-sidebar">
  <a class="zt-brand" href="${pageContext.request.contextPath}/home">
    <span>짠맛투어</span>
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
    <a class="zt-nav-link ${param.activePage eq 'profile' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/profile"
       aria-current="${param.activePage eq 'profile' ? 'page' : 'false'}">
      <i class="bi bi-person-circle"></i><span>내 정보</span>
    </a>
    <a class="zt-nav-link ${param.activePage eq 'new-post' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/new-post"
       aria-current="${param.activePage eq 'new-post' ? 'page' : 'false'}">
      <i class="bi bi-plus-square"></i>
      <span>게시물 만들기</span>
    </a>
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
