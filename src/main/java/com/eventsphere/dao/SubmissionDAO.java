package com.eventsphere.dao;

import com.eventsphere.config.DBConnection;
import com.eventsphere.model.Submission;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class SubmissionDAO {

    public boolean saveOrUpdate(Submission sub) {
        if (sub.getId() > 0) {
            String sql = "UPDATE submissions SET title = ?, description = ?, tech_stack = ?, repo_url = ?, demo_url = ?, ppt_url = ?, video_url = ?, version = version + 1, updated_at = ? WHERE id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, sub.getTitle());
                ps.setString(2, sub.getDescription());
                ps.setString(3, sub.getTechStack());
                ps.setString(4, sub.getRepoUrl());
                ps.setString(5, sub.getDemoUrl());
                ps.setString(6, sub.getPptUrl());
                ps.setString(7, sub.getVideoUrl());
                ps.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
                ps.setInt(9, sub.getId());
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            String sql = "INSERT INTO submissions (event_id, team_id, user_id, title, description, tech_stack, repo_url, demo_url, ppt_url, video_url, version, is_locked) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, false)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, sub.getEventId());
                if (sub.getTeamId() != null) {
                    ps.setInt(2, sub.getTeamId());
                } else {
                    ps.setNull(2, java.sql.Types.INTEGER);
                }
                ps.setInt(3, sub.getUserId());
                ps.setString(4, sub.getTitle());
                ps.setString(5, sub.getDescription());
                ps.setString(6, sub.getTechStack());
                ps.setString(7, sub.getRepoUrl());
                ps.setString(8, sub.getDemoUrl());
                ps.setString(9, sub.getPptUrl());
                ps.setString(10, sub.getVideoUrl());

                int affected = ps.executeUpdate();
                if (affected > 0) {
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            sub.setId(rs.getInt(1));
                        }
                    }
                    return true;
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public Submission findById(int id) {
        String sql = "SELECT s.*, e.title as event_title, t.name as team_name, u.name as submitter_name, u.email as submitter_email, " +
                     "(SELECT AVG(total_weighted_score) FROM scores sc WHERE sc.submission_id = s.id AND sc.is_submitted = true) as avg_score, " +
                     "(SELECT count(*) FROM scores sc WHERE sc.submission_id = s.id AND sc.is_submitted = true) as eval_count " +
                     "FROM submissions s " +
                     "JOIN events e ON s.event_id = e.id " +
                     "LEFT JOIN teams t ON s.team_id = t.id " +
                     "JOIN users u ON s.user_id = u.id " +
                     "WHERE s.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
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

    public Submission findByEventAndTeamOrUser(int eventId, Integer teamId, int userId) {
        String sql;
        if (teamId != null && teamId > 0) {
            sql = "SELECT s.*, e.title as event_title, t.name as team_name, u.name as submitter_name, u.email as submitter_email, " +
                  "(SELECT AVG(total_weighted_score) FROM scores sc WHERE sc.submission_id = s.id AND sc.is_submitted = true) as avg_score, " +
                  "(SELECT count(*) FROM scores sc WHERE sc.submission_id = s.id AND sc.is_submitted = true) as eval_count " +
                  "FROM submissions s " +
                  "JOIN events e ON s.event_id = e.id " +
                  "LEFT JOIN teams t ON s.team_id = t.id " +
                  "JOIN users u ON s.user_id = u.id " +
                  "WHERE s.event_id = ? AND s.team_id = ?";
        } else {
            sql = "SELECT s.*, e.title as event_title, t.name as team_name, u.name as submitter_name, u.email as submitter_email, " +
                  "(SELECT AVG(total_weighted_score) FROM scores sc WHERE sc.submission_id = s.id AND sc.is_submitted = true) as avg_score, " +
                  "(SELECT count(*) FROM scores sc WHERE sc.submission_id = s.id AND sc.is_submitted = true) as eval_count " +
                  "FROM submissions s " +
                  "JOIN events e ON s.event_id = e.id " +
                  "LEFT JOIN teams t ON s.team_id = t.id " +
                  "JOIN users u ON s.user_id = u.id " +
                  "WHERE s.event_id = ? AND s.user_id = ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, (teamId != null && teamId > 0) ? teamId : userId);
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

    public List<Submission> findByEventId(int eventId) {
        List<Submission> list = new ArrayList<>();
        String sql = "SELECT s.*, e.title as event_title, t.name as team_name, u.name as submitter_name, u.email as submitter_email, " +
                     "(SELECT AVG(total_weighted_score) FROM scores sc WHERE sc.submission_id = s.id AND sc.is_submitted = true) as avg_score, " +
                     "(SELECT count(*) FROM scores sc WHERE sc.submission_id = s.id AND sc.is_submitted = true) as eval_count " +
                     "FROM submissions s " +
                     "JOIN events e ON s.event_id = e.id " +
                     "LEFT JOIN teams t ON s.team_id = t.id " +
                     "JOIN users u ON s.user_id = u.id " +
                     "WHERE s.event_id = ? ORDER BY s.submitted_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
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

    public int countSubmissions() {
        String sql = "SELECT count(*) FROM submissions";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Submission mapRow(ResultSet rs) throws SQLException {
        Submission s = new Submission();
        s.setId(rs.getInt("id"));
        s.setEventId(rs.getInt("event_id"));
        s.setTeamId((Integer) rs.getObject("team_id"));
        s.setUserId(rs.getInt("user_id"));
        s.setTitle(rs.getString("title"));
        s.setDescription(rs.getString("description"));
        s.setTechStack(rs.getString("tech_stack"));
        s.setRepoUrl(rs.getString("repo_url"));
        s.setDemoUrl(rs.getString("demo_url"));
        s.setPptUrl(rs.getString("ppt_url"));
        s.setVideoUrl(rs.getString("video_url"));
        s.setVersion(rs.getInt("version"));
        s.setLocked(rs.getBoolean("is_locked"));
        s.setSubmittedAt(rs.getTimestamp("submitted_at"));
        s.setUpdatedAt(rs.getTimestamp("updated_at"));
        s.setEventTitle(rs.getString("event_title"));
        s.setTeamName(rs.getString("team_name"));
        s.setSubmitterName(rs.getString("submitter_name"));
        s.setSubmitterEmail(rs.getString("submitter_email"));

        double avg = rs.getDouble("avg_score");
        if (!rs.wasNull()) {
            s.setAverageScore(Math.round(avg * 100.0) / 100.0);
        }
        s.setEvaluationCount(rs.getInt("eval_count"));
        return s;
    }
}
