package com.eventsphere.dao;

import com.eventsphere.config.DBConnection;
import com.eventsphere.model.Announcement;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class AnnouncementDAO {

    public List<Announcement> getRecentAnnouncements(Integer eventId, int limit) {
        List<Announcement> list = new ArrayList<>();
        String sql;
        if (eventId != null && eventId > 0) {
            sql = "SELECT a.*, e.title as event_title FROM announcements a " +
                  "LEFT JOIN events e ON a.event_id = e.id " +
                  "WHERE a.event_id = ? OR a.event_id IS NULL " +
                  "ORDER BY a.created_at DESC LIMIT ?";
        } else {
            sql = "SELECT a.*, e.title as event_title FROM announcements a " +
                  "LEFT JOIN events e ON a.event_id = e.id " +
                  "ORDER BY a.created_at DESC LIMIT ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (eventId != null && eventId > 0) {
                ps.setInt(1, eventId);
                ps.setInt(2, limit);
            } else {
                ps.setInt(1, limit);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Announcement a = new Announcement();
                    a.setId(rs.getInt("id"));
                    a.setEventId((Integer) rs.getObject("event_id"));
                    a.setTitle(rs.getString("title"));
                    a.setContent(rs.getString("content"));
                    a.setPriority(rs.getString("priority"));
                    a.setCreatedAt(rs.getTimestamp("created_at"));
                    a.setEventTitle(rs.getString("event_title"));
                    list.add(a);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean create(Announcement a) {
        String sql = "INSERT INTO announcements (event_id, title, content, priority) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (a.getEventId() != null && a.getEventId() > 0) {
                ps.setInt(1, a.getEventId());
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            ps.setString(2, a.getTitle());
            ps.setString(3, a.getContent());
            ps.setString(4, a.getPriority() != null ? a.getPriority() : "NORMAL");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM announcements WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
