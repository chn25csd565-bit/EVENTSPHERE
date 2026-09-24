package com.eventsphere.controller;

import com.eventsphere.dao.EventDAO;
import com.eventsphere.dao.RegistrationDAO;
import com.eventsphere.dao.TeamDAO;
import com.eventsphere.model.Event;
import com.eventsphere.model.Registration;
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
import java.util.UUID;

@WebServlet(urlPatterns = {"/register-event", "/cancel-registration"})
public class RegistrationController extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();
    private final RegistrationDAO registrationDAO = new RegistrationDAO();
    private final TeamDAO teamDAO = new TeamDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            String eventIdParam = request.getParameter("eventId");
            response.sendRedirect(request.getContextPath() + "/login?error=login_required&redirect=/event-detail?id=" + eventIdParam);
            return;
        }

        String path = request.getServletPath();
        if ("/register-event".equals(path)) {
            handleEventRegistration(request, response, currentUser);
        }
    }

    private void handleEventRegistration(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        int eventId = ValidationUtil.parseInt(request.getParameter("eventId"), 0);
        Event event = eventDAO.findById(eventId);

        if (event == null) {
            response.sendRedirect(request.getContextPath() + "/events?error=event_not_found");
            return;
        }

        if (!event.isRegistrationOpen()) {
            response.sendRedirect(request.getContextPath() + "/event-detail?id=" + eventId + "&error=registration_closed");
            return;
        }

        if (registrationDAO.isRegistered(eventId, user.getId())) {
            response.sendRedirect(request.getContextPath() + "/event-detail?id=" + eventId + "&error=already_registered");
            return;
        }

        String regType = request.getParameter("regType"); // "individual", "create_team", "join_team"
        Integer teamId = null;

        if ("create_team".equalsIgnoreCase(regType)) {
            String teamName = request.getParameter("teamName");
            if (!ValidationUtil.isNotEmpty(teamName)) {
                response.sendRedirect(request.getContextPath() + "/event-detail?id=" + eventId + "&error=team_name_required");
                return;
            }
            String teamCode = ("TM-" + UUID.randomUUID().toString().substring(0, 6)).toUpperCase();
            Team newTeam = new Team();
            newTeam.setEventId(eventId);
            newTeam.setName(teamName.trim());
            newTeam.setTeamCode(teamCode);
            newTeam.setLeaderId(user.getId());

            boolean teamCreated = teamDAO.createTeam(newTeam, user.getId());
            if (teamCreated) {
                teamId = newTeam.getId();
            }
        } else if ("join_team".equalsIgnoreCase(regType)) {
            String joinCode = request.getParameter("teamCode");
            if (!ValidationUtil.isNotEmpty(joinCode)) {
                response.sendRedirect(request.getContextPath() + "/event-detail?id=" + eventId + "&error=team_code_required");
                return;
            }
            Team existingTeam = teamDAO.findByCode(joinCode.trim());
            if (existingTeam == null || existingTeam.getEventId() != eventId) {
                response.sendRedirect(request.getContextPath() + "/event-detail?id=" + eventId + "&error=invalid_team_code");
                return;
            }
            if (existingTeam.isLocked()) {
                response.sendRedirect(request.getContextPath() + "/event-detail?id=" + eventId + "&error=team_locked");
                return;
            }
            if (existingTeam.getMemberCount() >= event.getMaxTeamSize()) {
                response.sendRedirect(request.getContextPath() + "/event-detail?id=" + eventId + "&error=team_full");
                return;
            }
            teamDAO.addMember(existingTeam.getId(), user.getId(), "MEMBER");
            teamId = existingTeam.getId();
        }

        // Generate unique registration code
        String prefix = event.getSlug().length() > 4 ? event.getSlug().substring(0, 4).toUpperCase() : "EVT";
        String regCode = "REG-" + prefix + "-" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();

        Registration reg = new Registration();
        reg.setEventId(eventId);
        reg.setUserId(user.getId());
        reg.setTeamId(teamId);
        reg.setRegistrationCode(regCode);
        reg.setStatus("CONFIRMED");

        boolean success = registrationDAO.register(reg);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?registered=1&code=" + regCode);
        } else {
            response.sendRedirect(request.getContextPath() + "/event-detail?id=" + eventId + "&error=registration_failed");
        }
    }
}
