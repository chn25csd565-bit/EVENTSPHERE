<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="EventSphere | One Platform. Every College Event." />
<c:set var="activePage" value="home" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />
<jsp:include page="/WEB-INF/views/common/alerts.jsp" />

<!-- Hero Section -->
<section class="hero-section">
    <div class="hero-glow-blob blob-1"></div>
    <div class="hero-glow-blob blob-2"></div>

    <div class="container hero-content">
        <div class="hero-badge animate-fade-down">
            <span class="badge-dot"></span>
            <span>2026 Collegiate Innovation & Hackathon Season</span>
        </div>

        <h1 class="hero-title animate-fade-up">
            One Platform.<br>
            <span class="text-gradient">Every College Event.</span>
        </h1>

        <p class="hero-description animate-fade-up delay-1">
            Discover premier collegiate hackathons, algorithmic tournaments, and creative design sprints. Form teams, submit multi-modal prototypes, and track live rubric-calculated leaderboards in real time.
        </p>

        <!-- Flagship Hackathon Countdown Card -->
        <div class="hero-countdown-card animate-fade-up delay-2">
            <div class="countdown-header">
                <span class="pulse-indicator"></span>
                <span class="countdown-title">Next Flagship Sprint: <strong>HackSphere 2026</strong></span>
            </div>
            <div class="countdown-timer" data-countdown="2026-10-15T09:00:00">
                <div class="countdown-unit"><span>--</span><label>Days</label></div>
                <div class="countdown-unit"><span>--</span><label>Hours</label></div>
                <div class="countdown-unit"><span>--</span><label>Mins</label></div>
                <div class="countdown-unit"><span>--</span><label>Secs</label></div>
            </div>
        </div>

        <!-- Call to Action Buttons -->
        <div class="hero-actions animate-fade-up delay-3">
            <a href="${pageContext.request.contextPath}/events" class="btn btn-primary btn-lg">
                <span>Explore Events</span>
                <span class="btn-arrow">→</span>
            </a>
            <a href="${pageContext.request.contextPath}/previous-events" class="btn btn-outline btn-lg">
                <span>Showcase (2023–2025)</span>
            </a>
            <a href="${pageContext.request.contextPath}/leaderboard" class="btn btn-ghost btn-lg">
                <span>Live Leaderboard</span>
            </a>
        </div>

        <!-- Live Platform Stats Grid -->
        <div class="hero-stats-grid animate-fade-up delay-4">
            <div class="stat-card">
                <div class="stat-icon">👥</div>
                <div class="stat-value">${totalStudents}+</div>
                <div class="stat-label">Active Builders</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">⚡</div>
                <div class="stat-value">${totalEvents}</div>
                <div class="stat-label">Campus Events</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🎟️</div>
                <div class="stat-value">${totalRegistrations}+</div>
                <div class="stat-label">Registrations Issued</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🏆</div>
                <div class="stat-value">$30,000+</div>
                <div class="stat-label">Prize Pool Distributed</div>
            </div>
        </div>
    </div>
</section>

<!-- Announcements Ticker -->
<c:if test="${not empty announcements}">
    <section class="announcements-bar-section">
        <div class="container announcements-wrapper">
            <div class="announcement-tag">
                <span class="flash-icon">📢</span> Updates
            </div>
            <div class="announcement-items">
                <c:forEach var="ann" items="${announcements}">
                    <div class="announcement-item priority-${fn:toLowerCase(ann.priority)}">
                        <span class="ann-priority-pill">${ann.priority}</span>
                        <span class="ann-title"><strong>${ann.title}:</strong> ${ann.content}</span>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>
</c:if>

