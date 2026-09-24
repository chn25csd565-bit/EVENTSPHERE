package com.eventsphere.controller;

import com.eventsphere.dao.EventDAO;
import com.eventsphere.dao.ScoreDAO;
import com.eventsphere.model.Event;
import com.eventsphere.model.LeaderboardEntry;
import com.eventsphere.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/leaderboard"})
public class LeaderboardController extends HttpServlet {

    private final ScoreDAO scoreDAO = new ScoreDAO();
    private final EventDAO eventDAO = new EventDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String eventIdParam = request.getParameter("eventId");
        Integer selectedEventId = null;
        if (ValidationUtil.isNotEmpty(eventIdParam)) {
            int eid = ValidationUtil.parseInt(eventIdParam, 0);
            if (eid > 0) selectedEventId = eid;
        }

        List<Event> allEvents = eventDAO.findAll(null, null, null);
        List<LeaderboardEntry> leaderboard = scoreDAO.getLiveLeaderboard(selectedEventId);

        request.setAttribute("events", allEvents);
        request.setAttribute("selectedEventId", selectedEventId);
        request.setAttribute("leaderboard", leaderboard);

        request.getRequestDispatcher("/leaderboard.jsp").forward(request, response);
    }
}
