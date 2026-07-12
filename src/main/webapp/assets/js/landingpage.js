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
    if (navbar) {
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
        setTimeout(() => {
            backdrop.classList.remove('opacity-0');
            content.classList.remove('opacity-0', 'scale-95');
            content.classList.add('opacity-100', 'scale-100');
        }, 10);
    }
    window.openAuthModal = openModal;

    function closeModal() {
        backdrop.classList.add('opacity-0');
        content.classList.remove('opacity-100', 'scale-100');
        content.classList.add('opacity-0', 'scale-95');
        document.body.style.overflow = '';
        setTimeout(() => {
            modal.classList.add('hidden');
        }, 300);
    }

    if (openBtn) openBtn.addEventListener('click', openModal);
    if (closeBtn) closeBtn.addEventListener('click', closeModal);
    if (backdrop) backdrop.addEventListener('click', closeModal);

    // Tabs Logic
    if (tabLogin && tabRegister && loginForm && registerForm) {
        tabLogin.addEventListener('click', () => {
            loginForm.classList.remove('hidden');
            registerForm.classList.add('hidden');
            document.getElementById('forgotPasswordForm')?.classList.add('hidden');
            document.getElementById('resetPasswordForm')?.classList.add('hidden');

            tabLogin.classList.remove('text-slate-400', 'hover:text-slate-600');
            tabLogin.classList.add('text-[#6200EE]', 'border-b-2', 'border-[#6200EE]');

            tabRegister.classList.remove('text-[#6200EE]', 'border-b-2', 'border-[#6200EE]');
            tabRegister.classList.add('text-slate-400', 'hover:text-slate-600');
        });

        tabRegister.addEventListener('click', () => {
            registerForm.classList.remove('hidden');
            loginForm.classList.add('hidden');
            document.getElementById('forgotPasswordForm')?.classList.add('hidden');
            document.getElementById('resetPasswordForm')?.classList.add('hidden');

            tabRegister.classList.remove('text-slate-400', 'hover:text-slate-600');
            tabRegister.classList.add('text-[#6200EE]', 'border-b-2', 'border-[#6200EE]');

            tabLogin.classList.remove('text-[#6200EE]', 'border-b-2', 'border-[#6200EE]');
            tabLogin.classList.add('text-slate-400', 'hover:text-slate-600');
        });
    }

    // Forgot Password Form Toggle
    const forgotPasswordLink = document.getElementById('forgotPasswordLink');
    const backToLoginFromForgot = document.getElementById('backToLoginFromForgot');
    const forgotPasswordForm = document.getElementById('forgotPasswordForm');
    
    if (forgotPasswordLink && forgotPasswordForm && loginForm) {
        forgotPasswordLink.addEventListener('click', (e) => {
            e.preventDefault();
            loginForm.classList.add('hidden');
            forgotPasswordForm.classList.remove('hidden');
        });
    }

    if (backToLoginFromForgot && forgotPasswordForm && loginForm) {
        backToLoginFromForgot.addEventListener('click', (e) => {
            e.preventDefault();
            forgotPasswordForm.classList.add('hidden');
            loginForm.classList.remove('hidden');
        });
    }

    // --- Utility: Enter key to navigate and submit ---
    function setupEnterToNext(formId, submitBtnId) {
        const form = document.getElementById(formId);
        if (!form) return;
        
        // Find all visible, non-hidden inputs
        const inputs = Array.from(form.querySelectorAll('input:not([type="hidden"])'));
        const submitBtn = document.getElementById(submitBtnId);

        inputs.forEach((input, index) => {
            input.addEventListener('keydown', (e) => {
                if (e.key === 'Enter') {
                    e.preventDefault(); // Prevent default form submission if any
                    
                    // If there's a next input, focus it
                    if (index < inputs.length - 1) {
                        inputs[index + 1].focus();
                    } else {
                        // Otherwise, click the submit button
                        if (submitBtn && !submitBtn.disabled) {
                            submitBtn.click();
                        }
                    }
                }
            });
        });
    }

    // Apply to Login and Register forms
    setupEnterToNext('loginForm', 'loginBtn');
    setupEnterToNext('registerForm', 'registerBtn');

    // --- Authentication API Logic ---

    const sendOtpBtn = document.getElementById('sendOtpBtn');
    const registerBtn = document.getElementById('registerBtn');
    const loginBtn = document.getElementById('loginBtn');

    // Send OTP
    if (sendOtpBtn) {
        sendOtpBtn.addEventListener('click', () => {
            const phone = document.getElementById('registerPhone').value.trim();
            const email = document.getElementById('registerEmail').value.trim();
            
            if (!phone || !/^(0[3|5|7|8|9])+([0-9]{8})$/.test(phone)) {
                showToast('Vui lòng nhập số điện thoại hợp lệ (Ví dụ: 0912345678).', 'error');
                return;
            }

            if (!email || !/^[A-Za-z0-9+_.-]+@(.+)$/.test(email)) {
                showToast('Vui lòng nhập địa chỉ email hợp lệ.', 'error');
                return;
            }

            sendOtpBtn.disabled = true;
            sendOtpBtn.innerText = 'Đang gửi...';

            fetch(window.CONTEXT_PATH + '/api/send-otp', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ phoneNumber: phone, email: email })
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        showToast(data.message, 'success');
                        
                        let timeLeft = 30;
                        sendOtpBtn.innerText = `Gửi lại (${timeLeft}s)`;
                        
                        const timer = setInterval(() => {
                            timeLeft--;
                            if (timeLeft <= 0) {
                                clearInterval(timer);
                                sendOtpBtn.disabled = false;
                                sendOtpBtn.innerText = 'Gửi lại mã';
                            } else {
                                sendOtpBtn.innerText = `Gửi lại (${timeLeft}s)`;
                            }
                        }, 1000);
                        // Note: Mã OTP sẽ hiển thị trên Console của IDE theo yêu cầu
                    } else {
                        showToast(data.message, 'error');
                        sendOtpBtn.disabled = false;
                        sendOtpBtn.innerText = 'Gửi mã';
                    }
                })
                .catch(err => {
                    console.error(err);
                    showToast('Có lỗi xảy ra khi kết nối đến máy chủ.', 'error');
                    sendOtpBtn.disabled = false;
                    sendOtpBtn.innerText = 'Gửi mã';
                });
        });
    }

    // Register Submit
    if (registerBtn) {
        registerBtn.addEventListener('click', () => {
            const phone = document.getElementById('registerPhone').value.trim();
            const email = document.getElementById('registerEmail').value.trim();
            const otpCode = document.getElementById('registerOtp').value.trim();
            const password = document.getElementById('registerPassword').value;

            if (!phone || !email || !otpCode || !password) {
                showToast('Vui lòng nhập đầy đủ thông tin đăng ký.', 'warning');
                return;
            }

            registerBtn.disabled = true;
            registerBtn.innerText = 'Đang đăng ký...';

            fetch(window.CONTEXT_PATH + '/api/register', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    phoneNumber: phone,
                    email: email,
                    otpCode: otpCode,
                    password: password
                })
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        showToast(data.message, 'success');
                        closeModal();
                        if (data.needsOnboarding && window.openOnboardingModal) {
                            window.openOnboardingModal();
                        } else {
                            window.location.href = window.CONTEXT_PATH + '/dashboard';
                        }
                    } else {
                        showToast(data.message, 'error');
                        registerBtn.disabled = false;
                        registerBtn.innerText = 'Đăng ký ngay';
                    }
                })
                .catch(err => {
                    console.error(err);
                    showToast('Có lỗi xảy ra khi kết nối đến máy chủ.', 'error');
                    registerBtn.disabled = false;
                    registerBtn.innerText = 'Đăng ký ngay';
                });
        });
    }

    // Login Submit
    if (loginBtn) {
        loginBtn.addEventListener('click', () => {
            const email = document.getElementById('loginEmail').value.trim();
            const password = document.getElementById('loginPassword').value;

            if (!email || !password) {
                showToast('Vui lòng nhập đủ email và mật khẩu.', 'warning');
                return;
            }

            loginBtn.disabled = true;
            loginBtn.innerText = 'Đang xử lý...';

            fetch(window.CONTEXT_PATH + '/api/login', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    email: email,
                    password: password
                })
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        const welcomeMsg = data.userName ? ' Chào mừng bạn, ' + data.userName + '!' : '';
                        showToast(data.message + welcomeMsg, 'success');
                        
                        if (data.needsPasswordReset) {
                            // Hide login, show reset form
                            loginForm.classList.add('hidden');
                            document.getElementById('resetPasswordForm').classList.remove('hidden');
                            loginBtn.disabled = false;
                            loginBtn.innerText = 'Đăng nhập';
                        } else if (data.needsOnboarding && window.openOnboardingModal) {
                            closeModal();
                            window.openOnboardingModal();
                        } else {
                            closeModal();
                            if (data.role === 'admin') {
                                window.location.href = window.CONTEXT_PATH + '/admintranscake';
                            } else {
                                window.location.href = window.CONTEXT_PATH + '/dashboard';
                            }
                        }
                    } else {
                        showToast(data.message, 'error');
                        loginBtn.disabled = false;
                        loginBtn.innerText = 'Đăng nhập';
                    }
                })
                .catch(err => {
                    console.error(err);
                    showToast('Có lỗi xảy ra khi kết nối đến máy chủ.', 'error');
                    loginBtn.disabled = false;
                    loginBtn.innerText = 'Đăng nhập';
                });
        });
    }

    // Forgot Password Submit
    const submitForgotBtn = document.getElementById('submitForgotBtn');
    if (submitForgotBtn) {
        submitForgotBtn.addEventListener('click', () => {
            const email = document.getElementById('forgotEmail').value.trim();
            if (!email || !/^[A-Za-z0-9+_.-]+@(.+)$/.test(email)) {
                showToast('Vui lòng nhập địa chỉ email hợp lệ.', 'error');
                return;
            }

            submitForgotBtn.disabled = true;
            submitForgotBtn.innerText = 'Đang gửi...';

            fetch(window.CONTEXT_PATH + '/api/forgot-password', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ email: email })
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    showToast(data.message, 'success');
                    // Go back to login
                    document.getElementById('forgotPasswordForm').classList.add('hidden');
                    loginForm.classList.remove('hidden');
                } else {
                    showToast(data.message, 'error');
                }
            })
            .catch(err => {
                console.error(err);
                showToast('Lỗi máy chủ', 'error');
            })
            .finally(() => {
                submitForgotBtn.disabled = false;
                submitForgotBtn.innerText = 'Gửi mật khẩu mới';
            });
        });
    }

    // Reset Password Submit
    const submitResetBtn = document.getElementById('submitResetBtn');
    if (submitResetBtn) {
        submitResetBtn.addEventListener('click', () => {
            const newPassword = document.getElementById('resetNewPassword').value;
            const confirmPassword = document.getElementById('resetConfirmPassword').value;

            if (!newPassword || !confirmPassword) {
                showToast('Vui lòng nhập đầy đủ mật khẩu mới.', 'warning');
                return;
            }

            if (newPassword !== confirmPassword) {
                showToast('Mật khẩu xác nhận không khớp.', 'error');
                return;
            }

            submitResetBtn.disabled = true;
            submitResetBtn.innerText = 'Đang cập nhật...';

            fetch(window.CONTEXT_PATH + '/api/reset-password', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ newPassword: newPassword, confirmPassword: confirmPassword })
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    showToast(data.message, 'success');
                    if (data.needsOnboarding && window.openOnboardingModal) {
                        closeModal();
                        window.openOnboardingModal();
                    } else {
                        closeModal();
                        window.location.href = window.CONTEXT_PATH + '/dashboard';
                    }
                } else {
                    showToast(data.message, 'error');
                }
            })
            .catch(err => {
                console.error(err);
                showToast('Lỗi máy chủ', 'error');
            })
            .finally(() => {
                submitResetBtn.disabled = false;
                submitResetBtn.innerText = 'Lưu mật khẩu & Tiếp tục';
            });
        });
    }
});