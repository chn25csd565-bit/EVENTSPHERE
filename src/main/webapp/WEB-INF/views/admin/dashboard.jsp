<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Admin Command Center | EventSphere" />
<c:set var="activePage" value="admin" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />
<jsp:include page="/WEB-INF/views/common/alerts.jsp" />

<main class="page-container">
    <div class="container">
        <!-- Admin Profile Header -->
        <div class="dashboard-user-card">
            <div class="user-greeting-flex">
                <img src="${pageContext.request.contextPath}/${sessionScope.currentUser.avatar != null ? sessionScope.currentUser.avatar : 'assets/images/avatars/admin.jpg'}" 
                     alt="${sessionScope.currentUser.name}" class="dash-avatar" />
                <div class="user-greeting-meta">
                    <span class="user-role-badge role-admin">PLATFORM ADMINISTRATOR</span>
                    <h1 class="dash-greeting-name">${sessionScope.currentUser.name}</h1>
                    <p class="dash-greeting-sub">
                        <span>🏛️ ${sessionScope.currentUser.college}</span>
                        <span class="dot-separator">•</span>
                        <span>📋 ${sessionScope.currentUser.department}</span>
                        <span class="dot-separator">•</span>
                        <span>✉️ ${sessionScope.currentUser.email}</span>
                    </p>
                </div>
            </div>
            <div class="header-action-btns">
                <button type="button" class="btn btn-primary" onclick="openEventModal()">
                    + Create New Event
                </button>
                <a href="${pageContext.request.contextPath}/admin/attendance" class="btn btn-outline">
                    Check-In Desk →
                </a>
            </div>
        </div>

        <!-- Metric KPI Cards -->
        <div class="kpi-grid mt-6">
            <div class="kpi-card">
                <div class="kpi-icon">⚡</div>
                <div class="kpi-content">
                    <div class="kpi-val">${totalEvents}</div>
                    <div class="kpi-label">Active Campus Events</div>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon">👥</div>
                <div class="kpi-content">
                    <div class="kpi-val">${totalUsers}</div>
                    <div class="kpi-label">Total Registered Users</div>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon">🎟️</div>
                <div class="kpi-content">
                    <div class="kpi-val">${totalRegistrations}</div>
                    <div class="kpi-label">Confirmed Registrations</div>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon">🚀</div>
                <div class="kpi-content">
                    <div class="kpi-val">${totalSubmissions}</div>
                    <div class="kpi-label">Project Submissions</div>
                </div>
            </div>
        </div>

        <!-- Event Management Table Section -->
        <div class="portal-section-header mt-10">
            <div>
                <h2>Campus Events & Competitions</h2>
                <p class="text-muted text-sm">Full CRUD operational control over schedules, venues, prize pools, and status flags.</p>
            </div>
        </div>

        <div class="table-container mt-4">
            <div class="table-card">
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Competition</th>
                                <th>Category</th>
                                <th>Dates</th>
                                <th>Spots Filled</th>
                                <th>Status</th>
                                <th class="text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ev" items="${events}" varStatus="status">
                                <tr>
                                    <td>${ev.id}</td>
                                    <td>
                                        <strong><a href="${pageContext.request.contextPath}/event-detail?id=${ev.id}" class="text-white hover-underline">${ev.title}</a></strong>
                                        <small class="block text-muted">📍 ${ev.venue} &bull; 💰 ${ev.prizePool}</small>
                                    </td>
                                    <td><span class="badge badge-primary">${ev.category}</span></td>
                                    <td><small class="text-muted">${ev.startDate}</small></td>
                                    <td>
                                        <div class="text-sm">${ev.currentRegistrations} / ${ev.maxCapacity}</div>
                                        <div class="progress-bar-bg" style="width: 90px; height: 6px;">
                                            <div class="progress-bar-fill" style="width: ${ev.capacityPercentage}%"></div>
                                        </div>
                                    </td>
                                    <td><span class="event-status-badge status-${fn:toLowerCase(ev.status)}">${ev.status}</span></td>
                                    <td class="text-right">
                                        <div class="flex-row gap-2 justify-end">
                                            <a href="${pageContext.request.contextPath}/admin/attendance?eventId=${ev.id}" class="btn btn-xs btn-outline" title="Attendance">
                                                Attendance
                                            </a>
                                            <button type="button" class="btn btn-xs btn-primary" onclick="editEvent(${ev.id}, '${fn:escapeXml(ev.title)}', '${fn:escapeXml(ev.category)}', '${fn:escapeXml(ev.tagline)}', '${fn:escapeXml(ev.venue)}', '${fn:escapeXml(ev.prizePool)}', ${ev.minTeamSize}, ${ev.maxTeamSize}, ${ev.maxCapacity}, '${ev.status}', '${fn:escapeXml(ev.bannerImage)}')">
                                                Edit
                                            </button>
                                            <form action="${pageContext.request.contextPath}/admin/event/delete" method="POST" class="inline-form" onsubmit="return confirm('Are you sure you want to delete this event?');">
                                                <input type="hidden" name="id" value="${ev.id}" />
                                                <button type="submit" class="btn btn-xs btn-danger">Delete</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Two Column Control Grid: Judge Assignments & Broadcast Announcements -->
        <div class="portal-grid mt-10">
            <!-- Left Column: Judge Assignments -->
            <div class="portal-col">
                <div class="portal-section-header">
                    <h2>Jury Assignments</h2>
                </div>
                <div class="sidebar-card">
                    <form action="${pageContext.request.contextPath}/admin/judges/assign" method="POST">
                        <div class="form-group mb-3">
                            <label class="form-label">Select Judge</label>
                            <select name="judgeId" class="form-select" required>
                                <c:forEach var="j" items="${judges}">
                                    <option value="${j.id}">${j.name} (${j.organization})</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group mb-3">
                            <label class="form-label">Target Competition</label>
                            <select name="eventId" class="form-select" required>
                                <c:forEach var="ev" items="${events}">
                                    <option value="${ev.id}">${ev.title}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="flex-row gap-3 mt-4">
                            <button type="submit" name="action" value="assign" class="btn btn-primary btn-sm flex-1">
                                + Assign Judge
                            </button>
                            <button type="submit" name="action" value="unassign" class="btn btn-outline btn-sm">
                                Unassign
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Judges Directory Cards -->
                <div class="mt-4">
                    <h4 class="text-muted text-sm mb-2">Registered Jury Members:</h4>
                    <div class="flex-col gap-2">
                        <c:forEach var="j" items="${judges}">
                            <div class="p-3 bg-surface rounded-md border border-glass flex-row gap-3 align-center">
                                <img src="${pageContext.request.contextPath}/${j.avatar != null ? j.avatar : 'assets/images/avatars/judge1.jpg'}" alt="${j.name}" class="w-10 h-10 rounded-full" />
                                <div>
                                    <strong class="text-sm block">${j.name}</strong>
                                    <small class="text-muted">${j.title} &bull; ${j.organization}</small>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Right Column: Broadcast Campus Announcement -->
            <div class="portal-col">
                <div class="portal-section-header">
                    <h2>Broadcast Campus Announcement</h2>
                </div>
                <div class="sidebar-card">
                    <form action="${pageContext.request.contextPath}/admin/announcement/create" method="POST">
                        <div class="form-group mb-3">
                            <label class="form-label">Announcement Title <span class="text-danger">*</span></label>
                            <input type="text" name="title" required placeholder="e.g. HackSphere 2026: Mentor Discord Live" class="form-input" />
                        </div>

                        <div class="form-grid-2">
                            <div class="form-group mb-3">
                                <label class="form-label">Associated Event (Optional)</label>
                                <select name="eventId" class="form-select">
                                    <option value="0">-- Global Campus Announcement --</option>
                                    <c:forEach var="ev" items="${events}">
                                        <option value="${ev.id}">${ev.title}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group mb-3">
                                <label class="form-label">Priority Level</label>
                                <select name="priority" class="form-select">
                                    <option value="NORMAL">NORMAL</option>
                                    <option value="HIGH">HIGH (Amber Alert)</option>
                                    <option value="URGENT">URGENT (Red Banner)</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group mb-3">
                            <label class="form-label">Announcement Content <span class="text-danger">*</span></label>
                            <textarea name="content" rows="3" required placeholder="Type announcement details that will appear on homepage and dashboards..." class="form-input"></textarea>
                        </div>

                        <button type="submit" class="btn btn-primary btn-block btn-sm mt-3">
                            Broadcast Announcement 📢
                        </button>
                    </form>
                </div>

                <!-- Existing Announcements List -->
                <div class="mt-4">
                    <h4 class="text-muted text-sm mb-2">Recent Broadcasts:</h4>
                    <div class="flex-col gap-2">
                        <c:forEach var="ann" items="${announcements}">
                            <div class="p-3 bg-surface rounded-md border border-glass">
                                <div class="flex-between">
                                    <strong class="text-sm">${ann.title}</strong>
                                    <span class="ann-priority-pill">${ann.priority}</span>
                                </div>
                                <p class="text-xs text-muted mt-1">${ann.content}</p>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Event Create / Edit Modal -->
