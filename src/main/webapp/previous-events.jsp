<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Previous Events Showcase (2023–2025) | EventSphere" />
<c:set var="activePage" value="showcase" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />
<jsp:include page="/WEB-INF/views/common/alerts.jsp" />

<main class="page-container">
    <div class="container">
        <!-- Page Header -->
        <div class="page-header text-center">
            <span class="page-eyebrow">HALL OF FAME & LEGACY</span>
            <h1 class="page-title">Previous Events Showcase (2023–2025)</h1>
            <p class="page-subtitle">Celebrate the breakthrough prototypes, winning teams, and enduring campus memories that define our collegiate builder culture.</p>
        </div>

        <!-- Flagship Events Showcase Cards -->
        <section class="showcase-stories-section mt-6">
            <div class="stories-grid">
                <c:forEach var="pe" items="${previousEvents}">
                    <div class="story-card" data-year="${pe.year}">
                        <div class="story-banner-wrap">
                            <img src="${pageContext.request.contextPath}/${pe.coverImage}" alt="${pe.title}" class="story-banner-img" loading="lazy" />
                            <div class="story-year-badge">${pe.year}</div>
                            <span class="story-category-tag">${pe.category}</span>
                        </div>

                        <div class="story-content">
                            <h2 class="story-title">${pe.title}</h2>
                            <p class="story-desc">${pe.description}</p>

                            <!-- Winners & Highlights Grid -->
                            <div class="story-winners-box">
                                <div class="winner-row">
                                    <span class="trophy-icon">🥇</span>
                                    <div>
                                        <small>Grand Champion</small>
                                        <strong>${pe.winnerTeam}</strong>
                                    </div>
                                </div>
                                <div class="winner-row">
                                    <span class="trophy-icon">🥈</span>
                                    <div>
                                        <small>1st Runner Up</small>
                                        <strong>${pe.runnerUpTeam}</strong>
                                    </div>
                                </div>
                            </div>

                            <!-- Meta stats -->
                            <div class="story-stats-row">
                                <span class="sstat-item">👥 <strong>${pe.participantCount}</strong> Builders</span>
                                <span class="sstat-item">💰 <strong>${pe.prizePool}</strong> Pool</span>
                            </div>

                            <!-- Highlights Quote -->
                            <div class="story-highlights-quote">
                                <span>💡 <strong>Impact:</strong> ${pe.highlights}</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>

        <!-- High-Res Interactive Photo Gallery Section -->
        <section class="gallery-showcase-section mt-12">
            <div class="section-header text-center">
                <span class="section-eyebrow">PHOTO VAULT</span>
                <h2 class="section-title">Behind the Screens & On the Stage</h2>
                <p class="section-subtitle">Click any snapshot to launch the high-resolution lightbox view.</p>
            </div>

            <!-- Gallery Filter Pills -->
            <div class="gallery-filter-toolbar">
                <a href="${pageContext.request.contextPath}/previous-events?category=ALL" 
                   class="gallery-filter-btn ${selectedCategory == 'ALL' ? 'active' : ''}">All Photos</a>
                <a href="${pageContext.request.contextPath}/previous-events?category=Coding" 
                   class="gallery-filter-btn ${selectedCategory == 'Coding' ? 'active' : ''}">Coding Sprints</a>
                <a href="${pageContext.request.contextPath}/previous-events?category=Presentation" 
                   class="gallery-filter-btn ${selectedCategory == 'Presentation' ? 'active' : ''}">Jury Pitches</a>
                <a href="${pageContext.request.contextPath}/previous-events?category=Mentorship" 
                   class="gallery-filter-btn ${selectedCategory == 'Mentorship' ? 'active' : ''}">Mentorship</a>
                <a href="${pageContext.request.contextPath}/previous-events?category=Celebration" 
                   class="gallery-filter-btn ${selectedCategory == 'Celebration' ? 'active' : ''}">Gala & Crowd</a>
                <a href="${pageContext.request.contextPath}/previous-events?category=Prize" 
                   class="gallery-filter-btn ${selectedCategory == 'Prize' ? 'active' : ''}">Awards & Trophies</a>
            </div>

            <!-- Masonry Photo Grid -->
            <div class="gallery-masonry-grid mt-6">
                <c:forEach var="photo" items="${photos}">
                    <div class="gallery-card aspect-${photo.aspectRatio != null ? fn:replace(photo.aspectRatio, ':', '-') : '16-9'}"
                         onclick="openLightbox('${pageContext.request.contextPath}/${photo.photoUrl}', '${fn:escapeXml(photo.caption)}', '${photo.category}')">
                        <img src="${pageContext.request.contextPath}/${photo.photoUrl}" alt="${photo.caption}" loading="lazy" />
                        <div class="gallery-card-overlay">
                            <span class="badge badge-primary">${photo.category}</span>
                            <p class="gallery-card-caption">${photo.caption}</p>
                            <span class="gallery-expand-hint">🔍 Expand Lightbox</span>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
