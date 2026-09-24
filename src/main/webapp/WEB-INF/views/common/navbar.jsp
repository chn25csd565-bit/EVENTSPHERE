<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<nav class="navbar">
    <div class="nav-container">
        <!-- Logo -->
        <a href="${pageContext.request.contextPath}/home" class="nav-logo">
            <span class="logo-icon">✦</span>
            <span>EVENT<span class="text-gradient">SPHERE</span></span>
        </a>

        <!-- Main Navigation Links -->
        <ul class="nav-links">
            <li>
                <a href="${pageContext.request.contextPath}/home" class="nav-link ${activePage == 'home' ? 'active' : ''}">Home</a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/events" class="nav-link ${activePage == 'events' ? 'active' : ''}">Events</a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/previous-events" class="nav-link ${activePage == 'showcase' ? 'active' : ''}">Showcase</a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/leaderboard" class="nav-link ${activePage == 'leaderboard' ? 'active' : ''}">
                    <span class="leaderboard-badge-dot"></span> Leaderboard
                </a>
            </li>

            <c:if test="${sessionScope.currentUser != null}">
                <c:choose>
                    <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link ${activePage == 'admin' ? 'active' : ''}">Admin Console</a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/attendance" class="nav-link ${activePage == 'attendance' ? 'active' : ''}">Attendance</a>
                        </li>
                    </c:when>
                    <c:when test="${sessionScope.currentUser.role == 'JUDGE'}">
                        <li>
                            <a href="${pageContext.request.contextPath}/judge/dashboard" class="nav-link ${activePage == 'judge' ? 'active' : ''}">Judge Evaluations</a>
                        </li>
                    </c:when>
                    <c:when test="${sessionScope.currentUser.role == 'STUDENT'}">
                        <li>
                            <a href="${pageContext.request.contextPath}/student/dashboard" class="nav-link ${activePage == 'student' ? 'active' : ''}">My Dashboard</a>
                        </li>
                    </c:when>
                </c:choose>
            </c:if>
        </ul>

        <!-- User Authentication & Action Section -->
        <div class="nav-actions">
            <c:choose>
                <c:when test="${sessionScope.currentUser != null}">
                    <div class="user-profile-menu">
                        <img src="${pageContext.request.contextPath}/${sessionScope.currentUser.avatar != null ? sessionScope.currentUser.avatar : 'assets/images/avatars/student1.jpg'}" 
                             alt="${sessionScope.currentUser.name}" 
                             class="nav-avatar" />
                        <div class="user-meta">
                            <span class="user-name">${sessionScope.currentUser.name}</span>
                            <span class="user-role-badge role-${fn:toLowerCase(sessionScope.currentUser.role)}">${sessionScope.currentUser.role}</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm logout-btn" title="Sign Out">
                            <span>Sign Out</span>
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-ghost btn-sm">Log In</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm">Register</a>
                </c:otherwise>
            </c:choose>

            <!-- Mobile Hamburger Button -->
            <button class="mobile-menu-btn" aria-label="Toggle navigation">
                <span></span>
                <span></span>
                <span></span>
            </button>
        </div>
    </div>
</nav>
