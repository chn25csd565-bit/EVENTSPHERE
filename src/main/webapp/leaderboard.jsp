<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Live Calculated Leaderboard | EventSphere" />
<c:set var="activePage" value="leaderboard" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />
<jsp:include page="/WEB-INF/views/common/alerts.jsp" />

<main class="page-container">
    <div class="container">
        <!-- Page Header -->
        <div class="page-header text-center">
            <div class="leaderboard-live-pill">
                <span class="pulse-indicator"></span>
                <span>Real-Time Rubric Aggregation Active</span>
            </div>
            <h1 class="page-title">Live Competition Leaderboard</h1>
            <p class="page-subtitle">Rankings dynamically synthesized from jury rubric scorecards with multi-judge weighted averages.</p>
        </div>

        <!-- Event Filter Selector -->
        <div class="leaderboard-filter-bar">
            <form action="${pageContext.request.contextPath}/leaderboard" method="GET" class="filter-form-inline">
                <label for="eventSelect" class="filter-select-label">Select Competition:</label>
                <select name="eventId" id="eventSelect" class="form-select" onchange="this.form.submit()">
                    <option value="" ${empty selectedEventId ? 'selected' : ''}>-- All Campus Events --</option>
                    <c:forEach var="ev" items="${events}">
                        <option value="${ev.id}" ${selectedEventId == ev.id ? 'selected' : ''}>${ev.title} (${ev.category})</option>
                    </c:forEach>
                </select>
                <noscript><button type="submit" class="btn btn-sm btn-primary">Filter</button></noscript>
            </form>
            <div class="scoring-formula-hint">
                <span>Weighted Formula:</span>
                <code>Inno(25%) + Tech(30%) + UX(20%) + Pitch(15%) + Feas(10%)</code>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty leaderboard}">
                <!-- Top 3 Podium Highlights -->
                <div class="podium-section mt-8">
                    <div class="podium-grid">
                        <c:forEach var="entry" items="${leaderboard}" end="2">
                            <div class="podium-card rank-${entry.rank}">
                                <div class="podium-rank-badge">
                                    <c:choose>
                                        <c:when test="${entry.rank == 1}">👑 1st Gold</c:when>
                                        <c:when test="${entry.rank == 2}">🥈 2nd Silver</c:when>
                                        <c:when test="${entry.rank == 3}">🥉 3rd Bronze</c:when>
                                    </c:choose>
                                </div>
                                <h3 class="podium-team-name">${entry.teamName}</h3>
                                <h4 class="podium-project-title">${entry.projectTitle}</h4>
                                <div class="podium-event-name">📍 ${entry.eventTitle}</div>

                                <div class="podium-score-box">
                                    <div class="score-num">
                                        <fmt:formatNumber value="${entry.finalScore}" minFractionDigits="2" maxFractionDigits="2" />
                                    </div>
                                    <div class="score-denom">/ 10.0</div>
                                </div>
                                <small class="text-muted">Evaluated by ${entry.judgeCount} Jury Members</small>

                                <div class="podium-links mt-4">
                                    <c:if test="${not empty entry.demoUrl}">
                                        <a href="${entry.demoUrl}" target="_blank" rel="noopener" class="btn btn-outline btn-xs">Live Prototype ↗</a>
                                    </c:if>
                                    <c:if test="${not empty entry.repoUrl}">
                                        <a href="${entry.repoUrl}" target="_blank" rel="noopener" class="btn btn-ghost btn-xs">GitHub ↗</a>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Complete Leaderboard Table -->
                <div class="table-container mt-10">
                    <div class="table-card">
                        <div class="table-header-title">
                            <h3>Full Standings & Rubric Breakdown</h3>
                        </div>
                        <div class="table-responsive">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Rank</th>
                                        <th>Squad / Project</th>
                                        <th>Competition</th>
                                        <th class="text-center" title="Weight: 25%">Inno (25%)</th>
                                        <th class="text-center" title="Weight: 30%">Tech (30%)</th>
                                        <th class="text-center" title="Weight: 20%">UX (20%)</th>
                                        <th class="text-center" title="Weight: 15%">Pitch (15%)</th>
                                        <th class="text-center" title="Weight: 10%">Feas (10%)</th>
                                        <th class="text-center">Jury</th>
                                        <th class="text-right">Final Score</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="entry" items="${leaderboard}">
                                        <tr class="table-row-hover rank-row-${entry.rank}">
                                            <td class="rank-col">
                                                <span class="rank-pill ${entry.badgeClass}">#${entry.rank}</span>
                                            </td>
                                            <td class="project-col">
                                                <div class="table-team-name">${entry.teamName}</div>
                                                <div class="table-proj-title">${entry.projectTitle}</div>
                                                <c:if test="${not empty entry.techStack}">
                                                    <div class="table-tech-tags">
                                                        <c:forEach var="tech" items="${fn:split(entry.techStack, ',')}">
                                                            <span class="tech-tag">${fn:trim(tech)}</span>
                                                        </c:forEach>
                                                    </div>
                                                </c:if>
                                            </td>
                                            <td class="event-col">
                                                <span class="text-muted">${entry.eventTitle}</span>
                                            </td>
                                            <td class="text-center rubric-val"><fmt:formatNumber value="${entry.avgInnovation}" minFractionDigits="1" maxFractionDigits="1" /></td>
                                            <td class="text-center rubric-val"><fmt:formatNumber value="${entry.avgTechnical}" minFractionDigits="1" maxFractionDigits="1" /></td>
                                            <td class="text-center rubric-val"><fmt:formatNumber value="${entry.avgDesign}" minFractionDigits="1" maxFractionDigits="1" /></td>
                                            <td class="text-center rubric-val"><fmt:formatNumber value="${entry.avgPresentation}" minFractionDigits="1" maxFractionDigits="1" /></td>
                                            <td class="text-center rubric-val"><fmt:formatNumber value="${entry.avgFeasibility}" minFractionDigits="1" maxFractionDigits="1" /></td>
                                            <td class="text-center">
                                                <span class="judge-count-pill">${entry.judgeCount} ⚖️</span>
                                            </td>
                                            <td class="text-right score-col">
                                                <span class="final-score-pill">
                                                    <fmt:formatNumber value="${entry.finalScore}" minFractionDigits="2" maxFractionDigits="2" />
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state-card text-center mt-10">
                    <div class="empty-icon">📊</div>
                    <h3>No Evaluated Submissions Yet</h3>
                    <p>Scores appear here automatically once jury members submit rubric evaluations for this event.</p>
                    <a href="${pageContext.request.contextPath}/events" class="btn btn-primary btn-sm mt-4">View Active Events</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
