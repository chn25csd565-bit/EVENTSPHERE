package com.eventsphere.controller;

import com.eventsphere.dao.EventDAO;
import com.eventsphere.dao.RegistrationDAO;
import com.eventsphere.dao.SubmissionDAO;
import com.eventsphere.dao.TeamDAO;
import com.eventsphere.model.Event;
import com.eventsphere.model.Submission;
import com.eventsphere.model.Team;
import com.eventsphere.model.User;
import com.eventsphere.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(urlPatterns = {"/submit-project"})
public class SubmissionController extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();
    private final SubmissionDAO submissionDAO = new SubmissionDAO();
    private final RegistrationDAO registrationDAO = new RegistrationDAO();
    private final TeamDAO teamDAO = new TeamDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=login_required");
            return;
        }

        int eventId = ValidationUtil.parseInt(request.getParameter("eventId"), 0);
        Event event = eventDAO.findById(eventId);
        if (event == null) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=event_not_found");
            return;
        }

        if (!registrationDAO.isRegistered(eventId, currentUser.getId())) {
            response.sendRedirect(request.getContextPath() + "/event-detail?id=" + eventId + "&error=not_registered");
            return;
        }

        Team team = teamDAO.findByEventAndUser(eventId, currentUser.getId());
        Submission submission = submissionDAO.findByEventAndTeamOrUser(eventId, team != null ? team.getId() : null, currentUser.getId());

        request.setAttribute("event", event);
        request.setAttribute("team", team);
        request.setAttribute("submission", submission);

        request.getRequestDispatcher("/WEB-INF/views/student/submit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int eventId = ValidationUtil.parseInt(request.getParameter("eventId"), 0);
        int submissionId = ValidationUtil.parseInt(request.getParameter("submissionId"), 0);
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String techStack = request.getParameter("techStack");
        String repoUrl = request.getParameter("repoUrl");
        String demoUrl = request.getParameter("demoUrl");
        String pptUrl = request.getParameter("pptUrl");
        String videoUrl = request.getParameter("videoUrl");

        if (!ValidationUtil.isNotEmpty(title) || !ValidationUtil.isNotEmpty(description) ||
            !ValidationUtil.isNotEmpty(techStack) || !ValidationUtil.isValidUrl(repoUrl)) {
            response.sendRedirect(request.getContextPath() + "/submit-project?eventId=" + eventId + "&error=missing_required_fields");
            return;
        }

        Team team = teamDAO.findByEventAndUser(eventId, currentUser.getId());

        Submission sub;
        if (submissionId > 0) {
            sub = submissionDAO.findById(submissionId);
            if (sub == null || sub.isLocked()) {
                response.sendRedirect(request.getContextPath() + "/student/dashboard?error=submission_locked");
                return;
            }
        } else {
            sub = new Submission();
            sub.setEventId(eventId);
            sub.setTeamId(team != null ? team.getId() : null);
            sub.setUserId(currentUser.getId());
        }

        sub.setTitle(title.trim());
        sub.setDescription(description.trim());
        sub.setTechStack(techStack.trim());
        sub.setRepoUrl(repoUrl.trim());
        sub.setDemoUrl(demoUrl != null ? demoUrl.trim() : "");
        sub.setPptUrl(pptUrl != null ? pptUrl.trim() : "");
        sub.setVideoUrl(videoUrl != null ? videoUrl.trim() : "");

        boolean saved = submissionDAO.saveOrUpdate(sub);
        if (saved) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?msg=submission_saved");
        } else {
            response.sendRedirect(request.getContextPath() + "/submit-project?eventId=" + eventId + "&error=save_failed");
        }
    }
}
