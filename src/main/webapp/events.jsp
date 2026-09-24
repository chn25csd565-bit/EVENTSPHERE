<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Discover Events & Hackathons | EventSphere" />
<c:set var="activePage" value="events" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />
<jsp:include page="/WEB-INF/views/common/alerts.jsp" />

<main class="page-container">
    <div class="container">
        <!-- Page Title & Subtitle -->
        <div class="page-header text-center">
            <span class="page-eyebrow">CAMPUS ARENA</span>
            <h1 class="page-title">Explore Events & Hackathons</h1>
            <p class="page-subtitle">Find your next competitive challenge, form multi-disciplinary squads, and pitch to leading tech juries.</p>
        </div>

        <!-- Filter & Search Controls Bar -->
        <div class="filter-controls-card">
            <!-- Search Form -->
            <form action="${pageContext.request.contextPath}/events" method="GET" class="search-form">
                <div class="search-input-wrapper">
                    <span class="search-icon">🔍</span>
                    <input type="text" name="q" value="${fn:escapeXml(searchQuery)}" placeholder="Search by title, technology, or keywords..." class="form-input search-input" id="eventSearchInput" />
                    <c:if test="${not empty searchQuery}">
                        <a href="${pageContext.request.contextPath}/events" class="search-clear-btn" title="Clear search">&times;</a>
                    </c:if>
                </div>
                <button type="submit" class="btn btn-primary btn-sm">Search</button>
            </form>

            <!-- Category Pills Filter -->
            <div class="filter-pills-row">
                <span class="filter-label">Category:</span>
                <div class="pills-group">
                    <a href="${pageContext.request.contextPath}/events?category=ALL&status=${selectedStatus}&q=${searchQuery}" 
                       class="filter-pill ${selectedCategory == 'ALL' ? 'active' : ''}">All</a>
                    <a href="${pageContext.request.contextPath}/events?category=Hackathon&status=${selectedStatus}&q=${searchQuery}" 
                       class="filter-pill ${selectedCategory == 'Hackathon' ? 'active' : ''}">Hackathons</a>
                    <a href="${pageContext.request.contextPath}/events?category=Technical&status=${selectedStatus}&q=${searchQuery}" 
                       class="filter-pill ${selectedCategory == 'Technical' ? 'active' : ''}">Technical</a>
                    <a href="${pageContext.request.contextPath}/events?category=Workshop&status=${selectedStatus}&q=${searchQuery}" 
                       class="filter-pill ${selectedCategory == 'Workshop' ? 'active' : ''}">Workshops</a>
                    <a href="${pageContext.request.contextPath}/events?category=Cultural&status=${selectedStatus}&q=${searchQuery}" 
                       class="filter-pill ${selectedCategory == 'Cultural' ? 'active' : ''}">Cultural</a>
                </div>
            </div>

            <!-- Status Tabs Filter -->
            <div class="filter-status-row">
                <span class="filter-label">Status:</span>
                <div class="status-tabs-group">
                    <a href="${pageContext.request.contextPath}/events?category=${selectedCategory}&status=ALL&q=${searchQuery}" 
                       class="status-tab ${selectedStatus == 'ALL' ? 'active' : ''}">All Statuses</a>
                    <a href="${pageContext.request.contextPath}/events?category=${selectedCategory}&status=UPCOMING&q=${searchQuery}" 
                       class="status-tab ${selectedStatus == 'UPCOMING' ? 'active' : ''}">Upcoming</a>
                    <a href="${pageContext.request.contextPath}/events?category=${selectedCategory}&status=ONGOING&q=${searchQuery}" 
                       class="status-tab ${selectedStatus == 'ONGOING' ? 'active' : ''}">Ongoing</a>
                </div>
            </div>
        </div>

        <!-- Events Grid -->
        <c:choose>
            <c:when test="${not empty events}">
                <div class="events-grid mt-8" id="eventsGrid">
                    <c:forEach var="ev" items="${events}">
                        <div class="event-card event-item" data-title="${fn:toLowerCase(ev.title)}" data-category="${fn:toLowerCase(ev.category)}">
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

                                <!-- Capacity Progress Bar -->
                                <div class="capacity-box">
                                    <div class="capacity-info">
                                        <span>Capacity</span>
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
                                    <a href="${pageContext.request.contextPath}/event-detail?id=${ev.id}" class="btn btn-primary btn-sm">
                                        View & Register →
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state-card text-center mt-8">
                    <div class="empty-icon">📂</div>
                    <h3>No Events Match Your Filters</h3>
                    <p>Try modifying your keyword query or switching category filters.</p>
                    <a href="${pageContext.request.contextPath}/events" class="btn btn-outline btn-sm mt-4">Reset All Filters</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
