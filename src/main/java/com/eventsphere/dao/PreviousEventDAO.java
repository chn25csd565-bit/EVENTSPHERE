package com.eventsphere.dao;

import com.eventsphere.config.DBConnection;
import com.eventsphere.model.EventPhoto;
import com.eventsphere.model.PreviousEvent;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class PreviousEventDAO {

    public List<PreviousEvent> findAll() {
        List<PreviousEvent> list = new ArrayList<>();
        String sql = "SELECT * FROM previous_events ORDER BY event_year DESC, id ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                PreviousEvent pe = mapRow(rs);
                pe.setPhotos(getPhotosByEvent(pe.getId()));
                list.add(pe);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public PreviousEvent findById(int id) {
        String sql = "SELECT * FROM previous_events WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PreviousEvent pe = mapRow(rs);
                    pe.setPhotos(getPhotosByEvent(pe.getId()));
                    return pe;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<EventPhoto> getPhotosByEvent(int previousEventId) {
        List<EventPhoto> list = new ArrayList<>();
        String sql = "SELECT ep.*, pe.title as event_title, pe.event_year as event_year FROM event_photos ep " +
                     "JOIN previous_events pe ON ep.previous_event_id = pe.id " +
                     "WHERE ep.previous_event_id = ? ORDER BY ep.id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, previousEventId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPhotoRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<EventPhoto> getAllPhotos(String category) {
        List<EventPhoto> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT ep.*, pe.title as event_title, pe.event_year as event_year FROM event_photos ep " +
            "JOIN previous_events pe ON ep.previous_event_id = pe.id "
        );
        if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category)) {
            sql.append("WHERE LOWER(ep.category) = LOWER(?) ");
        }
        sql.append("ORDER BY pe.event_year DESC, ep.id ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category)) {
                ps.setString(1, category.trim());
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPhotoRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<EventPhoto> getFeaturedMoments(int limit) {
        List<EventPhoto> list = new ArrayList<>();
        String sql = "SELECT ep.*, pe.title as event_title, pe.event_year as event_year FROM event_photos ep " +
                     "JOIN previous_events pe ON ep.previous_event_id = pe.id " +
                     "ORDER BY ep.id ASC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPhotoRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private PreviousEvent mapRow(ResultSet rs) throws SQLException {
        PreviousEvent pe = new PreviousEvent();
        pe.setId(rs.getInt("id"));
        pe.setYear(rs.getInt("event_year"));
        pe.setTitle(rs.getString("title"));
        pe.setCategory(rs.getString("category"));
        pe.setDescription(rs.getString("description"));
        pe.setWinnerTeam(rs.getString("winner_team"));
        pe.setRunnerUpTeam(rs.getString("runner_up_team"));
        pe.setParticipantCount(rs.getInt("participant_count"));
        pe.setPrizePool(rs.getString("prize_pool"));
        pe.setCoverImage(rs.getString("cover_image"));
        pe.setHighlights(rs.getString("highlights"));
        return pe;
    }

    private EventPhoto mapPhotoRow(ResultSet rs) throws SQLException {
        EventPhoto p = new EventPhoto();
        p.setId(rs.getInt("id"));
        p.setPreviousEventId(rs.getInt("previous_event_id"));
        p.setCaption(rs.getString("caption"));
        p.setCategory(rs.getString("category"));
        p.setPhotoUrl(rs.getString("photo_url"));
        p.setAspectRatio(rs.getString("aspect_ratio"));
        p.setEventTitle(rs.getString("event_title"));
        p.setEventYear(rs.getInt("event_year"));
        return p;
    }
}
