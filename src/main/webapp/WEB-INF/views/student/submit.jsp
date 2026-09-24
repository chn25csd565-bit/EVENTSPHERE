<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Submit Project | ${event.title} | EventSphere" />
<c:set var="activePage" value="student" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />
<jsp:include page="/WEB-INF/views/common/alerts.jsp" />

<main class="page-container">
    <div class="container max-w-4xl">
        <!-- Breadcrumbs -->
        <nav class="breadcrumb-nav">
            <a href="${pageContext.request.contextPath}/student/dashboard">Student Dashboard</a>
            <span class="bc-sep">/</span>
            <span class="bc-current">Submit Project: ${event.title}</span>
        </nav>

        <div class="submit-card-wrapper mt-4">
            <div class="submit-header">
                <div class="submit-event-pill">
                    <span class="badge badge-primary">${event.category}</span>
                    <c:if test="${team != null}">
                        <span class="badge badge-outline">Squad: ${team.name}</span>
                    </c:if>
                </div>
                <h1 class="submit-title">
                    ${submission != null ? 'Update Project Submission' : 'Initial Project Submission'}
                </h1>
                <p class="submit-subtitle">
                    Provide your repository coordinates, interactive deployment links, and project architecture notes for jury evaluation.
                </p>
                <c:if test="${submission != null}">
                    <div class="version-callout">
                        <span>Current Version: <strong>v${submission.version}.0</strong></span>
                        <span class="text-muted">Submitting updates will increment the revision version for judges.</span>
                    </div>
                </c:if>
            </div>

            <!-- Submission Form -->
            <form action="${pageContext.request.contextPath}/submit-project" method="POST" class="project-submit-form" id="submitForm">
                <input type="hidden" name="eventId" value="${event.id}" />
                <input type="hidden" name="submissionId" value="${submission != null ? submission.id : 0}" />

                <!-- Project Title -->
                <div class="form-group mb-4">
                    <label for="titleInput" class="form-label">Project Title <span class="text-danger">*</span></label>
                    <input type="text" id="titleInput" name="title" value="${fn:escapeXml(submission != null ? submission.title : '')}" required placeholder="e.g. MedVision AI: Automated Multi-Modal Clinical Triage" class="form-input" />
                </div>

                <!-- Written Description -->
                <div class="form-group mb-4">
                    <label for="descInput" class="form-label">Project Summary & Problem Statement <span class="text-danger">*</span></label>
                    <textarea id="descInput" name="description" rows="5" required placeholder="Describe what your solution accomplishes, why it is innovative, and how it aligns with the hackathon track..." class="form-input">${fn:escapeXml(submission != null ? submission.description : '')}</textarea>
                    <small class="form-hint">Judges read this summary during the initial evaluation round.</small>
                </div>

                <!-- Tech Stack Tags -->
                <div class="form-group mb-4">
                    <label for="techInput" class="form-label">Technologies & Frameworks Used <span class="text-danger">*</span></label>
                    <input type="text" id="techInput" name="techStack" value="${fn:escapeXml(submission != null ? submission.techStack : '')}" required placeholder="e.g. Java, Python, PyTorch, React, Docker, WebSockets" class="form-input" />
                    <small class="form-hint">Separate libraries and tech stack keywords with commas.</small>
                </div>

                <div class="form-grid-2">
                    <!-- GitHub / Code Repo URL -->
                    <div class="form-group mb-4">
                        <label for="repoInput" class="form-label">Public Repository URL (GitHub / GitLab) <span class="text-danger">*</span></label>
                        <input type="url" id="repoInput" name="repoUrl" value="${fn:escapeXml(submission != null ? submission.repoUrl : '')}" required placeholder="https://github.com/username/project" class="form-input" />
                    </div>

                    <!-- Live Demo URL -->
                    <div class="form-group mb-4">
                        <label for="demoInput" class="form-label">Working Prototype / Live Demo URL</label>
                        <input type="url" id="demoInput" name="demoUrl" value="${fn:escapeXml(submission != null ? submission.demoUrl : '')}" placeholder="https://my-demo-app.vercel.app" class="form-input" />
                    </div>
                </div>

                <div class="form-grid-2">
                    <!-- Slide Deck / PPT URL -->
                    <div class="form-group mb-4">
                        <label for="pptInput" class="form-label">Slide Deck / Presentation URL (Google Slides / PDF)</label>
                        <input type="url" id="pptInput" name="pptUrl" value="${fn:escapeXml(submission != null ? submission.pptUrl : '')}" placeholder="https://slides.google.com/presentation/d/..." class="form-input" />
                    </div>

                    <!-- Video Demo URL -->
                    <div class="form-group mb-4">
                        <label for="videoInput" class="form-label">Video Walkthrough URL (YouTube / Loom)</label>
                        <input type="url" id="videoInput" name="videoUrl" value="${fn:escapeXml(submission != null ? submission.videoUrl : '')}" placeholder="https://youtu.be/..." class="form-input" />
                    </div>
                </div>

                <div class="submit-action-bar mt-6">
                    <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-outline">Cancel</a>
                    <button type="submit" class="btn btn-primary btn-lg">
                        ${submission != null ? 'Save Revised Version →' : 'Publish Project Submission →'}
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
