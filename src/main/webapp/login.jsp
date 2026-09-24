<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Sign In | EventSphere" />
<c:set var="activePage" value="login" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />
<jsp:include page="/WEB-INF/views/common/alerts.jsp" />

<main class="page-container flex-center">
    <div class="auth-card-wrapper animate-fade-up">
        <!-- Brand Header -->
        <div class="auth-header text-center">
            <div class="auth-logo-badge">✦</div>
            <h1 class="auth-title">Welcome to EventSphere</h1>
            <p class="auth-subtitle">Sign in to manage submissions, coordinate teams, or evaluate projects.</p>
        </div>

        <!-- 1-Click Fast Demo Switcher -->
        <div class="demo-quick-switcher">
            <span class="quick-switch-label">⚡ 1-Click Demo Login:</span>
            <div class="quick-switch-btns">
                <button type="button" class="btn-demo-pill student" onclick="fillDemo('alex.chen@student.edu', 'Student@123')">
                    Student (Alex)
                </button>
                <button type="button" class="btn-demo-pill judge" onclick="fillDemo('judge.alan@eventsphere.edu', 'Judge@123')">
                    Judge (Prof. Alan)
                </button>
                <button type="button" class="btn-demo-pill admin" onclick="fillDemo('admin@eventsphere.edu', 'Admin@123')">
                    Admin (Dr. Vance)
                </button>
            </div>
        </div>

        <!-- Authentication Form -->
        <form action="${pageContext.request.contextPath}/login" method="POST" class="auth-form" id="loginForm">
            <input type="hidden" name="redirect" value="${fn:escapeXml(param.redirect)}" />

            <div class="form-group mb-4">
                <label for="emailInput" class="form-label">Campus Email Address</label>
                <input type="email" id="emailInput" name="email" value="${fn:escapeXml(email)}" required placeholder="e.g. alex.chen@student.edu" class="form-input" autocomplete="email" />
            </div>

            <div class="form-group mb-4">
                <div class="flex-between">
                    <label for="passwordInput" class="form-label">Password</label>
                    <button type="button" class="text-xs text-muted toggle-pwd-btn" onclick="togglePasswordVisibility()">Show</button>
                </div>
                <input type="password" id="passwordInput" name="password" required placeholder="••••••••••••" class="form-input" autocomplete="current-password" />
            </div>

            <button type="submit" class="btn btn-primary btn-block btn-lg">
                Sign In to Platform →
            </button>
        </form>

        <div class="auth-footer text-center mt-6">
            <p class="text-muted">New to EventSphere? 
                <a href="${pageContext.request.contextPath}/register" class="text-primary font-semibold">Create Student Account</a>
            </p>
        </div>
    </div>
</main>

<script>
function fillDemo(email, pass) {
    document.getElementById('emailInput').value = email;
    document.getElementById('passwordInput').value = pass;
    document.getElementById('loginForm').submit();
}

function togglePasswordVisibility() {
    const input = document.getElementById('passwordInput');
    const btn = document.querySelector('.toggle-pwd-btn');
    if (input.type === 'password') {
        input.type = 'text';
        btn.textContent = 'Hide';
    } else {
        input.type = 'password';
        btn.textContent = 'Show';
    }
}
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
