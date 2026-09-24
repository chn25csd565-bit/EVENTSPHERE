<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<footer class="footer">
    <div class="footer-top">
        <div class="footer-grid">
            <!-- Brand Column -->
            <div class="footer-col brand-col">
                <a href="${pageContext.request.contextPath}/home" class="footer-logo">
                    <span class="logo-icon">✦</span>
                    <span>EVENT<span class="text-gradient">SPHERE</span></span>
                </a>
                <p class="footer-desc">
                    The next-generation college hackathon and event management engine. Fueling student builder culture, real-time rubric evaluations, and transparent competitive leaderboards.
                </p>
                <div class="footer-tech-stack">
                    <span class="tech-badge">Java 17</span>
                    <span class="tech-badge">Jakarta Servlet 6.0</span>
                    <span class="tech-badge">Tomcat 10</span>
                    <span class="tech-badge">Vanilla CSS & JS</span>
                </div>
            </div>

            <!-- Navigation Column -->
            <div class="footer-col">
                <h4 class="footer-heading">Platform Explore</h4>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/home">Home Overview</a></li>
                    <li><a href="${pageContext.request.contextPath}/events">Upcoming Events & Hackathons</a></li>
                    <li><a href="${pageContext.request.contextPath}/previous-events">2023–2025 Flagship Showcase</a></li>
                    <li><a href="${pageContext.request.contextPath}/leaderboard">Live Calculated Leaderboard</a></li>
                </ul>
            </div>

            <!-- Quick Portals Column -->
            <div class="footer-col">
                <h4 class="footer-heading">User Portals</h4>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/student/dashboard">Student Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/judge/dashboard">Jury Evaluation Portal</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard">Admin Management Console</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/attendance">Event Check-In Desk</a></li>
                </ul>
            </div>

            <!-- Demo Access Column -->
            <div class="footer-col">
                <h4 class="footer-heading">Instant Demo Accounts</h4>
                <div class="demo-account-list">
                    <div class="demo-acc-item">
                        <span class="demo-role admin">ADMIN</span>
                        <code>admin@eventsphere.edu</code>
                    </div>
                    <div class="demo-acc-item">
                        <span class="demo-role judge">JUDGE</span>
                        <code>judge.alan@eventsphere.edu</code>
                    </div>
                    <div class="demo-acc-item">
                        <span class="demo-role student">STUDENT</span>
                        <code>alex.chen@student.edu</code>
                    </div>
                    <small class="demo-hint">Default Pass: <code>Admin@123</code> / <code>Judge@123</code> / <code>Student@123</code></small>
                </div>
            </div>
        </div>
    </div>

    <div class="footer-bottom">
        <div class="footer-bottom-container">
            <p>&copy; 2026 EventSphere Platform. Built for collegiate innovation.</p>
            <div class="footer-bottom-links">
                <a href="#privacy">Terms of Service</a>
                <span class="dot-separator">•</span>
                <a href="#code-of-conduct">Code of Conduct</a>
                <span class="dot-separator">•</span>
                <a href="#support">Campus Support Desk</a>
            </div>
        </div>
    </div>
</footer>

<!-- Lightbox Modal for Photo Gallery (Universal) -->
<div id="imageLightboxModal" class="lightbox-modal" onclick="closeLightbox(event)">
    <span class="lightbox-close" onclick="closeLightbox(event)">&times;</span>
    <div class="lightbox-content-box" onclick="event.stopPropagation()">
        <img id="lightboxImg" src="" alt="Gallery Preview" class="lightbox-image" />
        <div class="lightbox-meta">
            <span id="lightboxTag" class="badge badge-primary"></span>
            <p id="lightboxCaption" class="lightbox-caption-text"></p>
        </div>
    </div>
</div>

<!-- Main Interactive JavaScript -->
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
