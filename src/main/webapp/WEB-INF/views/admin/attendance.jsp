<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Event Attendance & Check-In Desk | EventSphere" />
<c:set var="activePage" value="attendance" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />
<jsp:include page="/WEB-INF/views/common/alerts.jsp" />

<main class="page-container">
    <div class="container">
        <!-- Page Header -->
        <div class="page-header flex-between align-center">
            <div>
                <span class="page-eyebrow">OPERATIONS DESK</span>
                <h1 class="page-title">Event Attendance & Check-In</h1>
                <p class="page-subtitle">Track real-time campus participant check-ins, barcode tickets, and physical arrivals.</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline">
                    ← Admin Console
                </a>
            </div>
        </div>

        <!-- Event Selection & Search Toolbar -->
        <div class="filter-controls-card mt-6">
            <div class="flex-between flex-wrap gap-4 align-center">
                <form action="${pageContext.request.contextPath}/admin/attendance" method="GET" class="filter-form-inline">
                    <label for="eventSelect" class="filter-select-label">Select Event:</label>
                    <select name="eventId" id="eventSelect" class="form-select" onchange="this.form.submit()">
                        <c:forEach var="ev" items="${events}">
                            <option value="${ev.id}" ${selectedEventId == ev.id ? 'selected' : ''}>${ev.title}</option>
                        </c:forEach>
                    </select>
                </form>

                <!-- Search Input for volunteers -->
                <div class="search-input-wrapper" style="max-width: 320px;">
                    <span class="search-icon">🔍</span>
                    <input type="text" id="attendeeFilterInput" placeholder="Filter by name, ticket code..." class="form-input" onkeyup="filterAttendeeTable()" />
                </div>
            </div>
        </div>

        <!-- Attendance Stats Row -->
        <c:set var="checkedCount" value="0" />
        <c:forEach var="att" items="${attendanceList}">
            <c:if test="${att.status == 'CHECKED_IN'}">
                <c:set var="checkedCount" value="${checkedCount + 1}" />
            </c:if>
        </c:forEach>

        <div class="kpi-grid mt-6">
            <div class="kpi-card">
                <div class="kpi-icon">🎟️</div>
                <div class="kpi-content">
                    <div class="kpi-val">${fn:length(registrations)}</div>
                    <div class="kpi-label">Confirmed Registrations</div>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon">✅</div>
                <div class="kpi-content">
                    <div class="kpi-val">${checkedCount}</div>
                    <div class="kpi-label">Checked-In On Site</div>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon">⏳</div>
                <div class="kpi-content">
                    <div class="kpi-val">${fn:length(registrations) - checkedCount}</div>
                    <div class="kpi-label">Pending Arrival</div>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon">📊</div>
                <div class="kpi-content">
                    <div class="kpi-val">
                        <c:choose>
                            <c:when test="${fn:length(registrations) > 0}">
                                <fmt:formatNumber value="${(checkedCount / fn:length(registrations)) * 100}" maxFractionDigits="0" />%
                            </c:when>
                            <c:otherwise>0%</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="kpi-label">Check-In Rate</div>
                </div>
            </div>
        </div>

        <!-- Participants Check-in Table -->
        <div class="table-container mt-8">
            <div class="table-card">
                <div class="table-responsive">
                    <table class="data-table" id="attendanceTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Participant</th>
                                <th>Ticket ID</th>
                                <th>Squad</th>
                                <th>Check-in Timestamp</th>
                                <th>Status</th>
                                <th class="text-right">Check-In Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty registrations}">
                                    <c:forEach var="reg" items="${registrations}" varStatus="status">
                                        <!-- Find attendance record if matched -->
                                        <c:set var="attRec" value="${null}" />
                                        <c:forEach var="a" items="${attendanceList}">
                                            <c:if test="${a.userId == reg.userId}">
                                                <c:set var="attRec" value="${a}" />
                                            </c:if>
                                        </c:forEach>

                                        <tr class="attendee-row">
                                            <td>${status.index + 1}</td>
                                            <td>
                                                <strong class="block text-white attendee-name">${reg.userName}</strong>
                                                <small class="text-muted">${reg.userEmail}</small>
                                            </td>
                                            <td>
                                                <code class="ticket-code">${reg.registrationCode}</code>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty reg.teamName}">
                                                        <span class="badge badge-outline">${reg.teamName}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Solo</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${attRec != null && attRec.checkInTime != null}">
                                                        <small class="text-muted">${attRec.checkInTime}</small>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">—</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${attRec != null && attRec.status == 'CHECKED_IN'}">
                                                        <span class="status-badge status-ongoing">✓ Checked In</span>
                                                    </c:when>
                                                    <c:when test="${attRec != null && attRec.status == 'ABSENT'}">
                                                        <span class="status-badge status-closed">Absent</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-neutral">Pending Arrival</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-right">
                                                <form action="${pageContext.request.contextPath}/admin/attendance" method="POST" class="inline-form">
                                                    <input type="hidden" name="eventId" value="${selectedEventId}" />
                                                    <input type="hidden" name="userId" value="${reg.userId}" />

                                                    <c:choose>
                                                        <c:when test="${attRec != null && attRec.status == 'CHECKED_IN'}">
                                                            <button type="submit" name="status" value="ABSENT" class="btn btn-xs btn-outline">
                                                                Mark Absent
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="submit" name="status" value="CHECKED_IN" class="btn btn-xs btn-primary">
                                                                Check In ✓
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center p-6 text-muted">
                                            No registrations recorded for this competition yet.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
function filterAttendeeTable() {
    const query = document.getElementById('attendeeFilterInput').value.toLowerCase();
    const rows = document.querySelectorAll('.attendee-row');
    rows.forEach(row => {
        const text = row.innerText.toLowerCase();
        row.style.display = text.includes(query) ? '' : 'none';
    });
}
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
