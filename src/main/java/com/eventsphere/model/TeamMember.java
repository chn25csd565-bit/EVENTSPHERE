package com.eventsphere.model;

import java.sql.Timestamp;

public class TeamMember {
    private int id;
    private int teamId;
    private int userId;
    private String role; // LEADER, MEMBER
    private Timestamp joinedAt;

    // View helper fields
    private String userName;
    private String userEmail;
    private String userCollege;
    private String userDepartment;

    public TeamMember() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getTeamId() { return teamId; }
    public void setTeamId(int teamId) { this.teamId = teamId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Timestamp getJoinedAt() { return joinedAt; }
    public void setJoinedAt(Timestamp joinedAt) { this.joinedAt = joinedAt; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public String getUserCollege() { return userCollege; }
    public void setUserCollege(String userCollege) { this.userCollege = userCollege; }

    public String getUserDepartment() { return userDepartment; }
    public void setUserDepartment(String userDepartment) { this.userDepartment = userDepartment; }
}
