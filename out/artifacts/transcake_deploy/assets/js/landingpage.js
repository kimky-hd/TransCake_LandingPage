function closeMobileMenu() {
    const menu = document.getElementById('mobile-menu');
    menu.classList.add('translate-x-full');
    document.body.style.overflow = '';
}

document.addEventListener('DOMContentLoaded', () => {
    const menuBtn = document.getElementById('mobile-menu-btn');
    const menuClose = document.getElementById('mobile-menu-close');
    const menuOverlay = document.getElementById('mobile-menu-overlay');
    const mobileMenu = document.getElementById('mobile-menu');

    if (menuBtn && mobileMenu) {
        menuBtn.addEventListener('click', () => {
            mobileMenu.classList.remove('translate-x-full');
            document.body.style.overflow = 'hidden';
        });
    }
    if (menuClose) {
        menuClose.addEventListener('click', closeMobileMenu);
    }
    if (menuOverlay) {
        menuOverlay.addEventListener('click', closeMobileMenu);
    }
});

// Scroll Spy & Smooth Scroll Script
document.addEventListener('DOMContentLoaded', () => {
    const navLinks = document.querySelectorAll('.nav-link');
    const sections = document.querySelectorAll('section[id], footer[id]');

    // Smooth Scroll
    navLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const targetId = link.getAttribute('href');
            const targetSection = document.querySelector(targetId);

            if (targetSection) {
                window.scrollTo({
                    top: targetSection.offsetTop - 80, // Offset for fixed navbar
                    behavior: 'smooth'
                });
            }
        });
    });

    // Scroll Spy
    const observerOptions = {
        root: null,
        rootMargin: '-20% 0px -70% 0px', // Adjust trigger point
        threshold: 0
    };

    const observerCallback = (entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const id = entry.target.getAttribute('id');
                navLinks.forEach(link => {
                    link.classList.remove('active');
                    if (link.getAttribute('href') === `#${id}`) {
                        link.classList.add('active');
                    }
                });
            }
        });
    };

    const observer = new IntersectionObserver(observerCallback, observerOptions);
    sections.forEach(section => observer.observe(section));
});

// Adjust navbar background on scroll
document.addEventListener('DOMContentLoaded', () => {
    const navbar = document.getElementById("navbar");
    if(navbar) {
        window.addEventListener("scroll", () => {
            if (window.scrollY > 50) {
                navbar.classList.add("scale-95");
                navbar.classList.remove("mt-5");
            } else {
                navbar.classList.remove("scale-95");
            }
        });
    }
});

// Auth Modal Logic
document.addEventListener('DOMContentLoaded', () => {
    const openBtn = document.getElementById('openAuthModalBtn');
    const modal = document.getElementById('authModal');
    const backdrop = document.getElementById('authModalBackdrop');
    const content = document.getElementById('authModalContent');
    const closeBtn = document.getElementById('closeAuthModalBtn');
    
    const tabLogin = document.getElementById('tabLogin');
    const tabRegister = document.getElementById('tabRegister');
    const loginForm = document.getElementById('loginForm');
    const registerForm = document.getElementById('registerForm');

    function openModal() {
        modal.classList.remove('hidden');
        document.body.style.overflow = 'hidden';
        // Small delay to allow display:block to apply before animating opacity
        setTimeout(() => {
            backdrop.classList.remove('opacity-0');
            content.classList.remove('opacity-0', 'scale-95');
            content.classList.add('opacity-100', 'scale-100');
        }, 10);
    }

    function closeModal() {
        backdrop.classList.add('opacity-0');
        content.classList.remove('opacity-100', 'scale-100');
        content.classList.add('opacity-0', 'scale-95');
        document.body.style.overflow = '';
        setTimeout(() => {
            modal.classList.add('hidden');
        }, 300);
    }

    if(openBtn) openBtn.addEventListener('click', openModal);
    if(closeBtn) closeBtn.addEventListener('click', closeModal);
    if(backdrop) backdrop.addEventListener('click', closeModal);

    // Tabs Logic
    if(tabLogin && tabRegister && loginForm && registerForm) {
        tabLogin.addEventListener('click', () => {
            loginForm.classList.remove('hidden');
            registerForm.classList.add('hidden');
            
            tabLogin.classList.remove('text-slate-400', 'hover:text-slate-600');
            tabLogin.classList.add('text-[#6200EE]', 'border-b-2', 'border-[#6200EE]');
            
            tabRegister.classList.remove('text-[#6200EE]', 'border-b-2', 'border-[#6200EE]');
            tabRegister.classList.add('text-slate-400', 'hover:text-slate-600');
        });

        tabRegister.addEventListener('click', () => {
            registerForm.classList.remove('hidden');
            loginForm.classList.add('hidden');
            
            tabRegister.classList.remove('text-slate-400', 'hover:text-slate-600');
            tabRegister.classList.add('text-[#6200EE]', 'border-b-2', 'border-[#6200EE]');
            
            tabLogin.classList.remove('text-[#6200EE]', 'border-b-2', 'border-[#6200EE]');
            tabLogin.classList.add('text-slate-400', 'hover:text-slate-600');
        });
    }
});