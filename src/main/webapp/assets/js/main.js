document.addEventListener("DOMContentLoaded", () => {
    // 1. Initialize Lenis Smooth Scrolling Engine
    const lenis = new Lenis({
        duration: 1.2,
        easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)), 
        smooth: true,
    });

    function raf(time) {
        lenis.raf(time);
        requestAnimationFrame(raf);
    }
    requestAnimationFrame(raf);

    // Integrate GSAP with Lenis
    gsap.registerPlugin(ScrollTrigger);

    // 2. Hero Section Parallax & Entrance
    gsap.from(".mockup-glass", {
        y: 50,
        opacity: 0,
        duration: 1.5,
        ease: "power4.out",
        delay: 0.2
    });

    gsap.from(".phone-frame", {
        y: 100,
        opacity: 0,
        duration: 1.5,
        stagger: 0.2,
        ease: "power3.out",
        delay: 0.5
    });

    // 3. Generic Reveal Animations (Fade up)
    const revealElements = document.querySelectorAll('section > div > h2, section > div > h3, .trust-card');
    revealElements.forEach((el) => {
        gsap.fromTo(el, 
            { opacity: 0, y: 40 },
            { 
                opacity: 1, 
                y: 0, 
                duration: 1, 
                ease: "power3.out",
                scrollTrigger: {
                    trigger: el,
                    start: "top 85%",
                    toggleActions: "play none none reverse"
                }
            }
        );
    });

    // 4. Parallax on phones in Deep Dive sections
    const deepDivePhones = document.querySelectorAll('.perspective-1000 .phone-frame');
    deepDivePhones.forEach((phone) => {
        gsap.to(phone, {
            y: -50,
            scrollTrigger: {
                trigger: phone.parentElement,
                start: "top bottom",
                end: "bottom top",
                scrub: 1
            }
        });
    });

    // 5. 3D card hover effect reset (Cost Sharing Section)
    const cards = document.querySelectorAll('.preserve-3d.hover\\:rotate-0');
    cards.forEach(card => {
        // Elements already have CSS transitions for hover
        // This is just a fallback to ensure smooth interaction if needed
    });



});
