<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<c:set var="pageTitle" value="500 - Server Exception | EventSphere" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="page-container flex-center">
    <div class="error-card text-center">
        <div class="error-badge danger">500</div>
        <h1 class="error-title">Internal Server Encounter</h1>
        <p class="error-desc">An unexpected processing anomaly occurred while handling your request. The engine has logged the trace.</p>
        <div class="error-actions">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Return to Home</a>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
