package com.eventsphere.model;

import java.sql.Timestamp;

public class Event {
    private int id;
    private String title;
    private String slug;
    private String category; // Hackathon, Technical, Cultural, Workshop, Gaming
    private String tagline;
    private String description;
    private String rules;
    private String schedule;
    private String venue;
    private Timestamp startDate;
    private Timestamp endDate;
    private Timestamp registrationDeadline;
    private int minTeamSize;
    private int maxTeamSize;
    private int maxCapacity;
    private int currentRegistrations;
    private String prizePool;
    private String bannerImage;
    private String status; // UPCOMING, ONGOING, COMPLETED, CLOSED
    private Timestamp createdAt;

    public Event() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getTagline() { return tagline; }
    public void setTagline(String tagline) { this.tagline = tagline; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getRules() { return rules; }
    public void setRules(String rules) { this.rules = rules; }

    public String getSchedule() { return schedule; }
    public void setSchedule(String schedule) { this.schedule = schedule; }

    public String getVenue() { return venue; }
    public void setVenue(String venue) { this.venue = venue; }

    public Timestamp getStartDate() { return startDate; }
    public void setStartDate(Timestamp startDate) { this.startDate = startDate; }

    public Timestamp getEndDate() { return endDate; }
    public void setEndDate(Timestamp endDate) { this.endDate = endDate; }

    public Timestamp getRegistrationDeadline() { return registrationDeadline; }
    public void setRegistrationDeadline(Timestamp registrationDeadline) { this.registrationDeadline = registrationDeadline; }

    public int getMinTeamSize() { return minTeamSize; }
    public void setMinTeamSize(int minTeamSize) { this.minTeamSize = minTeamSize; }

    public int getMaxTeamSize() { return maxTeamSize; }
    public void setMaxTeamSize(int maxTeamSize) { this.maxTeamSize = maxTeamSize; }

    public int getMaxCapacity() { return maxCapacity; }
    public void setMaxCapacity(int maxCapacity) { this.maxCapacity = maxCapacity; }

    public int getCurrentRegistrations() { return currentRegistrations; }
    public void setCurrentRegistrations(int currentRegistrations) { this.currentRegistrations = currentRegistrations; }

    public String getPrizePool() { return prizePool; }
    public void setPrizePool(String prizePool) { this.prizePool = prizePool; }

    public String getBannerImage() { return bannerImage; }
    public void setBannerImage(String bannerImage) { this.bannerImage = bannerImage; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public boolean isRegistrationOpen() {
        if ("CLOSED".equalsIgnoreCase(status) || "COMPLETED".equalsIgnoreCase(status)) return false;
        if (currentRegistrations >= maxCapacity && maxCapacity > 0) return false;
        long now = System.currentTimeMillis();
        if (registrationDeadline != null && registrationDeadline.getTime() < now) return false;
        return true;
    }

    public int getCapacityPercentage() {
        if (maxCapacity <= 0) return 0;
        return (int) Math.min(100, Math.round(((double) currentRegistrations / maxCapacity) * 100));
    }
}
