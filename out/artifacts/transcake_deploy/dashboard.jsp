<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.model.User" %>
<%
    // Prevent browser caching of dashboard page to ensure latest JS and session states are loaded
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    User user = (User) session.getAttribute("loggedInUser");
    boolean isLoggedIn = (user != null);
    String fullName = isLoggedIn && user.getFullName() != null && !user.getFullName().trim().isEmpty() ?
        user.getFullName() : "Người dùng";
%>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="utf-8" />
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <title>Transcake - Dashboard</title>

                <!-- Tailwind CSS -->
                <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                <script src="${pageContext.request.contextPath}/assets/js/tailwind-config.js?v=<%= System.currentTimeMillis() %>"></script>

                <!-- Custom CSS -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css?v=<%= System.currentTimeMillis() %>" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/landingpage.css?v=<%= System.currentTimeMillis() %>" />

                <!-- Google Fonts & Material Symbols -->
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap"
                    rel="stylesheet" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400..900;1,400..900&display=swap"
                    rel="stylesheet" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                    rel="stylesheet" />

                <!-- Mapbox GL JS -->
                <script src='https://api.mapbox.com/mapbox-gl-js/v3.0.1/mapbox-gl.js'></script>
                <link href='https://api.mapbox.com/mapbox-gl-js/v3.0.1/mapbox-gl.css' rel='stylesheet' />

                <style>
                    body {
                        font-family: 'Inter', sans-serif;
                    }
                </style>
            </head>

            <body class="h-screen w-screen overflow-hidden bg-slate-100 flex relative text-slate-800">

                <!-- 1. Background (Main Stage): Mapbox Map Container -->
                <div id="map" class="absolute inset-0 z-0"></div>

                <!-- 2. Foreground (Left Dynamic Island) -->
                <!-- z-20 absolute left-8 top-8 bottom-8 w-[380px] -->
                <div class="absolute left-8 top-8 bottom-8 w-[380px] z-20 flex flex-col bg-white/75 backdrop-blur-xl border border-white/60 shadow-[0_30px_60px_rgba(0,0,0,0.15)] rounded-3xl overflow-hidden transition-all duration-500"
                    id="dynamic-island">

                    <!-- Header Section -->
                    <div class="p-6 pb-4 shrink-0 border-b border-slate-200/50 bg-white/40">
                        <div class="flex items-center justify-between mb-6">
                            <!-- Logo -->
                            <div class="flex items-center relative h-8 w-28">
                                <img src="${pageContext.request.contextPath}/img/transcake-03.png" alt="Transcake Logo"
                                    class="absolute left-0 top-1/2 -translate-y-1/2 h-10 w-auto object-contain">
                            </div>
                            <!-- Notification Bell -->
                            <button
                                class="w-10 h-10 rounded-full bg-white/80 hover:bg-white border border-slate-200 flex items-center justify-center shadow-sm transition-all relative group">
                                <span
                                    class="material-symbols-outlined text-slate-600 group-hover:text-slate-900 transition-colors">notifications</span>
                                <span
                                    class="absolute top-2.5 right-2.5 w-2 h-2 bg-red-500 rounded-full border border-white shadow-sm"></span>
                            </button>
                        </div>

                        <!-- Role Toggle -->
                        <div
                            class="bg-slate-100/80 p-1 rounded-full flex relative border border-slate-200/50 shadow-inner">
                            <!-- Sliding background -->
                            <div class="absolute top-1 bottom-1 left-1 w-[calc(50%-4px)] bg-white rounded-full shadow-sm border border-slate-200 transition-transform duration-300 ease-out"
                                id="toggle-bg"></div>

                            <button
                                class="flex-1 py-2 text-sm font-bold z-10 transition-colors duration-300 text-[#6200EE]"
                                id="btn-passenger" onclick="setRole('passenger')">Passenger</button>
                            <button
                                class="flex-1 py-2 text-sm font-bold z-10 transition-colors duration-300 text-slate-500 hover:text-slate-700"
                                id="btn-driver" onclick="setRole('driver')">Driver</button>
                        </div>
                    </div>

                    <!-- Scrollable Content Section -->
                    <div
                        class="flex-1 overflow-y-auto overflow-x-hidden panel-scroll relative bg-gradient-to-b from-white/40 to-transparent">

                        <!-- STATE 1: PASSENGER MODE -->
                        <div id="passenger-view"
                            class="transition-all duration-300 opacity-100 translate-x-0 absolute inset-x-0 top-0 p-6 pb-24">
                            <!-- Profile Card -->
                            <div class="flex items-center gap-4 mb-8">
                                <div class="relative" id="passenger-avatar-container">
                                    <div id="passenger-avatar-trigger" class="cursor-pointer">
                                        <svg class="w-14 h-14 text-slate-300 bg-slate-100 rounded-full border-[3px] border-white shadow-md hover:border-slate-300 transition-colors"
                                            fill="currentColor" viewBox="0 0 24 24">
                                            <path
                                                d="M24 20.993V24H0v-2.996A14.977 14.977 0 0112.004 15c4.904 0 9.26 2.354 11.996 5.993zM16.002 8.999a4 4 0 11-8 0 4 4 0 018 0z" />
                                        </svg>
                                    </div>
                                    <% if (isLoggedIn) { %>
                                        <!-- Dropdown Menu -->
                                        <div id="passenger-dropdown"
                                            class="hidden absolute top-full left-0 mt-2 w-44 bg-white rounded-xl shadow-lg border border-slate-100 overflow-hidden z-50">
                                            <button type="button" id="passenger-logout-btn"
                                                class="w-full text-left px-4 py-3 text-sm font-bold text-red-600 hover:bg-red-50 flex items-center gap-2 transition-colors">
                                                <span class="material-symbols-outlined text-[18px] pointer-events-none">logout</span> Đăng xuất
                                            </button>
                                        </div>
                                        <% } %>
                                </div>
                                <div class="flex-1">
                                    <% if (isLoggedIn) { %>
                                        <h3 class="font-bold text-lg text-slate-900 leading-tight">
                                            <%= fullName %>
                                        </h3>
                                        <div class="flex flex-col mt-1.5">
                                            <div class="flex items-center justify-between mb-1.5">
                                                <span
                                                    class="text-[10px] font-bold text-[#6200EE] uppercase tracking-wider bg-purple-100 border border-purple-200 px-2 py-0.5 rounded-md">Trust
                                                    Points: 10</span>
                                            </div>
                                            <div class="w-2/3 bg-purple-100 rounded-full h-1.5 overflow-hidden">
                                                <div class="bg-[#6200EE] h-full rounded-full" style="width: 100%"></div>
                                            </div>
                                        </div>
                                        <% } else { %>
                                            <div class="flex flex-col justify-center h-full gap-1">
                                                <button onclick="window.openAuthModal && window.openAuthModal()"
                                                    class="w-fit px-4 py-1.5 bg-[#6200EE] hover:bg-[#5000C8] text-white font-bold rounded-lg shadow-sm transition-colors text-sm">Đăng
                                                    nhập</button>
                                                <p class="text-[11px] text-slate-500">để sử dụng đầy đủ tính năng</p>
                                            </div>
                                            <% } %>
                                </div>
                            </div>

                            <!-- Primary CTA -->
                            <button
                                class="w-full bg-gradient-to-r from-[#6200EE] to-[#8C3AFF] hover:from-[#5000C8] hover:to-[#7A26F0] text-white font-bold text-lg py-4 rounded-2xl shadow-[0_10px_25px_rgba(98,0,238,0.35)] transition-all transform hover:-translate-y-1 hover:shadow-[0_15px_30px_rgba(98,0,238,0.4)] mb-8 flex items-center justify-center gap-2">
                                <span class="material-symbols-outlined">search</span>
                                Find a Ride
                            </button>

                            <!-- Expanded Desktop Features -->
                            <div class="space-y-3">
                                <!-- Recent Trips -->
                                <div
                                    class="bg-white/70 hover:bg-white p-4 rounded-xl border border-slate-200/60 shadow-sm cursor-pointer transition-colors flex items-center gap-4 group">
                                    <div
                                        class="w-10 h-10 rounded-full bg-purple-50 flex items-center justify-center text-[#6200EE] group-hover:scale-110 transition-transform">
                                        <span class="material-symbols-outlined">history</span>
                                    </div>
                                    <div class="flex-1">
                                        <h4 class="font-bold text-slate-800 text-sm">Recent Trips</h4>
                                        <p class="text-xs text-slate-500 font-medium">View travel history</p>
                                    </div>
                                    <span
                                        class="material-symbols-outlined text-slate-400 group-hover:text-slate-600 transition-colors">chevron_right</span>
                                </div>

                                <!-- Community Feed -->
                                <div
                                    class="bg-white/70 hover:bg-white p-4 rounded-xl border border-slate-200/60 shadow-sm cursor-pointer transition-colors flex items-center gap-4 group">
                                    <div
                                        class="w-10 h-10 rounded-full bg-purple-50 flex items-center justify-center text-[#6200EE] relative group-hover:scale-110 transition-transform">
                                        <span class="material-symbols-outlined">forum</span>
                                        <span
                                            class="absolute -top-1 -right-1 w-3 h-3 bg-red-500 border-2 border-white rounded-full"></span>
                                    </div>
                                    <div class="flex-1">
                                        <h4 class="font-bold text-slate-800 text-sm">Community Feed</h4>
                                        <p class="text-xs text-slate-500 font-medium">Connect with your network</p>
                                    </div>
                                    <span
                                        class="material-symbols-outlined text-slate-400 group-hover:text-slate-600 transition-colors">chevron_right</span>
                                </div>

                                <!-- Desktop Extension: Vibe Filters -->
                                <div class="mt-6 pt-6 border-t border-slate-200/60">
                                    <div class="flex items-center justify-between mb-3.5">
                                        <h4 class="font-bold text-slate-800 text-sm">Vibe Filters</h4>
                                        <span
                                            class="text-[9px] bg-slate-200/80 text-slate-600 px-2 py-0.5 rounded uppercase font-bold tracking-wider">Map
                                            Overlay</span>
                                    </div>
                                    <div class="flex flex-wrap gap-2.5">
                                        <button
                                            class="px-3 py-1.5 bg-purple-100 text-[#6200EE] text-xs font-bold rounded-full border border-purple-200 shadow-sm transition-transform hover:scale-105 flex items-center gap-1.5">
                                            &#127925; Music
                                        </button>
                                        <button
                                            class="px-3 py-1.5 bg-white text-slate-600 text-xs font-bold rounded-full border border-slate-200 shadow-sm hover:border-purple-300 hover:text-[#6200EE] transition-all hover:scale-105 flex items-center gap-1.5">
                                            &#128187; Tech
                                        </button>
                                        <button
                                            class="px-3 py-1.5 bg-white text-slate-600 text-xs font-bold rounded-full border border-slate-200 shadow-sm hover:border-purple-300 hover:text-[#6200EE] transition-all hover:scale-105 flex items-center gap-1.5">
                                            &#127936; Sports
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- STATE 2: DRIVER MODE -->
                        <div id="driver-view"
                            class="transition-all duration-300 opacity-0 translate-x-10 absolute inset-x-0 top-0 p-6 pb-24 pointer-events-none">
                            <!-- Profile Card -->
                            <div class="flex items-center gap-4 mb-8">
                                <div class="relative" id="driver-avatar-container">
                                    <div id="driver-avatar-trigger" class="cursor-pointer">
                                        <svg class="w-14 h-14 text-slate-300 bg-slate-100 rounded-full border-[3px] border-white shadow-md hover:border-slate-300 transition-colors"
                                            fill="currentColor" viewBox="0 0 24 24">
                                            <path
                                                d="M24 20.993V24H0v-2.996A14.977 14.977 0 0112.004 15c4.904 0 9.26 2.354 11.996 5.993zM16.002 8.999a4 4 0 11-8 0 4 4 0 018 0z" />
                                        </svg>
                                        <!-- Online Status Dot -->
                                        <span
                                            class="absolute bottom-0 right-0 w-4 h-4 bg-green-500 border-[2.5px] border-white rounded-full shadow-sm"></span>
                                    </div>
                                    <% if (isLoggedIn) { %>
                                        <!-- Dropdown Menu -->
                                        <div id="driver-dropdown"
                                            class="hidden absolute top-full left-0 mt-2 w-44 bg-white rounded-xl shadow-lg border border-slate-100 overflow-hidden z-50">
                                            <button type="button" id="driver-logout-btn"
                                                class="w-full text-left px-4 py-3 text-sm font-bold text-red-600 hover:bg-red-50 flex items-center gap-2 transition-colors">
                                                <span class="material-symbols-outlined text-[18px] pointer-events-none">logout</span> Đăng xuất
                                            </button>
                                        </div>
                                        <% } %>
                                </div>
                                <div class="flex-1">
                                    <% if (isLoggedIn) { %>
                                        <h3 class="font-bold text-lg text-slate-900 leading-tight">
                                            <%= fullName %>
                                        </h3>
                                        <div class="flex flex-col mt-1.5">
                                            <div class="flex items-center justify-between">
                                                <span
                                                    class="text-[10px] font-bold text-[#FF6D00] uppercase tracking-wider bg-orange-100 border border-orange-200 px-2 py-0.5 rounded-md">Trust
                                                    Points: 10</span>
                                            </div>
                                        </div>
                                        <% } else { %>
                                            <div class="flex flex-col justify-center h-full gap-1">
                                                <button onclick="window.openAuthModal && window.openAuthModal()"
                                                    class="w-fit px-4 py-1.5 bg-[#FF6D00] hover:bg-[#E66200] text-white font-bold rounded-lg shadow-sm transition-colors text-sm">Đăng
                                                    nhập</button>
                                                <p class="text-[11px] text-slate-500">để sử dụng đầy đủ tính năng</p>
                                            </div>
                                            <% } %>
                                </div>
                            </div>

                            <!-- Primary CTA -->
                            <button
                                class="w-full bg-gradient-to-r from-[#FF6D00] to-[#FF9100] hover:from-[#E66200] hover:to-[#E68200] text-white font-bold text-lg py-4 rounded-2xl shadow-[0_10px_25px_rgba(255,109,0,0.35)] transition-all transform hover:-translate-y-1 hover:shadow-[0_15px_30px_rgba(255,109,0,0.4)] mb-8 flex items-center justify-center gap-2">
                                <span class="material-symbols-outlined">add_circle</span>
                                Post a Ride
                            </button>

                            <!-- Expanded Desktop Features -->
                            <div class="space-y-3">
                                <!-- Quick Stats Grid -->
                                <div class="grid grid-cols-2 gap-3">
                                    <!-- Card 1: Ride Requests -->
                                    <div
                                        class="bg-white/70 hover:bg-white p-4 rounded-xl border border-slate-200/60 shadow-sm cursor-pointer transition-colors flex flex-col justify-between min-h-[100px] group">
                                        <span
                                            class="material-symbols-outlined text-slate-400 group-hover:text-red-500 transition-colors mb-2">person_add</span>
                                        <div>
                                            <h4 class="font-bold text-slate-800 text-xs">Ride Requests</h4>
                                            <p class="text-[13px] font-black text-red-500 mt-0.5">3 new pending</p>
                                        </div>
                                    </div>
                                    <!-- Card 2: Earnings -->
                                    <div
                                        class="bg-white/70 hover:bg-white p-4 rounded-xl border border-slate-200/60 shadow-sm cursor-pointer transition-colors flex flex-col justify-between min-h-[100px] relative overflow-hidden group">
                                        <!-- Mini line chart background -->
                                        <svg class="absolute bottom-0 left-0 w-full h-12 opacity-20"
                                            viewBox="0 0 100 40" preserveAspectRatio="none">
                                            <path d="M0,40 L0,30 L20,35 L40,15 L60,25 L80,5 L100,20 L100,40 Z"
                                                fill="#10B981" />
                                            <path d="M0,30 L20,35 L40,15 L60,25 L80,5 L100,20" fill="none"
                                                stroke="#10B981" stroke-width="2" />
                                        </svg>
                                        <span
                                            class="material-symbols-outlined text-slate-400 group-hover:text-emerald-500 transition-colors mb-2 relative z-10">account_balance_wallet</span>
                                        <div class="relative z-10">
                                            <h4 class="font-bold text-slate-800 text-xs">Earnings</h4>
                                            <p class="text-[13px] font-black text-emerald-600 mt-0.5">$245.50 /wk</p>
                                        </div>
                                    </div>
                                </div>

                                <!-- Driver History -->
                                <div
                                    class="bg-white/70 hover:bg-white p-4 rounded-xl border border-slate-200/60 shadow-sm cursor-pointer transition-colors flex items-center gap-4 mt-1 group">
                                    <div
                                        class="w-10 h-10 rounded-full bg-orange-50 flex items-center justify-center text-[#FF6D00] group-hover:scale-110 transition-transform">
                                        <span class="material-symbols-outlined">directions_car</span>
                                    </div>
                                    <div class="flex-1">
                                        <h4 class="font-bold text-slate-800 text-sm">Driver History</h4>
                                        <p class="text-xs text-slate-500 font-medium">Review past rides</p>
                                    </div>
                                    <span
                                        class="material-symbols-outlined text-slate-400 group-hover:text-slate-600 transition-colors">chevron_right</span>
                                </div>

                                <!-- Desktop Extension: Heatmap Overlay Toggle -->
                                <div class="mt-6 pt-6 border-t border-slate-200/60">
                                    <div
                                        class="flex items-center justify-between bg-white p-4 rounded-xl border border-slate-200 shadow-sm">
                                        <div class="flex items-center gap-3">
                                            <div
                                                class="w-8 h-8 rounded-full bg-orange-50 flex items-center justify-center text-[#FF6D00]">
                                                <span class="material-symbols-outlined text-sm">map</span>
                                            </div>
                                            <div>
                                                <h4 class="font-bold text-slate-800 text-sm">Heatmap Overlay</h4>
                                                <p class="text-[10px] text-slate-500 font-medium">Show high-demand areas
                                                </p>
                                            </div>
                                        </div>
                                        <!-- Toggle switch -->
                                        <label class="relative inline-flex items-center cursor-pointer">
                                            <input type="checkbox" value="" class="sr-only peer">
                                            <div
                                                class="w-9 h-5 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-[#FF6D00]">
                                            </div>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <!-- Navigation (Bottom Menu) -->
                    <div
                        class="absolute bottom-0 left-0 right-0 p-4 bg-white/90 backdrop-blur-lg border-t border-slate-200/60 z-30">
                        <div class="flex items-center justify-around">
                            <button
                                class="w-12 h-12 flex items-center justify-center rounded-xl bg-purple-50 text-[#6200EE] shadow-sm transition-colors relative"
                                id="nav-home">
                                <span class="material-symbols-outlined font-bold">home</span>
                                <span
                                    class="absolute -top-1 -right-1 w-2.5 h-2.5 bg-red-500 border-2 border-white rounded-full"></span>
                            </button>
                            <button
                                class="w-12 h-12 flex items-center justify-center rounded-xl text-slate-400 hover:bg-slate-100 hover:text-slate-600 transition-colors">
                                <span class="material-symbols-outlined">map</span>
                            </button>
                            <button
                                class="w-12 h-12 flex items-center justify-center rounded-xl text-slate-400 hover:bg-slate-100 hover:text-slate-600 transition-colors">
                                <span class="material-symbols-outlined">article</span>
                            </button>
                            <button
                                class="w-12 h-12 flex items-center justify-center rounded-xl text-slate-400 hover:bg-slate-100 hover:text-slate-600 transition-colors">
                                <span class="material-symbols-outlined">person</span>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Locate Me Button -->
                <button onclick="recenterMap()"
                    class="absolute bottom-8 right-8 z-20 w-14 h-14 bg-white text-slate-700 hover:text-[#6200EE] rounded-full shadow-[0_8px_20px_rgba(0,0,0,0.15)] flex items-center justify-center transition-all hover:scale-105 border border-slate-200"
                    title="Vị trí của tôi">
                    <span class="material-symbols-outlined text-[28px]">my_location</span>
                </button>

                <!-- Script to handle switching roles -->
                <script>
                    let userLngLat = [105.8542, 21.0285]; // Default: Hanoi

                    function recenterMap() {
                        if (window.mapInstance) {
                            window.mapInstance.flyTo({
                                center: userLngLat,
                                zoom: 15,
                                speed: 1.2
                            });
                        }
                    }

                    function setRole(role) {
                        const toggleBg = document.getElementById('toggle-bg');
                        const btnPassenger = document.getElementById('btn-passenger');
                        const btnDriver = document.getElementById('btn-driver');

                        const passView = document.getElementById('passenger-view');
                        const drvView = document.getElementById('driver-view');

                        const markerPulse = document.getElementById('marker-pulse');
                        const markerDot = document.getElementById('marker-dot');

                        const navHome = document.getElementById('nav-home');

                        if (role === 'passenger') {
                            // UI Toggle position
                            toggleBg.style.transform = 'translateX(0)';

                            // Text colors
                            btnPassenger.classList.remove('text-slate-500', 'hover:text-slate-700');
                            btnPassenger.classList.add('text-[#6200EE]');

                            btnDriver.classList.remove('text-[#FF6D00]');
                            btnDriver.classList.add('text-slate-500', 'hover:text-slate-700');

                            // View transition
                            passView.classList.replace('opacity-0', 'opacity-100');
                            passView.classList.replace('-translate-x-10', 'translate-x-0');
                            passView.classList.remove('pointer-events-none');

                            drvView.classList.replace('opacity-100', 'opacity-0');
                            drvView.classList.replace('translate-x-0', 'translate-x-10');
                            drvView.classList.add('pointer-events-none');

                            // Update map marker colors
                            markerPulse.className = 'absolute w-20 h-20 bg-[#6200EE]/30 rounded-full animate-ping';
                            markerDot.className = 'relative w-8 h-8 bg-[#6200EE] border-[3px] border-white rounded-full shadow-xl';

                            // Update nav active color
                            navHome.classList.replace('text-[#FF6D00]', 'text-[#6200EE]');
                            navHome.classList.replace('bg-orange-50', 'bg-purple-50');

                        } else {
                            // UI Toggle position
                            toggleBg.style.transform = 'translateX(100%)';

                            // Text colors
                            btnDriver.classList.remove('text-slate-500', 'hover:text-slate-700');
                            btnDriver.classList.add('text-[#FF6D00]');

                            btnPassenger.classList.remove('text-[#6200EE]');
                            btnPassenger.classList.add('text-slate-500', 'hover:text-slate-700');

                            // View transition
                            drvView.classList.replace('opacity-0', 'opacity-100');
                            drvView.classList.replace('translate-x-10', 'translate-x-0');
                            drvView.classList.remove('pointer-events-none');

                            passView.classList.replace('opacity-100', 'opacity-0');
                            passView.classList.replace('translate-x-0', '-translate-x-10');
                            passView.classList.add('pointer-events-none');

                            // Update map marker colors (if marker exists)
                            if (window.userMarkerEl) {
                                const pulse = window.userMarkerEl.querySelector('.animate-ping');
                                const dot = window.userMarkerEl.querySelector('.shadow-xl');
                                if (pulse) pulse.className = 'absolute w-20 h-20 bg-[#FF6D00]/30 rounded-full animate-ping';
                                if (dot) dot.className = 'relative w-8 h-8 bg-[#FF6D00] border-[3px] border-white rounded-full shadow-xl';
                            }

                            // Update nav active color
                            navHome.classList.replace('text-[#6200EE]', 'text-[#FF6D00]');
                            navHome.classList.replace('bg-purple-50', 'bg-orange-50');
                        }
                    }

                    // ==========================================
                    // MAPBOX INITIALIZATION & GEOLOCATION
                    // ==========================================

                    // Access token của bạn
                    mapboxgl.accessToken = 'pk.eyJ1Ijoia2lta3l2dSIsImEiOiJjbXBrbjBsenkxaG8xMnJvcWE4Ymp2bHVkIn0.cqSefs1dwaF89hY4SlLUsQ';

                    // Khởi tạo bản đồ với style sáng màu (phù hợp UI)
                    const map = new mapboxgl.Map({
                        container: 'map', // id của thẻ div
                        style: 'mapbox://styles/mapbox/light-v11', // giao diện sáng, tối giản
                        center: [105.8542, 21.0285], // Tọa độ mặc định (Hà Nội)
                        zoom: 13,
                        attributionControl: false // Ẩn logo mapbox nhỏ nếu muốn UI sạch hơn
                    });
                    window.mapInstance = map;

                    // Tạo DOM element cho Custom Marker
                    const markerEl = document.createElement('div');
                    markerEl.className = 'relative flex items-center justify-center';
                    markerEl.innerHTML = `
            <div class="absolute w-20 h-20 bg-[#6200EE]/30 rounded-full animate-ping"></div>
            <div class="relative w-8 h-8 bg-[#6200EE] border-[3px] border-white rounded-full shadow-xl">
                <div class="absolute inset-0 rounded-full border border-black/10"></div>
            </div>
        `;
                    // Lưu lại để có thể đổi màu khi toggle role
                    window.userMarkerEl = markerEl;

                    // Khởi tạo đối tượng Marker của Mapbox (nhưng chưa add vào map)
                    const userMarker = new mapboxgl.Marker(markerEl);

                    // Khi bản đồ load xong, ta sẽ lấy vị trí thực của user
                    map.on('load', () => {
                        if (navigator.geolocation) {
                            // Yêu cầu quyền truy cập vị trí và lấy tọa độ
                            navigator.geolocation.getCurrentPosition(
                                (position) => {
                                    const lng = position.coords.longitude;
                                    const lat = position.coords.latitude;
                                    userLngLat = [lng, lat]; // Cập nhật vị trí toàn cục

                                    // Di chuyển bản đồ (FlyTo) tới vị trí của user với hiệu ứng mượt
                                    map.flyTo({
                                        center: [lng, lat],
                                        zoom: 15,
                                        speed: 1.2
                                    });

                                    // Đặt custom marker lên vị trí của user
                                    userMarker.setLngLat([lng, lat]).addTo(map);
                                },
                                (error) => {
                                    console.error("Lỗi khi lấy vị trí: ", error.message);
                                    // Nếu user từ chối, marker có thể được đặt ở tọa độ mặc định
                                    userMarker.setLngLat([105.8542, 21.0285]).addTo(map);
                                },
                                {
                                    enableHighAccuracy: true,
                                    timeout: 5000,
                                    maximumAge: 0
                                }
                            );
                        } else {
                            console.log("Trình duyệt không hỗ trợ Geolocation.");
                        }
                    });

                </script>

                <!-- Auth Modal Include & Script -->
                <jsp:include page="includes/auth_modal.jsp" />
                <!-- Onboarding Modal -->
                <jsp:include page="includes/onboarding_modal.jsp" />

                <!-- Logout Confirmation Modal (Bulletproof) -->
                <div id="logoutConfirmModal" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; z-index: 999999; align-items: center; justify-content: center; font-family: 'Inter', sans-serif;">
                    <!-- Backdrop -->
                    <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px);"></div>
                    
                    <!-- Content -->
                    <div style="background: white; border-radius: 1.5rem; padding: 1.5rem; position: relative; width: 90%; max-width: 24rem; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25); display: flex; flex-direction: column; align-items: center; text-align: center; animation: modalPop 0.3s ease-out forwards;">
                        <style>
                            @keyframes modalPop {
                                0% { opacity: 0; transform: scale(0.95); }
                                100% { opacity: 1; transform: scale(1); }
                            }
                        </style>
                        <div style="width: 4rem; height: 4rem; background: rgba(254, 226, 226, 0.5); border-radius: 9999px; display: flex; align-items: center; justify-content: center; color: #ef4444; margin-bottom: 1rem; border: 1px solid #fee2e2;">
                            <span class="material-symbols-outlined" style="font-size: 1.875rem;">logout</span>
                        </div>
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: #1e293b; margin-bottom: 0.5rem; line-height: 1.2;">Đăng xuất tài khoản?</h3>
                        <p style="font-size: 0.875rem; color: #64748b; font-weight: 500; margin-bottom: 1.5rem; line-height: 1.5;">Bạn có chắc chắn muốn đăng xuất không? Bạn sẽ cần đăng nhập lại để tiếp tục sử dụng.</p>
                        <div style="display: flex; gap: 0.75rem; width: 100%;">
                            <button type="button" id="btnCancelLogout"
                                style="flex: 1; padding: 0.75rem 1rem; background: #f1f5f9; color: #334155; font-weight: 700; border-radius: 0.75rem; font-size: 0.875rem; border: none; cursor: pointer; transition: background 0.2s;" onmouseover="this.style.background='#e2e8f0'" onmouseout="this.style.background='#f1f5f9'">Hủy bỏ</button>
                            <button type="button" id="btnConfirmLogout"
                                style="flex: 1; padding: 0.75rem 1rem; background: #ef4444; color: white; font-weight: 700; border-radius: 0.75rem; font-size: 0.875rem; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); border: none; cursor: pointer; transition: background 0.2s;" onmouseover="this.style.background='#dc2626'" onmouseout="this.style.background='#ef4444'">Đăng xuất</button>
                        </div>
                    </div>
                </div>

                <script>
                    window.CONTEXT_PATH = '${pageContext.request.contextPath}';
                    <% if (!isLoggedIn) { %>
                        // Auto-open modal if not logged in
                        document.addEventListener('DOMContentLoaded', () => {
                            setTimeout(() => {
                                if (window.openAuthModal) window.openAuthModal();
                            }, 500);
                        });
                    <% } %>

                    // Define functions globally on window
                    window.showLogoutConfirmModal = function() {
                        console.log("[Logout] Opening confirmation modal");
                        const modal = document.getElementById('logoutConfirmModal');
                        if (modal) {
                            modal.style.setProperty('display', 'flex', 'important');
                        } else {
                            console.error("[Logout] Modal #logoutConfirmModal not found!");
                        }
                        const passDrop = document.getElementById('passenger-dropdown');
                        const drivDrop = document.getElementById('driver-dropdown');
                        if (passDrop) passDrop.classList.add('hidden');
                        if (drivDrop) drivDrop.classList.add('hidden');
                    };

                    window.closeLogoutConfirmModal = function() {
                        console.log("[Logout] Closing confirmation modal");
                        const modal = document.getElementById('logoutConfirmModal');
                        if (modal) {
                            modal.style.setProperty('display', 'none', 'important');
                        }
                    };

                    window.confirmLogout = function() {
                        console.log("[Logout] confirmLogout triggered");
                        const btn = document.getElementById('btnConfirmLogout');
                        if (btn) {
                            btn.disabled = true;
                            btn.innerHTML = 'Đang đăng xuất...';
                        }
                        fetch(window.CONTEXT_PATH + '/api/logout', { method: 'POST' })
                            .then(res => {
                                if(!res.ok) throw new Error("HTTP error " + res.status);
                                return res.json();
                            })
                            .then(data => {
                                console.log("[Logout] Response received", data);
                                if (data.success) {
                                    window.location.href = window.CONTEXT_PATH + '/dashboard.jsp';
                                } else {
                                    alert("Đăng xuất thất bại: " + data.message);
                                    if (btn) {
                                        btn.disabled = false;
                                        btn.innerHTML = 'Đăng xuất';
                                    }
                                }
                            })
                            .catch(err => {
                                console.error("[Logout] error", err);
                                alert("Đã xảy ra lỗi mạng khi đăng xuất. Trình duyệt sẽ tự tải lại.");
                                window.location.href = window.CONTEXT_PATH + '/dashboard.jsp';
                            });
                    };

                    // Bind dynamic events after DOM content is loaded
                    document.addEventListener('DOMContentLoaded', function() {
                        console.log("[Logout] Initializing logout event listeners");

                        // 1. Avatar Triggers
                        const pAvatarTrigger = document.getElementById('passenger-avatar-trigger');
                        if (pAvatarTrigger) {
                            pAvatarTrigger.addEventListener('click', function(e) {
                                e.stopPropagation();
                                const dropdown = document.getElementById('passenger-dropdown');
                                if (dropdown) dropdown.classList.toggle('hidden');
                            });
                        }
                        const dAvatarTrigger = document.getElementById('driver-avatar-trigger');
                        if (dAvatarTrigger) {
                            dAvatarTrigger.addEventListener('click', function(e) {
                                e.stopPropagation();
                                const dropdown = document.getElementById('driver-dropdown');
                                if (dropdown) dropdown.classList.toggle('hidden');
                            });
                        }

                        // 2. Dropdown Logout Buttons
                        const pLogoutBtn = document.getElementById('passenger-logout-btn');
                        if (pLogoutBtn) {
                            pLogoutBtn.addEventListener('click', function(e) {
                                console.log("[Logout] Passenger logout clicked");
                                e.preventDefault();
                                e.stopPropagation();
                                window.showLogoutConfirmModal();
                            });
                        }
                        const dLogoutBtn = document.getElementById('driver-logout-btn');
                        if (dLogoutBtn) {
                            dLogoutBtn.addEventListener('click', function(e) {
                                console.log("[Logout] Driver logout clicked");
                                e.preventDefault();
                                e.stopPropagation();
                                window.showLogoutConfirmModal();
                            });
                        }

                        // 3. Modal buttons
                        const cancelLogoutBtn = document.getElementById('btnCancelLogout');
                        if (cancelLogoutBtn) {
                            cancelLogoutBtn.addEventListener('click', function(e) {
                                e.preventDefault();
                                window.closeLogoutConfirmModal();
                            });
                        }
                        const confirmLogoutBtn = document.getElementById('btnConfirmLogout');
                        if (confirmLogoutBtn) {
                            confirmLogoutBtn.addEventListener('click', function(e) {
                                e.preventDefault();
                                window.confirmLogout();
                            });
                        }
                    });

                    // 4. Global click listener to close dropdowns when clicking outside
                    document.addEventListener('click', function (event) {
                        const passDrop = document.getElementById('passenger-dropdown');
                        const passContainer = document.getElementById('passenger-avatar-container');
                        const drivDrop = document.getElementById('driver-dropdown');
                        const drivContainer = document.getElementById('driver-avatar-container');

                        if (passDrop && passContainer && !passContainer.contains(event.target)) {
                            passDrop.classList.add('hidden');
                        }
                        if (drivDrop && drivContainer && !drivContainer.contains(event.target)) {
                            drivDrop.classList.add('hidden');
                        }
                    });
                </script>
                <!-- Toast Notification Utility -->
                <script src="${pageContext.request.contextPath}/assets/js/toast.js?v=<%= System.currentTimeMillis() %>"></script>
                <script src="${pageContext.request.contextPath}/assets/js/landingpage.js?v=<%= System.currentTimeMillis() %>"></script>
            </body>

            </html>