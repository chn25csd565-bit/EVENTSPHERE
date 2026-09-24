<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Create Student Account | EventSphere" />
<c:set var="activePage" value="register" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />
<jsp:include page="/WEB-INF/views/common/alerts.jsp" />

<main class="page-container flex-center">
    <div class="auth-card-wrapper animate-fade-up register-wrapper">
        <div class="auth-header text-center">
            <div class="auth-logo-badge">🎓</div>
            <h1 class="auth-title">Register as a Student Builder</h1>
            <p class="auth-subtitle">Join campus hackathons, form squads, and compete for scholarships and cash pools.</p>
        </div>

        <form action="${pageContext.request.contextPath}/register" method="POST" class="auth-form" id="registerForm">
            <div class="form-grid-2">
                <div class="form-group mb-3">
                    <label for="nameInput" class="form-label">Full Name</label>
                    <input type="text" id="nameInput" name="name" value="${fn:escapeXml(name)}" required placeholder="e.g. Maya Patel" class="form-input" />
                </div>

                <div class="form-group mb-3">
                    <label for="emailInput" class="form-label">Campus Email</label>
                    <input type="email" id="emailInput" name="email" value="${fn:escapeXml(email)}" required placeholder="e.g. maya@student.edu" class="form-input" />
                </div>
            </div>

            <div class="form-grid-2">
                <div class="form-group mb-3">
                    <label for="collegeInput" class="form-label">College / Institute</label>
                    <input type="text" id="collegeInput" name="college" value="${fn:escapeXml(college)}" required placeholder="e.g. Apex Institute of Technology" class="form-input" />
                </div>

                <div class="form-group mb-3">
                    <label for="deptInput" class="form-label">Department / Major</label>
                    <input type="text" id="deptInput" name="department" value="${fn:escapeXml(department)}" required placeholder="e.g. Computer Science & AI" class="form-input" />
                </div>
            </div>

            <div class="form-group mb-3">
                <label for="phoneInput" class="form-label">Contact Phone (Optional)</label>
                <input type="tel" id="phoneInput" name="phone" value="${fn:escapeXml(phone)}" placeholder="+1-555-0199" class="form-input" />
            </div>

            <div class="form-grid-2">
                <div class="form-group mb-4">
                    <label for="pwdInput" class="form-label">Password</label>
                    <input type="password" id="pwdInput" name="password" required placeholder="Min 6 characters" class="form-input" />
                </div>

                <div class="form-group mb-4">
                    <label for="confirmPwdInput" class="form-label">Confirm Password</label>
                    <input type="password" id="confirmPwdInput" name="confirmPassword" required placeholder="Re-enter password" class="form-input" />
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-block btn-lg">
                Create Account & Join Arena →
            </button>
        </form>

        <div class="auth-footer text-center mt-6">
            <p class="text-muted">Already registered? 
                <a href="${pageContext.request.contextPath}/login" class="text-primary font-semibold">Sign In here</a>
            </p>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
