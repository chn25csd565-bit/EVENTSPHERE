package com.eventsphere.controller;

import com.eventsphere.dao.EventDAO;
import com.eventsphere.dao.RegistrationDAO;
import com.eventsphere.dao.TeamDAO;
import com.eventsphere.dao.UserDAO;
import com.eventsphere.model.Event;
import com.eventsphere.model.Invitation;
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

@WebServlet(urlPatterns = {"/team/invite", "/team/respond-invite", "/team/lock", "/team/remove-member"})
public class TeamController extends HttpServlet {

    private final TeamDAO teamDAO = new TeamDAO();
    private final UserDAO userDAO = new UserDAO();
    private final RegistrationDAO registrationDAO = new RegistrationDAO();
    private final EventDAO eventDAO = new EventDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        if ("/team/invite".equals(path)) {
            handleInvite(request, response, currentUser);
        } else if ("/team/respond-invite".equals(path)) {
            handleRespondInvite(request, response, currentUser);
        } else if ("/team/lock".equals(path)) {
            handleLock(request, response, currentUser);
        } else if ("/team/remove-member".equals(path)) {
            handleRemoveMember(request, response, currentUser);
        }
    }

    private void handleInvite(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        int teamId = ValidationUtil.parseInt(request.getParameter("teamId"), 0);
        String inviteeEmail = request.getParameter("email");

        Team team = teamDAO.findById(teamId);
        if (team == null || team.getLeaderId() != user.getId()) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=not_authorized");
            return;
        }

        if (team.isLocked()) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=team_is_locked");
            return;
        }

        Event event = eventDAO.findById(team.getEventId());
        if (team.getMemberCount() >= event.getMaxTeamSize()) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=max_team_capacity_reached");
            return;
        }

        if (!ValidationUtil.isValidEmail(inviteeEmail)) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=invalid_invite_email");
            return;
        }

        boolean invited = teamDAO.createInvitation(teamId, user.getId(), inviteeEmail);
        if (invited) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?msg=invite_sent");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=invite_failed");
        }
    }

    private void handleRespondInvite(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        int invitationId = ValidationUtil.parseInt(request.getParameter("invitationId"), 0);
        String action = request.getParameter("action"); // "ACCEPT" or "DECLINE"

        Invitation inv = teamDAO.findInvitationById(invitationId);
        if (inv == null || !inv.getInviteeEmail().equalsIgnoreCase(user.getEmail())) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=invalid_invitation");
            return;
        }

        if ("ACCEPT".equalsIgnoreCase(action)) {
            Team team = teamDAO.findById(inv.getTeamId());
            if (team == null || team.isLocked()) {
                response.sendRedirect(request.getContextPath() + "/student/dashboard?error=team_locked_or_missing");
                return;
            }

            teamDAO.addMember(team.getId(), user.getId(), "MEMBER");
            teamDAO.respondInvitation(invitationId, "ACCEPTED");

            // Also register the user for the event if not registered
            if (!registrationDAO.isRegistered(team.getEventId(), user.getId())) {
                String regCode = "REG-TM-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
                Registration reg = new Registration();
                reg.setEventId(team.getEventId());
                reg.setUserId(user.getId());
                reg.setTeamId(team.getId());
                reg.setRegistrationCode(regCode);
                reg.setStatus("CONFIRMED");
                registrationDAO.register(reg);
            }

            response.sendRedirect(request.getContextPath() + "/student/dashboard?msg=joined_team");
        } else {
            teamDAO.respondInvitation(invitationId, "DECLINED");
            response.sendRedirect(request.getContextPath() + "/student/dashboard?msg=invitation_declined");
        }
    }

    private void handleLock(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        int teamId = ValidationUtil.parseInt(request.getParameter("teamId"), 0);
        Team team = teamDAO.findById(teamId);

        if (team == null || team.getLeaderId() != user.getId()) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=not_authorized");
            return;
        }

        teamDAO.lockTeam(teamId);
        response.sendRedirect(request.getContextPath() + "/student/dashboard?msg=roster_locked");
    }

    private void handleRemoveMember(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        int teamId = ValidationUtil.parseInt(request.getParameter("teamId"), 0);
        int targetUserId = ValidationUtil.parseInt(request.getParameter("userId"), 0);

        Team team = teamDAO.findById(teamId);
        if (team == null || (team.getLeaderId() != user.getId() && targetUserId != user.getId())) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=not_authorized");
            return;
        }

        if (team.isLocked()) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=team_is_locked");
            return;
        }

        teamDAO.removeMember(teamId, targetUserId);
        response.sendRedirect(request.getContextPath() + "/student/dashboard?msg=member_removed");
    }
}
