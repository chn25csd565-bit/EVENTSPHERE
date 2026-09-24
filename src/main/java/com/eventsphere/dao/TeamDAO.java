package com.eventsphere.dao;

import com.eventsphere.config.DBConnection;
import com.eventsphere.model.Invitation;
import com.eventsphere.model.Team;
import com.eventsphere.model.TeamMember;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class TeamDAO {

    public boolean createTeam(Team team, int leaderId) {
        String sql = "INSERT INTO teams (event_id, name, team_code, leader_id, is_locked) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, team.getEventId());
            ps.setString(2, team.getName());
            ps.setString(3, team.getTeamCode());
            ps.setInt(4, leaderId);
            ps.setBoolean(5, false);

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        team.setId(rs.getInt(1));
                    }
                }
                // Automatically add leader as first member
                addMember(team.getId(), leaderId, "LEADER");
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Team findById(int id) {
        String sql = "SELECT t.*, u.name as leader_name, u.email as leader_email, e.title as event_title " +
                     "FROM teams t " +
                     "JOIN users u ON t.leader_id = u.id " +
                     "JOIN events e ON t.event_id = e.id " +
                     "WHERE t.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Team team = mapRow(rs);
                    team.setMembers(getMembers(team.getId()));
                    return team;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Team findByCode(String code) {
        String sql = "SELECT t.*, u.name as leader_name, u.email as leader_email, e.title as event_title " +
                     "FROM teams t " +
                     "JOIN users u ON t.leader_id = u.id " +
                     "JOIN events e ON t.event_id = e.id " +
                     "WHERE UPPER(t.team_code) = UPPER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Team team = mapRow(rs);
                    team.setMembers(getMembers(team.getId()));
                    return team;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Team findByEventAndUser(int eventId, int userId) {
        String sql = "SELECT t.*, u.name as leader_name, u.email as leader_email, e.title as event_title " +
                     "FROM teams t " +
                     "JOIN team_members tm ON t.id = tm.team_id " +
                     "JOIN users u ON t.leader_id = u.id " +
                     "JOIN events e ON t.event_id = e.id " +
                     "WHERE t.event_id = ? AND tm.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Team team = mapRow(rs);
                    team.setMembers(getMembers(team.getId()));
                    return team;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Team> findTeamsByUserId(int userId) {
        List<Team> list = new ArrayList<>();
        String sql = "SELECT t.*, u.name as leader_name, u.email as leader_email, e.title as event_title " +
                     "FROM teams t " +
                     "JOIN team_members tm ON t.id = tm.team_id " +
                     "JOIN users u ON t.leader_id = u.id " +
                     "JOIN events e ON t.event_id = e.id " +
                     "WHERE tm.user_id = ? ORDER BY t.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Team t = mapRow(rs);
                    t.setMembers(getMembers(t.getId()));
                    list.add(t);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addMember(int teamId, int userId, String role) {
        String sql = "INSERT INTO team_members (team_id, user_id, role) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, teamId);
            ps.setInt(2, userId);
            ps.setString(3, role != null ? role : "MEMBER");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // Already member
            return false;
        }
    }

    public boolean removeMember(int teamId, int userId) {
        String sql = "DELETE FROM team_members WHERE team_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, teamId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<TeamMember> getMembers(int teamId) {
        List<TeamMember> list = new ArrayList<>();
        String sql = "SELECT tm.*, u.name as user_name, u.email as user_email, u.college as user_college, u.department as user_dept " +
                     "FROM team_members tm " +
                     "JOIN users u ON tm.user_id = u.id " +
                     "WHERE tm.team_id = ? ORDER BY tm.role DESC, tm.joined_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, teamId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TeamMember m = new TeamMember();
                    m.setId(rs.getInt("id"));
                    m.setTeamId(rs.getInt("team_id"));
                    m.setUserId(rs.getInt("user_id"));
                    m.setRole(rs.getString("role"));
                    m.setJoinedAt(rs.getTimestamp("joined_at"));
                    m.setUserName(rs.getString("user_name"));
                    m.setUserEmail(rs.getString("user_email"));
                    m.setUserCollege(rs.getString("user_college"));
                    m.setUserDepartment(rs.getString("user_dept"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean lockTeam(int teamId) {
        String sql = "UPDATE teams SET is_locked = TRUE WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, teamId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Invitations
    public boolean createInvitation(int teamId, int inviterId, String inviteeEmail) {
        String sql = "INSERT INTO invitations (team_id, inviter_id, invitee_email, status) VALUES (?, ?, ?, 'PENDING')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, teamId);
            ps.setInt(2, inviterId);
            ps.setString(3, inviteeEmail.trim().toLowerCase());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Invitation> getInvitationsForEmail(String email) {
        List<Invitation> list = new ArrayList<>();
        String sql = "SELECT i.*, t.name as team_name, t.event_id, u.name as inviter_name, e.title as event_title " +
                     "FROM invitations i " +
                     "JOIN teams t ON i.team_id = t.id " +
                     "JOIN users u ON i.inviter_id = u.id " +
                     "JOIN events e ON t.event_id = e.id " +
                     "WHERE LOWER(i.invitee_email) = LOWER(?) AND i.status = 'PENDING' " +
                     "ORDER BY i.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invitation inv = new Invitation();
                    inv.setId(rs.getInt("id"));
                    inv.setTeamId(rs.getInt("team_id"));
                    inv.setInviterId(rs.getInt("inviter_id"));
                    inv.setInviteeEmail(rs.getString("invitee_email"));
                    inv.setStatus(rs.getString("status"));
                    inv.setCreatedAt(rs.getTimestamp("created_at"));
                    inv.setTeamName(rs.getString("team_name"));
                    inv.setInviterName(rs.getString("inviter_name"));
                    inv.setEventTitle(rs.getString("event_title"));
                    inv.setEventId(rs.getInt("event_id"));
                    list.add(inv);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean respondInvitation(int invitationId, String status) {
        String sql = "UPDATE invitations SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, invitationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Invitation findInvitationById(int id) {
        String sql = "SELECT i.*, t.name as team_name, t.event_id, u.name as inviter_name, e.title as event_title " +
                     "FROM invitations i " +
                     "JOIN teams t ON i.team_id = t.id " +
                     "JOIN users u ON i.inviter_id = u.id " +
                     "JOIN events e ON t.event_id = e.id " +
                     "WHERE i.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Invitation inv = new Invitation();
                    inv.setId(rs.getInt("id"));
                    inv.setTeamId(rs.getInt("team_id"));
                    inv.setInviterId(rs.getInt("inviter_id"));
                    inv.setInviteeEmail(rs.getString("invitee_email"));
                    inv.setStatus(rs.getString("status"));
                    inv.setCreatedAt(rs.getTimestamp("created_at"));
                    inv.setTeamName(rs.getString("team_name"));
                    inv.setInviterName(rs.getString("inviter_name"));
                    inv.setEventTitle(rs.getString("event_title"));
                    inv.setEventId(rs.getInt("event_id"));
                    return inv;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Team mapRow(ResultSet rs) throws SQLException {
        Team t = new Team();
        t.setId(rs.getInt("id"));
        t.setEventId(rs.getInt("event_id"));
        t.setName(rs.getString("name"));
        t.setTeamCode(rs.getString("team_code"));
        t.setLeaderId(rs.getInt("leader_id"));
        t.setLocked(rs.getBoolean("is_locked"));
        t.setCreatedAt(rs.getTimestamp("created_at"));
        t.setLeaderName(rs.getString("leader_name"));
        t.setLeaderEmail(rs.getString("leader_email"));
        t.setEventTitle(rs.getString("event_title"));
        return t;
    }
}