<div id="eventModal" class="lightbox-modal" onclick="closeEventModal(event)">
    <div class="modal-box-card" onclick="event.stopPropagation()">
        <div class="flex-between modal-header">
            <h2 id="modalEventTitle">Create New Event</h2>
            <button type="button" class="alert-close" onclick="closeEventModal()">&times;</button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/event/save" method="POST" id="eventForm" class="mt-4">
            <input type="hidden" name="id" id="eventIdInput" value="0" />

            <div class="form-grid-2">
                <div class="form-group mb-3">
                    <label class="form-label">Event Title <span class="text-danger">*</span></label>
                    <input type="text" name="title" id="formTitle" required class="form-input" placeholder="e.g. AI Quantum Hack 2026" />
                </div>
                <div class="form-group mb-3">
                    <label class="form-label">Category</label>
                    <select name="category" id="formCategory" class="form-select">
                        <option value="Hackathon">Hackathon</option>
                        <option value="Technical">Technical</option>
                        <option value="Workshop">Workshop</option>
                        <option value="Cultural">Cultural</option>
                        <option value="Gaming">Gaming</option>
                    </select>
                </div>
            </div>

            <div class="form-group mb-3">
                <label class="form-label">Tagline</label>
                <input type="text" name="tagline" id="formTagline" class="form-input" placeholder="Short punchy summary" />
            </div>

            <div class="form-group mb-3">
                <label class="form-label">Detailed Description</label>
                <textarea name="description" id="formDesc" rows="3" class="form-input" placeholder="Full competition details..."></textarea>
            </div>

            <div class="form-grid-2">
                <div class="form-group mb-3">
                    <label class="form-label">Venue</label>
                    <input type="text" name="venue" id="formVenue" class="form-input" placeholder="e.g. Innovation Hall B" />
                </div>
                <div class="form-group mb-3">
                    <label class="form-label">Prize Pool</label>
                    <input type="text" name="prizePool" id="formPrize" class="form-input" placeholder="e.g. $5,000" />
                </div>
            </div>

            <div class="form-grid-3">
                <div class="form-group mb-3">
                    <label class="form-label">Min Team Size</label>
                    <input type="number" name="minTeamSize" id="formMinTeam" value="1" min="1" max="10" class="form-input" />
                </div>
                <div class="form-group mb-3">
                    <label class="form-label">Max Team Size</label>
                    <input type="number" name="maxTeamSize" id="formMaxTeam" value="4" min="1" max="10" class="form-input" />
                </div>
                <div class="form-group mb-3">
                    <label class="form-label">Max Capacity</label>
                    <input type="number" name="maxCapacity" id="formCapacity" value="100" min="5" max="1000" class="form-input" />
                </div>
            </div>

            <div class="form-grid-2">
                <div class="form-group mb-3">
                    <label class="form-label">Status</label>
                    <select name="status" id="formStatus" class="form-select">
                        <option value="UPCOMING">UPCOMING</option>
                        <option value="ONGOING">ONGOING</option>
                        <option value="COMPLETED">COMPLETED</option>
                        <option value="CLOSED">CLOSED</option>
                    </select>
                </div>
                <div class="form-group mb-3">
                    <label class="form-label">Banner Image Path</label>
                    <input type="text" name="bannerImage" id="formBanner" class="form-input" placeholder="assets/images/events/hacksphere2026.jpg" />
                </div>
            </div>

            <div class="flex-between mt-6 pt-4 border-t border-glass">
                <button type="button" class="btn btn-outline" onclick="closeEventModal()">Cancel</button>
                <button type="submit" class="btn btn-primary btn-lg">Save Event Details →</button>
            </div>
        </form>
    </div>
