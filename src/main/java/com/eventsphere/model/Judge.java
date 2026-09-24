package com.eventsphere.model;

public class Judge {
    private int id;
    private int userId;
    private String title;
    private String organization;
    private String bio;
    private String specialization;
    private String avatar;

    // View helper fields
    private String name;
    private String email;

    public Judge() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getOrganization() { return organization; }
    public void setOrganization(String organization) { this.organization = organization; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getUserName() { return name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
