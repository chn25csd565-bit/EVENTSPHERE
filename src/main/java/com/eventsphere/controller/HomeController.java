package com.eventsphere.controller;

import com.eventsphere.dao.AnnouncementDAO;
import com.eventsphere.dao.EventDAO;
import com.eventsphere.dao.PreviousEventDAO;
import com.eventsphere.dao.RegistrationDAO;
import com.eventsphere.dao.UserDAO;
import com.eventsphere.model.Announcement;
import com.eventsphere.model.Event;
import com.eventsphere.model.EventPhoto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"", "/home"})
public class HomeController extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();
    private final AnnouncementDAO announcementDAO = new AnnouncementDAO();
    private final PreviousEventDAO previousEventDAO = new PreviousEventDAO();
    private final UserDAO userDAO = new UserDAO();
    private final RegistrationDAO registrationDAO = new RegistrationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Event> featuredEvents = eventDAO.findFeatured(4);
        List<Announcement> announcements = announcementDAO.getRecentAnnouncements(null, 3);
        List<EventPhoto> moments = previousEventDAO.getFeaturedMoments(6);

        int totalStudents = userDAO.countStudents();
        int totalEvents = eventDAO.countEvents();
        int totalRegistrations = registrationDAO.countRegistrations();

        request.setAttribute("featuredEvents", featuredEvents);
        request.setAttribute("announcements", announcements);
        request.setAttribute("moments", moments);
        request.setAttribute("totalStudents", totalStudents > 0 ? totalStudents : 8);
        request.setAttribute("totalEvents", totalEvents > 0 ? totalEvents : 6);
        request.setAttribute("totalRegistrations", totalRegistrations > 0 ? totalRegistrations : 6);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
