package com.eventsphere.model;

public class LeaderboardEntry {
    private int rank;
    private int submissionId;
    private String projectTitle;
    private String teamName;
    private int eventId;
    private String eventTitle;
    private String techStack;
    private String repoUrl;
    private String demoUrl;
    private double avgInnovation;
    private double avgTechnical;
    private double avgDesign;
    private double avgPresentation;
    private double avgFeasibility;
    private double finalScore;
    private int judgeCount;

    public LeaderboardEntry() {}

    public int getRank() { return rank; }
    public void setRank(int rank) { this.rank = rank; }

    public int getSubmissionId() { return submissionId; }
    public void setSubmissionId(int submissionId) { this.submissionId = submissionId; }

    public String getProjectTitle() { return projectTitle; }
    public void setProjectTitle(String projectTitle) { this.projectTitle = projectTitle; }

    public String getTeamName() { return teamName; }
    public void setTeamName(String teamName) { this.teamName = teamName; }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public String getEventTitle() { return eventTitle; }
    public void setEventTitle(String eventTitle) { this.eventTitle = eventTitle; }

    public String getTechStack() { return techStack; }
    public void setTechStack(String techStack) { this.techStack = techStack; }

    public String getRepoUrl() { return repoUrl; }
    public void setRepoUrl(String repoUrl) { this.repoUrl = repoUrl; }

    public String getDemoUrl() { return demoUrl; }
    public void setDemoUrl(String demoUrl) { this.demoUrl = demoUrl; }

    public double getAvgInnovation() { return avgInnovation; }
    public void setAvgInnovation(double avgInnovation) { this.avgInnovation = avgInnovation; }

    public double getAvgTechnical() { return avgTechnical; }
    public void setAvgTechnical(double avgTechnical) { this.avgTechnical = avgTechnical; }

    public double getAvgDesign() { return avgDesign; }
    public void setAvgDesign(double avgDesign) { this.avgDesign = avgDesign; }

    public double getAvgPresentation() { return avgPresentation; }
    public void setAvgPresentation(double avgPresentation) { this.avgPresentation = avgPresentation; }

    public double getAvgFeasibility() { return avgFeasibility; }
    public void setAvgFeasibility(double avgFeasibility) { this.avgFeasibility = avgFeasibility; }

    public double getFinalScore() { return finalScore; }
    public void setFinalScore(double finalScore) { this.finalScore = finalScore; }

    public int getJudgeCount() { return judgeCount; }
    public void setJudgeCount(int judgeCount) { this.judgeCount = judgeCount; }

    public String getBadgeClass() {
        if (rank == 1) return "badge-gold";
        if (rank == 2) return "badge-silver";
        if (rank == 3) return "badge-bronze";
        return "badge-normal";
    }
}
