package com.eventsphere.dao;

import com.eventsphere.config.DBConnection;
import com.eventsphere.model.Attendance;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class AttendanceDAO {

    public boolean recordAttendance(int eventId, int userId, String status) {
        String checkSql = "SELECT id FROM attendance WHERE event_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String updateSql = "UPDATE attendance SET status = ?, check_in_time = ? WHERE id = ?";
                    try (PreparedStatement ups = conn.prepareStatement(updateSql)) {
                        ups.setString(1, status);
                        ups.setTimestamp(2, "CHECKED_IN".equalsIgnoreCase(status) ? new Timestamp(System.currentTimeMillis()) : null);
                        ups.setInt(3, rs.getInt(1));
                        return ups.executeUpdate() > 0;
                    }
                } else {
                    String insertSql = "INSERT INTO attendance (event_id, user_id, status, check_in_time) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement ins = conn.prepareStatement(insertSql)) {
                        ins.setInt(1, eventId);
                        ins.setInt(2, userId);
                        ins.setString(3, status);
                        ins.setTimestamp(4, "CHECKED_IN".equalsIgnoreCase(status) ? new Timestamp(System.currentTimeMillis()) : null);
                        return ins.executeUpdate() > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Attendance> getAttendanceForEvent(int eventId) {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT a.*, u.name as user_name, u.email as user_email, u.college as user_college, e.title as event_title " +
                     "FROM attendance a " +
                     "JOIN users u ON a.user_id = u.id " +
                     "JOIN events e ON a.event_id = e.id " +
                     "WHERE a.event_id = ? ORDER BY u.name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Attendance att = new Attendance();
                    att.setId(rs.getInt("id"));
                    att.setEventId(rs.getInt("event_id"));
                    att.setUserId(rs.getInt("user_id"));
                    att.setStatus(rs.getString("status"));
                    att.setCheckInTime(rs.getTimestamp("check_in_time"));
                    att.setUserName(rs.getString("user_name"));
                    att.setUserEmail(rs.getString("user_email"));
                    att.setUserCollege(rs.getString("user_college"));
                    att.setEventTitle(rs.getString("event_title"));
                    list.add(att);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Attendance getUserAttendance(int eventId, int userId) {
        String sql = "SELECT a.*, u.name as user_name, u.email as user_email, u.college as user_college, e.title as event_title " +
                     "FROM attendance a " +
                     "JOIN users u ON a.user_id = u.id " +
                     "JOIN events e ON a.event_id = e.id " +
                     "WHERE a.event_id = ? AND a.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Attendance att = new Attendance();
                    att.setId(rs.getInt("id"));
                    att.setEventId(rs.getInt("event_id"));
                    att.setUserId(rs.getInt("user_id"));
                    att.setStatus(rs.getString("status"));
                    att.setCheckInTime(rs.getTimestamp("check_in_time"));
                    att.setUserName(rs.getString("user_name"));
                    att.setUserEmail(rs.getString("user_email"));
                    att.setUserCollege(rs.getString("user_college"));
                    att.setEventTitle(rs.getString("event_title"));
                    return att;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
