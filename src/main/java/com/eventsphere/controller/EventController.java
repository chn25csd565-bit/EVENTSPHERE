package com.eventsphere.controller;

import com.eventsphere.dao.EventDAO;
import com.eventsphere.dao.JudgeDAO;
import com.eventsphere.dao.RegistrationDAO;
import com.eventsphere.dao.TeamDAO;
import com.eventsphere.model.Event;
import com.eventsphere.model.Judge;
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
import java.util.List;

@WebServlet(urlPatterns = {"/events", "/event-detail"})
public class EventController extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();
    private final JudgeDAO judgeDAO = new JudgeDAO();
    private final RegistrationDAO registrationDAO = new RegistrationDAO();
    private final TeamDAO teamDAO = new TeamDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/events".equals(path)) {
            handleEventList(request, response);
        } else if ("/event-detail".equals(path)) {
            handleEventDetail(request, response);
        }
    }

    private void handleEventList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String category = request.getParameter("category");
        String status = request.getParameter("status");
        String search = request.getParameter("q");

        List<Event> events = eventDAO.findAll(category, status, search);

        request.setAttribute("events", events);
        request.setAttribute("selectedCategory", category != null ? category : "ALL");
        request.setAttribute("selectedStatus", status != null ? status : "ALL");
        request.setAttribute("searchQuery", search != null ? search : "");

        request.getRequestDispatcher("/events.jsp").forward(request, response);
    }

    private void handleEventDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String slugParam = request.getParameter("slug");

        Event event = null;
        if (ValidationUtil.isNotEmpty(idParam)) {
            int id = ValidationUtil.parseInt(idParam, 0);
            if (id > 0) event = eventDAO.findById(id);
        } else if (ValidationUtil.isNotEmpty(slugParam)) {
            event = eventDAO.findBySlug(slugParam);
        }

        if (event == null) {
            response.sendRedirect(request.getContextPath() + "/events?error=event_not_found");
            return;
        }

        // Check if user is logged in and registration status
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        boolean isRegistered = false;
        Registration userRegistration = null;
        Team userTeam = null;

        if (currentUser != null) {
            isRegistered = registrationDAO.isRegistered(event.getId(), currentUser.getId());
            if (isRegistered) {
                userRegistration = registrationDAO.findByEventAndUser(event.getId(), currentUser.getId());
            }
            userTeam = teamDAO.findByEventAndUser(event.getId(), currentUser.getId());
        }

        List<Judge> judges = judgeDAO.getJudgesForEvent(event.getId());

        request.setAttribute("event", event);
        request.setAttribute("judges", judges);
        request.setAttribute("isRegistered", isRegistered);
        request.setAttribute("userRegistration", userRegistration);
        request.setAttribute("userTeam", userTeam);

        request.getRequestDispatcher("/event-detail.jsp").forward(request, response);
    }
}
