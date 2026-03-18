<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <title>Transcake - Next Gen Social Ride Hailing</title>

        <!-- Tailwind CSS -->
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <script src="${pageContext.request.contextPath}/assets/js/tailwind-config.js"></script>

        <!-- Google Fonts & Material Symbols -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap"
            rel="stylesheet" />
        <link
            href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400..900;1,400..900&display=swap"
            rel="stylesheet" />
        <link
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
            rel="stylesheet" />

        <!-- GSAP & Lenis Smooth Scroll -->
        <script src="https://unpkg.com/@studio-freight/lenis@1.0.34/dist/lenis.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/ScrollTrigger.min.js"></script>

        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css" />
        <style>
            /* Specific page styles embedded for convenience */
            .mockup-glass {
                background: rgba(255, 255, 255, 0.45);
                backdrop-filter: blur(24px) saturate(150%);
                -webkit-backdrop-filter: blur(24px) saturate(150%);
                border: 1px solid rgba(255, 255, 255, 0.6);
                box-shadow: 0 24px 48px -12px rgba(0, 0, 0, 0.15);
            }

            .phone-frame {
                background: #fff;
                border-radius: 2.5rem;
                border: 8px solid #1e293b;
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
                position: relative;
                overflow: hidden;
            }

            .phone-notch {
                position: absolute;
                top: 0;
                left: 50%;
                transform: translateX(-50%);
                width: 40%;
                height: 24px;
                background: #1e293b;
                border-bottom-left-radius: 16px;
                border-bottom-right-radius: 16px;
                z-index: 50;
            }

            .purple-gradient-text {
                background: linear-gradient(135deg, #6200EE 0%, #b84bf0 100%);
                -webkit-background-clip: text;
                background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            .hero-bg {
                background-image: url('${pageContext.request.contextPath}/img/Gemini_Generated_Image_tji7owtji7owtji7.png');
                background-size: cover;
                background-position: center 20%;
            }

            .tags-anim {
                animation: float 6s ease-in-out infinite;
            }

            @keyframes float {

                0%,
                100% {
                    transform: translateY(0px);
                }

                50% {
                    transform: translateY(-10px);
                }
            }

            /* Phone floating animations */
            .float-phone-left {
                animation: floatPhoneLeft 7s ease-in-out infinite;
            }

            .float-phone-right {
                animation: floatPhoneRight 8s ease-in-out infinite;
            }

            @keyframes floatPhoneLeft {

                0%,
                100% {
                    transform: rotate(-12deg) translateY(0px);
                }

                50% {
                    transform: rotate(-12deg) translateY(-18px);
                }
            }

            @keyframes floatPhoneRight {

                0%,
                100% {
                    transform: rotate(12deg) translateY(0px);
                }

                50% {
                    transform: rotate(12deg) translateY(-14px);
                }
            }

            /* Floating asset tag animations — staggered delays for depth */
            .float-1 {
                animation: floatTag 5s ease-in-out infinite;
                animation-delay: 0s;
            }

            .float-2 {
                animation: floatTag 6.5s ease-in-out infinite;
                animation-delay: -1.5s;
            }

            .float-3 {
                animation: floatTag 7s ease-in-out infinite;
                animation-delay: -3s;
            }

            .float-4 {
                animation: floatTag 5.5s ease-in-out infinite;
                animation-delay: -4.5s;
            }

            @keyframes floatTag {

                0%,
                100% {
                    transform: translateY(0px) scale(1);
                }

                50% {
                    transform: translateY(-12px) scale(1.02);
                }
            }

            /* Active Link Glow */
            .nav-link.active {
                color: #6200EE !important;
                text-shadow: 0 0 15px rgba(98, 0, 238, 0.4);
                position: relative;
            }

            .nav-link.active::after {
                content: '';
                position: absolute;
                bottom: -4px;
                left: 0;
                width: 100%;
                height: 2px;
                background: #6200EE;
                box-shadow: 0 0 10px rgba(98, 0, 238, 0.6);
                border-radius: 2px;
            }
        </style>
    </head>

    <body class="font-sans antialiased bg-[#fcfcfd] text-slate-800 overflow-x-hidden">

        <!-- Navbar -->
        <header id="main-header"
            class="fixed top-0 left-0 right-0 z-50 px-3 sm:px-4 md:px-8 py-2 sm:py-3 pointer-events-none">
            <nav class="max-w-7xl mx-auto mockup-glass rounded-full px-4 sm:px-6 md:px-8 py-2.5 sm:py-3 flex items-center justify-between shadow-md pointer-events-auto"
                id="navbar">
                <div class="flex items-center relative h-6 w-24 sm:w-32">
                    <img src="${pageContext.request.contextPath}/img/transcake-03.png" alt="Transcake Logo"
                        class="absolute left-0 h-10 sm:h-14 md:h-16 w-auto object-contain">
                </div>
                <div class="hidden lg:flex items-center gap-10">
                    <a class="nav-link text-sm font-semibold text-slate-700 hover:text-primary transition-colors"
                        href="#about">Về chúng tôi</a>
                    <a class="nav-link text-sm font-semibold text-slate-700 hover:text-primary transition-colors"
                        href="#features">Tính năng</a>
                    <a class="nav-link text-sm font-semibold text-slate-700 hover:text-primary transition-colors"
                        href="#how-it-works">Hướng dẫn</a>
                    <a class="nav-link text-sm font-semibold text-slate-700 hover:text-primary transition-colors"
                        href="#pricing">Bảng giá</a>
                    <a class="nav-link text-sm font-semibold text-slate-700 hover:text-primary transition-colors"
                        href="#contact">Contact us</a>
                </div>
                <div class="flex items-center gap-3">
                    <button
                        class="hidden sm:block bg-accent text-white px-4 sm:px-6 py-2 rounded-full font-bold text-xs sm:text-sm hover:scale-105 transition-transform shadow-md shadow-accent/40">
                        Tải ứng dụng
                    </button>
                    <!-- Hamburger Menu Button (Mobile) -->
                    <button id="mobile-menu-btn"
                        class="lg:hidden flex flex-col gap-1.5 p-2 rounded-xl hover:bg-white/30 transition-colors"
                        aria-label="Menu">
                        <span class="block w-5 h-0.5 bg-slate-700 rounded-full transition-all duration-300"
                            id="burger-line-1"></span>
                        <span class="block w-5 h-0.5 bg-slate-700 rounded-full transition-all duration-300"
                            id="burger-line-2"></span>
                        <span class="block w-3.5 h-0.5 bg-slate-700 rounded-full transition-all duration-300"
                            id="burger-line-3"></span>
                    </button>
                </div>
            </nav>
            <!-- Mobile Menu Drawer -->
            <div id="mobile-menu"
                class="lg:hidden pointer-events-auto fixed inset-0 z-[100] translate-x-full transition-transform duration-300 ease-in-out">
                <div class="absolute inset-0 bg-black/40 backdrop-blur-sm" id="mobile-menu-overlay"></div>
                <div
                    class="absolute right-0 top-0 h-full w-72 sm:w-80 bg-white/95 backdrop-blur-2xl shadow-2xl p-8 pt-20 flex flex-col gap-2">
                    <button id="mobile-menu-close"
                        class="absolute top-5 right-5 w-10 h-10 flex items-center justify-center rounded-full hover:bg-slate-100 transition-colors">
                        <span class="material-symbols-outlined text-slate-600">close</span>
                    </button>
                    <a class="nav-link text-lg font-semibold text-slate-700 hover:text-primary transition-colors py-3 border-b border-slate-100"
                        href="#about" onclick="closeMobileMenu()">Về chúng tôi</a>
                    <a class="nav-link text-lg font-semibold text-slate-700 hover:text-primary transition-colors py-3 border-b border-slate-100"
                        href="#features" onclick="closeMobileMenu()">Tính năng</a>
                    <a class="nav-link text-lg font-semibold text-slate-700 hover:text-primary transition-colors py-3 border-b border-slate-100"
                        href="#how-it-works" onclick="closeMobileMenu()">Hướng dẫn</a>
                    <a class="nav-link text-lg font-semibold text-slate-700 hover:text-primary transition-colors py-3 border-b border-slate-100"
                        href="#pricing" onclick="closeMobileMenu()">Bảng giá</a>
                    <a class="nav-link text-lg font-semibold text-slate-700 hover:text-primary transition-colors py-3 border-b border-slate-100"
                        href="#contact" onclick="closeMobileMenu()">Contact us</a>
                    <button
                        class="mt-6 bg-accent text-white px-6 py-3 rounded-full font-bold text-sm hover:scale-105 transition-transform shadow-md shadow-accent/40 w-full">
                        Tải ứng dụng
                    </button>
                </div>
            </div>
        </header>

        <!-- Hero Section -->
        <section id="hero"
            class="relative w-full min-h-screen flex items-center justify-center hero-bg overflow-hidden">
            <!-- Dark overlay -->
            <div
                class="absolute inset-0 bg-gradient-to-b from-black/50 via-purple-950/30 to-black/60 pointer-events-none">
            </div>

            <!-- LEFT PHONE (7.png) -->
            <div class="absolute left-0 bottom-[8%] z-10 float-phone-left pointer-events-none hidden md:block"
                style="width: clamp(220px, 32vw, 520px); transform: rotate(-8deg) translateX(4%);">
                <img src="${pageContext.request.contextPath}/img/7.png"
                    class="w-full h-auto drop-shadow-[0_40px_50px_rgba(0,0,0,0.6)]" />
            </div>

            <!-- RIGHT PHONE (8.png) -->
            <div class="absolute right-0 bottom-[8%] z-10 float-phone-right pointer-events-none hidden md:block"
                style="width: clamp(220px, 32vw, 520px); transform: rotate(8deg) translateX(-4%);">
                <img src="${pageContext.request.contextPath}/img/8.png"
                    class="w-full h-auto drop-shadow-[0_40px_50px_rgba(0,0,0,0.6)]" />
            </div>

            <!-- Desktop-only floating emojis -->
            <div class="absolute top-[22%] left-[18%] z-20 float-1 text-3xl pointer-events-none select-none hidden sm:block"
                style="filter: drop-shadow(0 2px 8px rgba(0,0,0,0.5));">&#127925;</div>
            <div class="absolute top-[18%] left-[26%] z-20 float-2 text-2xl pointer-events-none select-none hidden md:block"
                style="filter: drop-shadow(0 2px 8px rgba(0,0,0,0.5)); color: #00E676;">&#127925;</div>
            <div class="absolute bottom-[28%] left-[22%] z-20 float-3 text-2xl pointer-events-none select-none hidden md:block"
                style="filter: drop-shadow(0 2px 8px rgba(0,0,0,0.5));">&#127936;</div>
            <div class="absolute bottom-[16%] left-[28%] z-20 float-4 hidden md:block">
                <div
                    class="flex items-center gap-2 bg-[#2a1a4e]/80 backdrop-blur-md border border-purple-500/30 px-5 py-2.5 rounded-full shadow-lg shadow-purple-900/40">
                    <span class="text-base">&#127925;</span>
                    <span class="text-white font-bold text-sm tracking-wide">Music</span>
                </div>
            </div>
            <div class="absolute top-[22%] right-[20%] z-20 float-2 hidden md:block">
                <div
                    class="flex items-center gap-2 bg-[#2a1a4e]/80 backdrop-blur-md border border-purple-500/30 px-5 py-2.5 rounded-full shadow-lg shadow-purple-900/40">
                    <span class="text-base">&#127925;</span>
                    <span class="text-white font-bold text-sm tracking-wide">Music</span>
                </div>
            </div>
            <div class="absolute bottom-[16%] right-[26%] z-20 float-3 hidden md:block">
                <div
                    class="flex items-center gap-2 bg-[#2a1a4e]/80 backdrop-blur-md border border-purple-500/30 px-5 py-2.5 rounded-full shadow-lg shadow-purple-900/40">
                    <span class="text-base">&#128187;</span>
                    <span class="text-white font-bold text-sm tracking-wide">Tech</span>
                </div>
            </div>
            <div
                class="absolute bottom-[20%] right-[14%] z-20 float-1 text-white/60 text-xl pointer-events-none hidden sm:block">
                &#10022;</div>
            <div
                class="absolute top-[40%] left-[10%] z-20 float-3 text-white/40 text-base pointer-events-none hidden sm:block">
                &#10022;
            </div>

            <!-- ===== MOBILE-ONLY Decorations ===== -->
            <!-- Glowing gradient ring behind card -->
            <div class="absolute z-20 w-[320px] h-[320px] rounded-full pointer-events-none md:hidden"
                style="background: conic-gradient(from 0deg, rgba(98,0,238,0.3), rgba(255,109,0,0.2), rgba(98,0,238,0.3)); filter: blur(50px); animation: spin 20s linear infinite;">
            </div>
            <!-- Mobile floating pills (smaller, repositioned) -->
            <div class="absolute top-[15%] left-[5%] z-20 float-1 md:hidden pointer-events-none">
                <div class="bg-white/10 backdrop-blur-md border border-white/20 px-3 py-1.5 rounded-full shadow-lg">
                    <span class="text-white font-bold text-[10px] tracking-wide">&#127925; Music</span>
                </div>
            </div>
            <div class="absolute top-[20%] right-[8%] z-20 float-2 md:hidden pointer-events-none">
                <div class="bg-white/10 backdrop-blur-md border border-white/20 px-3 py-1.5 rounded-full shadow-lg">
                    <span class="text-white font-bold text-[10px] tracking-wide">&#128187; Tech</span>
                </div>
            </div>
            <div class="absolute bottom-[22%] left-[8%] z-20 float-3 md:hidden pointer-events-none">
                <div class="bg-white/10 backdrop-blur-md border border-white/20 px-3 py-1.5 rounded-full shadow-lg">
                    <span class="text-white font-bold text-[10px] tracking-wide">&#127936; Sport</span>
                </div>
            </div>
            <div class="absolute bottom-[18%] right-[10%] z-20 float-4 md:hidden pointer-events-none">
                <div
                    class="bg-[#6200EE]/30 backdrop-blur-md border border-purple-400/20 px-3 py-1.5 rounded-full shadow-lg">
                    <span class="text-white font-bold text-[10px] tracking-wide">&#10024; Transcake</span>
                </div>
            </div>
            <!-- Small sparkle dots for mobile -->
            <div
                class="absolute top-[30%] left-[15%] z-20 w-1.5 h-1.5 bg-white/40 rounded-full float-1 md:hidden pointer-events-none">
            </div>
            <div
                class="absolute top-[25%] right-[18%] z-20 w-1 h-1 bg-purple-300/50 rounded-full float-2 md:hidden pointer-events-none">
            </div>
            <div
                class="absolute bottom-[30%] left-[25%] z-20 w-2 h-2 bg-orange-300/30 rounded-full float-3 md:hidden pointer-events-none">
            </div>
            <div
                class="absolute bottom-[35%] right-[20%] z-20 w-1 h-1 bg-white/50 rounded-full float-4 md:hidden pointer-events-none">
            </div>

            <!-- CENTER CARD (dark glassmorphism) -->
            <div class="relative z-30 mx-4 sm:mx-auto text-center px-5 sm:px-8 md:px-10 py-8 sm:py-10 md:py-12 max-w-xl"
                style="background: rgba(98, 0, 238, 0.35); backdrop-filter: blur(24px); -webkit-backdrop-filter: blur(24px); border: 1px solid rgba(180, 140, 255, 0.2); border-radius: 1.5rem; box-shadow: 0 30px 80px rgba(0,0,0,0.5), inset 0 1px 0 rgba(255,255,255,0.1);">
                <!-- Mobile-only top badge -->
                <div class="md:hidden flex justify-center mb-4">
                    <span
                        class="inline-flex items-center gap-1.5 bg-white/10 backdrop-blur-sm border border-white/20 text-white/90 text-[10px] font-bold uppercase tracking-[0.2em] px-4 py-1.5 rounded-full">
                        <span class="w-1.5 h-1.5 bg-green-400 rounded-full animate-pulse"></span>
                        Ride Hailing mới
                    </span>
                </div>
                <h1 class="text-[1.6rem] leading-[1.2] sm:text-3xl md:text-5xl font-black text-white tracking-tight mb-3 sm:mb-5"
                    style="text-shadow: 0 0 40px rgba(160,100,255,0.4);">
                    Nền tảng tiên phong kết nôí di chuyển cộng đồng
                </h1>
                <p class="text-white/90 text-[13px] sm:text-base md:text-lg leading-[1.7] mb-3 sm:mb-4 font-medium">
                    Transcake: Gọi xe, ghép chuyến, kết nối cộng đồng.
                    Giá cước minh bạch, ghép chuyến cùng tần số,
                    an tâm tuyệt đối.
                </p>
                <p class="text-white/70 text-xs sm:text-sm font-medium mb-5 sm:mb-8 tracking-wide">
                    kết nối, minh bạch, cá nhân hóa.
                </p>
                <div class="flex flex-col sm:flex-row gap-3 sm:gap-4 justify-center mt-2">
                    <button>
                        <div class="flex gap-3">
                            <img src="https://upload.wikimedia.org/wikipedia/commons/3/3c/Download_on_the_App_Store_Badge.svg"
                                alt="App Store" class="h-10 cursor-pointer hover:opacity-80 transition-opacity">
                        </div>
                    </button>
                    <button>
                        <div class="flex gap-3">
                            <img src="https://upload.wikimedia.org/wikipedia/commons/7/78/Google_Play_Store_badge_EN.svg"
                                alt="Google Play" class="h-10 cursor-pointer hover:opacity-80 transition-opacity">
                        </div>
                    </button>
                </div>
                <!-- Mobile-only trust badges -->
                <div class="md:hidden flex flex-wrap justify-center gap-2 mt-5 pt-4 border-t border-white/10">
                    <span
                        class="inline-flex items-center gap-1 bg-white/10 text-white/80 text-[10px] font-semibold px-2.5 py-1 rounded-full">
                        <span class="material-symbols-outlined text-green-400 text-[12px]"
                            style="font-variation-settings: 'FILL' 1;">verified_user</span>
                        eKYC 100%
                    </span>
                    <span
                        class="inline-flex items-center gap-1 bg-white/10 text-white/80 text-[10px] font-semibold px-2.5 py-1 rounded-full">
                        <span class="material-symbols-outlined text-orange-400 text-[12px]"
                            style="font-variation-settings: 'FILL' 1;">shield</span>
                        An toàn
                    </span>
                    <span
                        class="inline-flex items-center gap-1 bg-white/10 text-white/80 text-[10px] font-semibold px-2.5 py-1 rounded-full">
                        <span class="material-symbols-outlined text-purple-300 text-[12px]"
                            style="font-variation-settings: 'FILL' 1;">favorite</span>
                        Ghép chuyến
                    </span>
                </div>
            </div>
        </section>

        <!-- SVG Wave Divider -->
        <div class="relative w-full overflow-hidden leading-none z-10 -mt-2" style="transform: rotate(180deg);">
            <svg class="block w-full h-[60px] md:h-[100px]" viewBox="0 0 1200 120" preserveAspectRatio="none">
                <path
                    d="M321.39,56.44c58-10.79,114.16-30.13,172-41.86,82.39-16.72,168.19-17.73,250.45-.39C823.78,31,906.67,72,985.66,92.83c70.05,18.48,146.53,26.09,214.34,3V0H0V27.35A600.21,600.21,0,0,0,321.39,56.44Z"
                    class="fill-[#fcfcfd]"></path>
            </svg>
        </div>

        <!-- About Us: Editorial Collage -->
        <section id="about" class="relative py-12 sm:py-16 md:py-20 px-4 md:px-8 bg-[#fcfcfd] overflow-hidden">
            <!-- Background Soft Glows -->
            <div
                class="absolute top-0 right-0 w-[500px] h-[500px] bg-purple-500/10 rounded-full blur-[100px] pointer-events-none">
            </div>
            <div
                class="absolute bottom-40 left-0 w-[600px] h-[600px] bg-orange-500/5 rounded-full blur-[120px] pointer-events-none">
            </div>

            <div class="max-w-7xl mx-auto relative z-10">
                <!-- 1. The Hook -->
                <div class="text-center max-w-4xl mx-auto mb-12 sm:mb-16 md:mb-24 relative">
                    <span
                        class="inline-block text-[#FF6D00] font-black tracking-[0.2em] sm:tracking-[0.3em] uppercase text-xs sm:text-sm mb-4 sm:mb-6 drop-shadow-sm">HƠN
                        CẢ MỘT CUỐC XE</span>
                    <h2
                        class="text-2xl sm:text-3xl md:text-5xl lg:text-6xl font-black text-[#1e293b] leading-[1.2] font-['Playfair_Display']">
                        Chúng tôi kiến tạo <span class="text-[#6200EE]">hạ tầng</span><br class="hidden md:block" /> và
                        kết nối cộng đồng.
                    </h2>
                </div>
                <!-- 2. The Creative Core (Collage Container) -->
                <div class="relative w-full max-w-6xl mx-auto">

                    <!-- Glowing Route Map Line (Desktop Only) -->
                    <svg class="hidden lg:block absolute top-[10%] left-[20%] w-[60%] h-[80%] z-0 pointer-events-none"
                        viewBox="0 0 100 100" preserveAspectRatio="none"
                        style="filter: drop-shadow(0 0 15px rgba(98,0,238,0.4));">
                        <path d="M 10 0 C 10 40, 90 40, 90 70 C 90 90, 20 90, 20 100" fill="transparent"
                            stroke="url(#routeGradient)" stroke-width="0.5" stroke-dasharray="2 3"
                            class="animate-[dash_30s_linear_infinite]" />
                        <defs>
                            <linearGradient id="routeGradient" x1="0%" y1="0%" x2="0%" y2="100%">
                                <stop offset="0%" stop-color="#FF6D00" />
                                <stop offset="50%" stop-color="#6200EE" />
                                <stop offset="100%" stop-color="#FF6D00" />
                            </linearGradient>
                        </defs>
                        <style>
                            @keyframes dash {
                                to {
                                    stroke-dashoffset: -100;
                                }
                            }
                        </style>
                    </svg>

                    <!-- Block 1: Vibe Matching -->
                    <div
                        class="relative flex flex-col lg:flex-row items-center gap-6 sm:gap-8 lg:gap-12 mb-16 sm:mb-24 lg:mb-32 z-10">
                        <div class="relative w-full lg:w-1/2 group">
                            <!-- Image -->
                            <div
                                class="relative rounded-[2rem] overflow-hidden shadow-2xl aspect-[4/3] transform transition-transform duration-700 group-hover:scale-[1.02]">
                                <img src="https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&q=80&w=800"
                                    class="w-full h-full object-cover" alt="Vibe Matching" />
                                <div
                                    class="absolute inset-0 bg-gradient-to-t from-black/40 to-transparent mix-blend-multiply">
                                </div>
                            </div>
                            <!-- Glassmorphism Overlay -->
                            <div
                                class="absolute -bottom-6 sm:-bottom-8 right-2 sm:-right-4 lg:-right-12 bg-white/30 backdrop-blur-xl border border-white/40 shadow-[0_20px_40px_rgba(0,0,0,0.15)] rounded-2xl p-3 sm:p-5 w-48 sm:w-64 transform transition-all duration-500 group-hover:-translate-y-4">
                                <div class="flex items-center gap-3 mb-3">
                                    <div
                                        class="w-10 h-10 rounded-full bg-gradient-to-br from-[#FF6D00] to-[#FF9100] flex items-center justify-center text-white shadow-lg">
                                        <span class="material-symbols-outlined text-xl">favorite</span>
                                    </div>
                                    <div>
                                        <p
                                            class="text-[11px] uppercase tracking-wider text-slate-800 font-bold opacity-70">
                                            Độ tương thích</p>
                                        <p class="text-xl font-black text-[#6200EE]">95%</p>
                                    </div>
                                </div>
                                <div class="flex flex-wrap gap-2">
                                    <span
                                        class="px-3 py-1 bg-white/80 text-slate-800 text-[10px] font-bold rounded-full uppercase tracking-wide border border-white/50 shadow-sm transition-transform hover:scale-105 pointer-events-auto">&#127925;
                                        Âm nhạc</span>
                                    <span
                                        class="px-3 py-1 bg-white/80 text-slate-800 text-[10px] font-bold rounded-full uppercase tracking-wide border border-white/50 shadow-sm transition-transform hover:scale-105 pointer-events-auto">&#128187;
                                        Công nghệ</span>
                                </div>
                            </div>
                        </div>
                        <div class="w-full lg:w-1/2 lg:pl-16 mt-12 sm:mt-14 lg:mt-0">
                            <h3
                                class="text-xl sm:text-2xl md:text-3xl font-bold text-slate-900 mb-4 sm:mb-6 font-['Playfair_Display']">
                                Cá nhân hóa
                                <span class="italic text-[#FF6D00]">trải nghiệm</span>
                            </h3>
                            <p class="text-base sm:text-lg text-slate-600 leading-[1.8] font-medium">
                                Kết nối đa chiều. Transcake không chỉ lấp đầy ghế trống, chúng tôi giúp bạn tìm thấy
                                những người đồng hành 'cùng tần số' qua thuật toán ghép chuyến thông minh.
                            </p>
                        </div>
                    </div>

                    <!-- Block 2: Trust Infrastructure -->
                    <div
                        class="relative flex flex-col-reverse lg:flex-row items-center gap-6 sm:gap-8 lg:gap-12 mb-16 sm:mb-24 lg:mb-32 z-10">
                        <div class="w-full lg:w-1/2 lg:pr-16 text-left lg:text-right mt-6 sm:mt-8 lg:mt-0">
                            <h3
                                class="text-xl sm:text-2xl md:text-3xl font-bold text-slate-900 mb-4 sm:mb-6 font-['Playfair_Display']">
                                <span class="italic text-[#6200EE]">An tâm</span> tuyệt đối
                            </h3>
                            <p class="text-base sm:text-lg text-slate-600 leading-[1.8] font-medium">
                                Với hệ thống xác thực danh tính 100%, đánh giá chéo 2 chiều và cảnh báo lệch lộ trình,
                                sự an toàn của bạn là tiêu chuẩn bắt buộc.
                            </p>
                        </div>
                        <div class="relative w-full lg:w-1/2 group">
                            <!-- Image -->
                            <div
                                class="relative rounded-[2rem] overflow-hidden shadow-2xl aspect-[4/3] transform transition-transform duration-700 group-hover:scale-[1.02]">
                                <img src="https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?auto=format&fit=crop&q=80&w=800"
                                    class="w-full h-full object-cover" alt="Trust Infrastructure" />
                                <div
                                    class="absolute inset-0 bg-gradient-to-t from-[#6200EE]/40 to-transparent mix-blend-multiply">
                                </div>
                            </div>
                            <!-- Glassmorphism Overlay -->
                            <div
                                class="absolute top-6 sm:top-10 left-2 sm:-left-4 lg:-left-12 bg-[#1a1130]/80 backdrop-blur-xl border border-purple-500/30 shadow-[0_20px_50px_rgba(98,0,238,0.4)] rounded-2xl p-3 sm:p-5 w-48 sm:w-60 transform transition-all duration-500 group-hover:-translate-y-4">
                                <div class="flex items-center gap-3 mb-4">
                                    <div
                                        class="relative w-12 h-12 rounded-full bg-gradient-to-br from-green-400 to-emerald-600 flex items-center justify-center text-white shadow-[0_0_20px_rgba(16,185,129,0.5)]">
                                        <span class="material-symbols-outlined text-2xl">verified_user</span>
                                        <!-- Glowing rings -->
                                        <div
                                            class="absolute inset-0 rounded-full border border-green-400 animate-ping opacity-75">
                                        </div>
                                    </div>
                                    <div>
                                        <p class="text-[11px] uppercase tracking-wider text-white/60 font-bold">Trust
                                            Point</p>
                                        <p class="text-2xl font-black text-white">10/10</p>
                                    </div>
                                </div>
                                <div
                                    class="flex items-center gap-2 bg-white/10 rounded-lg px-3 py-2 border border-white/5">
                                    <span class="material-symbols-outlined text-green-400 text-sm">check_circle</span>
                                    <span class="text-white text-xs font-semibold">Đã xác thực eKYC</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Block 3: Travel Blog & Community -->
                    <div class="relative flex flex-col lg:flex-row items-center gap-6 sm:gap-8 lg:gap-12 z-10">
                        <div class="relative w-full lg:w-5/12 group xl:-ml-10">
                            <!-- Image -->
                            <div
                                class="relative rounded-[2rem] overflow-hidden shadow-[0_30px_60px_rgba(0,0,0,0.2)] aspect-[3/4] transform transition-transform duration-700 group-hover:scale-[1.02]">
                                <img src="https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&q=80&w=800"
                                    class="w-full h-full object-cover" alt="Community Travel Trip" />
                                <div
                                    class="absolute inset-0 bg-gradient-to-t from-[#6200EE]/30 to-transparent mix-blend-multiply">
                                </div>
                            </div>
                            <!-- Social Media Post Overlay -->
                            <div
                                class="absolute top-[20%] right-0 sm:-right-8 lg:-right-24 bg-white/40 backdrop-blur-2xl border border-white/50 rounded-2xl shadow-[0_30px_60px_rgba(98,0,238,0.2)] p-3 sm:p-5 w-56 sm:w-72 transform rotate-2 transition-all duration-500 group-hover:rotate-0 group-hover:-translate-y-4">
                                <!-- User Info -->
                                <div class="flex items-center gap-3 mb-3">
                                    <div class="w-10 h-10 rounded-full overflow-hidden border-2 border-white shadow-sm">
                                        <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=150"
                                            alt="Avatar" class="w-full h-full object-cover" />
                                    </div>
                                    <div class="flex flex-col">
                                        <span class="text-slate-900 font-bold text-sm leading-tight">Minh Anh</span>
                                        <span
                                            class="text-[#6200EE] font-semibold text-[10px] uppercase tracking-wide">Hà
                                            Nội đến Đà Nẵng</span>
                                    </div>
                                </div>
                                <!-- Post Content -->
                                <div class="mb-4 text-left">
                                    <p class="text-slate-800 text-sm font-bold leading-snug mb-3 drop-shadow-sm">Chuyến
                                        đi tuyệt vời cùng những người bạn mới!</p>
                                    <div
                                        class="w-full h-28 rounded-xl overflow-hidden shadow-[0_5px_15px_rgba(0,0,0,0.1)]">
                                        <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&q=80&w=400"
                                            alt="Mini Trip Photo"
                                            class="w-full h-full object-cover transform hover:scale-110 transition-transform duration-700" />
                                    </div>
                                </div>
                                <!-- Interactions -->
                                <div
                                    class="flex items-center justify-between text-xs font-bold text-slate-700 border-t border-white/40 pt-3">
                                    <div
                                        class="flex items-center gap-1.5 hover:text-[#FF6D00] cursor-pointer transition-colors">
                                        <span>Thích</span>
                                        <span
                                            class="bg-white/80 px-2.5 py-0.5 rounded-full text-[10px] shadow-sm text-[#FF6D00]">2.4K</span>
                                    </div>
                                    <div
                                        class="flex items-center gap-1.5 hover:text-[#6200EE] cursor-pointer transition-colors">
                                        <span>Bình luận</span>
                                        <span
                                            class="bg-white/80 px-2.5 py-0.5 rounded-full text-[10px] shadow-sm text-[#6200EE]">156</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="w-full lg:w-7/12 lg:pl-24 mt-12 sm:mt-14 lg:mt-0 text-left">
                            <h3
                                class="text-2xl sm:text-3xl md:text-4xl font-black text-[#6200EE] mb-4 sm:mb-6 font-['Playfair_Display']">
                                Nhật ký hành
                                trình</h3>
                            <p class="text-base sm:text-lg text-slate-600 leading-[1.8] font-medium">
                                Chia sẻ trải nghiệm, đánh giá chuyến đi và lưu giữ những khoảnh khắc đáng nhớ trên mọi
                                nẻo đường. Transcake biến mỗi cuốc xe thành một không gian kết nối, nơi bạn có thể tự do
                                viết nên câu chuyện của riêng mình.
                            </p>
                        </div>
                    </div>

                </div>
            </div>
        </section>

        <!-- Core Features: Bento Box Grid -->
        <section id="features" class="py-12 sm:py-16 md:py-24 bg-[#F3F4F6]">
            <div class="max-w-7xl mx-auto px-4 md:px-8">
                <!-- Header -->
                <div class="text-center max-w-3xl mx-auto mb-8 sm:mb-12 md:mb-16">
                    <span
                        class="block text-[#FF6D00] text-xs sm:text-sm font-bold uppercase tracking-widest mb-3 sm:mb-4">Khám
                        phá
                        Transcake</span>
                    <h2
                        class="text-2xl sm:text-3xl md:text-4xl lg:text-5xl font-black text-[#6200EE] leading-tight font-['Playfair_Display']">
                        Công nghệ lõi định hình lại cách bạn di chuyển.</h2>
                </div>

                <!-- Grid -->
                <!-- Use a grid with 3 columns on desktop -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 lg:gap-8">

                    <!-- Card 1: Professional Ride-Hailing (Large, span 2) -->
                    <div
                        class="bg-white rounded-[24px] shadow-[0_10px_30px_rgba(0,0,0,0.04)] hover:shadow-[0_20px_40px_rgba(0,0,0,0.08)] transition-shadow duration-500 overflow-hidden md:col-span-2 flex flex-col md:flex-row group">
                        <!-- Visual (60%) -->
                        <div
                            class="w-full md:w-[60%] bg-gradient-to-br from-slate-50 to-slate-100 p-8 flex items-center justify-center relative overflow-hidden min-h-[300px]">
                            <!-- Subtle map background -->
                            <div class="absolute inset-0 opacity-[0.03]"
                                style="background-image: radial-gradient(#6200EE 2px, transparent 2px); background-size: 24px 24px;">
                            </div>

                            <!-- Phone Mockup UI -->
                            <div
                                class="relative w-full max-w-[320px] bg-white rounded-2xl shadow-xl border border-slate-100 p-6 transform transition-transform duration-500 group-hover:-translate-y-2 group-hover:shadow-2xl z-10">
                                <div class="flex items-start justify-between mb-6">
                                    <div class="flex-1 relative">
                                        <!-- Timeline line -->
                                        <div
                                            class="absolute left-[7px] top-[14px] bottom-[14px] w-[2px] border-l-2 border-dashed border-slate-300">
                                        </div>

                                        <div class="flex items-center gap-4 mb-6 relative bg-white z-10 h-6">
                                            <div
                                                class="w-4 h-4 shadow-sm rounded-full bg-[#6200EE] border-2 border-white flex-shrink-0">
                                            </div>
                                            <p class="text-sm font-bold text-slate-800">Điểm đón</p>
                                        </div>
                                        <div class="flex items-center gap-4 relative bg-white z-10 h-6">
                                            <div
                                                class="w-4 h-4 shadow-sm rounded-full bg-[#FF6D00] border-2 border-white flex-shrink-0">
                                            </div>
                                            <p class="text-sm font-bold text-slate-800">Điểm đến</p>
                                        </div>
                                    </div>
                                </div>
                                <div
                                    class="bg-slate-50 px-4 py-3 border-t border-slate-100 flex flex-col -mx-6 -mb-6 mt-4 rounded-b-2xl items-center text-center">
                                    <span
                                        class="text-[10px] text-slate-400 font-bold uppercase tracking-wider mb-1">Cước
                                        phí hợp lý</span>
                                    <span
                                        class="text-3xl font-black text-[#6200EE] font-mono tracking-tight">150.000<span
                                            class="text-lg">đ</span></span>
                                </div>
                            </div>
                        </div>
                        <!-- Text (40%) -->
                        <div
                            class="w-full md:w-[40%] p-8 flex flex-col justify-center border-t md:border-t-0 md:border-l border-slate-100">
                            <h3 class="text-2xl font-bold text-slate-900 mb-4 font-['Playfair_Display']">Đặt xe chuyên
                                nghiệp & Giá cước minh bạch</h3>
                            <p class="text-slate-600 leading-[1.7] font-medium text-[15px]">Trải nghiệm dịch vụ vận tải
                                chất lượng cao. Giá cước được chuẩn hóa và niêm yết rõ ràng trước mỗi chuyến đi, không
                                phí ẩn, không tăng giá bất hợp lý.</p>
                        </div>
                    </div>

                    <!-- Card 2: Vibe Matching Engine (Square) -->
                    <div
                        class="bg-white rounded-[24px] shadow-[0_10px_30px_rgba(0,0,0,0.04)] hover:shadow-[0_20px_40px_rgba(0,0,0,0.08)] transition-shadow duration-500 overflow-hidden lg:col-span-1 flex flex-col group">
                        <!-- Visual (60%) -->
                        <div
                            class="flex-1 bg-gradient-to-tr from-purple-50 to-white p-6 flex flex-col items-center justify-center relative overflow-hidden min-h-[260px]">
                            <!-- Floating tags -->
                            <span
                                class="absolute top-8 left-6 bg-white px-3 py-1.5 rounded-full text-[10px] font-bold text-[#6200EE] shadow-md border border-purple-50 z-20 animate-[bounce_4s_infinite]">Âm
                                nhạc</span>
                            <span
                                class="absolute bottom-10 right-6 bg-white px-3 py-1.5 rounded-full text-[10px] font-bold text-[#FF6D00] shadow-md border border-orange-50 z-20 animate-[bounce_5s_infinite]">Công
                                nghệ</span>
                            <span
                                class="absolute top-1/2 -right-4 bg-white px-3 py-1.5 rounded-full text-[10px] font-bold text-slate-700 shadow-md border border-slate-100 z-20 animate-[bounce_4.5s_infinite]">Thể
                                thao</span>

                            <!-- Avatars -->
                            <div
                                class="flex items-center justify-center w-full z-10 transform transition-transform group-hover:scale-105 duration-500">
                                <div
                                    class="w-20 h-20 rounded-full border-4 border-white shadow-lg z-10 bg-slate-200 overflow-hidden relative">
                                    <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=150"
                                        class="w-full h-full object-cover grayscale-[20%]" alt="User 1" />
                                </div>
                                <div
                                    class="w-12 h-1 bg-gradient-to-r from-[#6200EE] to-[#FF6D00] -mx-4 z-0 opacity-80 mix-blend-multiply">
                                </div>
                                <div
                                    class="w-20 h-20 rounded-full border-4 border-white shadow-lg z-10 bg-slate-200 overflow-hidden relative">
                                    <img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=150"
                                        class="w-full h-full object-cover grayscale-[20%]" alt="User 2" />
                                </div>
                            </div>
                        </div>
                        <!-- Text (40%) -->
                        <div class="p-8 border-t border-slate-50 bg-white md:min-h-[220px]">
                            <h3 class="text-xl font-bold text-slate-900 mb-3 font-['Playfair_Display']">Ghép chuyến cùng
                                tần số</h3>
                            <p class="text-[14px] text-slate-600 font-medium leading-[1.7]">Thuật toán thông minh tự
                                động gợi ý tài xế hoặc hành khách có chung sở thích. Biến những cuốc xe nhàm chán thành
                                cuộc trò chuyện thú vị.</p>
                        </div>
                    </div>

                    <!-- Card 3: Zenly Map & Social (Square) -->
                    <div
                        class="bg-white rounded-[24px] shadow-[0_10px_30px_rgba(0,0,0,0.04)] hover:shadow-[0_20px_40px_rgba(0,0,0,0.08)] transition-shadow duration-500 overflow-hidden lg:col-span-1 flex flex-col group">
                        <!-- Visual (60%) -->
                        <div
                            class="flex-1 bg-slate-50 flex items-center justify-center relative overflow-hidden min-h-[260px]">
                            <!-- Map Background snippet -->
                            <div
                                class="absolute inset-0 bg-[url('https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80&w=800')] bg-cover bg-center opacity-[0.2] saturate-50 mix-blend-multiply">
                            </div>
                            <div class="absolute inset-0 bg-blue-500/5 backdrop-blur-[2px]"></div>

                            <div
                                class="relative w-full max-w-[240px] z-10 transform transition-transform duration-500 group-hover:-translate-y-2">
                                <!-- Ghost mode toggle -->
                                <div
                                    class="bg-white/80 backdrop-blur-md border border-white p-3 rounded-xl shadow-[0_8px_16px_rgba(0,0,0,0.06)] flex items-center justify-between mb-4">
                                    <span class="text-xs font-bold text-slate-800">Cốt truyện ẩn danh</span>
                                    <div
                                        class="w-10 h-5 bg-slate-200 rounded-full relative shadow-inner cursor-pointer hover:bg-slate-300 transition-colors">
                                        <div
                                            class="w-5 h-5 bg-white rounded-full shadow-sm border border-slate-200 absolute left-0 top-0 transition-transform">
                                        </div>
                                    </div>
                                </div>

                                <!-- Map user bubble -->
                                <div class="bg-white p-2.5 rounded-xl border border-slate-100 shadow-md">
                                    <div
                                        class="h-24 bg-slate-100/50 rounded-lg relative overflow-hidden flex items-center justify-center">
                                        <!-- Animated pulse dot -->
                                        <div
                                            class="absolute w-10 h-10 bg-[#6200EE]/20 rounded-full top-[20px] left-[26px] animate-ping">
                                        </div>
                                        <div
                                            class="absolute w-3.5 h-3.5 bg-[#6200EE] border-2 border-white rounded-full shadow-md top-[33px] left-[39px] z-10">
                                        </div>

                                        <!-- User Avatar Pin -->
                                        <div
                                            class="absolute w-10 h-10 rounded-full border-2 border-white overflow-hidden shadow-md bottom-3 right-5 bg-white z-20 transform hover:scale-110 transition-transform">
                                            <img src="https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&q=80&w=150"
                                                class="w-full h-full object-cover" alt="User Map Pin" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Text (40%) -->
                        <div class="p-8 border-t border-slate-50 bg-white md:min-h-[220px]">
                            <h3 class="text-xl font-bold text-slate-900 mb-3 font-['Playfair_Display']">Bản đồ mạng xã
                                hội trực tiếp</h3>
                            <p class="text-[14px] text-slate-600 font-medium leading-[1.7]">Theo dõi hành trình của bạn
                                bè theo thời gian thực. Cập nhật trạng thái chuyến đi và kết nối an toàn trong suốt lộ
                                trình.</p>
                        </div>
                    </div>

                    <!-- Card 4: Trust & Safety Engine (Wide, span 2) -->
                    <div
                        class="bg-white rounded-[24px] shadow-[0_10px_30px_rgba(0,0,0,0.04)] hover:shadow-[0_20px_40px_rgba(0,0,0,0.08)] transition-shadow duration-500 overflow-hidden md:col-span-2 flex flex-col md:flex-row group border border-slate-50">
                        <!-- Text (40%) -->
                        <div
                            class="w-full md:w-[45%] p-8 flex flex-col justify-center border-b md:border-b-0 md:border-r border-slate-100 bg-white order-2 md:order-1">
                            <h3 class="text-2xl font-bold text-slate-900 mb-4 font-['Playfair_Display']">Hạ tầng an toàn
                                tuyệt đối</h3>
                            <p class="text-slate-600 font-medium leading-[1.7] text-[15px]">Hệ thống bảo vệ nhiều lớp:
                                100% người dùng bắt buộc xác thực thẻ căn cước và bằng lái xe. Tích hợp cảnh báo SOS tự
                                động khi phương tiện đi lệch lộ trình.</p>
                        </div>

                        <!-- Visual (60%) -->
                        <div
                            class="w-full md:w-[55%] bg-gradient-to-tr from-emerald-50/70 to-green-50/30 p-8 flex items-center justify-center relative overflow-hidden order-1 md:order-2 min-h-[300px]">
                            <div
                                class="relative z-10 flex flex-col sm:flex-row gap-6 items-center w-full justify-center transform transition-transform duration-500 group-hover:scale-105">
                                <!-- Trust Badge -->
                                <div
                                    class="bg-white rounded-[24px] p-6 flex flex-col items-center justify-center gap-3 shadow-[0_15px_30px_rgba(0,0,0,0.06)] border border-slate-100 w-48 relative overflow-hidden">
                                    <div
                                        class="w-16 h-16 bg-gradient-to-br from-[#6200EE] to-[#8C3AFF] rounded-full flex items-center justify-center text-white font-black text-2xl shadow-[0_0_20px_rgba(98,0,238,0.3)] relative z-10">
                                        10
                                        <div
                                            class="absolute inset-0 rounded-full border-2 border-[#6200EE] animate-ping opacity-30">
                                        </div>
                                    </div>
                                    <div class="text-center z-10">
                                        <p class="text-[10px] uppercase font-bold text-slate-400 tracking-wider">Trust
                                            Point</p>
                                        <p class="text-xl font-black text-slate-800 leading-none mt-1.5">10/10</p>
                                    </div>
                                </div>
                                <!-- eKYC -->
                                <div
                                    class="bg-gradient-to-r from-emerald-500 to-green-500 rounded-[24px] p-6 flex flex-col justify-center items-center shadow-[0_15px_30px_rgba(16,185,129,0.2)] text-white w-48 relative overflow-hidden">
                                    <div
                                        class="absolute right-0 top-0 w-24 h-24 bg-white/10 rounded-full blur-xl mix-blend-overlay pointer-events-none">
                                    </div>
                                    <div
                                        class="w-16 h-16 rounded-full bg-white/20 flex items-center justify-center backdrop-blur-sm mb-4 border border-white/20">
                                        <span class="material-symbols-outlined text-white text-3xl">how_to_reg</span>
                                    </div>
                                    <span class="font-bold text-sm tracking-wide">Đã xác thực eKYC</span>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </section>

        <!-- How It Works: Cinematic 3D iPhone Narrative -->
        <section id="how-it-works" class="relative bg-white h-[300vh] md:h-[500vh]">
            <!-- Added ID for GSAP Trigger -->
            <div id="how-it-works-cinematic" class="absolute inset-0 pointer-events-none"></div>
            <!-- Sticky Viewport -->
            <div class="sticky top-0 h-screen w-full flex items-center justify-center overflow-hidden">

                <!-- Background 3D Perspective Grid -->
                <div class="absolute inset-0 opacity-[0.03] pointer-events-none"
                    style="background-image: radial-gradient(#6200EE 2px, transparent 2px); background-size: 60px 60px; perspective: 1000px; transform: rotateX(60deg) translateY(-20%);">
                </div>

                <!-- Storyteller Container -->
                <div class="relative w-full max-w-7xl mx-auto px-4 sm:px-6 h-full flex items-center">

                    <!-- Left Side: Narratives (Overlaying) -->
                    <div class="relative z-20 w-full md:w-1/2 pointer-events-none pr-0 md:pr-4">
                        <!-- Step 1 Text -->
                        <div id="narrative-1"
                            class="absolute inset-0 flex flex-col justify-center opacity-0 translate-y-10">
                            <span class="text-orange-500 font-black text-xs uppercase tracking-widest mb-4">Bước
                                01</span>
                            <h3
                                class="text-2xl sm:text-3xl md:text-6xl font-black text-slate-900 mb-4 sm:mb-6 leading-tight">
                                Tải ứng dụng &
                                <span class="text-[#6200EE]">Xác thực eKYC.</span>
                            </h3>
                            <p
                                class="text-slate-500 text-sm sm:text-base md:text-lg font-medium max-w-md leading-relaxed">
                                Mở cổng an toàn. Đăng
                                ký và hoàn tất xác thực danh tính bằng CCCD trong 30 giây để đảm bảo cộng đồng di chuyển
                                tin cậy.</p>
                        </div>
                        <!-- Step 2 Text -->
                        <div id="narrative-2"
                            class="absolute inset-0 flex flex-col justify-center opacity-0 translate-y-10">
                            <span class="text-orange-500 font-black text-xs uppercase tracking-widest mb-4">Bước
                                02</span>
                            <h3
                                class="text-2xl sm:text-3xl md:text-6xl font-black text-slate-900 mb-4 sm:mb-6 leading-tight">
                                Đặt chuyến &
                                <span class="text-[#6200EE]">Chọn tần số.</span>
                            </h3>
                            <p
                                class="text-slate-500 text-sm sm:text-base md:text-lg font-medium max-w-md leading-relaxed">
                                Nhập điểm đến và lọc
                                các thẻ sở thích (Âm nhạc, Công nghệ) để hệ thống ghép bạn với "Soulmate" phù hợp nhất.
                            </p>
                        </div>
                        <!-- Step 3 Text -->
                        <div id="narrative-3"
                            class="absolute inset-0 flex flex-col justify-center opacity-0 translate-y-10">
                            <span class="text-orange-500 font-black text-xs uppercase tracking-widest mb-4">Bước
                                03</span>
                            <h3
                                class="text-2xl sm:text-3xl md:text-6xl font-black text-slate-900 mb-4 sm:mb-6 leading-tight">
                                Tận hưởng
                                <span class="text-[#6200EE]">Hành trình.</span>
                            </h3>
                            <p
                                class="text-slate-500 text-sm sm:text-base md:text-lg font-medium max-w-md leading-relaxed">
                                Theo dõi GPS thời
                                gian thực và trải nghiệm kết nối thú vị với những người bạn mới cùng lộ trình.</p>
                        </div>
                        <!-- Step 4 Text -->
                        <div id="narrative-4"
                            class="absolute inset-0 flex flex-col justify-center opacity-0 translate-y-10">
                            <span class="text-orange-500 font-black text-xs uppercase tracking-widest mb-4">Bước
                                04</span>
                            <h3
                                class="text-2xl sm:text-3xl md:text-6xl font-black text-slate-900 mb-4 sm:mb-6 leading-tight">
                                Thanh toán &
                                <span class="text-[#6200EE]">Đánh giá.</span>
                            </h3>
                            <p
                                class="text-slate-500 text-sm sm:text-base md:text-lg font-medium max-w-md leading-relaxed">
                                Tự động tất toán minh
                                bạch. Chấm điểm uy tín để cùng xây dựng văn hóa di chuyển văn minh của Transcake.</p>
                        </div>
                    </div>

                    <!-- Right Side: 3D Camera Focus -->
                    <div class="relative flex-1 h-full hidden md:flex items-center justify-center perspective-[2000px]">

                        <!-- The 3D Phone Scaffold -->
                        <div id="hero-phone-scaffold"
                            class="relative w-[240px] sm:w-[280px] md:w-[320px] aspect-[9/19] preserve-3d transition-transform duration-100 ease-linear">

                            <!-- Phone Shadow -->
                            <div
                                class="absolute inset-0 bg-black/20 blur-3xl rounded-[3rem] translate-y-20 scale-90 -z-10">
                            </div>

                            <!-- iPhone Pro Frame (CSS Rendered) -->
                            <div
                                class="absolute inset-0 bg-slate-900 rounded-[3rem] p-3 border-[6px] border-slate-800 shadow-2xl overflow-hidden preserve-3d">
                                <!-- Screen -->
                                <div class="w-full h-full bg-white rounded-[2.2rem] overflow-hidden relative">
                                    <div
                                        class="absolute top-0 left-1/2 -translate-x-1/2 w-1/3 h-6 bg-slate-900 rounded-b-2xl z-50">
                                    </div>

                                    <!-- Internal App UI Components (Dynamic) -->
                                    <div id="phone-ui-screen"
                                        class="w-full h-full relative transition-all duration-500">
                                        <!-- Step 1 UI -->
                                        <div id="ui-1"
                                            class="absolute inset-0 flex flex-col items-center bg-white p-6 pt-16 transition-opacity duration-500">
                                            <div
                                                class="w-20 h-20 rounded-full bg-slate-100 flex items-center justify-center mb-10">
                                                <span
                                                    class="material-symbols-outlined text-4xl text-slate-300">person_check</span>
                                            </div>
                                            <div class="w-full space-y-4">
                                                <div class="w-full h-3 bg-slate-50 rounded-full"></div>
                                                <div class="w-2/3 h-3 bg-slate-50 rounded-full"></div>
                                                <div
                                                    class="w-full h-12 bg-[#6200EE] rounded-2xl flex items-center justify-center mt-10">
                                                    <div class="w-20 h-2 bg-white/30 rounded-full"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Step 2 UI -->
                                        <div id="ui-2"
                                            class="absolute inset-0 flex flex-col items-center bg-white p-6 pt-16 opacity-0 transition-opacity duration-500">
                                            <div
                                                class="w-full h-32 bg-slate-50 rounded-3xl mb-6 relative overflow-hidden">
                                                <div class="absolute inset-0 opacity-[0.2]"
                                                    style="background-image: linear-gradient(#cbd5e1 1px, transparent 1px), linear-gradient(90deg, #cbd5e1 1px, transparent 1px); background-size: 8px 8px;">
                                                </div>
                                            </div>
                                            <div class="w-full h-10 bg-slate-50 rounded-xl mb-4"></div>
                                            <div class="flex gap-2 w-full">
                                                <div class="flex-1 h-8 bg-purple-50 rounded-lg"></div>
                                                <div class="flex-1 h-8 bg-orange-50 rounded-lg"></div>
                                            </div>
                                        </div>
                                        <!-- Step 3 UI -->
                                        <div id="ui-3"
                                            class="absolute inset-0 flex flex-col items-center bg-white opacity-0 transition-opacity duration-500">
                                            <div class="w-full h-full relative overflow-hidden">
                                                <div class="absolute inset-0 opacity-[0.05]"
                                                    style="background-image: linear-gradient(#6200ee 1px, transparent 1px), linear-gradient(90deg, #6200ee 1px, transparent 1px); background-size: 20px 20px;">
                                                </div>
                                                <!-- Animated Dot -->
                                                <div
                                                    class="absolute top-[20%] left-[20%] w-3 h-3 bg-[#6200EE] rounded-full shadow-lg">
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Step 4 UI -->
                                        <div id="ui-4"
                                            class="absolute inset-0 flex flex-col items-center bg-[#6200EE] p-6 pt-16 opacity-0 transition-opacity duration-500">
                                            <div
                                                class="w-16 h-16 rounded-full bg-white/20 flex items-center justify-center mb-6">
                                                <span
                                                    class="material-symbols-outlined text-3xl text-white">verified</span>
                                            </div>
                                            <div class="w-full h-2 bg-white/20 rounded-full mb-2"></div>
                                            <div class="w-1/2 h-2 bg-white/10 rounded-full"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 3D Floating Elements (Z-Space) -->

                            <!-- Floating Route (Step 3) -->
                            <div id="float-route"
                                class="absolute inset-0 pointer-events-none opacity-0 translate-z-[120px]">
                                <svg class="w-[200%] h-[100%] absolute top-0 left-[-50%]" viewBox="0 0 100 100"
                                    preserveAspectRatio="none">
                                    <path id="route-path-3d" d="M 10 90 Q 30 10 50 50 T 90 10" fill="none"
                                        stroke="#6200EE" stroke-width="2" stroke-dasharray="4" class="opacity-20">
                                    </path>
                                </svg>
                            </div>

                            <!-- Floating CCCD (Step 1) -->
                            <div id="float-cccd"
                                class="absolute top-[20%] -left-10 md:-left-20 w-40 md:w-48 h-24 md:h-28 bg-white rounded-xl shadow-2xl border border-slate-100 p-3 md:p-4 opacity-0 z-50 translate-z-[100px]">
                                <div class="flex gap-3 mb-4">
                                    <div class="w-10 h-10 bg-slate-200 rounded"></div>
                                    <div class="flex-1 space-y-2">
                                        <div class="w-full h-2 bg-slate-200"></div>
                                        <div class="w-1/2 h-2 bg-slate-100"></div>
                                    </div>
                                </div>
                                <div class="w-full h-3 flex items-center gap-2">
                                    <span class="material-symbols-outlined text-green-500 text-sm">verified</span>
                                    <span class="text-[8px] font-bold text-slate-400">IDENTITY VERIFIED</span>
                                </div>
                            </div>

                            <!-- Orbiting Vibe Tags (Step 2) -->
                            <div id="float-tags-container"
                                class="absolute inset-0 pointer-events-none opacity-0 translate-z-[150px]">
                                <div
                                    class="absolute top-10 -right-10 px-4 py-2 bg-[#6200EE] text-white rounded-full font-bold shadow-lg shadow-[#6200EE]/30">
                                    MUSIC</div>
                                <div
                                    class="absolute bottom-40 -left-16 px-4 py-2 bg-orange-500 text-white rounded-full font-bold shadow-lg shadow-orange-500/30">
                                    TECH</div>
                                <div
                                    class="absolute top-1/2 -right-20 px-4 py-2 bg-blue-500 text-white rounded-full font-bold shadow-lg shadow-blue-500/30">
                                    GAMING</div>
                            </div>

                            <!-- Floating Receipt (Step 4) -->
                            <div id="float-receipt"
                                class="absolute top-[10%] left-1/2 -translate-x-1/2 w-64 bg-white rounded-2xl shadow-2xl p-6 opacity-0 translate-z-[200px]">
                                <div class="w-full border-b border-dashed border-slate-200 pb-4 mb-4">
                                    <h4 class="text-xs font-black uppercase tracking-widest text-[#6200EE]">Hóa đơn
                                        chuyến đi</h4>
                                </div>
                                <div class="flex justify-between items-center mb-6">
                                    <span class="text-sm font-bold text-slate-500">Tổng cộng</span>
                                    <span class="text-2xl font-black text-slate-900">120.000đ</span>
                                </div>
                                <div class="flex justify-center gap-1 text-yellow-400">
                                    <span class="material-symbols-outlined"
                                        style="font-variation-settings: 'FILL' 1;">star</span>
                                    <span class="material-symbols-outlined"
                                        style="font-variation-settings: 'FILL' 1;">star</span>
                                    <span class="material-symbols-outlined"
                                        style="font-variation-settings: 'FILL' 1;">star</span>
                                    <span class="material-symbols-outlined"
                                        style="font-variation-settings: 'FILL' 1;">star</span>
                                    <span class="material-symbols-outlined"
                                        style="font-variation-settings: 'FILL' 1;">star</span>
                                </div>
                            </div>

                        </div>

                    </div>

                </div>
            </div>

            <!-- Cinematic Animation Script -->
            <script>
                document.addEventListener('DOMContentLoaded', () => {
                    if (typeof gsap === 'undefined' || typeof ScrollTrigger === 'undefined') return;

                    const container = document.getElementById('how-it-works-cinematic');
                    const scaffold = document.getElementById('hero-phone-scaffold');

                    // Narratives
                    const narratives = [
                        document.getElementById('narrative-1'),
                        document.getElementById('narrative-2'),
                        document.getElementById('narrative-3'),
                        document.getElementById('narrative-4')
                    ];

                    // Internal UIs
                    const uis = [
                        document.getElementById('ui-1'),
                        document.getElementById('ui-2'),
                        document.getElementById('ui-3'),
                        document.getElementById('ui-4')
                    ];

                    // Floating Elms
                    const cccd = document.getElementById('float-cccd');
                    const tags = document.getElementById('float-tags-container');
                    const route = document.getElementById('float-route');
                    const receipt = document.getElementById('float-receipt');

                    // Main Cinematic Timeline
                    const tl = gsap.timeline({
                        scrollTrigger: {
                            trigger: container,
                            start: "top top",
                            end: "bottom bottom",
                            scrub: 1,
                        }
                    });

                    // Initial State Setup
                    gsap.set(narratives, { opacity: 0, y: 50 });
                    gsap.set(uis.slice(1), { opacity: 0 });
                    gsap.set(scaffold, { rotateY: 0, rotateX: 0, scale: 0.85 });

                    // PHASE 1: eKYC (0% - 20%)
                    tl.to(narratives[0], { opacity: 1, y: 0, duration: 2 }, "phase1")
                        .to(scaffold, { rotateY: 20, rotateX: 5, duration: 2, scale: 1 }, "phase1")
                        .to(cccd, { opacity: 1, x: 20, z: 250, duration: 1.5, rotateY: -10 }, "phase1+=0.5")
                        .to(uis[0], { opacity: 1, duration: 1 }, "phase1");

                    // Transition 1-2
                    tl.to(narratives[0], { opacity: 0, y: -50, duration: 1.5 }, "t12")
                        .to(cccd, { opacity: 0, z: 500, scale: 0.2, duration: 1.5 }, "t12")
                        .to(uis[0], { opacity: 0, duration: 0.8 }, "t12")
                        .to(uis[1], { opacity: 1, duration: 0.8 }, "t12+=0.7");

                    // PHASE 2: Vibe Matching (25% - 45%)
                    tl.to(narratives[1], { opacity: 1, y: 0, duration: 2 }, "phase2")
                        .to(scaffold, { rotateY: -20, rotateX: 10, duration: 2 }, "phase2")
                        .to(tags, { opacity: 1, z: 200, duration: 1.5 }, "phase2")
                        .from(tags.querySelectorAll('div'), { z: 400, opacity: 0, stagger: 0.2, duration: 1 }, "phase2+=0.5");

                    // Transition 2-3
                    tl.to(narratives[1], { opacity: 0, y: -50, duration: 1.5 }, "t23")
                        .to(tags, { opacity: 0, z: -500, duration: 1.5 }, "t23")
                        .to(uis[1], { opacity: 0, duration: 0.8 }, "t23")
                        .to(uis[2], { opacity: 1, duration: 0.8 }, "t23+=0.7");

                    // PHASE 3: Journey (50% - 70%)
                    tl.to(narratives[2], { opacity: 1, y: 0, duration: 2 }, "phase3")
                        .to(scaffold, { rotateY: 45, rotateX: -15, scale: 1.2, duration: 2 }, "phase3")
                        .to(route, { opacity: 1, z: 150, duration: 1.5 }, "phase3")
                        .fromTo("#route-path-3d", { strokeDasharray: 200, strokeDashoffset: 200 }, { strokeDashoffset: 0, duration: 2 }, "phase3");

                    // Transition 3-4
                    tl.to(narratives[2], { opacity: 0, y: -50, duration: 1.5 }, "t34")
                        .to(route, { opacity: 0, scale: 1.5, duration: 1.5 }, "t34")
                        .to(uis[2], { opacity: 0, duration: 0.8 }, "t34")
                        .to(uis[3], { opacity: 1, duration: 0.8 }, "t34+=0.7");

                    // PHASE 4: Success/Payment (75% - 100%)
                    tl.to(narratives[3], { opacity: 1, y: 0, duration: 2 }, "phase4")
                        .to(scaffold, { rotateY: 0, rotateX: 0, scale: 0.9, duration: 2 }, "phase4")
                        .to(receipt, { opacity: 1, y: -30, z: 300, rotateX: -10, duration: 1.5 }, "phase4+=0.5");

                });
            </script>
        </section>

        <!-- Pricing & Plans Section -->
        <section id="pricing" class="py-24 px-4 md:px-8 w-full bg-white relative">
            <div class="max-w-[1200px] mx-auto">
                <!-- Header -->
                <div class="text-center max-w-3xl mx-auto mb-16 relative z-10">
                    <span
                        class="inline-block text-[#FF6D00] text-xs font-bold uppercase tracking-widest mb-4 bg-orange-50 px-3 py-1 rounded-full">
                        Minh bạch chi phí
                    </span>
                    <h2 class="text-3xl md:text-5xl font-black text-[#6200EE] leading-tight mb-8">
                        Lựa chọn hành trình theo cách của bạn.
                    </h2>

                    <!-- Toggle Switch (Top Center) -->
                    <div class="flex items-center justify-center gap-4 text-sm font-semibold select-none">
                        <span class="text-slate-900 transition-colors" id="label-monthly">Gói Tháng</span>
                        <button id="billing-toggle"
                            class="w-14 h-8 bg-slate-200 rounded-full relative transition-colors duration-300 focus:outline-none">
                            <div id="toggle-circle"
                                class="w-6 h-6 bg-white rounded-full absolute top-1 left-1 shadow-md transition-transform duration-300">
                            </div>
                        </button>
                        <span class="text-slate-500 transition-colors" id="label-yearly">Gói Năm <span
                                class="bg-green-100 text-green-700 text-[10px] px-2 py-0.5 rounded-full ml-1 font-bold">Tiết kiệm 20%</span></span>
                    </div>
                </div>

                <!-- Pricing Cards Container -->
                <div class="grid md:grid-cols-2 gap-8 md:gap-12 max-w-4xl mx-auto mb-20 relative z-10">

                    <!-- Card 1 - Transcake Standard (Left) -->
                    <div
                        class="bg-white border border-slate-200 rounded-[2rem] p-8 md:p-10 flex flex-col hover:shadow-xl transition-shadow duration-300">
                        <h3 class="text-2xl font-bold text-slate-800 mb-2">Transcake Standard</h3>
                        <p class="text-slate-500 text-sm mb-6 h-10">Dành cho nhu cầu di chuyển an toàn và kết nối cơ bản.</p>
                        
                        <div class="text-4xl font-black text-slate-900 mb-8 pb-8 border-b border-slate-100 flex items-baseline gap-1 relative overflow-hidden h-[80px]">
                            <!-- Standard Monthly Price -->
                            <div id="price-standard-monthly" class="absolute top-0 left-0 transition-all duration-500 ease-in-out">
                                49.000 <span class="text-lg text-slate-500 font-medium">VNĐ / tháng</span>
                            </div>
                            <!-- Standard Yearly Price -->
                            <div id="price-standard-yearly" class="absolute top-[100%] left-0 transition-all duration-500 ease-in-out opacity-0">
                                469.000 <span class="text-lg text-slate-500 font-medium">VNĐ / năm</span>
                            </div>
                        </div>

                        <ul class="space-y-4 mb-10 flex-1">
                            <li class="flex items-start gap-3">
                                <div class="w-5 h-5 rounded-full border-2 border-[#6200EE] flex items-center justify-center shrink-0 mt-0.5">
                                    <div class="w-2 h-3 border-r-2 border-b-2 border-[#6200EE] rotate-45 mb-1"></div>
                                </div>
                                <span class="text-slate-700 font-medium">Quyền truy cập mạng lưới đặt xe và ghép chuyến.</span>
                            </li>
                            <li class="flex items-start gap-3">
                                <div class="w-5 h-5 rounded-full border-2 border-[#6200EE] flex items-center justify-center shrink-0 mt-0.5">
                                    <div class="w-2 h-3 border-r-2 border-b-2 border-[#6200EE] rotate-45 mb-1"></div>
                                </div>
                                <span class="text-slate-700 font-medium">Tham gia vào mạng lướt mạng xã hội Transcake cơ bản.</span>
                            </li>
                            <li class="flex items-start gap-3">
                                <div class="w-5 h-5 rounded-full border-2 border-[#6200EE] flex items-center justify-center shrink-0 mt-0.5">
                                    <div class="w-2 h-3 border-r-2 border-b-2 border-[#6200EE] rotate-45 mb-1"></div>
                                </div>
                                <span class="text-slate-700 font-medium">Đặt xe không cọc, thanh toán trực tiếp cho tài xế.</span>
                            </li>
                        </ul>
                        <a href="#"
                            class="block w-full text-center py-4 rounded-xl border-2 border-[#6200EE] text-[#6200EE] font-bold hover:bg-purple-50 transition-all">
                            Đăng ký Standard
                        </a>
                    </div>

                    <!-- Card 2 - Transcake Pro (Right - Highlighted) -->
                    <div
                        class="bg-white border-2 border-[#FF6D00] rounded-[2rem] p-8 md:p-10 flex flex-col relative shadow-[0_20px_50px_rgba(255,109,0,0.15)] md:scale-105 z-10 transition-transform duration-300">
                        <div
                            class="absolute -top-4 left-1/2 -translate-x-1/2 bg-[#FF6D00] text-white text-xs font-black uppercase tracking-widest px-4 py-1.5 rounded-full shadow-lg">
                            PHỔ BIẾN NHẤT
                        </div>
                        <h3 class="text-2xl font-bold text-[#FF6D00] mb-2">Transcake Pro</h3>
                        <p class="text-slate-500 text-sm mb-6 h-10">Dành cho trải nghiệm cá nhân hóa và mạng xã hội di chuyển.</p>

                        <div class="text-4xl font-black text-[#FF6D00] mb-8 pb-8 border-b border-slate-100 flex items-baseline gap-1 relative overflow-hidden h-[80px]">
                            <!-- Pro Monthly Price -->
                            <div id="price-pro-monthly" class="absolute top-0 left-0 transition-all duration-500 ease-in-out">
                                89.000 <span class="text-lg text-slate-500 font-medium">VNĐ / tháng</span>
                            </div>
                            <!-- Pro Yearly Price -->
                            <div id="price-pro-yearly" class="absolute top-[100%] left-0 transition-all duration-500 ease-in-out opacity-0">
                                849.000 <span class="text-lg text-slate-500 font-medium">VNĐ / năm</span>
                            </div>
                        </div>

                        <ul class="space-y-4 mb-10 flex-1">
                            <li class="flex items-start gap-3">
                                <div class="w-5 h-5 rounded-full border-2 border-[#FF6D00] flex items-center justify-center shrink-0 mt-0.5">
                                    <div class="w-2 h-3 border-r-2 border-b-2 border-[#FF6D00] rotate-45 mb-1"></div>
                                </div>
                                <span class="text-slate-700 font-medium">Toàn bộ đặc quyền của gói Standard.</span>
                            </li>
                            <li class="flex items-start gap-3">
                                <div class="w-5 h-5 rounded-full border-2 border-[#FF6D00] flex items-center justify-center shrink-0 mt-0.5">
                                    <div class="w-2 h-3 border-r-2 border-b-2 border-[#FF6D00] rotate-45 mb-1"></div>
                                </div>
                                <span class="text-slate-700 font-medium">Ưu tiên ghép chuyến nhanh nhất.</span>
                            </li>
                            <li class="flex items-start gap-3">
                                <div class="w-5 h-5 rounded-full border-2 border-[#FF6D00] flex items-center justify-center shrink-0 mt-0.5">
                                    <div class="w-2 h-3 border-r-2 border-b-2 border-[#FF6D00] rotate-45 mb-1"></div>
                                </div>
                                <span class="text-slate-700 font-medium">Vibe Matching: Thuật toán chọn tài xế dựa trên thông tin cá nhân hóa</span>
                            </li>
                            <li class="flex items-start gap-3">
                                <div class="w-5 h-5 rounded-full border-2 border-[#FF6D00] flex items-center justify-center shrink-0 mt-0.5">
                                    <div class="w-2 h-3 border-r-2 border-b-2 border-[#FF6D00] rotate-45 mb-1"></div>
                                </div>
                                <span class="text-slate-700 font-medium">Tính năng an toàn nâng cao: lựa chọn tài xế cùng giới tính & Tự động gửi cảnh báo cho người thân nếu đi sai lộ trình.</span>
                            </li>
                            <li class="flex items-start gap-3">
                                <div class="w-5 h-5 rounded-full border-2 border-[#FF6D00] flex items-center justify-center shrink-0 mt-0.5">
                                    <div class="w-2 h-3 border-r-2 border-b-2 border-[#FF6D00] rotate-45 mb-1"></div>
                                </div>
                                <span class="text-slate-700 font-medium">Trải nghiệm không gian ứng dụng cá nhân hóa.</span>
                            </li>
                            <li class="flex items-start gap-3">
                                <div class="w-5 h-5 rounded-full border-2 border-[#FF6D00] flex items-center justify-center shrink-0 mt-0.5">
                                    <div class="w-2 h-3 border-r-2 border-b-2 border-[#FF6D00] rotate-45 mb-1"></div>
                                </div>
                                <span class="text-slate-700 font-medium">Bản đồ mạng xã hội chia sẻ vị trí thời gian thực với bạn bè </span>
                            </li>
                        </ul>
                        <a href="#"
                            class="block w-full text-center py-4 rounded-xl bg-[#FF6D00] text-white font-bold hover:bg-[#E65C00] shadow-xl shadow-orange-500/20 transition-all hover:-translate-y-1">
                            Nâng cấp Pro ngay
                        </a>
                    </div>
                </div>

                <!-- Driver Commission Banner (B2B/Partners) -->
                <div
                    class="max-w-4xl mx-auto rounded-3xl p-8 md:p-10 relative overflow-hidden backdrop-blur-xl bg-purple-50/80 border border-purple-100 shadow-[0_10px_30px_rgba(98,0,238,0.05)] text-left">
                    <h3 class="text-2xl md:text-3xl font-bold text-[#6200EE] mb-8 max-w-2xl">
                        Dành cho Đối tác Tài xế: Tối đa thu nhập, An tâm cầm lái.
                    </h3>

                    <div class="grid md:grid-cols-2 gap-6 mb-8">
                        <!-- Xe Máy -->
                        <div class="bg-white/60 p-6 rounded-2xl border border-white">
                            <h4 class="font-bold text-slate-800 text-lg mb-2">Xe máy</h4>
                            <p class="text-slate-600 font-medium mb-3">
                                Chiết khấu siêu thấp chỉ <strong>15%</strong><br>
                                <span class="text-sm text-slate-500">(Tối thiểu 3.000 VNĐ/chuyến)</span>
                            </p>
                            <p class="text-xs text-slate-500">
                                Đã bao gồm 1.000 VNĐ trích quỹ bảo hiểm phương tiện.
                            </p>
                        </div>

                        <!-- Ô Tô -->
                        <div class="bg-white/60 p-6 rounded-2xl border border-white">
                            <h4 class="font-bold text-slate-800 text-lg mb-2">Ô tô</h4>
                            <p class="text-slate-600 font-medium mb-3">
                                Chiết khấu ưu đãi chỉ <strong>10%</strong><br>
                                <span class="text-sm text-slate-500">(Tối thiểu 10.000 VNĐ/chuyến)</span>
                            </p>
                            <p class="text-xs text-slate-500">
                                Đã bao gồm 2.000 VNĐ trích quỹ bảo hiểm phương tiện.
                            </p>
                        </div>
                    </div>

                    <a href="#"
                        class="inline-flex items-center gap-2 text-[#FF6D00] font-bold hover:text-[#E65C00] transition-colors group">
                        Xem chi tiết chính sách Tài xế
                    </a>
                </div>

                <script>
                    document.addEventListener('DOMContentLoaded', () => {
                        const toggleBtn = document.getElementById('billing-toggle');
                        const toggleCircle = document.getElementById('toggle-circle');
                        const labelMonthly = document.getElementById('label-monthly');
                        const labelYearly = document.getElementById('label-yearly');

                        const priceStandardMonthly = document.getElementById('price-standard-monthly');
                        const priceStandardYearly = document.getElementById('price-standard-yearly');
                        const priceProMonthly = document.getElementById('price-pro-monthly');
                        const priceProYearly = document.getElementById('price-pro-yearly');

                        let isYearly = false;

                        toggleBtn.addEventListener('click', () => {
                            isYearly = !isYearly;

                            if (isYearly) {
                                toggleCircle.style.transform = 'translateX(24px)';
                                toggleBtn.classList.remove('bg-slate-200');
                                toggleBtn.classList.add('bg-[#6200EE]');

                                labelMonthly.classList.remove('text-slate-900');
                                labelMonthly.classList.add('text-slate-500');
                                labelYearly.classList.remove('text-slate-500');
                                labelYearly.classList.add('text-slate-900');

                                // Standard Price Animation
                                priceStandardMonthly.style.transform = 'translateY(-100%)';
                                priceStandardMonthly.style.opacity = '0';
                                priceStandardYearly.style.transform = 'translateY(-100%)';
                                priceStandardYearly.style.opacity = '1';

                                // Pro Price Animation
                                priceProMonthly.style.transform = 'translateY(-100%)';
                                priceProMonthly.style.opacity = '0';
                                priceProYearly.style.transform = 'translateY(-100%)';
                                priceProYearly.style.opacity = '1';
                            } else {
                                toggleCircle.style.transform = 'translateX(0)';
                                toggleBtn.classList.remove('bg-[#6200EE]');
                                toggleBtn.classList.add('bg-slate-200');

                                labelMonthly.classList.remove('text-slate-500');
                                labelMonthly.classList.add('text-slate-900');
                                labelYearly.classList.remove('text-slate-900');
                                labelYearly.classList.add('text-slate-500');

                                // Standard Price Animation
                                priceStandardMonthly.style.transform = 'translateY(0)';
                                priceStandardMonthly.style.opacity = '1';
                                priceStandardYearly.style.transform = 'translateY(0)';
                                priceStandardYearly.style.opacity = '0';

                                // Pro Price Animation
                                priceProMonthly.style.transform = 'translateY(0)';
                                priceProMonthly.style.opacity = '1';
                                priceProYearly.style.transform = 'translateY(0)';
                                priceProYearly.style.opacity = '0';
                            }
                        });
                    });
                </script>
            </div>
        </section>

        <!-- Deep Dive 1: Connection -->
        <section class="py-12 sm:py-16 md:py-24 px-4 sm:px-6 overflow-hidden max-w-7xl mx-auto">
            <div class="flex flex-col md:flex-row items-center gap-10 md:gap-16 lg:gap-24">
                <!-- Left: Phone with Tags -->
                <div
                    class="flex-1 relative perspective-1000 min-h-[400px] sm:min-h-[500px] md:min-h-[600px] w-full flex items-center justify-center">
                    <!-- Background Glow -->
                    <div class="absolute w-[400px] h-[400px] bg-primary/20 blur-[100px] rounded-full"></div>

                    <div class="relative w-[220px] sm:w-[250px] md:w-[280px] rotate-12 rotate-y-12 preserve-3d">
                        <div class="phone-frame h-[440px] sm:h-[500px] md:h-[580px]">
                            <div class="phone-notch"></div>
                            <div class="w-full h-full bg-slate-50 relative p-6 pt-20">
                                <h3 class="font-bold text-xl text-center mb-2">Interest selection</h3>
                                <p class="text-xs text-center text-slate-500 mb-8">Tìm bạn đồng hành chung sở
                                    thích</p>
                                <div class="space-y-4">
                                    <!-- Mock UI elements inside phone -->
                                    <div
                                        class="bg-white p-4 rounded-xl shadow-sm border border-slate-100 text-sm font-medium flex justify-between items-center">
                                        <span class="flex items-center gap-2"><span
                                                class="w-6 h-6 rounded bg-primary/10 block"></span>Music Genres</span>
                                        <span
                                            class="material-symbols-outlined text-slate-400 text-sm">expand_more</span>
                                    </div>
                                    <div
                                        class="bg-white p-4 rounded-xl shadow-sm border border-slate-100 text-sm font-medium flex justify-between items-center">
                                        <span class="flex items-center gap-2"><span
                                                class="w-6 h-6 rounded bg-accent/10 block"></span>Hobbies</span> <span
                                            class="material-symbols-outlined text-slate-400 text-sm">expand_more</span>
                                    </div>
                                    <div
                                        class="bg-white p-4 rounded-xl shadow-sm border border-slate-100 text-sm font-medium flex justify-between items-center">
                                        <span class="flex items-center gap-2"><span
                                                class="w-6 h-6 rounded bg-green-500/10 block"></span>Profession</span>
                                        <span
                                            class="material-symbols-outlined text-slate-400 text-sm">expand_more</span>
                                    </div>
                                </div>
                                <!-- Save Button Mock -->
                                <div class="absolute bottom-10 left-6 right-6 h-12 bg-accent rounded-full"></div>
                            </div>
                        </div>

                        <div class="absolute -left-6 sm:-left-12 md:-left-16 top-1/4 bg-primary text-white font-bold text-xs sm:text-sm px-3 sm:px-4 md:px-6 py-2 sm:py-3 rounded-full shadow-xl shadow-primary/30 tags-anim transform translate-z-30 flex items-center gap-2"
                            style="animation-delay: 0s;">
                            <span>🎵</span> <span class="hidden sm:inline">Rock </span>Music
                        </div>
                        <div class="absolute -right-6 sm:-right-12 md:-right-20 top-1/3 bg-white text-slate-800 font-bold text-xs sm:text-sm px-3 sm:px-4 md:px-6 py-2 sm:py-3 rounded-full shadow-lg border border-slate-100 tags-anim transform translate-z-20 flex items-center gap-2"
                            style="animation-delay: 1s;">
                            <span>💻</span> Tech
                        </div>
                        <div class="absolute -left-4 sm:-left-8 md:-left-10 bottom-1/3 bg-white text-slate-800 font-bold text-xs sm:text-sm px-3 sm:px-4 md:px-6 py-2 sm:py-3 rounded-full shadow-lg border border-slate-100 tags-anim transform translate-z-20 flex items-center gap-2"
                            style="animation-delay: 2s;">
                            <span>⚽</span> Football
                        </div>
                        <div class="absolute right-0 bottom-1/4 bg-slate-900 text-white font-bold text-xs sm:text-sm px-3 sm:px-4 md:px-6 py-2 sm:py-3 rounded-full shadow-xl tags-anim transform translate-z-30 flex items-center gap-2"
                            style="animation-delay: 0.5s;">
                            <span>🍣</span> Sushi
                        </div>
                        <!-- Smaller blurred tags for depth -->
                        <div class="absolute left-1/2 -top-10 bg-white/60 backdrop-blur text-slate-600 font-bold text-[10px] sm:text-xs px-3 sm:px-4 py-1.5 sm:py-2 rounded-full shadow-sm transform -translate-z-10 tags-anim hidden sm:block"
                            style="animation-delay: 1.5s;">Startup</div>
                        <div class="absolute -right-4 sm:-right-10 bottom-10 bg-white/60 backdrop-blur text-slate-600 font-bold text-[10px] sm:text-xs px-3 sm:px-4 py-1.5 sm:py-2 rounded-full shadow-sm transform -translate-z-10 tags-anim hidden sm:block"
                            style="animation-delay: 0.8s;">Art</div>
                    </div>
                </div>

                <!-- Right: Text Content -->
                <div class="flex-1 max-w-md">
                    <span
                        class="text-primary font-bold text-xs sm:text-sm tracking-widest uppercase mb-3 sm:mb-4 block">Transcake</span>
                    <h2
                        class="text-2xl sm:text-3xl md:text-4xl lg:text-5xl font-black text-slate-900 mb-4 sm:mb-6 leading-tight">
                        Không chỉ là gọi
                        xe.<br />Đó là sự kết nối.</h2>
                    <p class="text-slate-600 text-base sm:text-lg leading-relaxed">Trải nghiệm gọi xe trở nên thú vị hơn
                        bao giờ hết
                        khi bạn tìm thấy người bạn đồng hành chung gu âm nhạc, sở thích và phong
                        cách sống, xua tan đi
                        sự tẻ nhạt.</p>
                </div>
            </div>
        </section>
        <!-- Testimonials -->
        <section class="py-8 sm:py-10 md:py-12 px-4 sm:px-6 max-w-6xl mx-auto">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Review 1 -->
                <div
                    class="bg-white p-8 rounded-3xl shadow-sm border border-slate-100 flex flex-col justify-between hover:shadow-md transition-shadow">
                    <div>
                        <div class="flex items-center justify-between mb-6">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-full bg-slate-200 overflow-hidden"><img
                                        src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=100" />
                                </div>
                                <div>
                                    <h4 class="font-bold text-sm">Hinh Sanh</h4>
                                    <p class="text-xs text-slate-500">Trust Point: 10</p>
                                </div>
                            </div>
                            <span class="material-symbols-outlined text-slate-300">format_quote</span>
                        </div>
                        <p class="text-slate-600 font-medium leading-relaxed italic text-sm">"Ban đầu cũng hơi ngại đi
                            chung với người lạ, nhưng dùng Transcake thì khác hẳn. Sáng nay ghép được một anh tài xế
                            cùng sở thích nghe nhạc Rock, hai anh em mải buôn chuyện mà đến công ty lúc nào không hay.
                            Xe sạch, app báo giá rõ ràng, cực kỳ ưng!"</p>
                    </div>
                    <span class="text-[10px] text-slate-400 font-medium uppercase tracking-widest mt-6">Hanoi,
                        Vietnam</span>
                </div>
                <!-- Review 2 -->
                <div
                    class="bg-white p-8 rounded-3xl shadow-sm border border-slate-100 flex flex-col justify-between hover:shadow-md transition-shadow">
                    <div>
                        <div class="flex items-center justify-between mb-6">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-full bg-slate-200 overflow-hidden"><img
                                        src="https://images.unsplash.com/photo-1580489944761-15a19d654956?auto=format&fit=crop&q=80&w=100" />
                                </div>
                                <div>
                                    <h4 class="font-bold text-sm">Nguyen Mom</h4>
                                    <p class="text-xs text-slate-500">Trust Point: 10</p>
                                </div>
                            </div>
                            <span class="material-symbols-outlined text-slate-300">format_quote</span>
                        </div>
                        <p class="text-slate-600 font-medium leading-relaxed italic text-sm">"Đi làm về muộn mà có app
                            này thấy yên tâm hẳn. Mình hay chọn bộ lọc 'Tài xế nữ' cho an toàn. Các chị em tài xế thân
                            thiện, nói chuyện vui vẻ, lại còn tiết kiệm được kha khá so với đặt xe truyền thống. 5 sao
                            cho đội ngũ Transcake!"</p>
                    </div>
                    <span class="text-[10px] text-slate-400 font-medium uppercase tracking-widest mt-6">Da Nang,
                        Vietnam</span>
                </div>
                <!-- Review 3 -->
                <div
                    class="bg-white p-8 rounded-3xl shadow-sm border border-slate-100 flex flex-col justify-between hover:shadow-md transition-shadow">
                    <div>
                        <div class="flex items-center justify-between mb-6">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-full bg-slate-200 overflow-hidden"><img
                                        src="https://images.unsplash.com/photo-1554151228-14d9def656e4?auto=format&fit=crop&q=80&w=100" />
                                </div>
                                <div>
                                    <h4 class="font-bold text-sm">Van Tinh</h4>
                                    <p class="text-xs text-slate-500">Trust Point: 10</p>
                                </div>
                            </div>
                            <span class="material-symbols-outlined text-slate-300">format_quote</span>
                        </div>
                        <p class="text-slate-600 font-medium leading-relaxed italic text-sm">"Thích nhất tính năng Bản
                            đồ mạng xã hội trên app, vừa đi vừa biết bạn bè mình đang ở đâu quanh đây. Chiều qua
                            ghép chuyến đi nhậu với mấy ông bạn cùng tần số IT, tiện đường mà lại còn kết nối thêm được
                            mối quan hệ mới. Rất đáng để trải nghiệm mỗi ngày."</p>
                    </div>
                    <span class="text-[10px] text-slate-400 font-medium uppercase tracking-widest mt-6">HCMC,
                        Vietnam</span>
                </div>
            </div>
            <!-- Paginator mock -->
            <div class="flex justify-center mt-8 gap-2">
                <div class="w-2 h-2 rounded-full bg-primary/20 cursor-pointer"></div>
                <div class="w-2 h-2 rounded-full bg-primary cursor-pointer w-4"></div>
                <div class="w-2 h-2 rounded-full bg-primary/20 cursor-pointer"></div>
            </div>
        </section>

        <!-- Bottom CTA Card -->
        <section class="py-12 sm:py-16 md:py-24 px-4 sm:px-6 max-w-6xl mx-auto">
            <div
                class="relative w-full rounded-2xl sm:rounded-[2rem] md:rounded-[3rem] p-6 sm:p-8 md:p-10 lg:p-16 flex flex-col md:flex-row items-center justify-between overflow-hidden">
                <!-- Gradient background exactly like mockup -->
                <div class="absolute inset-0 bg-gradient-to-r from-[#DFD5FF] via-[#EADBFF] to-[#DFD5FF] z-0"></div>
                <!-- Abstract background shape -->
                <div
                    class="absolute right-0 top-0 w-1/2 h-full bg-gradient-to-l from-white/30 to-transparent blur-2xl z-0 transform translate-x-1/2 rounded-full">
                </div>

                <div class="relative z-10 max-w-lg mb-8 sm:mb-10 md:mb-0">
                    <h2
                        class="text-2xl sm:text-3xl md:text-4xl lg:text-5xl font-black text-slate-900 mb-6 sm:mb-8 leading-tight">
                        Sẵn sàng di
                        chuyển
                        <br /> theo cách của bạn?
                    </h2>
                    <div class="flex gap-4 mb-4">
                        <!-- Button in exact mockup style -->
                        <button
                            class="bg-[#FF6B00] text-white px-8 py-3 rounded-2xl font-bold shadow-lg shadow-orange-500/30 hover:bg-orange-600 transition-colors">Tải
                            ứng dụng</button>
                    </div>
                    <div class="flex gap-3">
                        <img src="https://upload.wikimedia.org/wikipedia/commons/3/3c/Download_on_the_App_Store_Badge.svg"
                            alt="App Store" class="h-10 cursor-pointer hover:opacity-80 transition-opacity">
                        <img src="https://upload.wikimedia.org/wikipedia/commons/7/78/Google_Play_Store_badge_EN.svg"
                            alt="Google Play" class="h-10 cursor-pointer hover:opacity-80 transition-opacity">
                    </div>
                </div>

                <!-- Phone Peeking out -->
                <div class="relative z-10 w-[240px] md:w-[280px] h-0 md:h-full md:min-h-[400px] hidden md:block">
                    <div class="absolute top-20 right-0 w-[280px]">
                        <div class="phone-frame h-[500px] border-[#1e293b]">
                            <div class="phone-notch"></div>
                            <div class="w-full h-full bg-[#1e293b] relative">
                                <!-- Driver Notification Toast -->
                                <div
                                    class="absolute top-20 left-4 right-4 bg-white/10 backdrop-blur-xl p-4 rounded-2xl border border-white/20 shadow-2xl flex items-center gap-4">
                                    <div
                                        class="w-10 h-10 rounded-xl bg-purple-500 flex items-center justify-center text-white shrink-0">
                                        <span class="material-symbols-outlined text-sm">directions_car</span>
                                    </div>
                                    <div>
                                        <span class="block text-white font-bold text-sm">Driver is 5 mins away.</span>
                                    </div>
                                    <span
                                        class="material-symbols-outlined text-white/50 text-sm ml-auto">more_horiz</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer id="contact"
            class="bg-[#4615B2] pt-12 sm:pt-16 md:pt-20 pb-8 sm:pb-10 px-4 sm:px-6 text-white text-sm relative overflow-hidden">
            <!-- Decoration Star -->
            <div
                class="absolute right-[10%] top-[40%] text-white/10 text-7xl sm:text-9xl font-black pointer-events-none transform rotate-12 select-none">
                ✦</div>

            <div
                class="max-w-6xl mx-auto flex flex-col md:flex-row flex-wrap gap-8 sm:gap-10 md:gap-12 justify-between mb-10 sm:mb-12 md:mb-16 relative z-10">
                <!-- Column 1 -->
                <div class="max-w-sm">
                    <div class="flex items-center mb-6">
                        <img src="${pageContext.request.contextPath}/img/transcake-03.png" alt="Transcake Logo"
                            class="h-20 w-auto object-contain brightness-0 invert">
                    </div>
                    <p class="text-white/70 leading-relaxed font-medium">Transcake create experiences bringing true
                        human value into society standing out of the crowd.</p>
                </div>

                <!-- Column 2 -->
                <div>
                    <h5 class="font-bold mb-6 text-base text-white/90">Công ty</h5>
                    <ul class="space-y-4 font-medium text-white/60">
                        <li><a class="hover:text-white transition-colors block" href="#">About Us</a></li>
                        <li><a class="hover:text-white transition-colors block" href="#">Jobs</a></li>
                        <li><a class="hover:text-white transition-colors block" href="#">Press</a></li>
                    </ul>
                </div>

                <!-- Column 3 -->
                <div>
                    <h5 class="font-bold mb-6 text-base text-white/90">Hỗ trợ</h5>
                    <ul class="space-y-4 font-medium text-white/60">
                        <li><a class="hover:text-white transition-colors block" href="#">Help Center</a></li>
                        <li><a class="hover:text-white transition-colors block" href="#">Rules</a></li>
                        <li><a class="hover:text-white transition-colors block" href="#">Sign up as Driver</a></li>
                    </ul>
                </div>

                <!-- Column 4 -->
                <div>
                    <h5 class="font-bold mb-6 text-base text-white/90">Minh bạch & Pháp lý</h5>
                    <ul class="space-y-4 font-medium text-white/60">
                        <li><a class="hover:text-white transition-colors block" href="#">Terms</a></li>
                        <li><a class="hover:text-white transition-colors block" href="#">Privacy</a></li>
                        <li><a class="hover:text-white transition-colors block" href="#">Safety</a></li>
                        <li><a class="hover:text-white transition-colors block" href="#">Pricing</a></li>
                    </ul>
                </div>
            </div>

            <!-- Sub Footer Divider -->
            <div class="max-w-6xl mx-auto h-px bg-white/10 mb-6 sm:mb-8 w-full"></div>

            <div
                class="max-w-6xl mx-auto flex flex-col-reverse md:flex-row items-start md:items-center justify-between gap-6 relative z-10 text-white/50 font-medium">
                <p>Copyright © 2023 Transcake.<br />Vietnamese company address. All rights reserved.</p>
                <div class="flex flex-col gap-1 items-start md:items-end">
                    <span>Hotline: 0821 882 320</span>
                    <span>Email: contact@transcake.com</span>
                </div>
                <div class="flex gap-4 order-first md:order-last text-white/80">
                    <a href="#" class="hover:text-white transition-colors"><span
                            class="material-symbols-outlined text-[20px]">social_leaderboard</span></a>
                    <a href="#" class="hover:text-white transition-colors"><span
                            class="material-symbols-outlined text-[20px]">movie</span></a>
                    <a href="#" class="hover:text-white transition-colors"><span
                            class="material-symbols-outlined text-[20px]">link</span></a>
                </div>
            </div>
        </footer>

        <!-- Mobile Menu Script -->
        <script>
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
        </script>

        <!-- Scroll Spy & Smooth Scroll Script -->
        <script>
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
        </script>

        <!-- Initialize Animation Engine Script -->
        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
        <script>
            // Adjust navbar background on scroll
            const navbar = document.getElementById("navbar");
            window.addEventListener("scroll", () => {
                if (window.scrollY > 50) {
                    navbar.classList.add("scale-95");
                    navbar.classList.remove("mt-5");
                } else {
                    navbar.classList.remove("scale-95");
                }
            });
        </script>
    </body>

    </html>