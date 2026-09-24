<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Judge Evaluation Portal | EventSphere" />
<c:set var="activePage" value="judge" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />
<jsp:include page="/WEB-INF/views/common/alerts.jsp" />

<main class="page-container">
    <div class="container">
        <!-- Judge Profile Header -->
        <div class="dashboard-user-card">
            <div class="user-greeting-flex">
                <img src="${pageContext.request.contextPath}/${judge.avatar != null ? judge.avatar : 'assets/images/avatars/judge1.jpg'}" 
                     alt="${judge.name}" class="dash-avatar" />
                <div class="user-greeting-meta">
                    <span class="user-role-badge role-judge">JURY EVALUATOR</span>
                    <h1 class="dash-greeting-name">${judge.name}</h1>
                    <p class="dash-greeting-sub">
                        <span>🏛️ ${judge.organization}</span>
                        <span class="dot-separator">•</span>
                        <span>🎖️ ${judge.title}</span>
                        <span class="dot-separator">•</span>
                        <span>🎯 Focus: ${judge.specialization}</span>
                    </p>
                </div>
            </div>
        </div>

        <!-- Metric KPI Cards -->
        <div class="kpi-grid mt-6">
            <div class="kpi-card">
                <div class="kpi-icon">📋</div>
                <div class="kpi-content">
                    <div class="kpi-val">${fn:length(assignedEvents)}</div>
                    <div class="kpi-label">Assigned Competitions</div>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon">📁</div>
                <div class="kpi-content">
                    <div class="kpi-val">${fn:length(submissions)}</div>
                    <div class="kpi-label">Queue Submissions</div>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon">⚖️</div>
                <div class="kpi-content">
                    <div class="kpi-val">${fn:length(existingScores)}</div>
                    <div class="kpi-label">Evaluated by You</div>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon">⏳</div>
                <div class="kpi-content">
                    <div class="kpi-val">${fn:length(submissions) - fn:length(existingScores)}</div>
                    <div class="kpi-label">Pending Reviews</div>
                </div>
            </div>
        </div>

        <!-- Assigned Competitions Overview -->
        <div class="portal-section-header mt-8">
            <h2>My Assigned Competitions</h2>
        </div>
        <div class="assigned-events-grid mt-4">
            <c:forEach var="ev" items="${assignedEvents}">
                <div class="assigned-event-mini-card">
                    <div class="mini-card-header">
                        <span class="badge badge-primary">${ev.category}</span>
                        <span class="event-status-badge status-${fn:toLowerCase(ev.status)}">${ev.status}</span>
                    </div>
                    <h4>${ev.title}</h4>
                    <p class="text-sm text-muted">📍 ${ev.venue} &bull; 👥 ${ev.currentRegistrations} Registered Teams</p>
                </div>
            </c:forEach>
        </div>

        <!-- Submissions Queue Table -->
        <div class="portal-section-header mt-10">
            <h2>Project Evaluation Queue</h2>
        </div>
        
        <div class="table-container mt-4">
            <div class="table-card">
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Project & Squad</th>
                                <th>Competition</th>
                                <th>Tech Stack</th>
                                <th>Review Status</th>
                                <th class="text-center">My Weighted Score</th>
                                <th class="text-right">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="sub" items="${submissions}" varStatus="status">
                                <c:set var="myScore" value="${existingScores[sub.id]}" />
                                <tr>
                                    <td>${status.index + 1}</td>
                                    <td>
                                        <div class="table-team-name">${sub.teamName != null ? sub.teamName : sub.userName}</div>
                                        <div class="table-proj-title">${sub.title}</div>
                                    </td>
                                    <td>
                                        <span class="text-muted">${sub.eventTitle}</span>
                                    </td>
                                    <td>
                                        <c:if test="${not empty sub.techStack}">
                                            <div class="table-tech-tags">
                                                <c:forEach var="tag" items="${fn:split(sub.techStack, ',')}" end="2">
                                                    <span class="tech-tag">${fn:trim(tag)}</span>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${myScore != null && myScore.submitted}">
                                                <span class="badge badge-success">✓ Locked & Submitted</span>
                                            </c:when>
                                            <c:when test="${myScore != null && !myScore.submitted}">
                                                <span class="badge badge-warning">✏️ Draft Saved</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-neutral">⏳ Pending Evaluation</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${myScore != null}">
                                                <span class="font-bold text-accent">
                                                    <fmt:formatNumber value="${myScore.totalWeightedScore}" minFractionDigits="2" maxFractionDigits="2" /> / 10.0
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">—</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-right">
                                        <a href="${pageContext.request.contextPath}/judge/evaluate?submissionId=${sub.id}" class="btn btn-sm btn-primary">
                                            ${myScore != null ? 'Edit / View Score' : 'Score Rubric →'}
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
