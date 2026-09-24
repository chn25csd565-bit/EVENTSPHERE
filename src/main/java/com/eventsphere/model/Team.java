package com.eventsphere.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Team {
    private int id;
    private int eventId;
    private String name;
    private String teamCode;
    private int leaderId;
    private boolean isLocked;
    private Timestamp createdAt;

    // View helper fields
    private String leaderName;
    private String leaderEmail;
    private String eventTitle;
    private List<TeamMember> members = new ArrayList<>();

    public Team() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getTeamCode() { return teamCode; }
    public void setTeamCode(String teamCode) { this.teamCode = teamCode; }

    public int getLeaderId() { return leaderId; }
    public void setLeaderId(int leaderId) { this.leaderId = leaderId; }

    public boolean isLocked() { return isLocked; }
    public void setLocked(boolean locked) { isLocked = locked; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getLeaderName() { return leaderName; }
    public void setLeaderName(String leaderName) { this.leaderName = leaderName; }

    public String getLeaderEmail() { return leaderEmail; }
    public void setLeaderEmail(String leaderEmail) { this.leaderEmail = leaderEmail; }

    public String getEventTitle() { return eventTitle; }
    public void setEventTitle(String eventTitle) { this.eventTitle = eventTitle; }

    public List<TeamMember> getMembers() { return members; }
    public void setMembers(List<TeamMember> members) { this.members = members; }

    public int getMemberCount() {
        return members != null ? members.size() : 0;
    }
}
