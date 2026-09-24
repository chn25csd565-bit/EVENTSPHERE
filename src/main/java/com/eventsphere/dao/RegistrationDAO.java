package com.eventsphere.dao;

import com.eventsphere.config.DBConnection;
import com.eventsphere.model.Registration;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class RegistrationDAO {

    public boolean register(Registration reg) {
        String sql = "INSERT INTO registrations (event_id, user_id, team_id, registration_code, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, reg.getEventId());
            ps.setInt(2, reg.getUserId());
            if (reg.getTeamId() != null) {
                ps.setInt(3, reg.getTeamId());
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            ps.setString(4, reg.getRegistrationCode());
            ps.setString(5, reg.getStatus() != null ? reg.getStatus() : "CONFIRMED");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        reg.setId(rs.getInt(1));
                    }
                }
                new EventDAO().incrementRegistrations(reg.getEventId());
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isRegistered(int eventId, int userId) {
        String sql = "SELECT count(*) FROM registrations WHERE event_id = ? AND user_id = ? AND status = 'CONFIRMED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Registration findByEventAndUser(int eventId, int userId) {
        String sql = "SELECT r.*, e.title as event_title, e.category as event_category, e.start_date as event_start, e.venue as event_venue, t.name as team_name " +
                     "FROM registrations r " +
                     "JOIN events e ON r.event_id = e.id " +
                     "LEFT JOIN teams t ON r.team_id = t.id " +
                     "WHERE r.event_id = ? AND r.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowWithDetails(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Registration> findByUserId(int userId) {
        List<Registration> list = new ArrayList<>();
        String sql = "SELECT r.*, e.title as event_title, e.category as event_category, e.start_date as event_start, e.venue as event_venue, t.name as team_name " +
                     "FROM registrations r " +
                     "JOIN events e ON r.event_id = e.id " +
                     "LEFT JOIN teams t ON r.team_id = t.id " +
                     "WHERE r.user_id = ? ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowWithDetails(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Registration> findByEventId(int eventId) {
        List<Registration> list = new ArrayList<>();
        String sql = "SELECT r.*, u.name as user_name, u.email as user_email, t.name as team_name " +
                     "FROM registrations r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "LEFT JOIN teams t ON r.team_id = t.id " +
                     "WHERE r.event_id = ? ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Registration reg = new Registration();
                    reg.setId(rs.getInt("id"));
                    reg.setEventId(rs.getInt("event_id"));
                    reg.setUserId(rs.getInt("user_id"));
                    reg.setTeamId((Integer) rs.getObject("team_id"));
                    reg.setRegistrationCode(rs.getString("registration_code"));
                    reg.setStatus(rs.getString("status"));
                    reg.setCreatedAt(rs.getTimestamp("created_at"));
                    reg.setUserName(rs.getString("user_name"));
                    reg.setUserEmail(rs.getString("user_email"));
                    reg.setTeamName(rs.getString("team_name"));
                    list.add(reg);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countRegistrations() {
        String sql = "SELECT count(*) FROM registrations";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Registration mapRowWithDetails(ResultSet rs) throws SQLException {
        Registration reg = new Registration();
        reg.setId(rs.getInt("id"));
        reg.setEventId(rs.getInt("event_id"));
        reg.setUserId(rs.getInt("user_id"));
        reg.setTeamId((Integer) rs.getObject("team_id"));
        reg.setRegistrationCode(rs.getString("registration_code"));
        reg.setStatus(rs.getString("status"));
        reg.setCreatedAt(rs.getTimestamp("created_at"));
        reg.setEventTitle(rs.getString("event_title"));
        reg.setEventCategory(rs.getString("event_category"));
        reg.setEventStartDate(rs.getTimestamp("event_start"));
        reg.setEventVenue(rs.getString("event_venue"));
        reg.setTeamName(rs.getString("team_name"));
        return reg;
    }
}
