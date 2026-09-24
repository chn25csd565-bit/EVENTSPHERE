<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<div class="toast-container" id="toastContainer">
    <!-- Success Message from request attribute or parameter -->
    <c:if test="${not empty successMessage or not empty param.msg or not empty param.welcome or not empty param.registered}">
        <div class="alert alert-success animate-slide-in">
            <span class="alert-icon">✓</span>
            <div class="alert-content">
                <c:choose>
                    <c:when test="${not empty successMessage}">${successMessage}</c:when>
                    <c:when test="${param.msg == 'logged_out'}">You have been logged out successfully.</c:when>
                    <c:when test="${param.msg == 'invite_sent'}">Teammate invitation sent successfully!</c:when>
                    <c:when test="${param.msg == 'joined_team'}">Successfully accepted invitation and joined team!</c:when>
                    <c:when test="${param.msg == 'invitation_declined'}">Team invitation declined.</c:when>
                    <c:when test="${param.msg == 'roster_locked'}">Team roster successfully locked for submission.</c:when>
                    <c:when test="${param.msg == 'member_removed'}">Team member removed successfully.</c:when>
                    <c:when test="${param.msg == 'submission_saved'}">Project submission successfully uploaded!</c:when>
                    <c:when test="${param.msg == 'score_submitted'}">Evaluation scores successfully submitted and locked!</c:when>
                    <c:when test="${param.msg == 'draft_saved'}">Evaluation draft score saved successfully.</c:when>
                    <c:when test="${param.welcome == '1'}">Welcome to EventSphere! Your student account is now active.</c:when>
                    <c:when test="${param.registered == '1'}">Registration confirmed! Your registration ticket code is: <strong>${param.code}</strong></c:when>
                    <c:otherwise>Action completed successfully.</c:otherwise>
                </c:choose>
            </div>
            <button type="button" class="alert-close" onclick="this.parentElement.remove()">&times;</button>
        </div>
    </c:if>

    <!-- Error Message from request attribute or parameter -->
    <c:if test="${not empty errorMessage or not empty param.error}">
        <div class="alert alert-danger animate-slide-in">
            <span class="alert-icon">⚠</span>
            <div class="alert-content">
                <c:choose>
                    <c:when test="${not empty errorMessage}">${errorMessage}</c:when>
                    <c:when test="${param.error == 'invalid_credentials'}">Invalid email or password. Please try again.</c:when>
                    <c:when test="${param.error == 'login_required'}">Please log in to access this feature.</c:when>
                    <c:when test="${param.error == 'admin_required'}">Administrator privileges required to access that resource.</c:when>
                    <c:when test="${param.error == 'judge_required'}">Jury authorization required to access evaluation portal.</c:when>
                    <c:when test="${param.error == 'already_registered'}">You are already registered for this event.</c:when>
                    <c:when test="${param.error == 'registration_closed'}">Registration for this event has reached capacity or expired.</c:when>
                    <c:when test="${param.error == 'team_name_required'}">Please specify a valid team name to register as a new team.</c:when>
                    <c:when test="${param.error == 'invalid_team_code'}">The team join code provided was not found for this event.</c:when>
                    <c:when test="${param.error == 'team_locked'}">This team roster is already locked by the team leader.</c:when>
                    <c:when test="${param.error == 'team_full'}">This team has already reached maximum allowable members.</c:when>
                    <c:when test="${param.error == 'not_authorized'}">You are not authorized to perform this operation.</c:when>
                    <c:when test="${param.error == 'submission_locked'}">Submissions are now closed and locked for judging.</c:when>
                    <c:when test="${param.error == 'missing_required_fields'}">Please fill in all mandatory submission fields.</c:when>
                    <c:otherwise>An error occurred. Please check your input and try again.</c:otherwise>
                </c:choose>
            </div>
            <button type="button" class="alert-close" onclick="this.parentElement.remove()">&times;</button>
        </div>
    </c:if>
</div>
