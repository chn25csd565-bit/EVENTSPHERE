package com.eventsphere.dao;

import com.eventsphere.config.DBConnection;
import com.eventsphere.model.Event;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {

    public List<Event> findAll(String category, String status, String search) {
        List<Event> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM events WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category)) {
            sql.append("AND LOWER(category) = LOWER(?) ");
            params.add(category.trim());
        }

        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append("AND LOWER(status) = LOWER(?) ");
            params.add(status.trim());
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(title) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?) OR LOWER(tagline) LIKE LOWER(?)) ");
            String q = "%" + search.trim() + "%";
            params.add(q);
            params.add(q);
            params.add(q);
        }

        sql.append("ORDER BY start_date ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
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

    public Event findById(int id) {
        String sql = "SELECT * FROM events WHERE id = ?";
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

    public Event findBySlug(String slug) {
        String sql = "SELECT * FROM events WHERE LOWER(slug) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, slug.trim());
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

    public boolean create(Event event) {
        String sql = "INSERT INTO events (title, slug, category, tagline, description, rules, schedule, venue, start_date, end_date, registration_deadline, min_team_size, max_team_size, max_capacity, prize_pool, banner_image, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, event.getTitle());
            ps.setString(2, event.getSlug());
            ps.setString(3, event.getCategory());
            ps.setString(4, event.getTagline());
            ps.setString(5, event.getDescription());
            ps.setString(6, event.getRules());
            ps.setString(7, event.getSchedule());
            ps.setString(8, event.getVenue());
            ps.setTimestamp(9, event.getStartDate());
            ps.setTimestamp(10, event.getEndDate());
            ps.setTimestamp(11, event.getRegistrationDeadline());
            ps.setInt(12, event.getMinTeamSize());
            ps.setInt(13, event.getMaxTeamSize());
            ps.setInt(14, event.getMaxCapacity());
            ps.setString(15, event.getPrizePool());
            ps.setString(16, event.getBannerImage() != null ? event.getBannerImage() : "assets/images/events/default.jpg");
            ps.setString(17, event.getStatus() != null ? event.getStatus() : "UPCOMING");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        event.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Event event) {
        String sql = "UPDATE events SET title = ?, slug = ?, category = ?, tagline = ?, description = ?, rules = ?, schedule = ?, venue = ?, start_date = ?, end_date = ?, registration_deadline = ?, min_team_size = ?, max_team_size = ?, max_capacity = ?, prize_pool = ?, banner_image = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, event.getTitle());
            ps.setString(2, event.getSlug());
            ps.setString(3, event.getCategory());
            ps.setString(4, event.getTagline());
            ps.setString(5, event.getDescription());
            ps.setString(6, event.getRules());
            ps.setString(7, event.getSchedule());
            ps.setString(8, event.getVenue());
            ps.setTimestamp(9, event.getStartDate());
            ps.setTimestamp(10, event.getEndDate());
            ps.setTimestamp(11, event.getRegistrationDeadline());
            ps.setInt(12, event.getMinTeamSize());
            ps.setInt(13, event.getMaxTeamSize());
            ps.setInt(14, event.getMaxCapacity());
            ps.setString(15, event.getPrizePool());
            ps.setString(16, event.getBannerImage());
            ps.setString(17, event.getStatus());
            ps.setInt(18, event.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM events WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void incrementRegistrations(int eventId) {
        String sql = "UPDATE events SET current_registrations = current_registrations + 1 WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Event> findFeatured(int limit) {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM events WHERE status IN ('UPCOMING', 'ONGOING') ORDER BY start_date ASC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
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

    public int countEvents() {
        String sql = "SELECT count(*) FROM events";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Event mapRow(ResultSet rs) throws SQLException {
        Event e = new Event();
        e.setId(rs.getInt("id"));
        e.setTitle(rs.getString("title"));
        e.setSlug(rs.getString("slug"));
        e.setCategory(rs.getString("category"));
        e.setTagline(rs.getString("tagline"));
        e.setDescription(rs.getString("description"));
        e.setRules(rs.getString("rules"));
        e.setSchedule(rs.getString("schedule"));
        e.setVenue(rs.getString("venue"));
        e.setStartDate(rs.getTimestamp("start_date"));
        e.setEndDate(rs.getTimestamp("end_date"));
        e.setRegistrationDeadline(rs.getTimestamp("registration_deadline"));
        e.setMinTeamSize(rs.getInt("min_team_size"));
        e.setMaxTeamSize(rs.getInt("max_team_size"));
        e.setMaxCapacity(rs.getInt("max_capacity"));
        e.setCurrentRegistrations(rs.getInt("current_registrations"));
        e.setPrizePool(rs.getString("prize_pool"));
        e.setBannerImage(rs.getString("banner_image"));
        e.setStatus(rs.getString("status"));
        e.setCreatedAt(rs.getTimestamp("created_at"));
        return e;
    }
}
