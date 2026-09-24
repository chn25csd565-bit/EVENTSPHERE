<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Evaluate: ${submission.title} | EventSphere" />
<c:set var="activePage" value="judge" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />
<jsp:include page="/WEB-INF/views/common/alerts.jsp" />

<main class="page-container">
    <div class="container max-w-5xl">
        <!-- Breadcrumbs -->
        <nav class="breadcrumb-nav">
            <a href="${pageContext.request.contextPath}/judge/dashboard">Judge Dashboard</a>
            <span class="bc-sep">/</span>
            <span class="bc-current">Evaluate: ${submission.title}</span>
        </nav>

        <!-- Project Submission Dossier Card -->
        <div class="detail-banner-card mt-4">
            <div class="detail-banner-content p-6">
                <div class="detail-badge-row">
                    <span class="badge badge-primary">${submission.eventTitle}</span>
                    <span class="badge badge-outline">Squad: ${submission.teamName != null ? submission.teamName : submission.userName}</span>
                    <span class="version-tag">Version ${submission.version}.0</span>
                </div>

                <h1 class="detail-title mt-2">${submission.title}</h1>
                <p class="content-text mt-3">${submission.description}</p>

                <!-- Tech Stack Tags -->
                <c:if test="${not empty submission.techStack}">
                    <div class="tech-tags-list mt-3">
                        <c:forEach var="tech" items="${fn:split(submission.techStack, ',')}">
                            <span class="tech-tag">${fn:trim(tech)}</span>
                        </c:forEach>
                    </div>
                </c:if>

                <!-- Project Links Grid -->
                <div class="project-links-grid mt-4">
                    <c:if test="${not empty submission.demoUrl}">
                        <a href="${submission.demoUrl}" target="_blank" rel="noopener" class="btn btn-sm btn-primary">
                            🚀 Launch Working Prototype ↗
                        </a>
                    </c:if>
                    <c:if test="${not empty submission.repoUrl}">
                        <a href="${submission.repoUrl}" target="_blank" rel="noopener" class="btn btn-sm btn-outline">
                            💻 Inspect GitHub Repo ↗
                        </a>
                    </c:if>
                    <c:if test="${not empty submission.pptUrl}">
                        <a href="${submission.pptUrl}" target="_blank" rel="noopener" class="btn btn-sm btn-ghost">
                            📊 View Slide Deck ↗
                        </a>
                    </c:if>
                    <c:if test="${not empty submission.videoUrl}">
                        <a href="${submission.videoUrl}" target="_blank" rel="noopener" class="btn btn-sm btn-ghost">
                            ▶ Video Walkthrough ↗
                        </a>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- 5-Criteria Rubric Scoring Card -->
        <div class="rubric-evaluation-card mt-8">
            <div class="rubric-card-header flex-between">
                <div>
                    <h2>Official 5-Criteria Rubric Scorecard</h2>
                    <p class="text-muted">Rate each dimension on a 1.0 to 10.0 scale. Weighted totals update dynamically.</p>
                </div>
                <!-- Dynamic Real-Time Score Badge -->
                <div class="live-score-display">
                    <small>Calculated Total</small>
                    <div class="live-score-val" id="totalWeightedScoreDisplay">
                        <fmt:formatNumber value="${score != null ? score.totalWeightedScore : 0.00}" minFractionDigits="2" maxFractionDigits="2" />
                    </div>
                    <span class="live-score-scale">/ 10.00</span>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/judge/evaluate" method="POST" id="rubricForm" class="mt-6">
                <input type="hidden" name="submissionId" value="${submission.id}" />
                <input type="hidden" name="isFinal" id="isFinalInput" value="true" />

                <div class="criteria-sliders-list">
                    <!-- 1. Innovation & Creativity (25%) -->
                    <div class="criterion-item">
                        <div class="crit-header flex-between">
                            <div>
                                <label class="crit-label" for="critInno">1. Innovation & Creativity</label>
                                <span class="crit-weight-pill">Weight: 25%</span>
                                <p class="crit-desc text-muted">Originality of concept, novelty of architecture, and out-of-the-box problem framing.</p>
                            </div>
                            <div class="crit-val-badge">
                                <span id="valInnoDisplay">${score != null ? score.criteriaInnovation : '8.5'}</span>
                            </div>
                        </div>
                        <input type="range" min="1.0" max="10.0" step="0.1" 
                               id="critInno" name="criteriaInnovation" 
                               value="${score != null ? score.criteriaInnovation : '8.5'}" 
                               class="rubric-slider" oninput="updateRubricTotal()" />
                    </div>

                    <!-- 2. Technical Complexity & Execution (30%) -->
                    <div class="criterion-item mt-6">
                        <div class="crit-header flex-between">
                            <div>
                                <label class="crit-label" for="critTech">2. Technical Complexity & Execution</label>
                                <span class="crit-weight-pill">Weight: 30%</span>
                                <p class="crit-desc text-muted">Architectural depth, algorithm design, clean API implementation, and code hygiene.</p>
                            </div>
                            <div class="crit-val-badge">
                                <span id="valTechDisplay">${score != null ? score.criteriaTechnical : '8.5'}</span>
                            </div>
                        </div>
                        <input type="range" min="1.0" max="10.0" step="0.1" 
                               id="critTech" name="criteriaTechnical" 
                               value="${score != null ? score.criteriaTechnical : '8.5'}" 
                               class="rubric-slider" oninput="updateRubricTotal()" />
                    </div>

                    <!-- 3. Design & User Experience (20%) -->
                    <div class="criterion-item mt-6">
                        <div class="crit-header flex-between">
                            <div>
                                <label class="crit-label" for="critDesign">3. Design & User Experience</label>
                                <span class="crit-weight-pill">Weight: 20%</span>
                                <p class="crit-desc text-muted">Interface polish, intuitive interaction flows, visual hierarchy, and accessibility.</p>
                            </div>
                            <div class="crit-val-badge">
                                <span id="valDesignDisplay">${score != null ? score.criteriaDesign : '8.0'}</span>
                            </div>
                        </div>
                        <input type="range" min="1.0" max="10.0" step="0.1" 
                               id="critDesign" name="criteriaDesign" 
                               value="${score != null ? score.criteriaDesign : '8.0'}" 
                               class="rubric-slider" oninput="updateRubricTotal()" />
                    </div>

                    <!-- 4. Presentation & Pitch (15%) -->
                    <div class="criterion-item mt-6">
                        <div class="crit-header flex-between">
                            <div>
                                <label class="crit-label" for="critPres">4. Presentation & Pitch</label>
                                <span class="crit-weight-pill">Weight: 15%</span>
                                <p class="crit-desc text-muted">Clarity of demo presentation, slide storytelling, and articulation of project hurdles.</p>
                            </div>
                            <div class="crit-val-badge">
                                <span id="valPresDisplay">${score != null ? score.criteriaPresentation : '8.0'}</span>
                            </div>
                        </div>
                        <input type="range" min="1.0" max="10.0" step="0.1" 
                               id="critPres" name="criteriaPresentation" 
                               value="${score != null ? score.criteriaPresentation : '8.0'}" 
                               class="rubric-slider" oninput="updateRubricTotal()" />
                    </div>

                    <!-- 5. Practical Feasibility (10%) -->
                    <div class="criterion-item mt-6">
                        <div class="crit-header flex-between">
                            <div>
                                <label class="crit-label" for="critFeas">5. Practical Feasibility & Scalability</label>
                                <span class="crit-weight-pill">Weight: 10%</span>
                                <p class="crit-desc text-muted">Real-world commercial viability, edge cases handling, cloud security, and deployment roadmaps.</p>
                            </div>
                            <div class="crit-val-badge">
                                <span id="valFeasDisplay">${score != null ? score.criteriaFeasibility : '8.0'}</span>
                            </div>
                        </div>
                        <input type="range" min="1.0" max="10.0" step="0.1" 
                               id="critFeas" name="criteriaFeasibility" 
                               value="${score != null ? score.criteriaFeasibility : '8.0'}" 
                               class="rubric-slider" oninput="updateRubricTotal()" />
                    </div>
                </div>

                <!-- Qualitative Feedback Notes -->
                <div class="form-group mt-8">
                    <label for="feedbackInput" class="form-label">Qualitative Feedback & Architectural Recommendations</label>
                    <textarea id="feedbackInput" name="feedback" rows="4" class="form-input" placeholder="Provide constructive technical notes and feedback for the student builder team...">${fn:escapeXml(score != null ? score.feedback : '')}</textarea>
                </div>

                <!-- Actions -->
                <div class="rubric-actions-bar mt-8 flex-between">
                    <a href="${pageContext.request.contextPath}/judge/dashboard" class="btn btn-outline">
                        ← Back to Queue
                    </a>
                    <div class="flex-row gap-3">
                        <button type="button" class="btn btn-secondary" onclick="submitEvaluation(false)">
                            Save Draft
                        </button>
                        <button type="button" class="btn btn-primary btn-lg" onclick="submitEvaluation(true)">
                            Lock & Submit Final Evaluation 🔒
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</main>

