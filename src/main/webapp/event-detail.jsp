<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="${event.title} | EventSphere" />
<c:set var="activePage" value="events" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />
<jsp:include page="/WEB-INF/views/common/alerts.jsp" />

<main class="page-container">
    <div class="container">
        <!-- Breadcrumbs -->
        <nav class="breadcrumb-nav">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <span class="bc-sep">/</span>
            <a href="${pageContext.request.contextPath}/events">Events</a>
            <span class="bc-sep">/</span>
            <span class="bc-current">${event.title}</span>
        </nav>

        <!-- Event Detail Header Banner -->
        <div class="detail-banner-card">
            <div class="banner-img-wrap">
                <img src="${pageContext.request.contextPath}/${event.bannerImage}" alt="${event.title}" class="detail-banner-image" />
                <div class="banner-overlay-gradient"></div>
            </div>
            <div class="detail-banner-content">
                <div class="detail-badge-row">
                    <span class="badge badge-primary">${event.category}</span>
                    <span class="event-status-badge status-${fn:toLowerCase(event.status)}">${event.status}</span>
                </div>
                <h1 class="detail-title">${event.title}</h1>
                <p class="detail-tagline">${event.tagline}</p>
                
                <div class="detail-quick-meta">
                    <div class="qmeta-item">
                        <span class="qmeta-icon">📍</span>
                        <div>
                            <small>Venue</small>
                            <strong>${event.venue}</strong>
                        </div>
                    </div>
                    <div class="qmeta-item">
                        <span class="qmeta-icon">💰</span>
                        <div>
                            <small>Prize Pool</small>
                            <strong class="text-gold">${event.prizePool}</strong>
                        </div>
                    </div>
                    <div class="qmeta-item">
                        <span class="qmeta-icon">👥</span>
                        <div>
                            <small>Team Size</small>
                            <strong>
                                <c:choose>
                                    <c:when test="${event.minTeamSize == event.maxTeamSize}">
                                        ${event.minTeamSize == 1 ? 'Solo Only' : event.minTeamSize.toString().concat(' Members')}
                                    </c:when>
                                    <c:otherwise>
                                        ${event.minTeamSize} – ${event.maxTeamSize} Members
                                    </c:otherwise>
                                </c:choose>
                            </strong>
                        </div>
                    </div>
                    <div class="qmeta-item">
                        <span class="qmeta-icon">📅</span>
                        <div>
                            <small>Start Date</small>
                            <strong>${event.startDate}</strong>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Two Column Layout: Left Content & Right Sticky Sidebar -->
        <div class="detail-layout-grid mt-8">
            <!-- Left Main Content Column -->
            <div class="detail-main-content">
                <!-- Overview Section -->
                <div class="content-block">
                    <h2 class="content-heading">About This Competition</h2>
                    <p class="content-text">${event.description}</p>
                </div>

                <!-- Rules & Guidelines -->
                <div class="content-block mt-6">
                    <h2 class="content-heading">Rules & Eligibility</h2>
                    <div class="rules-box">
                        <c:forEach var="rule" items="${fn:split(event.rules, '&#10;')}">
                            <c:if test="${not empty fn:trim(rule)}">
                                <div class="rule-item">
                                    <span class="rule-icon">✔</span>
                                    <span>${rule}</span>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

                <!-- Schedule & Timeline -->
                <div class="content-block mt-6">
                    <h2 class="content-heading">Event Schedule & Milestones</h2>
                    <div class="schedule-timeline">
                        <c:forEach var="schedLine" items="${fn:split(event.schedule, '&#10;')}">
                            <c:if test="${not empty fn:trim(schedLine)}">
                                <div class="timeline-entry">
                                    <div class="timeline-dot"></div>
                                    <div class="timeline-content">${schedLine}</div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

                <!-- Judging Rubric Breakdown -->
                <div class="content-block mt-6">
                    <h2 class="content-heading">Official Evaluation Rubric (100 Points)</h2>
                    <p class="text-muted mb-4">All project submissions are evaluated across five weighted criteria:</p>
                    <div class="rubric-cards-grid">
                        <div class="rubric-mini-card">
                            <div class="rubric-weight">25%</div>
                            <h4>Innovation & Creativity</h4>
                            <p>Originality of the problem approach, novel architecture, or breakthrough thinking.</p>
                        </div>
                        <div class="rubric-mini-card">
                            <div class="rubric-weight">30%</div>
                            <h4>Technical Complexity</h4>
                            <p>Code architecture, algorithm implementation, API integrations, and robust test handling.</p>
                        </div>
                        <div class="rubric-mini-card">
                            <div class="rubric-weight">20%</div>
                            <h4>Design & UX</h4>
                            <p>Visual polish, responsive behavior, accessibility, and intuitive interaction flow.</p>
                        </div>
                        <div class="rubric-mini-card">
                            <div class="rubric-weight">15%</div>
                            <h4>Presentation & Pitch</h4>
                            <p>Clarity of demonstration, deck communication, and concise architectural articulation.</p>
                        </div>
                        <div class="rubric-mini-card">
                            <div class="rubric-weight">10%</div>
                            <h4>Practical Feasibility</h4>
                            <p>Commercial viability, scalability, data privacy, and realistic deployment readiness.</p>
                        </div>
                    </div>
                </div>

                <!-- Assigned Jury Panel -->
                <div class="content-block mt-6">
                    <h2 class="content-heading">Distinguished Jury Panel</h2>
                    <c:choose>
                        <c:when test="${not empty judges}">
                            <div class="judges-grid">
                                <c:forEach var="judge" items="${judges}">
                                    <div class="judge-profile-card">
                                        <img src="${pageContext.request.contextPath}/${judge.avatar != null ? judge.avatar : 'assets/images/avatars/judge1.jpg'}" alt="${judge.name}" class="judge-avatar-img" />
                                        <div class="judge-info">
                                            <h4>${judge.name}</h4>
                                            <span class="judge-title">${judge.title}</span>
                                            <span class="judge-org">${judge.organization}</span>
                                            <p class="judge-bio">${judge.bio}</p>
                                            <div class="judge-spec-tag">
                                                <strong>Focus:</strong> ${judge.specialization}
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted">Jury panel is currently being finalized by the organizing committee.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Right Sticky Sidebar Column -->
            <div class="detail-sidebar">
                <!-- Countdown Card -->
                <div class="sidebar-card countdown-sidebar-card">
                    <h3 class="sidebar-card-title">Event Starts In</h3>
                    <div class="countdown-timer sidebar-timer" data-countdown="${event.startDate}">
                        <div class="countdown-unit"><span>--</span><label>Days</label></div>
                        <div class="countdown-unit"><span>--</span><label>Hours</label></div>
                        <div class="countdown-unit"><span>--</span><label>Mins</label></div>
                        <div class="countdown-unit"><span>--</span><label>Secs</label></div>
                    </div>
                </div>

                <!-- Registration State Card -->
                <div class="sidebar-card registration-action-card">
                    <c:choose>
                        <c:when test="${isRegistered}">
                            <div class="registration-success-badge">
                                <div class="reg-check-icon">✓</div>
                                <h3>You're Registered!</h3>
                                <p class="reg-code-label">Ticket ID: <span class="reg-code-badge">${userRegistration.registrationCode}</span></p>
                                
                                <c:if test="${userTeam != null}">
                                    <div class="reg-team-info mt-3">
                                        <small>Team: <strong>${userTeam.name}</strong></small>
                                        <small class="team-code-pill">Code: <code>${userTeam.teamCode}</code></small>
                                    </div>
                                </c:if>

                                <div class="mt-4 flex-col gap-2">
                                    <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-primary btn-block">
                                        Open Student Dashboard
                                    </a>
                                    <a href="${pageContext.request.contextPath}/submit-project?eventId=${event.id}" class="btn btn-outline btn-block">
                                        Submit Project Links →
                                    </a>
                                </div>
                            </div>
                        </c:when>

                        <c:when test="${sessionScope.currentUser == null}">
                            <h3 class="sidebar-card-title">Join Competition</h3>
                            <p class="text-muted text-sm mb-4">Sign in with your student account to register solo or form a team.</p>
                            <a href="${pageContext.request.contextPath}/login?redirect=/event-detail?id=${event.id}" class="btn btn-primary btn-block">
                                Log In to Register
                            </a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-ghost btn-block text-center mt-2">
                                Need an account? Register here
                            </a>
                        </c:when>

                        <c:otherwise>
                            <h3 class="sidebar-card-title">Event Registration</h3>
                            
                            <c:choose>
                                <c:when test="${event.registrationOpen}">
                                    <p class="text-muted text-sm mb-4">Registration closes on <strong>${event.registrationDeadline}</strong>.</p>
                                    
                                    <!-- Registration Form -->
                                    <form action="${pageContext.request.contextPath}/register-event" method="POST" class="registration-form" id="eventRegForm">
                                        <input type="hidden" name="eventId" value="${event.id}" />

                                        <div class="form-group mb-3">
                                            <label class="form-label">Registration Mode</label>
                                            <div class="radio-pill-group">
                                                <c:if test="${event.minTeamSize == 1}">
                                                    <label class="radio-pill">
                                                        <input type="radio" name="regType" value="individual" checked onchange="toggleRegMode(this.value)" />
                                                        <span>Solo</span>
                                                    </label>
                                                </c:if>
                                                <label class="radio-pill">
                                                    <input type="radio" name="regType" value="create_team" ${event.minTeamSize > 1 ? 'checked' : ''} onchange="toggleRegMode(this.value)" />
                                                    <span>Create Team</span>
                                                </label>
                                                <label class="radio-pill">
                                                    <input type="radio" name="regType" value="join_team" onchange="toggleRegMode(this.value)" />
                                                    <span>Join Team</span>
                                                </label>
                                            </div>
                                        </div>

                                        <!-- Create Team Input -->
                                        <div class="form-group mb-3 ${event.minTeamSize > 1 ? '' : 'hidden'}" id="createTeamGroup">
                                            <label for="teamNameInput" class="form-label">Squad / Team Name</label>
                                            <input type="text" id="teamNameInput" name="teamName" placeholder="e.g. NeuralPulse Pioneers" class="form-input" />
                                            <small class="form-hint">A unique join code will be generated for your teammates.</small>
                                        </div>

                                        <!-- Join Team Input -->
                                        <div class="form-group mb-3 hidden" id="joinTeamGroup">
                                            <label for="teamCodeInput" class="form-label">Team Join Code</label>
                                            <input type="text" id="teamCodeInput" name="teamCode" placeholder="e.g. NFV2026" class="form-input text-uppercase" />
                                            <small class="form-hint">Ask your team leader for their 6-character team join code.</small>
                                        </div>

                                        <button type="submit" class="btn btn-primary btn-block btn-lg mt-4">
                                            Confirm Registration →
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-warning">
                                        <span>Registration for this event is currently closed or has reached maximum capacity.</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>

                    <!-- Capacity Gauge -->
                    <div class="capacity-box sidebar-capacity mt-5">
                        <div class="capacity-info">
                            <span>Capacity Status</span>
                            <span>${event.currentRegistrations} / ${event.maxCapacity}</span>
                        </div>
                        <div class="progress-bar-bg">
                            <div class="progress-bar-fill" style="width: ${event.capacityPercentage}%"></div>
                        </div>
                    </div>
                </div>

                <!-- Event Details Summary Card -->
                <div class="sidebar-card">
                    <h4 class="sidebar-heading">Competition Facts</h4>
                    <ul class="fact-list">
                        <li><span>Registration Deadline:</span> <strong>${event.registrationDeadline}</strong></li>
                        <li><span>Dates:</span> <strong>${event.startDate} – ${event.endDate}</strong></li>
                        <li><span>Location:</span> <strong>${event.venue}</strong></li>
                        <li><span>Jury Size:</span> <strong>${fn:length(judges)} Assigned Judges</strong></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
function toggleRegMode(mode) {
    const createGroup = document.getElementById('createTeamGroup');
    const joinGroup = document.getElementById('joinTeamGroup');
    if (!createGroup || !joinGroup) return;

    if (mode === 'create_team') {
        createGroup.classList.remove('hidden');
        joinGroup.classList.add('hidden');
    } else if (mode === 'join_team') {
        createGroup.classList.add('hidden');
        joinGroup.classList.remove('hidden');
    } else {
        createGroup.classList.add('hidden');
        joinGroup.classList.add('hidden');
    }
}
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