<!-- Featured Events Grid -->
<section class="section featured-events-section">
    <div class="container">
        <div class="section-header">
            <div class="section-eyebrow">COMPETE & INNOVATE</div>
            <h2 class="section-title">Featured Competitions & Workshops</h2>
            <p class="section-subtitle">Jump into active registrations, form squads, and prepare your project pitch.</p>
        </div>

        <div class="events-grid">
            <c:forEach var="ev" items="${featuredEvents}">
                <div class="event-card">
                    <div class="event-card-banner">
                        <img src="${pageContext.request.contextPath}/${ev.bannerImage}" alt="${ev.title}" loading="lazy" />
                        <span class="event-card-category">${ev.category}</span>
                        <span class="event-status-badge status-${fn:toLowerCase(ev.status)}">${ev.status}</span>
                    </div>

                    <div class="event-card-body">
                        <div class="event-card-meta">
                            <span class="meta-item">📍 ${ev.venue}</span>
                            <span class="meta-item prize-tag">💰 ${ev.prizePool}</span>
                        </div>

                        <h3 class="event-card-title">
                            <a href="${pageContext.request.contextPath}/event-detail?id=${ev.id}">${ev.title}</a>
                        </h3>
                        <p class="event-card-tagline">${ev.tagline}</p>

                        <!-- Capacity Bar -->
                        <div class="capacity-box">
                            <div class="capacity-info">
                                <span>Spots Filled</span>
                                <span>${ev.currentRegistrations} / ${ev.maxCapacity} (${ev.capacityPercentage}%)</span>
                            </div>
                            <div class="progress-bar-bg">
                                <div class="progress-bar-fill" style="width: ${ev.capacityPercentage}%"></div>
                            </div>
                        </div>

                        <!-- Card Footer -->
                        <div class="event-card-footer">
                            <div class="team-size-info">
                                <span class="team-icon">👥</span>
                                <c:choose>
                                    <c:when test="${ev.minTeamSize == ev.maxTeamSize}">
                                        ${ev.minTeamSize == 1 ? 'Solo Entry' : ev.minTeamSize.toString().concat(' Members')}
                                    </c:when>
                                    <c:otherwise>
                                        ${ev.minTeamSize} – ${ev.maxTeamSize} Members
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <a href="${pageContext.request.contextPath}/event-detail?id=${ev.id}" class="btn btn-outline btn-sm">
                                View Details →
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div class="text-center mt-8">
            <a href="${pageContext.request.contextPath}/events" class="btn btn-primary btn-md">
                Browse All 6 Campus Events →
            </a>
        </div>
    </div>
</section>

<!-- Moments That Made It - Showcase Teaser -->
<section class="section showcase-teaser-section">
    <div class="container">
        <div class="section-header">
            <div class="section-eyebrow">LEGACY & CULTURE</div>
            <h2 class="section-title">Moments That Made It (2023–2025)</h2>
            <p class="section-subtitle">Take a look through collegiate memories, winning prototypes, and celebratory gala nights.</p>
        </div>

        <div class="moments-grid">
            <c:forEach var="photo" items="${moments}">
                <div class="moment-card" 
                     onclick="openLightbox('${pageContext.request.contextPath}/${photo.photoUrl}', '${fn:escapeXml(photo.caption)}', '${photo.category}')">
                    <img src="${pageContext.request.contextPath}/${photo.photoUrl}" alt="${photo.caption}" loading="lazy" />
                    <div class="moment-overlay">
                        <span class="badge badge-primary">${photo.category}</span>
                        <p class="moment-caption">${photo.caption}</p>
                        <span class="moment-zoom-hint">🔍 Expand Photo</span>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div class="text-center mt-8">
            <a href="${pageContext.request.contextPath}/previous-events" class="btn btn-outline btn-md">
                View Full Showcase & Hall of Fame →
            </a>
        </div>
    </div>
</section>

<!-- Platform Architecture Pillars -->
<section class="section platform-pillars-section">
    <div class="container">
        <div class="section-header">
            <div class="section-eyebrow">BUILT FOR SPEED & INTEGRITY</div>
            <h2 class="section-title">Designed for Modern College Builders</h2>
            <p class="section-subtitle">Zero bloated dependencies. Pure Jakarta Servlet MVC architecture for lightning-fast performance.</p>
        </div>

        <div class="pillars-grid">
            <div class="pillar-card">
                <div class="pillar-icon">⚡</div>
                <h3>Dynamic Squad Formation</h3>
                <p>Generate secure team join codes, invite peers via student email, and lock rosters before final submission.</p>
            </div>
            <div class="pillar-card">
                <div class="pillar-icon">⚖️</div>
                <h3>5-Criteria Rubric Judging</h3>
                <p>Jury members evaluate innovation, technical complexity, UX, presentation, and feasibility with weighted live scores.</p>
            </div>
            <div class="pillar-card">
                <div class="pillar-icon">🏅</div>
                <h3>Calculated Live Leaderboard</h3>
                <p>Automated SQL aggregation computes transparent weighted averages across multi-judge panels with podium rankings.</p>
            </div>
            <div class="pillar-card">
                <div class="pillar-icon">🛡️</div>
                <h3>Resilient Dual-Mode DB</h3>
                <p>Autonomous failover between enterprise MySQL and embedded H2 database ensures zero disruption during demos.</p>
            </div>
        </div>
    </div>
</section>

<!-- Final Call to Action -->
<section class="section cta-banner-section">
    <div class="container">
        <div class="cta-banner-card">
            <div class="cta-content">
                <h2>Ready to Showcase Your Next Big Build?</h2>
                <p>Register with your university credentials today and claim your spot in HackSphere 2026.</p>
                <div class="cta-buttons">
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-lg">Create Student Account</a>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline btn-lg">Sign In with Demo Role</a>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
