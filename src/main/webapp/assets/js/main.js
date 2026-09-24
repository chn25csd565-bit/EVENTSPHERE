/**
 * EventSphere Interactive Script
 */

document.addEventListener('DOMContentLoaded', () => {

  // 1. Mobile Menu Toggle
  const mobileBtn = document.querySelector('.mobile-menu-btn');
  const navLinks = document.querySelector('.nav-links');
  if (mobileBtn && navLinks) {
    mobileBtn.addEventListener('click', () => {
      const isVisible = navLinks.style.display === 'flex';
      navLinks.style.display = isVisible ? 'none' : 'flex';
      navLinks.style.flexDirection = 'column';
      navLinks.style.position = 'absolute';
      navLinks.style.top = '100%';
      navLinks.style.left = '0';
      navLinks.style.width = '100%';
      navLinks.style.background = 'rgba(10, 13, 20, 0.98)';
      navLinks.style.padding = '1.5rem';
      navLinks.style.borderBottom = '1px solid rgba(255,255,255,0.1)';
    });
  }

  // 2. Countdown Clocks
  const countdownElements = document.querySelectorAll('[data-countdown]');
  if (countdownElements.length > 0) {
    const updateCountdowns = () => {
      const now = new Date().getTime();
      countdownElements.forEach(el => {
        const targetTime = new Date(el.getAttribute('data-countdown')).getTime();
        const diff = targetTime - now;

        if (diff <= 0) {
          el.innerHTML = '<span class="status-closed">Event Started / Closed</span>';
          return;
        }

        const days = Math.floor(diff / (1000 * 60 * 60 * 24));
        const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((diff % (1000 * 60)) / 1000);

        el.innerHTML = `
          <div class="countdown-unit"><span>${days}</span><label>Days</label></div>
          <div class="countdown-unit"><span>${hours}</span><label>Hours</label></div>
          <div class="countdown-unit"><span>${minutes}</span><label>Mins</label></div>
          <div class="countdown-unit"><span>${seconds}</span><label>Secs</label></div>
        `;
      });
    };
    updateCountdowns();
    setInterval(updateCountdowns, 1000);
  }

  // 3. Rubric Dynamic Score Calculator (Judge Evaluation)
  const rubricForm = document.getElementById('rubricForm');
  if (rubricForm) {
    const innov = document.getElementById('criteriaInnovation');
    const tech = document.getElementById('criteriaTechnical');
    const design = document.getElementById('criteriaDesign');
    const pres = document.getElementById('criteriaPresentation');
    const feas = document.getElementById('criteriaFeasibility');
    const totalDisplay = document.getElementById('totalWeightedScoreDisplay');

    const updateScore = () => {
      const vInnov = parseFloat(innov ? innov.value : 0) || 0;
      const vTech = parseFloat(tech ? tech.value : 0) || 0;
      const vDesign = parseFloat(design ? design.value : 0) || 0;
      const vPres = parseFloat(pres ? pres.value : 0) || 0;
      const vFeas = parseFloat(feas ? feas.value : 0) || 0;

      // Update value display spans
      ['criteriaInnovation', 'criteriaTechnical', 'criteriaDesign', 'criteriaPresentation', 'criteriaFeasibility'].forEach(id => {
        const input = document.getElementById(id);
        const valSpan = document.getElementById(id + 'Val');
        if (input && valSpan) {
          valSpan.textContent = parseFloat(input.value).toFixed(1);
        }
      });

      // Innovation 25%, Technical 30%, Design 20%, Presentation 15%, Feasibility 10%
      const total = (vInnov * 0.25) + (vTech * 0.30) + (vDesign * 0.20) + (vPres * 0.15) + (vFeas * 0.10);
      if (totalDisplay) {
        totalDisplay.textContent = total.toFixed(2);
      }
    };

    [innov, tech, design, pres, feas].forEach(slider => {
      if (slider) {
        slider.addEventListener('input', updateScore);
      }
    });

    updateScore();
  }

  // 4. Photo Gallery Lightbox
  const lightboxModal = document.getElementById('lightboxModal');
  const lightboxImg = document.getElementById('lightboxImg');
  const lightboxCaption = document.getElementById('lightboxCaption');
  const lightboxClose = document.getElementById('lightboxClose');

  document.querySelectorAll('[data-lightbox]').forEach(item => {
    item.addEventListener('click', (e) => {
      e.preventDefault();
      const imgUrl = item.getAttribute('data-img-src') || item.querySelector('img').src;
      const caption = item.getAttribute('data-caption') || '';

      if (lightboxModal && lightboxImg) {
        lightboxImg.src = imgUrl;
        if (lightboxCaption) lightboxCaption.textContent = caption;
        lightboxModal.classList.add('active');
      }
    });
  });

  if (lightboxClose && lightboxModal) {
    lightboxClose.addEventListener('click', () => {
      lightboxModal.classList.remove('active');
    });

    lightboxModal.addEventListener('click', (e) => {
      if (e.target === lightboxModal) {
        lightboxModal.classList.remove('active');
      }
    });

    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && lightboxModal.classList.contains('active')) {
        lightboxModal.classList.remove('active');
      }
    });
  }

  // 5. Registration Modal Tab Switching
  const regTabs = document.querySelectorAll('[data-reg-tab]');
  regTabs.forEach(tab => {
    tab.addEventListener('click', () => {
      regTabs.forEach(t => t.classList.remove('active'));
      tab.classList.add('active');
      const targetType = tab.getAttribute('data-reg-tab');
      const regTypeInput = document.getElementById('regTypeInput');
      if (regTypeInput) regTypeInput.value = targetType;

      document.querySelectorAll('.reg-panel').forEach(panel => {
        panel.style.display = panel.id === targetType + 'Panel' ? 'block' : 'none';
      });
    });
  });

  // 6. Auto-dismiss Toast alerts after 4s
  const toasts = document.querySelectorAll('.toast');
  toasts.forEach(toast => {
    setTimeout(() => {
      toast.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
      toast.style.opacity = '0';
      toast.style.transform = 'translateY(10px)';
      setTimeout(() => toast.remove(), 400);
    }, 4500);
  });

});
