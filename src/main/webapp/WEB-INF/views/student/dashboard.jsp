<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Student Builder Dashboard | EventSphere" />
<c:set var="activePage" value="student" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />
<jsp:include page="/WEB-INF/views/common/alerts.jsp" />

<main class="page-container">
    <div class="container">
        <!-- Student Profile Greeting Banner -->
        <div class="dashboard-user-card">
            <div class="user-greeting-flex">
                <img src="${pageContext.request.contextPath}/${sessionScope.currentUser.avatar != null ? sessionScope.currentUser.avatar : 'assets/images/avatars/student1.jpg'}" 
                     alt="${sessionScope.currentUser.name}" class="dash-avatar" />
                <div class="user-greeting-meta">
                    <span class="user-role-badge role-student">STUDENT BUILDER</span>
                    <h1 class="dash-greeting-name">Welcome back, ${sessionScope.currentUser.name}!</h1>
                    <p class="dash-greeting-sub">
                        <span>🏛️ ${sessionScope.currentUser.college}</span>
                        <span class="dot-separator">•</span>
                        <span>🎓 ${sessionScope.currentUser.department}</span>
                        <span class="dot-separator">•</span>
                        <span>✉️ ${sessionScope.currentUser.email}</span>
                    </p>
                </div>
            </div>
        </div>

        <!-- Metric KPI Cards -->
        <div class="kpi-grid mt-6">
            <div class="kpi-card">
                <div class="kpi-icon">🎟️</div>
                <div class="kpi-content">
                    <div class="kpi-val">${fn:length(registrations)}</div>
                    <div class="kpi-label">Registered Events</div>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon">👥</div>
                <div class="kpi-content">
                    <div class="kpi-val">${fn:length(teams)}</div>
                    <div class="kpi-label">Active Squads</div>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon">🚀</div>
                <div class="kpi-content">
                    <div class="kpi-val">${fn:length(submissions)}</div>
                    <div class="kpi-label">Submitted Projects</div>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon">📨</div>
                <div class="kpi-content">
                    <div class="kpi-val">${fn:length(invitations)}</div>
                    <div class="kpi-label">Pending Invites</div>
                </div>
            </div>
        </div>

        <!-- Pending Invitations Notice (If any) -->
        <c:if test="${not empty invitations}">
            <div class="invitations-alert-card mt-6">
                <div class="inv-header">
                    <span class="inv-bell">🔔</span>
                    <h3>You have ${fn:length(invitations)} Pending Squad Invitation(s)</h3>
                </div>
                <div class="inv-list mt-3">
                    <c:forEach var="inv" items="${invitations}">
                        <div class="inv-item">
                            <div class="inv-meta">
                                <strong>${inv.teamName}</strong> invites you to join their squad for <em>${inv.eventTitle}</em>.
                                <small class="text-muted block">Invited by: ${inv.inviterName} (${inv.inviterEmail})</small>
                            </div>
                            <div class="inv-actions">
                                <form action="${pageContext.request.contextPath}/team/respond-invite" method="POST" class="inline-form">
                                    <input type="hidden" name="invitationId" value="${inv.id}" />
                                    <input type="hidden" name="action" value="ACCEPT" />
                                    <button type="submit" class="btn btn-sm btn-primary">Accept & Join</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/team/respond-invite" method="POST" class="inline-form">
                                    <input type="hidden" name="invitationId" value="${inv.id}" />
                                    <input type="hidden" name="action" value="DECLINE" />
                                    <button type="submit" class="btn btn-sm btn-outline">Decline</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <!-- Two Column Content Grid -->
        <div class="portal-grid mt-8">
            <!-- Left Column: My Registrations -->
            <div class="portal-col">
                <div class="portal-section-header">
                    <h2>My Event Registrations</h2>
                    <a href="${pageContext.request.contextPath}/events" class="btn btn-sm btn-outline">+ Discover Events</a>
                </div>

                <c:choose>
                    <c:when test="${not empty registrations}">
                        <div class="registrations-list">
                            <c:forEach var="reg" items="${registrations}">
                                <div class="reg-item-card">
                                    <div class="reg-card-top">
                                        <div class="reg-title-wrap">
                                            <span class="badge badge-primary">${reg.eventCategory}</span>
                                            <h3>${reg.eventTitle}</h3>
                                        </div>
                                        <span class="ticket-badge">
                                            Ticket: <code>${reg.registrationCode}</code>
                                        </span>
                                    </div>

                                    <div class="reg-card-meta">
                                        <span>📍 ${reg.eventVenue}</span>
                                        <span>📅 ${reg.eventStartDate}</span>
                                        <c:if test="${not empty reg.teamName}">
                                            <span>👥 Squad: <strong>${reg.teamName}</strong></span>
                                        </c:if>
                                    </div>

                                    <div class="reg-card-actions mt-4">
                                        <a href="${pageContext.request.contextPath}/event-detail?id=${reg.eventId}" class="btn btn-sm btn-ghost">
                                            Event Details
                                        </a>
                                        <a href="${pageContext.request.contextPath}/submit-project?eventId=${reg.eventId}" class="btn btn-sm btn-primary">
                                            Submit / Edit Project →
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state-card text-center">
                            <p>You haven't registered for any events yet.</p>
                            <a href="${pageContext.request.contextPath}/events" class="btn btn-primary btn-sm mt-3">Explore Events Now</a>
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- My Submissions -->
                <div class="portal-section-header mt-10">
                    <h2>My Submissions & Judging Status</h2>
                </div>
                <c:choose>
                    <c:when test="${not empty submissions}">
                        <div class="submissions-list">
                            <c:forEach var="sub" items="${submissions}">
                                <div class="sub-item-card">
                                    <div class="sub-card-top">
                                        <h4>${sub.title}</h4>
                                        <span class="version-tag">v${sub.version}.0</span>
                                    </div>
                                    <p class="sub-desc text-muted">${sub.description}</p>
                                    
                                    <c:if test="${not empty sub.techStack}">
                                        <div class="tech-tags-list mt-2">
                                            <c:forEach var="tag" items="${fn:split(sub.techStack, ',')}">
                                                <span class="tech-tag">${fn:trim(tag)}</span>
                                            </c:forEach>
                                        </div>
                                    </c:if>

                                    <div class="sub-links-row mt-3">
                                        <c:if test="${not empty sub.demoUrl}">
                                            <a href="${sub.demoUrl}" target="_blank" rel="noopener" class="btn btn-xs btn-outline">Demo Prototype ↗</a>
                                        </c:if>
                                        <c:if test="${not empty sub.repoUrl}">
                                            <a href="${sub.repoUrl}" target="_blank" rel="noopener" class="btn btn-xs btn-ghost">Repository ↗</a>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/leaderboard?eventId=${sub.eventId}" class="btn btn-xs btn-ghost text-gold">
                                            View On Leaderboard →
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state-card text-center">
                            <p>No project submissions uploaded yet. Click on any registered event above to submit your project links!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Right Column: Teams & Squad Management -->
            <div class="portal-col">
                <div class="portal-section-header">
                    <h2>My Squads & Teammates</h2>
                </div>

                <c:choose>
                    <c:when test="${not empty teams}">
                        <div class="teams-list">
                            <c:forEach var="team" items="${teams}">
                                <div class="team-panel-card">
                                    <div class="team-panel-header">
                                        <div>
                                            <h3 class="team-panel-name">${team.name}</h3>
                                            <small class="text-muted">Event: ${team.eventTitle}</small>
                                        </div>
                                        <c:choose>
                                            <c:when test="${team.locked}">
                                                <span class="status-badge status-closed">🔒 Roster Locked</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-ongoing">🔓 Formation Open</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Team Join Code & Copy Button -->
                                    <div class="team-code-banner">
                                        <span>Squad Join Code:</span>
                                        <code id="code-${team.id}">${team.teamCode}</code>
                                        <button type="button" class="btn-copy-code" onclick="copyToClipboard('${team.teamCode}', this)">Copy</button>
                                    </div>

                                    <!-- Team Roster Members -->
                                    <div class="roster-box mt-3">
                                        <div class="roster-title">Current Members (${team.memberCount}):</div>
                                        <ul class="roster-list">
                                            <c:forEach var="member" items="${team.members}">
                                                <li class="roster-item">
                                                    <span class="member-name">${member.userName}</span>
                                                    <span class="member-role ${fn:toLowerCase(member.role)}">${member.role}</span>
                                                    <c:if test="${team.leaderId == sessionScope.currentUser.id && member.userId != sessionScope.currentUser.id && !team.locked}">
                                                        <form action="${pageContext.request.contextPath}/team/remove-member" method="POST" class="inline-form" onsubmit="return confirm('Remove teammate?');">
                                                            <input type="hidden" name="teamId" value="${team.id}" />
                                                            <input type="hidden" name="userId" value="${member.userId}" />
                                                            <button type="submit" class="btn-remove-member" title="Remove Member">&times;</button>
                                                        </form>
                                                    </c:if>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </div>

                                    <!-- Invite Teammate Form (Only for Leader & when not locked) -->
                                    <c:if test="${team.leaderId == sessionScope.currentUser.id && !team.locked}">
                                        <div class="invite-form-box mt-4">
                                            <form action="${pageContext.request.contextPath}/team/invite" method="POST" class="invite-inline-form">
                                                <input type="hidden" name="teamId" value="${team.id}" />
                                                <input type="email" name="email" required placeholder="Teammate's campus email..." class="form-input form-input-sm" />
                                                <button type="submit" class="btn btn-sm btn-primary">Invite</button>
                                            </form>
                                        </div>

                                        <!-- Lock Roster Button -->
                                        <div class="mt-4 pt-3 border-t border-glass">
                                            <form action="${pageContext.request.contextPath}/team/lock" method="POST" onsubmit="return confirm('Locking the roster freezes your team composition. Proceed?');">
                                                <input type="hidden" name="teamId" value="${team.id}" />
                                                <button type="submit" class="btn btn-sm btn-outline btn-block text-warning">
                                                    🔒 Lock Team Roster
                                                </button>
                                            </form>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state-card text-center">
                            <p>You haven't formed or joined any squads yet. Register for a team hackathon to create your squad!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</main>

<script>
function copyToClipboard(text, btn) {
    navigator.clipboard.writeText(text).then(() => {
        const original = btn.textContent;
        btn.textContent = 'Copied!';
        setTimeout(() => { btn.textContent = original; }, 2000);
    });
}
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
