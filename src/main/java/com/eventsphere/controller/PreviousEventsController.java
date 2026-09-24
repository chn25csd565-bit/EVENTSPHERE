package com.eventsphere.controller;

import com.eventsphere.dao.PreviousEventDAO;
import com.eventsphere.model.EventPhoto;
import com.eventsphere.model.PreviousEvent;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/previous-events"})
public class PreviousEventsController extends HttpServlet {

    private final PreviousEventDAO previousEventDAO = new PreviousEventDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String category = request.getParameter("category");
        List<PreviousEvent> previousEvents = previousEventDAO.findAll();
        List<EventPhoto> photos = previousEventDAO.getAllPhotos(category);

        request.setAttribute("previousEvents", previousEvents);
        request.setAttribute("photos", photos);
        request.setAttribute("selectedCategory", category != null ? category : "ALL");

        request.getRequestDispatcher("/previous-events.jsp").forward(request, response);
    }
}
