package com.eventsphere.controller;

import com.eventsphere.dao.EventDAO;
import com.eventsphere.dao.JudgeDAO;
import com.eventsphere.dao.ScoreDAO;
import com.eventsphere.dao.SubmissionDAO;
import com.eventsphere.model.Event;
import com.eventsphere.model.Judge;
import com.eventsphere.model.Score;
import com.eventsphere.model.Submission;
import com.eventsphere.model.User;
import com.eventsphere.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/judge/dashboard", "/judge/evaluate", "/judge/score"})
public class JudgeController extends HttpServlet {

    private final JudgeDAO judgeDAO = new JudgeDAO();
    private final EventDAO eventDAO = new EventDAO();
    private final SubmissionDAO submissionDAO = new SubmissionDAO();
    private final ScoreDAO scoreDAO = new ScoreDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null || (!currentUser.isJudge() && !currentUser.isAdmin())) {
            response.sendRedirect(request.getContextPath() + "/login?error=judge_required");
            return;
        }

        String path = request.getServletPath();
        Judge judge = judgeDAO.getJudgeByUserId(currentUser.getId());
        if (judge == null) {
            // Fallback: create mock judge profile if admin is testing
            judge = new Judge();
            judge.setId(1);
            judge.setUserId(currentUser.getId());
            judge.setName(currentUser.getName());
            judge.setTitle("Technical Evaluator");
            judge.setOrganization("Apex Institute");
        }

        if ("/judge/dashboard".equals(path)) {
            handleDashboard(request, response, judge);
        } else if ("/judge/evaluate".equals(path)) {
            handleEvaluate(request, response, judge);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null || (!currentUser.isJudge() && !currentUser.isAdmin())) {
            response.sendRedirect(request.getContextPath() + "/login?error=judge_required");
            return;
        }

        Judge judge = judgeDAO.getJudgeByUserId(currentUser.getId());
        int judgeId = judge != null ? judge.getId() : 1;

        int submissionId = ValidationUtil.parseInt(request.getParameter("submissionId"), 0);
        double innov = ValidationUtil.parseDouble(request.getParameter("criteriaInnovation"), 0.0);
        double tech = ValidationUtil.parseDouble(request.getParameter("criteriaTechnical"), 0.0);
        double design = ValidationUtil.parseDouble(request.getParameter("criteriaDesign"), 0.0);
        double pres = ValidationUtil.parseDouble(request.getParameter("criteriaPresentation"), 0.0);
        double feas = ValidationUtil.parseDouble(request.getParameter("criteriaFeasibility"), 0.0);
        String feedback = request.getParameter("feedback");
        boolean isFinal = "true".equalsIgnoreCase(request.getParameter("isFinal"));

        Score score = new Score();
        score.setSubmissionId(submissionId);
        score.setJudgeId(judgeId);
        score.setCriteriaInnovation(innov);
        score.setCriteriaTechnical(tech);
        score.setCriteriaDesign(design);
        score.setCriteriaPresentation(pres);
        score.setCriteriaFeasibility(feas);
        score.setFeedback(feedback != null ? feedback.trim() : "");
        score.setSubmitted(isFinal);

        boolean saved = scoreDAO.saveOrUpdateScore(score);
        if (saved) {
            response.sendRedirect(request.getContextPath() + "/judge/dashboard?msg=" + (isFinal ? "score_submitted" : "draft_saved"));
        } else {
            response.sendRedirect(request.getContextPath() + "/judge/evaluate?submissionId=" + submissionId + "&error=score_failed");
        }
    }

    private void handleDashboard(HttpServletRequest request, HttpServletResponse response, Judge judge)
            throws ServletException, IOException {
        List<Event> assignedEvents = judgeDAO.findAssignedEvents(judge.getId());

        List<Submission> allSubmissions = new ArrayList<>();
        Map<Integer, Score> existingScores = new HashMap<>();

        for (Event e : assignedEvents) {
            List<Submission> subs = submissionDAO.findByEventId(e.getId());
            for (Submission s : subs) {
                allSubmissions.add(s);
                Score sc = scoreDAO.getScore(s.getId(), judge.getId());
                if (sc != null) {
                    existingScores.put(s.getId(), sc);
                }
            }
        }

        request.setAttribute("judge", judge);
        request.setAttribute("assignedEvents", assignedEvents);
        request.setAttribute("submissions", allSubmissions);
        request.setAttribute("existingScores", existingScores);

        request.getRequestDispatcher("/WEB-INF/views/judge/dashboard.jsp").forward(request, response);
    }

    private void handleEvaluate(HttpServletRequest request, HttpServletResponse response, Judge judge)
            throws ServletException, IOException {
        int submissionId = ValidationUtil.parseInt(request.getParameter("submissionId"), 0);
        Submission submission = submissionDAO.findById(submissionId);

        if (submission == null) {
            response.sendRedirect(request.getContextPath() + "/judge/dashboard?error=submission_not_found");
            return;
        }

        Score existingScore = scoreDAO.getScore(submissionId, judge.getId());

        request.setAttribute("judge", judge);
        request.setAttribute("submission", submission);
        request.setAttribute("score", existingScore);

        request.getRequestDispatcher("/WEB-INF/views/judge/evaluate.jsp").forward(request, response);
    }
}
