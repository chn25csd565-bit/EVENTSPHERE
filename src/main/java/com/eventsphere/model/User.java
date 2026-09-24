package com.eventsphere.model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String name;
    private String email;
    private String passwordHash;
    private String role; // STUDENT, JUDGE, ADMIN
    private String college;
    private String department;
    private String phone;
    private String avatar;
    private Timestamp createdAt;

    public User() {}

    public User(int id, String name, String email, String passwordHash, String role, String college, String department, String phone, String avatar, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
        this.college = college;
        this.department = department;
        this.phone = phone;
        this.avatar = avatar;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getCollege() { return college; }
    public void setCollege(String college) { this.college = college; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public boolean isAdmin() { return "ADMIN".equalsIgnoreCase(role); }
    public boolean isJudge() { return "JUDGE".equalsIgnoreCase(role); }
    public boolean isStudent() { return "STUDENT".equalsIgnoreCase(role); }
}
