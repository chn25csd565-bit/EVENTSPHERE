<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<c:set var="pageTitle" value="404 - Page Not Found | EventSphere" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="page-container flex-center">
    <div class="error-card text-center">
        <div class="error-badge">404</div>
        <h1 class="error-title">Checkpoint Not Found</h1>
        <p class="error-desc">The requested campus event or coordinate does not exist or may have been relocated.</p>
        <div class="error-actions">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Return Home</a>
            <a href="${pageContext.request.contextPath}/events" class="btn btn-outline">Explore Active Events</a>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
