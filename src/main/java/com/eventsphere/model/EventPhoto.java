package com.eventsphere.model;

public class EventPhoto {
    private int id;
    private int previousEventId;
    private String caption;
    private String category; // Coding, Presentation, Mentorship, Celebration, Prize
    private String photoUrl;
    private String aspectRatio; // 16:9, 4:3, 3:2

    // View helper
    private String eventTitle;
    private int eventYear;

    public EventPhoto() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPreviousEventId() { return previousEventId; }
    public void setPreviousEventId(int previousEventId) { this.previousEventId = previousEventId; }

    public String getCaption() { return caption; }
    public void setCaption(String caption) { this.caption = caption; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getPhotoUrl() { return photoUrl; }
    public void setPhotoUrl(String photoUrl) { this.photoUrl = photoUrl; }

    public String getAspectRatio() { return aspectRatio; }
    public void setAspectRatio(String aspectRatio) { this.aspectRatio = aspectRatio; }

    public String getEventTitle() { return eventTitle; }
    public void setEventTitle(String eventTitle) { this.eventTitle = eventTitle; }

    public int getEventYear() { return eventYear; }
    public void setEventYear(int eventYear) { this.eventYear = eventYear; }
}
