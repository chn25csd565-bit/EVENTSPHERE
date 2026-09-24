package com.eventsphere.dao;

import com.eventsphere.config.DBConnection;
import com.eventsphere.model.Event;
import com.eventsphere.model.Judge;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class JudgeDAO {

    public Judge getJudgeByUserId(int userId) {
        String sql = "SELECT j.*, u.name, u.email FROM judges j JOIN users u ON j.user_id = u.id WHERE j.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
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

    public Judge findById(int id) {
        String sql = "SELECT j.*, u.name, u.email FROM judges j JOIN users u ON j.user_id = u.id WHERE j.id = ?";
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

    public List<Judge> getAllJudges() {
        List<Judge> list = new ArrayList<>();
        String sql = "SELECT j.*, u.name, u.email FROM judges j JOIN users u ON j.user_id = u.id ORDER BY u.name ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Event> findAssignedEvents(int judgeId) {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT e.* FROM events e " +
                     "JOIN judge_assignments ja ON e.id = ja.event_id " +
                     "WHERE ja.judge_id = ? ORDER BY e.start_date ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, judgeId);
            try (ResultSet rs = ps.executeQuery()) {
                EventDAO eventDAO = new EventDAO();
                while (rs.next()) {
                    Event e = new Event();
                    e.setId(rs.getInt("id"));
                    e.setTitle(rs.getString("title"));
                    e.setSlug(rs.getString("slug"));
                    e.setCategory(rs.getString("category"));
                    e.setTagline(rs.getString("tagline"));
                    e.setDescription(rs.getString("description"));
                    e.setVenue(rs.getString("venue"));
                    e.setStartDate(rs.getTimestamp("start_date"));
                    e.setEndDate(rs.getTimestamp("end_date"));
                    e.setStatus(rs.getString("status"));
                    list.add(e);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Judge> getJudgesForEvent(int eventId) {
        List<Judge> list = new ArrayList<>();
        String sql = "SELECT j.*, u.name, u.email FROM judges j " +
                     "JOIN users u ON j.user_id = u.id " +
                     "JOIN judge_assignments ja ON j.id = ja.judge_id " +
                     "WHERE ja.event_id = ? ORDER BY u.name ASC";
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

    public boolean assignJudge(int judgeId, int eventId) {
        String sql = "INSERT INTO judge_assignments (judge_id, event_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, judgeId);
            ps.setInt(2, eventId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // Already assigned
            return false;
        }
    }

    public boolean unassignJudge(int judgeId, int eventId) {
        String sql = "DELETE FROM judge_assignments WHERE judge_id = ? AND event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, judgeId);
            ps.setInt(2, eventId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Judge mapRow(ResultSet rs) throws SQLException {
        Judge j = new Judge();
        j.setId(rs.getInt("id"));
        j.setUserId(rs.getInt("user_id"));
        j.setTitle(rs.getString("title"));
        j.setOrganization(rs.getString("organization"));
        j.setBio(rs.getString("bio"));
        j.setSpecialization(rs.getString("specialization"));
        j.setAvatar(rs.getString("avatar"));
        j.setName(rs.getString("name"));
        j.setEmail(rs.getString("email"));
        return j;
    }
}
