package com.eventsphere.model;

import java.sql.Timestamp;

public class Score {
    private int id;
    private int submissionId;
    private int judgeId;
    private double criteriaInnovation;    // 25%
    private double criteriaTechnical;     // 30%
    private double criteriaDesign;        // 20%
    private double criteriaPresentation;  // 15%
    private double criteriaFeasibility;   // 10%
    private double totalWeightedScore;
    private String feedback;
    private boolean isSubmitted;
    private Timestamp submittedAt;

    // View helper fields
    private String judgeName;
    private String judgeOrganization;
    private String submissionTitle;
    private String teamName;

    public Score() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getSubmissionId() { return submissionId; }
    public void setSubmissionId(int submissionId) { this.submissionId = submissionId; }

    public int getJudgeId() { return judgeId; }
    public void setJudgeId(int judgeId) { this.judgeId = judgeId; }

    public double getCriteriaInnovation() { return criteriaInnovation; }
    public void setCriteriaInnovation(double criteriaInnovation) { this.criteriaInnovation = criteriaInnovation; }

    public double getCriteriaTechnical() { return criteriaTechnical; }
    public void setCriteriaTechnical(double criteriaTechnical) { this.criteriaTechnical = criteriaTechnical; }

    public double getCriteriaDesign() { return criteriaDesign; }
    public void setCriteriaDesign(double criteriaDesign) { this.criteriaDesign = criteriaDesign; }

    public double getCriteriaPresentation() { return criteriaPresentation; }
    public void setCriteriaPresentation(double criteriaPresentation) { this.criteriaPresentation = criteriaPresentation; }

    public double getCriteriaFeasibility() { return criteriaFeasibility; }
    public void setCriteriaFeasibility(double criteriaFeasibility) { this.criteriaFeasibility = criteriaFeasibility; }

    public double getTotalWeightedScore() { return totalWeightedScore; }
    public void setTotalWeightedScore(double totalWeightedScore) { this.totalWeightedScore = totalWeightedScore; }

    public String getFeedback() { return feedback; }
    public void setFeedback(String feedback) { this.feedback = feedback; }

    public boolean isSubmitted() { return isSubmitted; }
    public void setSubmitted(boolean submitted) { isSubmitted = submitted; }

    public Timestamp getSubmittedAt() { return submittedAt; }
    public void setSubmittedAt(Timestamp submittedAt) { this.submittedAt = submittedAt; }

    public String getJudgeName() { return judgeName; }
    public void setJudgeName(String judgeName) { this.judgeName = judgeName; }

    public String getJudgeOrganization() { return judgeOrganization; }
    public void setJudgeOrganization(String judgeOrganization) { this.judgeOrganization = judgeOrganization; }

    public String getSubmissionTitle() { return submissionTitle; }
    public void setSubmissionTitle(String submissionTitle) { this.submissionTitle = submissionTitle; }

    public String getTeamName() { return teamName; }
    public void setTeamName(String teamName) { this.teamName = teamName; }

    public void calculateTotal() {
        double total = (criteriaInnovation * 0.25)
                     + (criteriaTechnical * 0.30)
                     + (criteriaDesign * 0.20)
                     + (criteriaPresentation * 0.15)
                     + (criteriaFeasibility * 0.10);
        this.totalWeightedScore = Math.round(total * 100.0) / 100.0;
    }
}
