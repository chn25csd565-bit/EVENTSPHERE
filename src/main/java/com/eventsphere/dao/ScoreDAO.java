package com.eventsphere.dao;

import com.eventsphere.config.DBConnection;
import com.eventsphere.model.LeaderboardEntry;
import com.eventsphere.model.Score;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ScoreDAO {

    public boolean saveOrUpdateScore(Score score) {
        score.calculateTotal();

        String checkSql = "SELECT id FROM scores WHERE submission_id = ? AND judge_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setInt(1, score.getSubmissionId());
            ps.setInt(2, score.getJudgeId());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Update
                    int scoreId = rs.getInt(1);
                    String updateSql = "UPDATE scores SET criteria_innovation = ?, criteria_technical = ?, criteria_design = ?, criteria_presentation = ?, criteria_feasibility = ?, total_weighted_score = ?, feedback = ?, is_submitted = ?, submitted_at = ? WHERE id = ?";
                    try (PreparedStatement ups = conn.prepareStatement(updateSql)) {
                        ups.setDouble(1, score.getCriteriaInnovation());
                        ups.setDouble(2, score.getCriteriaTechnical());
                        ups.setDouble(3, score.getCriteriaDesign());
                        ups.setDouble(4, score.getCriteriaPresentation());
                        ups.setDouble(5, score.getCriteriaFeasibility());
                        ups.setDouble(6, score.getTotalWeightedScore());
                        ups.setString(7, score.getFeedback());
                        ups.setBoolean(8, score.isSubmitted());
                        ups.setTimestamp(9, new java.sql.Timestamp(System.currentTimeMillis()));
                        ups.setInt(10, scoreId);
                        return ups.executeUpdate() > 0;
                    }
                } else {
                    // Insert
                    String insertSql = "INSERT INTO scores (submission_id, judge_id, criteria_innovation, criteria_technical, criteria_design, criteria_presentation, criteria_feasibility, total_weighted_score, feedback, is_submitted, submitted_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement ins = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                        ins.setInt(1, score.getSubmissionId());
                        ins.setInt(2, score.getJudgeId());
                        ins.setDouble(3, score.getCriteriaInnovation());
                        ins.setDouble(4, score.getCriteriaTechnical());
                        ins.setDouble(5, score.getCriteriaDesign());
                        ins.setDouble(6, score.getCriteriaPresentation());
                        ins.setDouble(7, score.getCriteriaFeasibility());
                        ins.setDouble(8, score.getTotalWeightedScore());
                        ins.setString(9, score.getFeedback());
                        ins.setBoolean(10, score.isSubmitted());
                        ins.setTimestamp(11, new java.sql.Timestamp(System.currentTimeMillis()));

                        int affected = ins.executeUpdate();
                        if (affected > 0) {
                            try (ResultSet gen = ins.getGeneratedKeys()) {
                                if (gen.next()) score.setId(gen.getInt(1));
                            }
                            return true;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Score getScore(int submissionId, int judgeId) {
        String sql = "SELECT sc.*, u.name as judge_name, j.organization as judge_org, s.title as submission_title, t.name as team_name " +
                     "FROM scores sc " +
                     "JOIN judges j ON sc.judge_id = j.id " +
                     "JOIN users u ON j.user_id = u.id " +
                     "JOIN submissions s ON sc.submission_id = s.id " +
                     "LEFT JOIN teams t ON s.team_id = t.id " +
                     "WHERE sc.submission_id = ? AND sc.judge_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, submissionId);
            ps.setInt(2, judgeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Score> getScoresForSubmission(int submissionId) {
        List<Score> list = new ArrayList<>();
        String sql = "SELECT sc.*, u.name as judge_name, j.organization as judge_org, s.title as submission_title, t.name as team_name " +
                     "FROM scores sc " +
                     "JOIN judges j ON sc.judge_id = j.id " +
                     "JOIN users u ON j.user_id = u.id " +
                     "JOIN submissions s ON sc.submission_id = s.id " +
                     "LEFT JOIN teams t ON s.team_id = t.id " +
                     "WHERE sc.submission_id = ? AND sc.is_submitted = true ORDER BY sc.total_weighted_score DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, submissionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<LeaderboardEntry> getLiveLeaderboard(Integer eventId) {
        List<LeaderboardEntry> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT s.id as submission_id, s.title as project_title, COALESCE(t.name, u.name) as team_name, " +
            "s.event_id, e.title as event_title, s.tech_stack, s.repo_url, s.demo_url, " +
            "AVG(sc.criteria_innovation) as avg_innov, " +
            "AVG(sc.criteria_technical) as avg_tech, " +
            "AVG(sc.criteria_design) as avg_des, " +
            "AVG(sc.criteria_presentation) as avg_pres, " +
            "AVG(sc.criteria_feasibility) as avg_feas, " +
            "AVG(sc.total_weighted_score) as final_score, " +
            "COUNT(sc.id) as judge_count " +
            "FROM submissions s " +
            "JOIN events e ON s.event_id = e.id " +
            "LEFT JOIN teams t ON s.team_id = t.id " +
            "JOIN users u ON s.user_id = u.id " +
            "JOIN scores sc ON s.id = sc.submission_id AND sc.is_submitted = true "
        );

        if (eventId != null && eventId > 0) {
            sql.append("WHERE s.event_id = ? ");
        }

        sql.append("GROUP BY s.id, s.title, t.name, u.name, s.event_id, e.title, s.tech_stack, s.repo_url, s.demo_url ");
        sql.append("ORDER BY final_score DESC, avg_tech DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (eventId != null && eventId > 0) {
                ps.setInt(1, eventId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                int rank = 1;
                while (rs.next()) {
                    LeaderboardEntry entry = new LeaderboardEntry();
                    entry.setRank(rank++);
                    entry.setSubmissionId(rs.getInt("submission_id"));
                    entry.setProjectTitle(rs.getString("project_title"));
                    entry.setTeamName(rs.getString("team_name"));
                    entry.setEventId(rs.getInt("event_id"));
                    entry.setEventTitle(rs.getString("event_title"));
                    entry.setTechStack(rs.getString("tech_stack"));
                    entry.setRepoUrl(rs.getString("repo_url"));
                    entry.setDemoUrl(rs.getString("demo_url"));

                    entry.setAvgInnovation(Math.round(rs.getDouble("avg_innov") * 100.0) / 100.0);
                    entry.setAvgTechnical(Math.round(rs.getDouble("avg_tech") * 100.0) / 100.0);
                    entry.setAvgDesign(Math.round(rs.getDouble("avg_des") * 100.0) / 100.0);
                    entry.setAvgPresentation(Math.round(rs.getDouble("avg_pres") * 100.0) / 100.0);
                    entry.setAvgFeasibility(Math.round(rs.getDouble("avg_feas") * 100.0) / 100.0);
                    entry.setFinalScore(Math.round(rs.getDouble("final_score") * 100.0) / 100.0);
                    entry.setJudgeCount(rs.getInt("judge_count"));

                    list.add(entry);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Score mapRow(ResultSet rs) throws SQLException {
        Score sc = new Score();
        sc.setId(rs.getInt("id"));
        sc.setSubmissionId(rs.getInt("submission_id"));
        sc.setJudgeId(rs.getInt("judge_id"));
        sc.setCriteriaInnovation(rs.getDouble("criteria_innovation"));
        sc.setCriteriaTechnical(rs.getDouble("criteria_technical"));
        sc.setCriteriaDesign(rs.getDouble("criteria_design"));
        sc.setCriteriaPresentation(rs.getDouble("criteria_presentation"));
        sc.setCriteriaFeasibility(rs.getDouble("criteria_feasibility"));
        sc.setTotalWeightedScore(rs.getDouble("total_weighted_score"));
        sc.setFeedback(rs.getString("feedback"));
        sc.setSubmitted(rs.getBoolean("is_submitted"));
        sc.setSubmittedAt(rs.getTimestamp("submitted_at"));
        sc.setJudgeName(rs.getString("judge_name"));
        sc.setJudgeOrganization(rs.getString("judge_org"));
        sc.setSubmissionTitle(rs.getString("submission_title"));
        sc.setTeamName(rs.getString("team_name"));
        return sc;
    }
}
