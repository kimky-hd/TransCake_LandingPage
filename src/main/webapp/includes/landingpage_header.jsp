<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
                        Trải nghiệm ngay
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