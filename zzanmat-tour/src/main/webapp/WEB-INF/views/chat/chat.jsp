<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="여행 커뮤니티 실시간 채팅">
  <title>실시간 톡 | 짠맛투어</title>
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
  <a href="${pageContext.request.contextPath}/chat" class="active" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
  <a href="${pageContext.request.contextPath}/profile" class="" aria-label="profile"><i class="bi bi-person-circle"></i></a>
</nav>

  <div class="zt-layout">

<jsp:include page="/WEB-INF/views/components/sidebar.jsp">
  <jsp:param name="activePage" value="chat" />
</jsp:include>

    <main class="zt-content">

<section class="zt-panel zt-chat-shell">
  <header class="zt-chat-header d-flex align-items-center justify-content-between gap-2">
    <div class="flex-grow-1">
      <h1 class="h5 mb-1">Talk for Travel</h1>
      <p class="zt-muted zt-small mb-2">실시간으로 여행 정보와 동선을 나눠보세요.</p>
      <c:if test="${empty loginMember}">
        <p class="zt-muted zt-small mb-0">
          메시지 전송은 로그인이 필요합니다.
          <a href="${pageContext.request.contextPath}/member/login?redirectURL=${pageContext.request.contextPath}/chat">로그인</a>
        </p>
      </c:if>
    </div>
    <span id="chat-status" class="zt-chip"><i class="bi bi-circle-fill text-secondary"></i> 연결 중</span>
  </header>

  <div id="chat-list" class="zt-chat-list" aria-live="polite"></div>

  <form id="chat-form" class="zt-chat-compose">
    <div class="input-group">
      <label class="btn btn-light border disabled" for="chat-image" aria-label="이미지 업로드" aria-disabled="true">
        <i class="bi bi-image"></i>
      </label>
      <input id="chat-image" type="file" class="d-none" accept="image/*" disabled>
      <c:choose>
        <c:when test="${not empty loginMember}">
          <input id="chat-input" class="form-control bg-white" type="text" maxlength="300"
                 placeholder="메시지를 입력하세요" aria-label="메시지" autocomplete="off">
          <button class="btn btn-primary zt-primary-btn" type="submit">전송</button>
        </c:when>
        <c:otherwise>
          <input id="chat-input" class="form-control bg-white" type="text" maxlength="300" disabled
                 placeholder="로그인 후 전송할 수 있습니다" aria-label="메시지" autocomplete="off">
          <button class="btn btn-primary zt-primary-btn" type="submit" disabled>전송</button>
        </c:otherwise>
      </c:choose>
    </div>
  </form>
</section>

    </main>

  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
<script>
(function () {
  const contextPath = "${pageContext.request.contextPath}";
  const avatarSrc = contextPath + "/assets/images/profile-sora.svg";
  const chatList = document.getElementById("chat-list");
  const chatForm = document.getElementById("chat-form");
  const chatInput = document.getElementById("chat-input");
  const statusEl = document.getElementById("chat-status");
  const isLoggedIn = "${not empty loginMember}" === "true";
  const myUserId = ${not empty loginMember ? loginMember.id : 'null'};

  let stompClient = null;

  function setStatus(connected) {
    statusEl.innerHTML = connected
      ? '<i class="bi bi-circle-fill text-success"></i> 실시간'
      : '<i class="bi bi-circle-fill text-secondary"></i> 연결 끊김';
  }

  function scrollToLatest() {
    chatList.scrollTop = chatList.scrollHeight;
  }

  function appendMessage(message) {
    const isMine = myUserId != null && Number(message.userId) === Number(myUserId);
    const article = document.createElement("article");
    article.className = isMine ? "zt-chat-item zt-chat-item-mine" : "zt-chat-item";
    article.innerHTML =
      '<img class="zt-avatar" src="' + avatarSrc + '" alt="">' +
      "<div>" +
        '<div class="d-flex gap-2 align-items-center mb-1">' +
          '<strong class="small">' + escapeHtml(message.sender || "익명") + "</strong>" +
          '<span class="zt-muted small">' + escapeHtml(message.time || "") + "</span>" +
        "</div>" +
        '<div class="zt-chat-bubble">' + escapeHtml(message.content || "") + "</div>" +
      "</div>";
    chatList.appendChild(article);
    scrollToLatest();
  }

  function connect() {
    const socket = new SockJS(contextPath + "/ws");
    stompClient = Stomp.over(socket);
    stompClient.debug = null;
    stompClient.connect({}, function () {
      setStatus(true);
      stompClient.subscribe("/topic/public", function (frame) {
        if (!frame.body) {
          return;
        }
        appendMessage(JSON.parse(frame.body));
      });
    }, function () {
      setStatus(false);
    });
  }

  async function loadHistory() {
    try {
      const res = await fetch(contextPath + "/api/chat/messages?limit=50");
      if (!res.ok) return;
      const body = await res.json();
      const messages = Array.isArray(body) ? body : (body.data ?? []);
      if (!Array.isArray(messages)) return;
      messages.forEach(function (m) {
        appendMessage(m);
      });
      requestAnimationFrame(scrollToLatest);
    } catch (e) {
      // 이력 로드 실패해도 실시간 구독은 진행
    }
  }

  chatForm.addEventListener("submit", function (event) {
    event.preventDefault();
    if (!isLoggedIn) {
      window.location.href = contextPath + "/member/login?redirectURL=" +
        encodeURIComponent(contextPath + "/chat");
      return;
    }
    if (!stompClient || !stompClient.connected) {
      return;
    }
    const content = chatInput.value.trim();
    if (!content) {
      return;
    }
    stompClient.send("/app/chat.send", {}, JSON.stringify({ content: content }));
    chatInput.value = "";
    chatInput.focus();
  });

  loadHistory().finally(connect);
})();
</script>

</body>
</html>
