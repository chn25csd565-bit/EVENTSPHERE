package com.eventsphere.model;

import java.sql.Timestamp;

public class Announcement {
    private int id;
    private Integer eventId;
    private String title;
    private String content;
    private String priority; // NORMAL, HIGH, URGENT
    private Timestamp createdAt;

    // View helper fields
    private String eventTitle;

    public Announcement() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Integer getEventId() { return eventId; }
    public void setEventId(Integer eventId) { this.eventId = eventId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getEventTitle() { return eventTitle; }
    public void setEventTitle(String eventTitle) { this.eventTitle = eventTitle; }
}
