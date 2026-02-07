document.addEventListener('DOMContentLoaded', () => {
    // Intersection Observer for Fade-up Animations
    const observerOptions = {
        root: null,
        rootMargin: '0px',
        threshold: 0.25 // Trigger when 25% visible
    };

    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    // Select elements to animate using the new class name
    const hiddenElements = document.querySelectorAll('.fade-up');
    hiddenElements.forEach((el) => {
        observer.observe(el);
    });

    // Smooth Scrolling for Navigation Links & Buttons
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            if (targetId === '#') return;

            const targetElement = document.querySelector(targetId);
            if (targetElement) {
                targetElement.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
});
