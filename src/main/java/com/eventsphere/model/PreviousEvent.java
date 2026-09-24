package com.eventsphere.model;

import java.util.ArrayList;
import java.util.List;

public class PreviousEvent {
    private int id;
    private int year;
    private String title;
    private String category;
    private String description;
    private String winnerTeam;
    private String runnerUpTeam;
    private int participantCount;
    private String prizePool;
    private String coverImage;
    private String highlights;

    private List<EventPhoto> photos = new ArrayList<>();

    public PreviousEvent() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getWinnerTeam() { return winnerTeam; }
    public void setWinnerTeam(String winnerTeam) { this.winnerTeam = winnerTeam; }

    public String getRunnerUpTeam() { return runnerUpTeam; }
    public void setRunnerUpTeam(String runnerUpTeam) { this.runnerUpTeam = runnerUpTeam; }

    public int getParticipantCount() { return participantCount; }
    public void setParticipantCount(int participantCount) { this.participantCount = participantCount; }

    public String getPrizePool() { return prizePool; }
    public void setPrizePool(String prizePool) { this.prizePool = prizePool; }

    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }

    public String getHighlights() { return highlights; }
    public void setHighlights(String highlights) { this.highlights = highlights; }

    public List<EventPhoto> getPhotos() { return photos; }
    public void setPhotos(List<EventPhoto> photos) { this.photos = photos; }
}
