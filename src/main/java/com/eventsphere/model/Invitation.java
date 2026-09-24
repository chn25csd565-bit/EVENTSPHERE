package com.eventsphere.model;

import java.sql.Timestamp;

public class Invitation {
    private int id;
    private int teamId;
    private int inviterId;
    private String inviteeEmail;
    private String status; // PENDING, ACCEPTED, DECLINED
    private Timestamp createdAt;

    // View helper fields
    private String teamName;
    private String inviterName;
    private String eventTitle;
    private int eventId;

    public Invitation() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getTeamId() { return teamId; }
    public void setTeamId(int teamId) { this.teamId = teamId; }

    public int getInviterId() { return inviterId; }
    public void setInviterId(int inviterId) { this.inviterId = inviterId; }

    public String getInviteeEmail() { return inviteeEmail; }
    public void setInviteeEmail(String inviteeEmail) { this.inviteeEmail = inviteeEmail; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getTeamName() { return teamName; }
    public void setTeamName(String teamName) { this.teamName = teamName; }

    public String getInviterName() { return inviterName; }
    public void setInviterName(String inviterName) { this.inviterName = inviterName; }

    public String getEventTitle() { return eventTitle; }
    public void setEventTitle(String eventTitle) { this.eventTitle = eventTitle; }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }
}