</div>

<script>
function openEventModal() {
    document.getElementById('eventIdInput').value = '0';
    document.getElementById('modalEventTitle').textContent = 'Create New Campus Event';
    document.getElementById('eventForm').reset();
    document.getElementById('eventModal').classList.add('active');
}

function editEvent(id, title, cat, tagline, venue, prize, minT, maxT, cap, status, banner) {
    document.getElementById('eventIdInput').value = id;
    document.getElementById('modalEventTitle').textContent = 'Edit Event: ' + title;
    document.getElementById('formTitle').value = title;
    document.getElementById('formCategory').value = cat;
    document.getElementById('formTagline').value = tagline;
    document.getElementById('formVenue').value = venue;
    document.getElementById('formPrize').value = prize;
    document.getElementById('formMinTeam').value = minT;
    document.getElementById('formMaxTeam').value = maxT;
    document.getElementById('formCapacity').value = cap;
    document.getElementById('formStatus').value = status;
    document.getElementById('formBanner').value = banner;
    document.getElementById('eventModal').classList.add('active');
}

function closeEventModal(e) {
    if (!e || e.target.id === 'eventModal' || e.target.classList.contains('alert-close') || e.target.classList.contains('btn-outline')) {
        document.getElementById('eventModal').classList.remove('active');
    }
}
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
