package com.eventsphere.controller;

import com.eventsphere.dao.AnnouncementDAO;
import com.eventsphere.dao.AttendanceDAO;
import com.eventsphere.dao.EventDAO;
import com.eventsphere.dao.JudgeDAO;
import com.eventsphere.dao.RegistrationDAO;
import com.eventsphere.dao.SubmissionDAO;
import com.eventsphere.dao.UserDAO;
import com.eventsphere.model.Announcement;
import com.eventsphere.model.Attendance;
import com.eventsphere.model.Event;
import com.eventsphere.model.Judge;
import com.eventsphere.model.Registration;
import com.eventsphere.model.User;
import com.eventsphere.util.DateUtil;
import com.eventsphere.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet(urlPatterns = {
    "/admin/dashboard",
    "/admin/events",
    "/admin/event/save",
    "/admin/event/delete",
    "/admin/judges/assign",
    "/admin/attendance",
    "/admin/announcement/create"
})
public class AdminController extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();
    private final UserDAO userDAO = new UserDAO();
    private final RegistrationDAO registrationDAO = new RegistrationDAO();
    private final SubmissionDAO submissionDAO = new SubmissionDAO();
    private final JudgeDAO judgeDAO = new JudgeDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final AnnouncementDAO announcementDAO = new AnnouncementDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login?error=admin_required");
            return;
        }

        String path = request.getServletPath();

        if ("/admin/dashboard".equals(path) || "/admin/events".equals(path)) {
            handleDashboard(request, response);
        } else if ("/admin/attendance".equals(path)) {
            handleAttendance(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login?error=admin_required");
            return;
        }

        String path = request.getServletPath();

        if ("/admin/event/save".equals(path)) {
            handleEventSave(request, response);
        } else if ("/admin/event/delete".equals(path)) {
            handleEventDelete(request, response);
        } else if ("/admin/judges/assign".equals(path)) {
            handleJudgeAssign(request, response);
        } else if ("/admin/attendance".equals(path)) {
            handleAttendanceToggle(request, response);
        } else if ("/admin/announcement/create".equals(path)) {
            handleAnnouncementCreate(request, response);
        }
    }

    private void handleDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Event> allEvents = eventDAO.findAll(null, null, null);
        List<Judge> allJudges = judgeDAO.getAllJudges();
        List<User> allUsers = userDAO.findAll();
        List<Announcement> announcements = announcementDAO.getRecentAnnouncements(null, 5);

        int totalEvents = eventDAO.countEvents();
        int totalUsers = userDAO.countUsers();
        int totalRegistrations = registrationDAO.countRegistrations();
        int totalSubmissions = submissionDAO.countSubmissions();

        request.setAttribute("events", allEvents);
        request.setAttribute("judges", allJudges);
        request.setAttribute("users", allUsers);
        request.setAttribute("announcements", announcements);
        request.setAttribute("totalEvents", totalEvents);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalRegistrations", totalRegistrations);
        request.setAttribute("totalSubmissions", totalSubmissions);

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    private void handleAttendance(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int eventId = ValidationUtil.parseInt(request.getParameter("eventId"), 1);
        List<Event> allEvents = eventDAO.findAll(null, null, null);
        List<Attendance> attendanceList = attendanceDAO.getAttendanceForEvent(eventId);
        List<Registration> registrations = registrationDAO.findByEventId(eventId);

        request.setAttribute("events", allEvents);
        request.setAttribute("selectedEventId", eventId);
        request.setAttribute("attendanceList", attendanceList);
        request.setAttribute("registrations", registrations);

        request.getRequestDispatcher("/WEB-INF/views/admin/attendance.jsp").forward(request, response);
    }

    private void handleEventSave(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = ValidationUtil.parseInt(request.getParameter("id"), 0);
        String title = request.getParameter("title");
        String slug = request.getParameter("slug");
        String category = request.getParameter("category");
        String tagline = request.getParameter("tagline");
        String description = request.getParameter("description");
        String rules = request.getParameter("rules");
        String schedule = request.getParameter("schedule");
        String venue = request.getParameter("venue");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String deadlineStr = request.getParameter("registrationDeadline");
        int minTeam = ValidationUtil.parseInt(request.getParameter("minTeamSize"), 1);
        int maxTeam = ValidationUtil.parseInt(request.getParameter("maxTeamSize"), 4);
        int capacity = ValidationUtil.parseInt(request.getParameter("maxCapacity"), 100);
        String prizePool = request.getParameter("prizePool");
        String bannerImage = request.getParameter("bannerImage");
        String status = request.getParameter("status");

        if (!ValidationUtil.isNotEmpty(slug) && ValidationUtil.isNotEmpty(title)) {
            slug = title.toLowerCase().replaceAll("[^a-z0-9]+", "-").replaceAll("^-|-$", "");
        }

        Event event = new Event();
        event.setId(id);
        event.setTitle(title);
        event.setSlug(slug);
        event.setCategory(category != null ? category : "Technical");
        event.setTagline(tagline != null ? tagline : "");
        event.setDescription(description != null ? description : "");
        event.setRules(rules);
        event.setSchedule(schedule);
        event.setVenue(venue != null ? venue : "Main Auditorium");

        Timestamp start = DateUtil.parseInput(startDateStr);
        Timestamp end = DateUtil.parseInput(endDateStr);
        Timestamp deadline = DateUtil.parseInput(deadlineStr);

        event.setStartDate(start != null ? start : new Timestamp(System.currentTimeMillis() + 86400000L * 7));
        event.setEndDate(end != null ? end : new Timestamp(System.currentTimeMillis() + 86400000L * 8));
        event.setRegistrationDeadline(deadline != null ? deadline : new Timestamp(System.currentTimeMillis() + 86400000L * 5));

        event.setMinTeamSize(minTeam);
        event.setMaxTeamSize(maxTeam);
        event.setMaxCapacity(capacity);
        event.setPrizePool(prizePool != null ? prizePool : "$1,000");
        event.setBannerImage(ValidationUtil.isNotEmpty(bannerImage) ? bannerImage : "assets/images/events/default.jpg");
        event.setStatus(status != null ? status : "UPCOMING");

        if (id > 0) {
            eventDAO.update(event);
        } else {
            eventDAO.create(event);
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=event_saved");
    }

    private void handleEventDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = ValidationUtil.parseInt(request.getParameter("id"), 0);
        if (id > 0) {
            eventDAO.delete(id);
        }
        response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=event_deleted");
    }

    private void handleJudgeAssign(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int judgeId = ValidationUtil.parseInt(request.getParameter("judgeId"), 0);
        int eventId = ValidationUtil.parseInt(request.getParameter("eventId"), 0);
        String action = request.getParameter("action"); // "assign" or "unassign"

        if ("unassign".equalsIgnoreCase(action)) {
            judgeDAO.unassignJudge(judgeId, eventId);
        } else {
            judgeDAO.assignJudge(judgeId, eventId);
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=judge_updated");
    }

    private void handleAttendanceToggle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int eventId = ValidationUtil.parseInt(request.getParameter("eventId"), 0);
        int userId = ValidationUtil.parseInt(request.getParameter("userId"), 0);
        String status = request.getParameter("status"); // CHECKED_IN, ABSENT, PENDING

        attendanceDAO.recordAttendance(eventId, userId, status != null ? status : "CHECKED_IN");
        response.sendRedirect(request.getContextPath() + "/admin/attendance?eventId=" + eventId + "&msg=attendance_updated");
    }

    private void handleAnnouncementCreate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int eventId = ValidationUtil.parseInt(request.getParameter("eventId"), 0);
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String priority = request.getParameter("priority");

        if (ValidationUtil.isNotEmpty(title) && ValidationUtil.isNotEmpty(content)) {
            Announcement a = new Announcement();
            a.setEventId(eventId > 0 ? eventId : null);
            a.setTitle(title.trim());
            a.setContent(content.trim());
            a.setPriority(priority != null ? priority : "NORMAL");
            announcementDAO.create(a);
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=announcement_posted");
    }
}