<script>
function updateRubricTotal() {
    const inno = parseFloat(document.getElementById('critInno').value) || 0;
    const tech = parseFloat(document.getElementById('critTech').value) || 0;
    const design = parseFloat(document.getElementById('critDesign').value) || 0;
    const pres = parseFloat(document.getElementById('critPres').value) || 0;
    const feas = parseFloat(document.getElementById('critFeas').value) || 0;

    document.getElementById('valInnoDisplay').textContent = inno.toFixed(1);
    document.getElementById('valTechDisplay').textContent = tech.toFixed(1);
    document.getElementById('valDesignDisplay').textContent = design.toFixed(1);
    document.getElementById('valPresDisplay').textContent = pres.toFixed(1);
    document.getElementById('valFeasDisplay').textContent = feas.toFixed(1);

    // Weighted Formula: 25% + 30% + 20% + 15% + 10%
    const total = (inno * 0.25) + (tech * 0.30) + (design * 0.20) + (pres * 0.15) + (feas * 0.10);
    document.getElementById('totalWeightedScoreDisplay').textContent = total.toFixed(2);
}

function submitEvaluation(isFinal) {
    document.getElementById('isFinalInput').value = isFinal ? 'true' : 'false';
    if (isFinal) {
        if (!confirm('Lock and submit final scores? This will publish your scorecard to the live leaderboard.')) {
            return;
        }
    }
    document.getElementById('rubricForm').submit();
}

// Initial calculation on load
document.addEventListener('DOMContentLoaded', updateRubricTotal);
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
