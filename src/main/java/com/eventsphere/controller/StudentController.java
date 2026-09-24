package com.eventsphere.controller;

import com.eventsphere.dao.AnnouncementDAO;
import com.eventsphere.dao.RegistrationDAO;
import com.eventsphere.dao.SubmissionDAO;
import com.eventsphere.dao.TeamDAO;
import com.eventsphere.model.Announcement;
import com.eventsphere.model.Invitation;
import com.eventsphere.model.Registration;
import com.eventsphere.model.Submission;
import com.eventsphere.model.Team;
import com.eventsphere.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/student/dashboard"})
public class StudentController extends HttpServlet {

    private final RegistrationDAO registrationDAO = new RegistrationDAO();
    private final TeamDAO teamDAO = new TeamDAO();
    private final SubmissionDAO submissionDAO = new SubmissionDAO();
    private final AnnouncementDAO announcementDAO = new AnnouncementDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=login_required");
            return;
        }

        List<Registration> registrations = registrationDAO.findByUserId(currentUser.getId());
        List<Team> teams = teamDAO.findTeamsByUserId(currentUser.getId());
        List<Invitation> invitations = teamDAO.getInvitationsForEmail(currentUser.getEmail());
        List<Announcement> announcements = announcementDAO.getRecentAnnouncements(null, 5);

        List<Submission> submissions = new ArrayList<>();
        for (Registration r : registrations) {
            Submission sub = submissionDAO.findByEventAndTeamOrUser(r.getEventId(), r.getTeamId(), currentUser.getId());
            if (sub != null) {
                submissions.add(sub);
            }
        }

        request.setAttribute("registrations", registrations);
        request.setAttribute("teams", teams);
        request.setAttribute("invitations", invitations);
        request.setAttribute("submissions", submissions);
        request.setAttribute("announcements", announcements);

        request.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(request, response);
    }
}
