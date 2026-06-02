<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.model.User" %>
<%@ page import="org.example.model.BlogPost" %>
<%@ page import="org.example.model.Trip" %>
<%@ page import="org.example.dao.TripDAO" %>
<%@ page import="java.util.List" %>
<% 
    // Data is now provided by DashboardServlet
    Boolean isLoggedInAttr = (Boolean) request.getAttribute("isLoggedIn");
    
    // Nếu truy cập thẳng vào dashboard.jsp (isLoggedInAttr bị null do chưa qua Servlet), redirect về /dashboard
    if (isLoggedInAttr == null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }

    boolean isLoggedIn = (isLoggedInAttr != null && isLoggedInAttr);
    String fullName = (String) request.getAttribute("fullName");
    
    @SuppressWarnings("unchecked")
    List<BlogPost> blogPosts = (List<BlogPost>) request.getAttribute("blogPosts");
    
    Trip activeTrip = (Trip) request.getAttribute("activeTrip");
    Trip activePreBookTrip = (Trip) request.getAttribute("activePreBookTrip");
    
    String preBookDateStr = (String) request.getAttribute("preBookDateStr");
    String preBookTimeStr = (String) request.getAttribute("preBookTimeStr");
    
    if (preBookDateStr == null) preBookDateStr = "";
    if (preBookTimeStr == null) preBookTimeStr = "";
%>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="utf-8" />
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <title>Transcake - Dashboard</title>
                <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/transcake-04.png" />

                <!-- Tailwind CSS -->
                <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                <script
                    src="${pageContext.request.contextPath}/assets/js/tailwind-config.js?v=<%= System.currentTimeMillis() %>"></script>

                <!-- Custom CSS -->
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/css/styles.css?v=<%= System.currentTimeMillis() %>" />
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/css/landingpage.css?v=<%= System.currentTimeMillis() %>" />

                <!-- Google Fonts & Material Symbols -->
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap"
                    rel="stylesheet" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400..900;1,400..900&display=swap"
                    rel="stylesheet" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                    rel="stylesheet" />

                <!-- VietMap GL JS -->
                <script src="https://unpkg.com/@vietmap/vietmap-gl-js@6.0.1/dist/vietmap-gl.js"></script>
                <link href="https://unpkg.com/@vietmap/vietmap-gl-js@6.0.1/dist/vietmap-gl.css" rel="stylesheet" />

                <style>
                    body {
                        font-family: 'Inter', sans-serif;
                        /* Removed custom cursors to use system defaults */
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
                                id="btn-passenger" onclick="setRole('passenger')">Hành khách</button>
                            <button
                                class="flex-1 py-2 text-sm font-bold z-10 transition-colors duration-300 text-slate-500 hover:text-slate-700"
                                id="btn-driver" onclick="setRole('driver')">Tài xế</button>
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

                                </div>
                                <div class="flex-1">
                                    <% if (isLoggedIn) { %>
                                        <h3 class="font-bold text-lg text-slate-900 leading-tight">
                                            <%= fullName %>
                                        </h3>
                                        <div class="flex flex-col mt-1.5">
                                            <div class="flex items-center justify-between mb-1.5">
                                                <span
                                                    class="text-[10px] font-bold text-[#6200EE] uppercase tracking-wider bg-purple-100 border border-purple-200 px-2 py-0.5 rounded-md">Điểm uy tín: 10</span>
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

                            <!-- Primary CTA & Search Form -->
                            <div class="mb-8 relative">
                                <button <% if (isLoggedIn) { %>
                                    onclick="toggleBottomSearchBar()"
                                    <% } else { %>
                                        onclick="window.openAuthModal && window.openAuthModal()"
                                        <% } %>
                                            class="w-full bg-gradient-to-r from-[#6200EE] to-[#8C3AFF]
                                            hover:from-[#5000C8] hover:to-[#7A26F0] text-white font-bold text-lg py-4
                                            rounded-2xl shadow-[0_10px_25px_rgba(98,0,238,0.35)] transition-all
                                            transform hover:-translate-y-1 hover:shadow-[0_15px_30px_rgba(98,0,238,0.4)]
                                            flex items-center justify-center gap-2 relative z-10">
                                            <span class="material-symbols-outlined">search</span>
                                            Tìm kiếm chuyến đi
                                </button>
                            </div>

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
                                        <h4 class="font-bold text-slate-800 text-sm">Lịch sử chuyến đi</h4>
                                        <p class="text-xs text-slate-500 font-medium">Xem lịch sử chuyến đi</p>
                                    </div>
                                    <span
                                        class="material-symbols-outlined text-slate-400 group-hover:text-slate-600 transition-colors">chevron_right</span>
                                </div>

                                <!-- Community Feed -->
                                <div onclick="toggleBottomBlogBar()"
                                    class="bg-white/70 hover:bg-white p-4 rounded-xl border border-slate-200/60 shadow-sm cursor-pointer transition-colors flex items-center gap-4 group">
                                    <div
                                        class="w-10 h-10 rounded-full bg-purple-50 flex items-center justify-center text-[#6200EE] relative group-hover:scale-110 transition-transform">
                                        <span class="material-symbols-outlined">forum</span>
                                        <span
                                            class="absolute -top-1 -right-1 w-3 h-3 bg-red-500 border-2 border-white rounded-full"></span>
                                    </div>
                                    <div class="flex-1">
                                        <h4 class="font-bold text-slate-800 text-sm">Kết nối cộng đồng</h4>
                                        <p class="text-xs text-slate-500 font-medium">Kết nối với cộng đồng của bạn</p>
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

                                </div>
                                <div class="flex-1">
                                    <% if (isLoggedIn) { %>
                                        <h3 class="font-bold text-lg text-slate-900 leading-tight">
                                            <%= fullName %>
                                        </h3>
                                        <div class="flex flex-col mt-1.5">
                                            <div class="flex items-center justify-between">
                                                <span
                                                    class="text-[10px] font-bold text-[#FF6D00] uppercase tracking-wider bg-orange-100 border border-orange-200 px-2 py-0.5 rounded-md">Điểm uy tín: 10</span>
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
                                Đăng chuyến đi
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
                                            <h4 class="font-bold text-slate-800 text-xs">Đề xuất chuyến đi</h4>
                                            <p class="text-[13px] font-black text-red-500 mt-0.5">3 chuyến đang chờ</p>
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
                                            <h4 class="font-bold text-slate-800 text-xs">Thu nhập</h4>
                                            <p class="text-[13px] font-black text-emerald-600 mt-0.5">800.000đ/wk</p>
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
                                        <h4 class="font-bold text-slate-800 text-sm">Lịch sử chuyến đi</h4>
                                        <p class="text-xs text-slate-500 font-medium">Xem lịch sử chuyến đi</p>
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

                        <!-- STATE 3: PROFILE VIEW -->
                        <div id="sidebar-profile-view"
                            class="transition-all duration-300 opacity-0 translate-x-10 absolute inset-x-0 top-0 p-6 pb-24 pointer-events-none flex flex-col items-center justify-start min-h-[400px]">
                            
                            <div class="w-full flex items-center mb-8">
                                <button id="btn-back-from-profile" class="w-10 h-10 rounded-full bg-white hover:bg-slate-100 border border-slate-200 flex items-center justify-center shadow-sm transition-all relative z-10 cursor-pointer">
                                    <span class="material-symbols-outlined text-slate-600">arrow_back</span>
                                </button>
                                <h3 class="flex-1 text-center font-bold text-lg text-slate-800 -ml-10">Hồ sơ cá nhân</h3>
                            </div>
                            
                            <div class="flex flex-col items-center mb-8">
                                <div class="w-24 h-24 text-slate-400 bg-slate-100 rounded-full border-[4px] border-white shadow-lg flex items-center justify-center mb-4 relative">
                                     <span class="material-symbols-outlined text-[48px]">person</span>
                                </div>
                                <h3 class="font-bold text-xl text-slate-900 leading-tight mb-1"><%= fullName != null ? fullName : "Khách" %></h3>
                                <p class="text-sm text-slate-500"><%= isLoggedIn ? "Thành viên Transcake" : "Chưa đăng nhập" %></p>
                            </div>
                            
                            <% if (isLoggedIn) { %>
                            <div class="w-full space-y-3 px-4 mt-auto pt-8 border-t border-slate-200/50">
                                <!-- Other functions can be added here later -->
                                <button id="profile-logout-btn" onclick="handleProfileLogout()" class="w-full bg-red-50 hover:bg-red-100 text-red-600 font-bold text-sm py-3 rounded-xl border border-red-200 shadow-sm transition-all flex items-center justify-center gap-2 cursor-pointer relative z-50">
                                    <span class="material-symbols-outlined text-[18px]">logout</span>
                                    Đăng xuất
                                </button>
                                <script>
                                    function handleProfileLogout() {
                                        if (window.showConfirmModal) {
                                            window.showConfirmModal('Đăng xuất', 'Bạn có chắc chắn muốn đăng xuất không? Bạn sẽ cần đăng nhập lại để tiếp tục sử dụng.', function() {
                                                var ctx = window.CONTEXT_PATH || '';
                                                var btn = document.getElementById('profile-logout-btn');
                                                if(btn) { btn.innerHTML = '<span class="material-symbols-outlined text-[18px] animate-spin">sync</span> Đang xử lý...'; }
                                                
                                                fetch(ctx + '/api/logout', { method: 'POST' })
                                                    .then(function(r) { return r.json(); })
                                                    .then(function(d) {
                                                        if(d.success) {
                                                            if(window.showToast) window.showToast(d.message || 'Đăng xuất thành công!', 'success');
                                                            setTimeout(function(){ window.location.href = ctx + '/dashboard'; }, 1000);
                                                        } else {
                                                            if(window.showToast) window.showToast(d.message || 'Đăng xuất thất bại', 'error');
                                                            if(btn) { btn.innerHTML = '<span class="material-symbols-outlined text-[18px]">logout</span> Đăng xuất'; }
                                                        }
                                                    })
                                                    .catch(function() {
                                                        if(window.showToast) window.showToast('Lỗi kết nối, đang chuyển hướng...', 'error');
                                                        setTimeout(function(){ window.location.href = ctx + '/dashboard'; }, 1500);
                                                    });
                                            });
                                        } else {
                                            alert('Lỗi: Không tìm thấy hàm showConfirmModal!');
                                        }
                                    }
                                </script>
                            </div>
                            <% } %>
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
                                class="w-12 h-12 flex items-center justify-center rounded-xl text-slate-400 hover:bg-slate-100 hover:text-slate-600 transition-colors"
                                id="nav-blog" onclick="toggleBottomBlogBar()">
                                <span class="material-symbols-outlined">article</span>
                            </button>
                            <button
                                class="w-12 h-12 flex items-center justify-center rounded-xl text-slate-400 hover:bg-slate-100 hover:text-slate-600 transition-colors"
                                id="nav-profile" onclick="window.openProfileView(document.getElementById('passenger-view').classList.contains('opacity-0') ? 'driver' : 'passenger')">
                                <span class="material-symbols-outlined">person</span>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Bottom Search Bar (Right of Dynamic Island) -->
                <% if (isLoggedIn) { %>
                    <div id="bottom-search-bar"
                        class="fixed bottom-8 left-[420px] right-8 z-30 bg-white/75 backdrop-blur-xl border border-white/60 rounded-3xl p-6 transition-all duration-500 transform translate-y-[150%] opacity-0 flex flex-col w-auto min-h-[360px]">

                        <!-- Handle for dragging/closing -->
                        <div class="w-full flex justify-center mb-4 cursor-pointer" onclick="toggleBottomSearchBar()">
                            <div class="w-16 h-1.5 bg-slate-300 rounded-full hover:bg-slate-400 transition-colors">
                            </div>
                        </div>

                        <!-- Header & Close -->
                        <div class="flex justify-between items-center mb-6">
                            <h3 class="text-2xl font-bold text-slate-800 tracking-tight">Tìm kiếm chuyến đi</h3>
                            <button onclick="toggleBottomSearchBar()"
                                class="w-10 h-10 rounded-full bg-slate-100 hover:bg-slate-200 flex items-center justify-center text-slate-600 transition-colors">
                                <span class="material-symbols-outlined text-[20px]">close</span>
                            </button>
                        </div>

                        <!-- Split Layout: Left (Form) | Right (Results) -->
                        <div class="flex flex-col lg:flex-row gap-8 flex-1 h-full">

                            <!-- LEFT: Search Form -->
                            <form id="trip-search-form" action="${pageContext.request.contextPath}/trip-search" method="POST"
                                onsubmit="handleTripSearch(event)"
                                class="w-full lg:w-[45%] flex flex-col gap-5 border-r border-slate-200/60 pr-4">

                                <!-- Booking Type Toggle -->
                                <div
                                    class="bg-slate-100/80 p-1 rounded-full flex relative border border-slate-200/50 shadow-inner w-full">
                                    <input type="hidden" name="tripType" id="tripType" value="ON_DEMAND">
                                    <!-- Sliding background indicator -->
                                    <div class="absolute top-1 bottom-1 left-1 w-[calc(50%-4px)] bg-white rounded-full shadow-sm border border-slate-200 transition-transform duration-300 ease-out"
                                        id="booking-type-bg"></div>

                                    <button type="button"
                                        class="flex-1 py-2 text-sm font-bold z-10 transition-colors duration-300 text-[#6200EE]"
                                        id="btn-ondemand" onclick="setBookingType('ON_DEMAND')">Đặt xe ngay</button>
                                    <button type="button"
                                        class="flex-1 py-2 text-sm font-bold z-10 transition-colors duration-300 text-slate-500 hover:text-slate-700"
                                        id="btn-prebook" onclick="setBookingType('PRE_BOOK')">Đặt lịch trước</button>
                                </div>

                                <!-- Location Input Group -->
                                <div class="relative flex flex-col gap-3 w-full">
                                    <input type="hidden" name="pickupLat" id="pickup-lat">
                                    <input type="hidden" name="pickupLng" id="pickup-lng">
                                    <input type="hidden" name="dropoffLat" id="dropoff-lat">
                                    <input type="hidden" name="dropoffLng" id="dropoff-lng">
                                    <!-- Connecting Line -->
                                    <div
                                        class="absolute left-6 top-10 bottom-10 w-[2px] bg-slate-200 flex flex-col items-center justify-center pointer-events-none z-0">
                                    </div>

                                    <!-- Pickup -->
                                    <div class="relative z-20">
                                        <div
                                            class="relative flex items-center p-1 bg-white border border-slate-200/80 rounded-full shadow-sm hover:border-[#6200EE]/50 transition-colors w-full">
                                            <div class="w-10 h-10 flex items-center justify-center shrink-0">
                                                <div
                                                    class="w-3.5 h-3.5 rounded-full border-[3px] border-[#6200EE] bg-white">
                                                </div>
                                            </div>
                                            <input type="text" id="pickup-input" name="pickup" required
                                                autocomplete="off" placeholder="Điểm đón (VD: 123 Nguyễn Trãi)"
                                                class="w-full pr-4 py-2.5 bg-transparent text-sm sm:text-base font-medium placeholder:text-slate-400 text-slate-700 border-none focus:ring-0 focus:outline-none">
                                        </div>
                                        <div id="pickup-suggestions"
                                            class="absolute left-0 right-0 top-full mt-1 bg-white border border-slate-200 rounded-xl shadow-lg overflow-hidden hidden max-h-48 panel-scroll overflow-y-auto">
                                        </div>
                                    </div>

                                    <!-- Dropoff -->
                                    <div class="relative z-10">
                                        <div
                                            class="relative flex items-center p-1 bg-white border border-slate-200/80 rounded-full shadow-sm hover:border-[#6200EE]/50 transition-colors w-full">
                                            <div class="w-10 h-10 flex items-center justify-center shrink-0">
                                                <span
                                                    class="material-symbols-outlined text-[#FF6D00] text-[22px]">location_on</span>
                                            </div>
                                            <input type="text" id="dropoff-input" name="dropoff" required
                                                autocomplete="off" placeholder="Điểm đến (VD: Sân bay Nội Bài)"
                                                class="w-full pr-4 py-2.5 bg-transparent text-sm sm:text-base font-medium placeholder:text-slate-400 text-slate-700 border-none focus:ring-0 focus:outline-none">
                                        </div>
                                        <div id="dropoff-suggestions"
                                            class="absolute left-0 right-0 top-full mt-1 bg-white border border-slate-200 rounded-xl shadow-lg overflow-hidden hidden max-h-48 panel-scroll overflow-y-auto">
                                        </div>
                                    </div>
                                    <!-- End of Location Input Group -->
                                </div>
                                
                                <!-- Vehicle Selection -->
                                <div class="flex gap-3 w-full mt-1">
                                    <label class="flex-1 cursor-pointer">
                                        <input type="radio" name="vehicleType" value="MOTORBIKE" class="peer hidden" onchange="if(document.getElementById('pickup-lat').value && document.getElementById('dropoff-lat').value) calculateRouteAndPrice();">
                                        <div class="flex items-center justify-center gap-2 p-3 bg-white border border-slate-200/80 rounded-xl shadow-sm peer-checked:border-[#6200EE] peer-checked:bg-purple-50 transition-colors">
                                            <span class="material-symbols-outlined text-[20px] text-slate-500 peer-checked:text-[#6200EE]">two_wheeler</span>
                                            <span class="text-sm font-semibold text-slate-600 peer-checked:text-[#6200EE]">Xe máy</span>
                                        </div>
                                    </label>
                                    <label class="flex-1 cursor-pointer">
                                        <input type="radio" name="vehicleType" value="CAR" class="peer hidden" checked onchange="if(document.getElementById('pickup-lat').value && document.getElementById('dropoff-lat').value) calculateRouteAndPrice();">
                                        <div class="flex items-center justify-center gap-2 p-3 bg-white border border-slate-200/80 rounded-xl shadow-sm peer-checked:border-[#6200EE] peer-checked:bg-purple-50 transition-colors">
                                            <span class="material-symbols-outlined text-[20px] text-slate-500 peer-checked:text-[#6200EE]">directions_car</span>
                                            <span class="text-sm font-semibold text-slate-600 peer-checked:text-[#6200EE]">Ô tô</span>
                                        </div>
                                    </label>
                                </div>
                                
                                <!-- Price Estimation Box -->
                                <div id="price-estimation-box" class="hidden w-full bg-orange-50/80 border border-orange-200 rounded-2xl p-4 shadow-sm transition-all duration-300 mt-2">
                                    <div class="flex justify-between items-center mb-1">
                                        <span class="text-sm font-bold text-slate-700">Giá cước ước tính</span>
                                        <span id="price-value" class="text-lg font-bold text-[#FF6D00]">...</span>
                                    </div>
                                    <div class="flex justify-between items-center text-xs text-slate-500">
                                        <span id="distance-value">Đang tính toán...</span>
                                        <span id="duration-value"></span>
                                    </div>
                                    <input type="hidden" name="price" id="trip-price">
                                    <input type="hidden" name="distance" id="trip-distance">
                                </div>

                                <!-- Note for Driver -->
                                <div class="w-full">
                                    <div class="relative flex items-start p-1 bg-white border border-slate-200/80 rounded-2xl shadow-sm hover:border-[#6200EE]/50 transition-colors w-full">
                                        <div class="w-10 h-10 flex items-center justify-center shrink-0 mt-1">
                                            <span class="material-symbols-outlined text-slate-400 text-[20px]">edit_note</span>
                                        </div>
                                        <textarea id="note-input" name="note" rows="2"
                                            placeholder="Lưu ý cho tài xế (VD: Đứng ở cổng chính, tôi mang nhiều đồ...)"
                                            class="w-full pr-4 py-2.5 bg-transparent text-sm sm:text-base placeholder:text-slate-400 text-slate-700 border-none focus:ring-0 focus:outline-none resize-none"></textarea>
                                    </div>
                                </div>

                                <!-- Date & Time -->
                                <div id="datetime-container"
                                    class="flex flex-col gap-3 hidden opacity-0 transition-all duration-300 transform -translate-y-2">
                                    <div class="flex gap-3">
                                        <div
                                            class="relative flex-1 bg-white border border-slate-200/80 rounded-full overflow-hidden shadow-sm flex items-center hover:border-[#6200EE]/50 transition-colors">
                                            <div
                                                class="w-10 h-10 flex items-center justify-center text-slate-400 shrink-0 ml-1">
                                                <span
                                                    class="material-symbols-outlined text-[18px]">calendar_today</span>
                                            </div>
                                            <input type="date" name="date" id="trip-date"
                                                class="w-full pr-4 py-2.5 bg-transparent text-sm sm:text-base font-semibold text-slate-700 border-none focus:ring-0 focus:outline-none">
                                        </div>
                                        <div
                                            class="relative flex-1 bg-white border border-slate-200/80 rounded-full overflow-hidden shadow-sm flex items-center hover:border-[#6200EE]/50 transition-colors">
                                            <div
                                                class="w-10 h-10 flex items-center justify-center text-slate-400 shrink-0 ml-1">
                                                <span class="material-symbols-outlined text-[18px]">schedule</span>
                                            </div>
                                            <input type="time" name="time" id="trip-time"
                                                class="w-full pr-4 py-2.5 bg-transparent text-sm sm:text-base font-semibold text-slate-700 border-none focus:ring-0 focus:outline-none">
                                        </div>
                                    </div>

                                    <!-- Share to Blog Toggle -->
                                    <div class="flex items-center justify-between px-2 mt-1">
                                        <div class="flex items-center gap-2">
                                            <span
                                                class="material-symbols-outlined text-[#6200EE] text-[20px]">dynamic_feed</span>
                                            <span class="text-sm font-semibold text-slate-700">Chia sẻ lên Cộng
                                                đồng</span>
                                        </div>
                                        <label class="relative inline-flex items-center cursor-pointer">
                                            <input type="checkbox" name="shareToBlog" value="true" class="sr-only peer"
                                                checked>
                                            <div
                                                class="w-9 h-5 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-[#6200EE]">
                                            </div>
                                        </label>
                                    </div>
                                </div>

                                <button type="submit" id="btn-submit-search"
                                    class="w-full bg-slate-900 hover:bg-black text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto">
                                    Tìm chuyến
                                    <span class="material-symbols-outlined text-[20px]">arrow_forward</span>
                                </button>
                            </form>

                            <!-- RIGHT: Results Display -->
                            <div class="w-full lg:w-[55%] flex flex-col pl-4 relative h-full min-h-[300px]">
                                <!-- Empty State -->
                                <div id="empty-search-state" class="absolute inset-0 flex flex-col items-center justify-center p-6 bg-white/50 border border-dashed border-slate-300/80 rounded-3xl ml-4">
                                    <div class="w-20 h-20 bg-slate-100/80 rounded-full flex items-center justify-center mb-5 shadow-inner">
                                        <span class="material-symbols-outlined text-[40px] text-slate-400">directions_car</span>
                                    </div>
                                    <h5 class="font-bold text-slate-800 text-lg mb-2">Tìm chuyến xe của bạn</h5>
                                    <p class="text-sm text-slate-500 text-center max-w-[280px]">Nhập điểm đón và điểm đến, sau đó nhấn "Tìm chuyến" để bắt đầu.</p>
                                </div>

                                <!-- Loading State -->
                                <div id="loading-search-state" class="absolute inset-0 hidden flex-col ml-4">
                                    <div class="flex items-center justify-between mb-4">
                                        <h4 class="font-bold text-slate-800 text-lg">Kết quả nổi bật</h4>
                                        <span class="bg-slate-100 text-slate-500 text-xs font-bold px-3 py-1.5 rounded-lg flex items-center gap-1 shadow-sm">
                                            <span class="material-symbols-outlined text-[14px] animate-spin">sync</span>
                                            Đang tìm kiếm
                                        </span>
                                    </div>
                                    <div class="flex-1 flex flex-col items-center justify-center p-6 bg-white/50 border border-slate-200/60 rounded-3xl shadow-inner">
                                        <div class="relative w-16 h-16 mb-6">
                                            <!-- Ripple/Pulse effect -->
                                            <div class="absolute inset-0 bg-[#6200EE]/20 rounded-full animate-ping duration-1000"></div>
                                            <div class="absolute inset-2 bg-[#6200EE]/40 rounded-full animate-pulse"></div>
                                            <div class="absolute inset-0 flex items-center justify-center bg-white rounded-full shadow-sm z-10">
                                                <span class="material-symbols-outlined text-[#6200EE] text-[28px] animate-[spin_3s_linear_infinite]">radar</span>
                                            </div>
                                        </div>
                                        <h5 class="font-bold text-slate-800 text-base mb-1">Đang quét hệ thống...</h5>
                                        <p class="text-sm text-slate-500 text-center max-w-[280px]">Chúng tôi đang tìm kiếm các chuyến xe có lộ trình phù hợp nhất với bạn.</p>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                    <!-- Mini Search Popup (Top Right) -->
                    <div id="mini-search-popup" class="fixed top-24 right-8 z-40 bg-white/90 backdrop-blur-md border border-[#6200EE]/30 rounded-2xl p-4 shadow-[0_8px_30px_rgba(98,0,238,0.15)] transition-all duration-500 transform translate-x-[150%] opacity-0 flex items-center gap-4 w-[320px] cursor-pointer hover:bg-white" onclick="toggleBottomSearchBar(); if(window.setBookingType) window.setBookingType('ON_DEMAND');">
                        <div class="relative w-10 h-10 shrink-0">
                            <div class="absolute inset-0 bg-[#6200EE]/20 rounded-full animate-ping"></div>
                            <div class="absolute inset-0 flex items-center justify-center bg-white border border-[#6200EE]/50 rounded-full shadow-sm z-10">
                                <span class="material-symbols-outlined text-[#6200EE] text-[20px] animate-[spin_3s_linear_infinite]">radar</span>
                            </div>
                        </div>
                        <div class="flex-1 min-w-0">
                            <h6 class="text-sm font-bold text-[#6200EE] mb-1">Đang tìm chuyến xe...</h6>
                            <div class="flex items-center gap-1 text-xs text-slate-600 truncate">
                                <div class="w-1.5 h-1.5 rounded-full border-[2px] border-[#6200EE] bg-white shrink-0"></div>
                                <span id="mini-popup-pickup" class="truncate"></span>
                            </div>
                            <div class="flex items-center gap-1 text-xs text-slate-600 truncate mt-0.5">
                                <span class="material-symbols-outlined text-[#FF6D00] text-[12px] shrink-0">location_on</span>
                                <span id="mini-popup-dropoff" class="truncate"></span>
                            </div>
                        </div>
                    </div>

                    <!-- Mini Prebook Popup (Top Right, Below OnDemand) -->
                    <div id="mini-prebook-popup" class="fixed top-48 right-8 z-40 bg-white/90 backdrop-blur-md border border-[#FF6D00]/30 rounded-2xl p-4 shadow-[0_8px_30px_rgba(255,109,0,0.15)] transition-all duration-500 transform translate-x-[150%] opacity-0 flex items-center gap-4 w-[320px] cursor-pointer hover:bg-white" onclick="toggleBottomSearchBar(); if(window.setBookingType) window.setBookingType('PRE_BOOK');">
                        <div class="relative w-10 h-10 shrink-0">
                            <div class="absolute inset-0 flex items-center justify-center bg-orange-50 border border-[#FF6D00]/50 rounded-full shadow-sm z-10">
                                <span class="material-symbols-outlined text-[#FF6D00] text-[20px]">calendar_month</span>
                            </div>
                        </div>
                        <div class="flex-1 min-w-0">
                            <h6 class="text-sm font-bold text-[#FF6D00] mb-1">Chuyến đi đã đặt trước</h6>
                            <div class="flex items-center gap-1 text-xs text-slate-600 truncate">
                                <div class="w-1.5 h-1.5 rounded-full border-[2px] border-[#FF6D00] bg-white shrink-0"></div>
                                <span id="mini-prebook-pickup" class="truncate"></span>
                            </div>
                            <div class="flex items-center gap-1 text-xs text-slate-600 truncate mt-0.5">
                                <span class="material-symbols-outlined text-[#FF6D00] text-[12px] shrink-0">location_on</span>
                                <span id="mini-prebook-dropoff" class="truncate"></span>
                            </div>
                        </div>
                    </div>

                    <!-- Bottom Blog Bar (Right of Dynamic Island) -->
                    <div id="bottom-blog-bar"
                        class="fixed bottom-8 left-[420px] right-8 z-30 bg-white/75 backdrop-blur-xl border border-white/60 rounded-3xl p-6 transition-all duration-500 transform translate-y-[150%] opacity-0 flex flex-col w-auto max-h-[80vh] min-h-[360px]">

                        <!-- Handle for dragging/closing -->
                        <div class="w-full flex justify-center mb-4 cursor-pointer shrink-0"
                            onclick="toggleBottomBlogBar()">
                            <div class="w-16 h-1.5 bg-slate-300 rounded-full hover:bg-slate-400 transition-colors">
                            </div>
                        </div>

                        <!-- Header & Close -->
                        <div class="flex justify-between items-center mb-6 shrink-0">
                            <h3 class="text-2xl font-bold text-slate-800 tracking-tight flex items-center gap-2">
                                <span class="material-symbols-outlined text-[#6200EE]">diversity_3</span> Cộng đồng &
                                Chia sẻ
                            </h3>
                            <button onclick="toggleBottomBlogBar()"
                                class="w-10 h-10 rounded-full bg-slate-100 hover:bg-slate-200 flex items-center justify-center text-slate-600 transition-colors">
                                <span class="material-symbols-outlined text-[20px]">close</span>
                            </button>
                        </div>

                        <!-- Split Layout -->
                        <div class="flex flex-col lg:flex-row gap-8 flex-1 min-h-0 overflow-y-auto panel-scroll pr-2 relative">
                            <!-- Left: Blog Feed (2/3) -->
                            <div class="w-full lg:w-2/3 flex flex-col space-y-5 pb-4">
<%
                                        if (blogPosts != null && !blogPosts.isEmpty()) {
                                            for (BlogPost post : blogPosts) {
                                    %>
                                    <div class="bg-white/90 border border-slate-200/80 rounded-3xl p-5 shadow-sm hover:shadow-md transition-shadow mb-4">
                                        <div class="flex items-center gap-3 mb-4">
                                            <!-- Empty Avatar -->
                                            <div class="w-10 h-10 rounded-full bg-slate-200 flex items-center justify-center shrink-0 text-slate-400">
                                                <span class="material-symbols-outlined text-[20px]">person</span>
                                            </div>
                                            <div>
                                                <h5 class="font-bold text-slate-800 text-sm"><%= post.getPassengerName() != null ? post.getPassengerName() : "Người dùng ẩn danh" %></h5>
                                                <p class="text-xs text-slate-500">
                                                    <%= post.getTripCreatedAt() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(post.getTripCreatedAt()) : "Mới đây" %>
                                                    • Nhóm Chia sẻ chuyến đi
                                                </p>
                                            </div>
                                        </div>
                                        <p class="text-slate-700 text-sm mb-3 leading-relaxed whitespace-pre-line">
                                            <strong><%= post.getTitle() %></strong>
                                            
                                            <%= post.getContent() %>
                                        </p>
                                        <div class="flex items-center gap-6 border-t border-slate-100/50 pt-3 mt-2">
                                            <button class="flex items-center gap-2 text-slate-500 hover:text-[#6200EE] transition-colors text-sm font-medium">
                                                <span class="material-symbols-outlined text-[20px]">thumb_up</span>
                                                Thích (0)
                                            </button>
                                            <button class="flex items-center gap-2 text-slate-500 hover:text-[#6200EE] transition-colors text-sm font-medium">
                                                <span class="material-symbols-outlined text-[20px]">chat_bubble</span>
                                                Bình luận (0)
                                            </button>
                                        </div>
                                    </div>
                                    <%
                                            }
                                        } else {
                                    %>
                                    <div class="text-center p-10 bg-white/50 border border-slate-200/80 rounded-3xl">
                                        <span class="material-symbols-outlined text-[40px] text-slate-300 mb-2">inbox</span>
                                        <p class="text-slate-500 font-medium">Hiện chưa có bài đăng nào.</p>
                                    </div>
                                    <%
                                        }
                                    %>
                            </div>

                            <!-- Right: Create Post & Friends (1/3) -->
                            <div class="w-full lg:w-1/3">
                                <div class="sticky top-0 flex flex-col gap-6 pb-4">
                                <!-- Create Post -->
                                <div class="bg-white/90 border border-slate-200/80 rounded-3xl p-5 shadow-sm shrink-0">
                                    <h4 class="font-bold text-slate-800 mb-3 flex items-center gap-2">
                                        <span
                                            class="material-symbols-outlined text-[#6200EE] text-[20px]">edit_square</span>
                                        Tạo bài đăng
                                    </h4>
                                    <textarea
                                        class="w-full bg-white border border-slate-200/80 rounded-2xl p-3 text-sm focus:outline-none focus:border-[#6200EE]/50 focus:ring-2 focus:ring-[#6200EE]/20 resize-none h-20 mb-3 placeholder:text-slate-400 transition-all"
                                        placeholder="Bạn đang nghĩ gì? Chia sẻ hành trình của bạn..."></textarea>
                                    <div class="flex justify-between items-center">
                                        <div class="flex gap-1 text-slate-500">
                                            <button
                                                class="w-8 h-8 flex items-center justify-center hover:bg-slate-100 rounded-full transition-colors"
                                                title="Thêm ảnh">
                                                <span
                                                    class="material-symbols-outlined text-[20px] text-green-500">image</span>
                                            </button>
                                            <button
                                                class="w-8 h-8 flex items-center justify-center hover:bg-slate-100 rounded-full transition-colors"
                                                title="Gắn thẻ vị trí">
                                                <span
                                                    class="material-symbols-outlined text-[20px] text-red-500">location_on</span>
                                            </button>
                                            <button
                                                class="w-8 h-8 flex items-center justify-center hover:bg-slate-100 rounded-full transition-colors"
                                                title="Tìm ghép chuyến">
                                                <span
                                                    class="material-symbols-outlined text-[20px] text-blue-500">directions_car</span>
                                            </button>
                                        </div>
                                        <button
                                            class="bg-[#6200EE] hover:bg-[#5000c0] text-white px-5 py-2 rounded-xl text-sm font-bold transition-all shadow-sm hover:shadow-md">
                                            Đăng bài
                                        </button>
                                    </div>
                                </div>

                                <!-- Friends List -->
                                <div
                                    class="bg-white/90 border border-slate-200/80 rounded-3xl p-5 shadow-sm max-h-[40vh] overflow-y-auto panel-scroll">
                                    <h4 class="font-bold text-slate-800 mb-4 flex items-center gap-2">
                                        <span class="material-symbols-outlined text-[#FF6D00] text-[20px]">group</span>
                                        Người liên hệ
                                    </h4>
                                    <div class="flex flex-col gap-4">
                                        <div class="flex items-center gap-3 cursor-pointer group">
                                            <div class="relative shrink-0">
                                                <img src="https://i.pravatar.cc/150?u=a04"
                                                    class="w-10 h-10 rounded-full object-cover">
                                                <div
                                                    class="absolute bottom-0 right-0 w-3 h-3 bg-green-500 border-2 border-white rounded-full">
                                                </div>
                                            </div>
                                            <div class="flex-1 min-w-0">
                                                <h6
                                                    class="text-sm font-bold text-slate-800 group-hover:text-[#6200EE] transition-colors truncate">
                                                    Phương Thảo</h6>
                                                <p class="text-xs text-slate-500 truncate">Trực tuyến</p>
                                            </div>
                                        </div>
                                        <div class="flex items-center gap-3 cursor-pointer group">
                                            <div class="relative shrink-0">
                                                <img src="https://i.pravatar.cc/150?u=a05"
                                                    class="w-10 h-10 rounded-full object-cover">
                                                <div
                                                    class="absolute bottom-0 right-0 w-3 h-3 bg-green-500 border-2 border-white rounded-full">
                                                </div>
                                            </div>
                                            <div class="flex-1 min-w-0">
                                                <h6
                                                    class="text-sm font-bold text-slate-800 group-hover:text-[#6200EE] transition-colors truncate">
                                                    Tuấn Anh</h6>
                                                <p class="text-xs text-slate-500 truncate">Trực tuyến</p>
                                            </div>
                                        </div>
                                        <div class="flex items-center gap-3 cursor-pointer group">
                                            <div class="relative shrink-0">
                                                <img src="https://i.pravatar.cc/150?u=a06"
                                                    class="w-10 h-10 rounded-full object-cover">
                                                <div
                                                    class="absolute bottom-0 right-0 w-3 h-3 bg-slate-300 border-2 border-white rounded-full">
                                                </div>
                                            </div>
                                            <div class="flex-1 min-w-0">
                                                <h6
                                                    class="text-sm font-bold text-slate-800 group-hover:text-[#6200EE] transition-colors truncate">
                                                    Đức Mạnh</h6>
                                                <p class="text-xs text-slate-500 truncate">Hoạt động 5p trước</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script>
                        let isSearchingOnDemand = <%= activeTrip != null ? "true" : "false" %>;
                        window.currentTripId = <%= activeTrip != null ? activeTrip.getId() : "null" %>;
                        
                        let hasPreBookTrip = <%= activePreBookTrip != null ? "true" : "false" %>;
                        window.currentPreBookTripId = <%= activePreBookTrip != null ? activePreBookTrip.getId() : "null" %>;
                        
                        const tripData = {
                            ON_DEMAND: {
                                active: isSearchingOnDemand,
                                pickup: "<%= activeTrip != null ? activeTrip.getPickupLocation() : "" %>",
                                dropoff: "<%= activeTrip != null ? activeTrip.getDropoffLocation() : "" %>"
                            },
                            PRE_BOOK: {
                                active: hasPreBookTrip,
                                pickup: "<%= activePreBookTrip != null ? activePreBookTrip.getPickupLocation() : "" %>",
                                dropoff: "<%= activePreBookTrip != null ? activePreBookTrip.getDropoffLocation() : "" %>",
                                date: "<%= preBookDateStr %>",
                                time: "<%= preBookTimeStr %>"
                            }
                        };
                        
                        // Phục hồi trạng thái UI nếu đã có chuyến xe đang tìm kiếm
                        document.addEventListener("DOMContentLoaded", function() {
                            if (isSearchingOnDemand) {
                                // Giao diện đang tìm kiếm
                                document.getElementById('empty-search-state').classList.add('hidden');
                                document.getElementById('empty-search-state').classList.remove('flex');
                                
                                document.getElementById('loading-search-state').classList.remove('hidden');
                                document.getElementById('loading-search-state').classList.add('flex');
                                
                                // Giao diện form
                                document.getElementById('pickup-input').value = tripData.ON_DEMAND.pickup;
                                document.getElementById('dropoff-input').value = tripData.ON_DEMAND.dropoff;
                                
                                // Giao diện popup
                                document.getElementById('mini-popup-pickup').textContent = "<%= activeTrip != null ? activeTrip.getPickupLocation() : "" %>";
                                document.getElementById('mini-popup-dropoff').textContent = "<%= activeTrip != null ? activeTrip.getDropoffLocation() : "" %>";
                                
                                const btnSubmit = document.getElementById('btn-submit-search');
                                if (btnSubmit) {
                                    btnSubmit.type = 'button';
                                    btnSubmit.innerHTML = 'Hủy tìm kiếm <span class="material-symbols-outlined text-[20px]">cancel</span>';
                                    btnSubmit.className = 'w-full bg-red-500 hover:bg-red-600 text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                    btnSubmit.disabled = false;
                                    btnSubmit.onclick = cancelTripSearch;
                                }
                            }
                            
                            if (hasPreBookTrip) {
                                document.getElementById('mini-prebook-pickup').textContent = "<%= activePreBookTrip != null ? activePreBookTrip.getPickupLocation() : "" %>";
                                document.getElementById('mini-prebook-dropoff').textContent = "<%= activePreBookTrip != null ? activePreBookTrip.getDropoffLocation() : "" %>";
                            }
                            
                            // Hiển thị popup nếu khung search đang ẩn
                            const searchBar = document.getElementById('bottom-search-bar');
                            if (searchBar && searchBar.classList.contains('translate-y-[150%]')) {
                                if (isSearchingOnDemand) {
                                    const miniPopup = document.getElementById('mini-search-popup');
                                    if (miniPopup) {
                                        miniPopup.classList.remove('translate-x-[150%]', 'opacity-0');
                                        miniPopup.classList.add('translate-x-0', 'opacity-100');
                                    }
                                }
                                if (hasPreBookTrip) {
                                    const prebookPopup = document.getElementById('mini-prebook-popup');
                                    if (prebookPopup) {
                                        prebookPopup.classList.remove('translate-x-[150%]', 'opacity-0');
                                        prebookPopup.classList.add('translate-x-0', 'opacity-100');
                                    }
                                }
                            }
                            
                            // Đóng băng form nếu tab hiện tại đang có chuyến
                            const currentTab = document.getElementById('tripType') ? document.getElementById('tripType').value : 'ON_DEMAND';
                            if (currentTab === 'ON_DEMAND') {
                                toggleFormInputs(isSearchingOnDemand);
                            } else {
                                toggleFormInputs(hasPreBookTrip);
                            }
                        });


                        function toggleFormInputs(disabled) {
                            const fields = ['pickup-input', 'dropoff-input', 'note-input', 'trip-date', 'trip-time'];
                            fields.forEach(id => {
                                const el = document.getElementById(id);
                                if (el) {
                                    el.disabled = disabled;
                                    if (disabled) {
                                        el.classList.add('bg-slate-100', 'cursor-not-allowed', 'opacity-60');
                                    } else {
                                        el.classList.remove('bg-slate-100', 'cursor-not-allowed', 'opacity-60');
                                    }
                                }
                            });
                            
                            const radios = document.querySelectorAll('input[name="vehicleType"]');
                            radios.forEach(radio => {
                                radio.disabled = disabled;
                                if (disabled) {
                                    radio.parentElement.classList.add('opacity-60', 'cursor-not-allowed');
                                } else {
                                    radio.parentElement.classList.remove('opacity-60', 'cursor-not-allowed');
                                }
                            });
                        }

                        function handleTripSearch(event) {
                            event.preventDefault(); // Ngăn chặn load lại trang
                            
                            // Validate if locations were selected from dropdown
                            const pickupLat = document.getElementById('pickup-lat').value;
                            const dropoffLat = document.getElementById('dropoff-lat').value;
                            
                            if(!pickupLat || !dropoffLat) {
                                showToast("Vui lòng chọn Điểm đón và Điểm đến từ danh sách gợi ý của bản đồ!", "error");
                                return;
                            }

                            const form = event.target;
                            
                            const tripType = document.getElementById('tripType') ? document.getElementById('tripType').value : 'ON_DEMAND';
                            if (tripType === 'ON_DEMAND') {
                                if (isSearchingOnDemand) {
                                    showToast("Bạn đang tìm kiếm một chuyến đi. Vui lòng chờ kết quả!", "warning");
                                    return; // Chặn không cho tìm thêm
                                }
                                isSearchingOnDemand = true;
                                
                                // Cập nhật thông tin lên mini popup
                                document.getElementById('mini-popup-pickup').textContent = document.getElementById('pickup-input').value || "Đang tải...";
                                document.getElementById('mini-popup-dropoff').textContent = document.getElementById('dropoff-input').value || "Đang tải...";
                                
                                // Disable nút tìm kiếm
                                const btnSubmit = document.getElementById('btn-submit-search');
                                if (btnSubmit) {
                                    btnSubmit.disabled = true;
                                    btnSubmit.classList.add('opacity-70', 'cursor-not-allowed');
                                    btnSubmit.innerHTML = 'Đang tìm kiếm... <span class="material-symbols-outlined text-[20px] animate-spin">sync</span>';
                                }
                            }
                            
                            // Ẩn state rỗng, hiện loading state
                            document.getElementById('empty-search-state').classList.add('hidden');
                            document.getElementById('empty-search-state').classList.remove('flex');
                            
                            document.getElementById('loading-search-state').classList.remove('hidden');
                            document.getElementById('loading-search-state').classList.add('flex');
                            
                            // Gửi data thực tế lên server (sử dụng x-www-form-urlencoded để tương thích với Servlet thông thường)
                            const formData = new URLSearchParams(new FormData(form));
                            formData.append("ajax", "true");
                            
                            fetch(form.action, {
                                method: form.method,
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded'
                                },
                                body: formData.toString()
                            })
                            .then(response => response.json())
                            .then(data => {
                                if (data.success) {
                                    if (tripType === 'ON_DEMAND') {
                                        window.currentTripId = data.tripId;
                                        tripData.ON_DEMAND.active = true;
                                        toggleFormInputs(true);
                                        const btnSubmit = document.getElementById('btn-submit-search');
                                        if (btnSubmit) {
                                            // Đổi nút thành nút Hủy tìm kiếm
                                            btnSubmit.type = 'button';
                                            btnSubmit.innerHTML = 'Hủy tìm kiếm <span class="material-symbols-outlined text-[20px]">cancel</span>';
                                            btnSubmit.classList.remove('bg-slate-900', 'hover:bg-black', 'opacity-70', 'cursor-not-allowed');
                                            btnSubmit.classList.add('bg-red-500', 'hover:bg-red-600');
                                            btnSubmit.disabled = false;
                                            btnSubmit.onclick = cancelTripSearch;
                                        }
                                    } else if (tripType === 'PRE_BOOK') {
                                        window.currentPreBookTripId = data.tripId;
                                        hasPreBookTrip = true;
                                        tripData.PRE_BOOK.active = true;
                                        toggleFormInputs(true);
                                        const btnSubmit = document.getElementById('btn-submit-search');
                                        if (btnSubmit) {
                                            // Đổi nút thành nút Hủy đặt lịch
                                            btnSubmit.type = 'button';
                                            btnSubmit.innerHTML = 'Hủy đặt lịch <span class="material-symbols-outlined text-[20px]">cancel</span>';
                                            btnSubmit.classList.remove('bg-slate-900', 'hover:bg-black', 'opacity-70', 'cursor-not-allowed');
                                            btnSubmit.classList.add('bg-[#FF6D00]', 'hover:bg-orange-600');
                                            btnSubmit.disabled = false;
                                            btnSubmit.onclick = cancelPreBookTrip;
                                        }
                                    }
                                }
                            }).catch(error => {
                                console.error("Lỗi khi gửi yêu cầu tìm chuyến:", error);
                            });
                        }

                        function cancelTripSearch() {
                            if (!window.currentTripId) {
                                showToast("Đang xử lý, vui lòng thử lại sau giây lát.", "warning");
                                return;
                            }
                            
                            // Sử dụng Confirm Modal tuỳ chỉnh
                            showConfirmModal("Xác nhận hủy", "Bạn có chắc chắn muốn hủy yêu cầu tìm kiếm này?", function() {
                                fetch('${pageContext.request.contextPath}/trip-cancel', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                    body: 'tripId=' + window.currentTripId
                                })
                                .then(res => res.json())
                                .then(data => {
                                    if (data.success) {
                                        // Reset giao diện
                                        isSearchingOnDemand = false;
                                        window.currentTripId = null;
                                        tripData.ON_DEMAND.active = false;
                                        toggleFormInputs(false);
                                        
                                        // Xóa marker và đường đi
                                        if (window.markerOnDemand) {
                                            window.markerOnDemand.remove();
                                            window.markerOnDemand = null;
                                        }
                                        if (map.getSource('route-on-demand')) {
                                            map.removeLayer('route-on-demand');
                                            map.removeSource('route-on-demand');
                                        }
                                        
                                        // Reset fields
                                        document.getElementById('pickup-input').value = "";
                                        document.getElementById('dropoff-input').value = "";
                                        document.getElementById('pickup-lat').value = "";
                                        document.getElementById('pickup-lng').value = "";
                                        document.getElementById('dropoff-lat').value = "";
                                        document.getElementById('dropoff-lng').value = "";
                                        document.getElementById('trip-price').value = "";
                                        document.getElementById('trip-distance').value = "";
                                        document.getElementById('price-estimation-box').classList.add('hidden');
                                        
                                        // Trả lại nút Tìm chuyến nếu đang ở tab ON_DEMAND
                                        const btnSubmit = document.getElementById('btn-submit-search');
                                        if (btnSubmit && document.getElementById('tripType').value === 'ON_DEMAND') {
                                            btnSubmit.type = 'submit';
                                            btnSubmit.innerHTML = 'Tìm chuyến <span class="material-symbols-outlined text-[20px]">arrow_forward</span>';
                                            btnSubmit.className = 'w-full bg-slate-900 hover:bg-black text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                            btnSubmit.onclick = null;
                                            
                                            // Gọi lại setBookingType để làm sạch form
                                            if (window.setBookingType) window.setBookingType('ON_DEMAND');
                                        }
                                        
                                        // Ẩn loading state, hiện empty state
                                        document.getElementById('loading-search-state').classList.add('hidden');
                                        document.getElementById('loading-search-state').classList.remove('flex');
                                        document.getElementById('empty-search-state').classList.remove('hidden');
                                        document.getElementById('empty-search-state').classList.add('flex');
                                        
                                        // Ẩn mini popup
                                        const miniPopup = document.getElementById('mini-search-popup');
                                        if (miniPopup) {
                                            miniPopup.classList.add('translate-x-[150%]', 'opacity-0');
                                            miniPopup.classList.remove('translate-x-0', 'opacity-100');
                                        }
                                        
                                        showToast("Đã hủy chuyến đi thành công!", "success");
                                    } else {
                                        showToast("Lỗi khi hủy chuyến: " + (data.error || "Không xác định"), "error");
                                    }
                                });
                            });
                        }

                        function cancelPreBookTrip() {
                            if (!window.currentPreBookTripId) {
                                showToast("Đang xử lý, vui lòng thử lại sau giây lát.", "warning");
                                return;
                            }
                            
                            showConfirmModal("Xác nhận hủy", "Bạn có chắc chắn muốn hủy chuyến xe đặt trước này?", function() {
                                fetch('${pageContext.request.contextPath}/trip-cancel', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                    body: 'tripId=' + window.currentPreBookTripId
                                })
                                .then(res => res.json())
                                .then(data => {
                                    if (data.success) {
                                        hasPreBookTrip = false;
                                        window.currentPreBookTripId = null;
                                        tripData.PRE_BOOK.active = false;
                                        toggleFormInputs(false);
                                        
                                        // Xóa marker và đường đi
                                        if (window.markerPreBook) {
                                            window.markerPreBook.remove();
                                            window.markerPreBook = null;
                                        }
                                        if (map.getSource('route-pre-book')) {
                                            map.removeLayer('route-pre-book');
                                            map.removeSource('route-pre-book');
                                        }
                                        
                                        // Reset fields
                                        document.getElementById('pickup-input').value = "";
                                        document.getElementById('dropoff-input').value = "";
                                        document.getElementById('pickup-lat').value = "";
                                        document.getElementById('pickup-lng').value = "";
                                        document.getElementById('dropoff-lat').value = "";
                                        document.getElementById('dropoff-lng').value = "";
                                        document.getElementById('trip-date').value = "";
                                        document.getElementById('trip-time').value = "";
                                        document.getElementById('trip-price').value = "";
                                        document.getElementById('trip-distance').value = "";
                                        document.getElementById('price-estimation-box').classList.add('hidden');
                                        
                                        // Reset nút bấm nếu đang ở tab PRE_BOOK
                                        const btnSubmit = document.getElementById('btn-submit-search');
                                        if (btnSubmit && document.getElementById('tripType').value === 'PRE_BOOK') {
                                            btnSubmit.type = 'submit';
                                            btnSubmit.innerHTML = 'Tìm chuyến <span class="material-symbols-outlined text-[20px]">arrow_forward</span>';
                                            btnSubmit.className = 'w-full bg-slate-900 hover:bg-black text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                            btnSubmit.onclick = null;
                                            
                                            // Gọi lại setBookingType để làm sạch form
                                            if (window.setBookingType) window.setBookingType('PRE_BOOK');
                                        }
                                        
                                        // Ẩn loading state, hiện empty state
                                        document.getElementById('loading-search-state').classList.add('hidden');
                                        document.getElementById('loading-search-state').classList.remove('flex');
                                        document.getElementById('empty-search-state').classList.remove('hidden');
                                        document.getElementById('empty-search-state').classList.add('flex');

                                        // Ẩn mini popup đặt trước
                                        const prebookPopup = document.getElementById('mini-prebook-popup');
                                        if (prebookPopup) {
                                            prebookPopup.classList.add('translate-x-[150%]', 'opacity-0');
                                            prebookPopup.classList.remove('translate-x-0', 'opacity-100');
                                        }
                                        
                                        showToast("Đã hủy chuyến xe đặt trước thành công!", "success");
                                    } else {
                                        showToast("Lỗi khi hủy chuyến: " + (data.error || "Không xác định"), "error");
                                    }
                                });
                            });
                        }

                        function toggleBottomSearchBar() {
                            const searchBar = document.getElementById('bottom-search-bar');
                            const blogBar = document.getElementById('bottom-blog-bar');
                            
                            if (searchBar) {
                                if (searchBar.classList.contains('translate-y-[150%]')) {
                                    // Close blog bar if open
                                    if (blogBar && !blogBar.classList.contains('translate-y-[150%]')) {
                                        blogBar.classList.add('translate-y-[150%]', 'opacity-0');
                                        blogBar.classList.remove('translate-y-0', 'opacity-100');
                                    }

                                    searchBar.classList.remove('translate-y-[150%]');
                                    searchBar.classList.remove('opacity-0');
                                    searchBar.classList.add('translate-y-0');
                                    searchBar.classList.add('opacity-100');
                                    
                                    // Ẩn mini popups khi mở search bar
                                    const miniPopup = document.getElementById('mini-search-popup');
                                    if (miniPopup) {
                                        miniPopup.classList.add('translate-x-[150%]', 'opacity-0');
                                        miniPopup.classList.remove('translate-x-0', 'opacity-100');
                                    }
                                    const prebookPopup = document.getElementById('mini-prebook-popup');
                                    if (prebookPopup) {
                                        prebookPopup.classList.add('translate-x-[150%]', 'opacity-0');
                                        prebookPopup.classList.remove('translate-x-0', 'opacity-100');
                                    }
                                } else {
                                    searchBar.classList.add('translate-y-[150%]');
                                    searchBar.classList.add('opacity-0');
                                    searchBar.classList.remove('translate-y-0');
                                    searchBar.classList.remove('opacity-100');
                                    
                                    // Hiện mini popups nếu đang tìm kiếm
                                    const miniPopup = document.getElementById('mini-search-popup');
                                    if (isSearchingOnDemand && miniPopup) {
                                        miniPopup.classList.remove('translate-x-[150%]', 'opacity-0');
                                        miniPopup.classList.add('translate-x-0', 'opacity-100');
                                    }
                                    const prebookPopup = document.getElementById('mini-prebook-popup');
                                    if (hasPreBookTrip && prebookPopup) {
                                        prebookPopup.classList.remove('translate-x-[150%]', 'opacity-0');
                                        prebookPopup.classList.add('translate-x-0', 'opacity-100');
                                    }
                                }
                            }
                        }

                        function toggleBottomBlogBar() {
                            const searchBar = document.getElementById('bottom-search-bar');
                            const blogBar = document.getElementById('bottom-blog-bar');
                            if (blogBar) {
                                if (blogBar.classList.contains('translate-y-[150%]')) {
                                    // Đang ẩn -> Mở lên
                                    // Đóng search bar nếu đang mở
                                    if (searchBar && !searchBar.classList.contains('translate-y-[150%]')) {
                                        searchBar.classList.add('translate-y-[150%]', 'opacity-0');
                                        searchBar.classList.remove('translate-y-0', 'opacity-100');
                                    }

                                    blogBar.classList.remove('translate-y-[150%]', 'opacity-0');
                                    blogBar.classList.add('translate-y-0', 'opacity-100');
                                    
                                    // Ẩn mini popups
                                    const miniPopup = document.getElementById('mini-search-popup');
                                    if (miniPopup) {
                                        miniPopup.classList.add('translate-x-[150%]', 'opacity-0');
                                        miniPopup.classList.remove('translate-x-0', 'opacity-100');
                                    }
                                    const prebookPopup = document.getElementById('mini-prebook-popup');
                                    if (prebookPopup) {
                                        prebookPopup.classList.add('translate-x-[150%]', 'opacity-0');
                                        prebookPopup.classList.remove('translate-x-0', 'opacity-100');
                                    }
                                } else {
                                    // Đang mở -> Đóng lại
                                    blogBar.classList.add('translate-y-[150%]', 'opacity-0');
                                    blogBar.classList.remove('translate-y-0', 'opacity-100');
                                    
                                    // Hiện lại mini popups nếu đang có
                                    const miniPopup = document.getElementById('mini-search-popup');
                                    if (isSearchingOnDemand && miniPopup) {
                                        miniPopup.classList.remove('translate-x-[150%]', 'opacity-0');
                                        miniPopup.classList.add('translate-x-0', 'opacity-100');
                                    }
                                    const prebookPopup = document.getElementById('mini-prebook-popup');
                                    if (hasPreBookTrip && prebookPopup) {
                                        prebookPopup.classList.remove('translate-x-[150%]', 'opacity-0');
                                        prebookPopup.classList.add('translate-x-0', 'opacity-100');
                                    }
                                }
                            }
                        }
                    </script>
                    <% } %>

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
                            // VIETMAP INITIALIZATION & GEOLOCATION
                            // ==========================================

                            // Vietmap API Keys (Vietmap tách riêng key cho Map và Search)
                            const vietmapMapApiKey = '7b895685ca3fbced0955461bcbbeb5b50cb8e5a2943fdc49';
                            const vietmapSearchApiKey = '663154c8a54428313795b6799a4e6dc463c0f678b38f7648';

                            // Khởi tạo bản đồ Vietmap
                            const map = new vietmapgl.Map({
                                container: 'map', // id của thẻ div
                                style: 'https://maps.vietmap.vn/maps/styles/tm/style.json?apikey=' + vietmapMapApiKey, // giao diện mặc định
                                center: [105.8542, 21.0285], // Tọa độ mặc định (Hà Nội)
                                zoom: 13,
                                attributionControl: false, // Ẩn logo nếu muốn UI sạch hơn
                                transformRequest: (url, resourceType) => {
                                    if (url.indexOf('vietmap.vn') > -1 && url.indexOf('apikey=') === -1) {
                                        return { url: url + (url.indexOf('?') === -1 ? '?' : '&') + 'apikey=' + vietmapMapApiKey };
                                    }
                                    return { url: url };
                                }
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

                            // Khởi tạo đối tượng Marker của Vietmap (nhưng chưa add vào map)
                            const userMarker = new vietmapgl.Marker({ element: markerEl, offset: [0, 0] });

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

                            // Bind dynamic events after DOM content is loaded
                            document.addEventListener('DOMContentLoaded', function () {
                                window.openProfileView = function(role) {
                                    const passView = document.getElementById('passenger-view');
                                    const drvView = document.getElementById('driver-view');
                                    const profView = document.getElementById('sidebar-profile-view');
                                    
                                    if (!profView) return;

                                    if (role === 'passenger' && passView) {
                                        passView.classList.replace('opacity-100', 'opacity-0');
                                        passView.classList.replace('translate-x-0', '-translate-x-10');
                                        passView.classList.add('pointer-events-none');
                                    } else if (role === 'driver' && drvView) {
                                        drvView.classList.replace('opacity-100', 'opacity-0');
                                        drvView.classList.replace('translate-x-0', '-translate-x-10');
                                        drvView.classList.add('pointer-events-none');
                                    }
                                    
                                    profView.classList.replace('opacity-0', 'opacity-100');
                                    profView.classList.replace('translate-x-10', 'translate-x-0');
                                    profView.classList.remove('pointer-events-none');
                                    
                                    const backBtn = document.getElementById('btn-back-from-profile');
                                    if (backBtn) {
                                        backBtn.onclick = function() {
                                            profView.classList.replace('opacity-100', 'opacity-0');
                                            profView.classList.replace('translate-x-0', 'translate-x-10');
                                            profView.classList.add('pointer-events-none');
                                            
                                            if (role === 'passenger' && passView) {
                                                passView.classList.replace('opacity-0', 'opacity-100');
                                                passView.classList.replace('-translate-x-10', 'translate-x-0');
                                                passView.classList.remove('pointer-events-none');
                                            } else if (role === 'driver' && drvView) {
                                                drvView.classList.replace('opacity-0', 'opacity-100');
                                                drvView.classList.replace('-translate-x-10', 'translate-x-0');
                                                drvView.classList.remove('pointer-events-none');
                                            }
                                        };
                                    }
                                };


                                // 1. Avatar Triggers
                                const pAvatarTrigger = document.getElementById('passenger-avatar-trigger');
                                if (pAvatarTrigger) {
                                    pAvatarTrigger.addEventListener('click', function (e) {
                                        e.stopPropagation();
                                        window.openProfileView('passenger');
                                    });
                                }
                                const dAvatarTrigger = document.getElementById('driver-avatar-trigger');
                                if (dAvatarTrigger) {
                                    dAvatarTrigger.addEventListener('click', function (e) {
                                        e.stopPropagation();
                                        window.openProfileView('driver');
                                    });
                                }
                            });

                            // Function to handle booking type toggle (On-demand vs Pre-book)
                            window.setBookingType = function (type) {
                                const inputTripType = document.getElementById('tripType');
                                const bg = document.getElementById('booking-type-bg');
                                const btnOnDemand = document.getElementById('btn-ondemand');
                                const btnPreBook = document.getElementById('btn-prebook');
                                const datetimeContainer = document.getElementById('datetime-container');
                                const tripDate = document.getElementById('trip-date');
                                const tripTime = document.getElementById('trip-time');

                                if (!inputTripType || !bg) return;

                                inputTripType.value = type;

                                if (type === 'ON_DEMAND') {
                                    // Set Toggle UI
                                    bg.style.transform = 'translateX(0)';
                                    btnOnDemand.classList.remove('text-slate-500');
                                    btnOnDemand.classList.add('text-[#6200EE]');
                                    btnPreBook.classList.remove('text-[#6200EE]');
                                    btnPreBook.classList.add('text-slate-500');

                                    // Hide Date/Time fields smoothly and remove 'required'
                                    datetimeContainer.classList.add('opacity-0', '-translate-y-2');
                                    setTimeout(() => {
                                        datetimeContainer.classList.add('hidden');
                                        datetimeContainer.classList.remove('flex');
                                    }, 300);

                                    tripDate.removeAttribute('required');
                                    tripTime.removeAttribute('required');
                                    
                                    // Điền form nếu có dữ liệu chuyến đang tìm
                                    if (tripData.ON_DEMAND.active) {
                                        document.getElementById('pickup-input').value = tripData.ON_DEMAND.pickup;
                                        document.getElementById('dropoff-input').value = tripData.ON_DEMAND.dropoff;
                                    } else if (tripData.PRE_BOOK.active) {
                                        // Xóa form nếu tab cũ có active trip
                                        document.getElementById('pickup-input').value = "";
                                        document.getElementById('dropoff-input').value = "";
                                    }
                                    
                                    // Chuyển nút về trạng thái Hủy nếu đang tìm kiếm ON_DEMAND
                                    const btnSubmit = document.getElementById('btn-submit-search');
                                    if (btnSubmit) {
                                        if (isSearchingOnDemand) {
                                            btnSubmit.type = 'button';
                                            btnSubmit.innerHTML = 'Hủy tìm kiếm <span class="material-symbols-outlined text-[20px]">cancel</span>';
                                            btnSubmit.className = 'w-full bg-red-500 hover:bg-red-600 text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                            btnSubmit.disabled = false;
                                            btnSubmit.onclick = cancelTripSearch;
                                            
                                            document.getElementById('empty-search-state').classList.add('hidden');
                                            document.getElementById('empty-search-state').classList.remove('flex');
                                            document.getElementById('loading-search-state').classList.remove('hidden');
                                            document.getElementById('loading-search-state').classList.add('flex');
                                        } else {
                                            btnSubmit.type = 'submit';
                                            btnSubmit.innerHTML = 'Tìm chuyến <span class="material-symbols-outlined text-[20px]">arrow_forward</span>';
                                            btnSubmit.className = 'w-full bg-slate-900 hover:bg-black text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                            btnSubmit.onclick = null;
                                            btnSubmit.disabled = false;
                                            
                                            document.getElementById('loading-search-state').classList.add('hidden');
                                            document.getElementById('loading-search-state').classList.remove('flex');
                                            document.getElementById('empty-search-state').classList.remove('hidden');
                                            document.getElementById('empty-search-state').classList.add('flex');
                                        }
                                        
                                        toggleFormInputs(tripData.ON_DEMAND.active);
                                    }

                                } else if (type === 'PRE_BOOK') {
                                    // Set Toggle UI
                                    bg.style.transform = 'translateX(100%)';
                                    btnPreBook.classList.remove('text-slate-500');
                                    btnPreBook.classList.add('text-[#FF6D00]');
                                    btnOnDemand.classList.remove('text-[#6200EE]');
                                    btnOnDemand.classList.add('text-slate-500');

                                    // Show Date/Time fields smoothly and add 'required'
                                    datetimeContainer.classList.remove('hidden');
                                    datetimeContainer.classList.add('flex');
                                    setTimeout(() => {
                                        datetimeContainer.classList.remove('opacity-0', '-translate-y-2');
                                    }, 10); // Small delay to allow display change to take effect

                                    tripDate.setAttribute('required', 'required');
                                    tripTime.setAttribute('required', 'required');
                                    
                                    // Điền form nếu có dữ liệu chuyến đặt trước
                                    if (tripData.PRE_BOOK.active) {
                                        document.getElementById('pickup-input').value = tripData.PRE_BOOK.pickup;
                                        document.getElementById('dropoff-input').value = tripData.PRE_BOOK.dropoff;
                                        document.getElementById('trip-date').value = tripData.PRE_BOOK.date;
                                        document.getElementById('trip-time').value = tripData.PRE_BOOK.time;
                                    } else if (tripData.ON_DEMAND.active) {
                                        // Xóa form nếu tab cũ có active trip
                                        document.getElementById('pickup-input').value = "";
                                        document.getElementById('dropoff-input').value = "";
                                        document.getElementById('trip-date').value = "";
                                        document.getElementById('trip-time').value = "";
                                    }
                                    
                                    // Phục hồi nút Submit mặc định để đăng ký chuyến xe trước, hoặc Đổi sang hủy nếu đã có chuyến
                                    const btnSubmit = document.getElementById('btn-submit-search');
                                    if (btnSubmit) {
                                        if (hasPreBookTrip) {
                                            btnSubmit.type = 'button';
                                            btnSubmit.innerHTML = 'Hủy đặt lịch <span class="material-symbols-outlined text-[20px]">cancel</span>';
                                            btnSubmit.className = 'w-full bg-[#FF6D00] hover:bg-orange-600 text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                            btnSubmit.disabled = false;
                                            btnSubmit.onclick = cancelPreBookTrip;
                                            
                                            document.getElementById('empty-search-state').classList.add('hidden');
                                            document.getElementById('empty-search-state').classList.remove('flex');
                                            document.getElementById('loading-search-state').classList.remove('hidden');
                                            document.getElementById('loading-search-state').classList.add('flex');
                                        } else {
                                            btnSubmit.type = 'submit';
                                            btnSubmit.innerHTML = 'Tìm chuyến <span class="material-symbols-outlined text-[20px]">arrow_forward</span>';
                                            btnSubmit.className = 'w-full bg-slate-900 hover:bg-black text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                            btnSubmit.onclick = null;
                                            btnSubmit.disabled = false;
                                            
                                            document.getElementById('loading-search-state').classList.add('hidden');
                                            document.getElementById('loading-search-state').classList.remove('flex');
                                            document.getElementById('empty-search-state').classList.remove('hidden');
                                            document.getElementById('empty-search-state').classList.add('flex');
                                        }
                                    }
                                    
                                    toggleFormInputs(tripData.PRE_BOOK.active);
                                }
                            };

                            // Mapbox Location Autocomplete
                            function setupAutocomplete(inputId, suggestionsId) {
                                const input = document.getElementById(inputId);
                                const suggestionsContainer = document.getElementById(suggestionsId);
                                let debounceTimer;

                                if (!input || !suggestionsContainer) return;

                                input.addEventListener('input', function () {
                                    clearTimeout(debounceTimer);
                                    const query = this.value;
                                    
                                    // Clear hidden coordinates when user types
                                    if(inputId === 'pickup-input') {
                                        document.getElementById('pickup-lat').value = '';
                                        document.getElementById('pickup-lng').value = '';
                                    } else if(inputId === 'dropoff-input') {
                                        document.getElementById('dropoff-lat').value = '';
                                        document.getElementById('dropoff-lng').value = '';
                                    }

                                    if (!query || query.length < 2) {
                                        suggestionsContainer.innerHTML = '';
                                        suggestionsContainer.classList.add('hidden');
                                        return;
                                    }

                                    debounceTimer = setTimeout(() => {
                                        // Gọi API Search của Vietmap
                                        const url = `https://maps.vietmap.vn/api/search/v3?apikey=\${vietmapSearchApiKey}&text=\${encodeURIComponent(query)}`;

                                        fetch(url)
                                            .then(response => response.json())
                                            .then(data => {
                                                suggestionsContainer.innerHTML = '';
                                                if (data && data.length > 0) {
                                                    data.slice(0, 8).forEach(feature => {
                                                        const mainText = feature.name || '';
                                                        let fullAddress = feature.display || feature.address || '';

                                                        const secondaryText = fullAddress !== mainText ? fullAddress : '';

                                                        const div = document.createElement('div');
                                                        div.className = 'px-4 py-2 hover:bg-slate-100 cursor-pointer text-sm text-slate-700 border-b border-slate-100 last:border-0';

                                                        // Viết tách HTML, cần dùng backslash để tránh JSP EL
                                                        let suggestionHtml = `<strong>\${mainText}</strong>`;
                                                        if (secondaryText) {
                                                            suggestionHtml += `<br><span class="text-xs text-slate-500">\${secondaryText}</span>`;
                                                        }
                                                        div.innerHTML = suggestionHtml;

                                                        div.onclick = () => {
                                                            input.value = fullAddress;
                                                            suggestionsContainer.innerHTML = '';
                                                            suggestionsContainer.classList.add('hidden');
                                                            
                                                            // Gọi Place API để lấy toạ độ chính xác từ ref_id
                                                            if (feature.ref_id) {
                                                                const placeUrl = `https://maps.vietmap.vn/api/place/v3?apikey=\${vietmapSearchApiKey}&refid=\${feature.ref_id}`;
                                                                fetch(placeUrl)
                                                                    .then(res => res.json())
                                                                    .then(placeData => {
                                                                        const lat = placeData.lat;
                                                                        const lng = placeData.lng;
                                                                        
                                                                        if (lat && lng) {
                                                                            // Lưu coordinates vào hidden fields
                                                                            if (inputId === 'pickup-input') {
                                                                                document.getElementById('pickup-lat').value = lat;
                                                                                document.getElementById('pickup-lng').value = lng;
                                                                            } else if (inputId === 'dropoff-input') {
                                                                                document.getElementById('dropoff-lat').value = lat;
                                                                                document.getElementById('dropoff-lng').value = lng;
                                                                            }
                                                                            
                                                                            // Bay đến vị trí
                                                                            map.flyTo({
                                                                                center: [lng, lat],
                                                                                zoom: 15,
                                                                                essential: true
                                                                            });

                                                                            // Xóa marker cũ nếu có
                                                                            const isPrebook = document.getElementById('tripType') ? document.getElementById('tripType').value === 'PRE_BOOK' : false;
                                                                            if (isPrebook && window.markerPreBook) {
                                                                                window.markerPreBook.remove();
                                                                            } else if (!isPrebook && window.markerOnDemand) {
                                                                                window.markerOnDemand.remove();
                                                                            }

                                                                            // Màu sắc động theo loại
                                                                            const color1 = isPrebook ? 'bg-orange-500/30' : 'bg-purple-500/30';
                                                                            const color2 = isPrebook ? 'bg-orange-500/40' : 'bg-purple-500/40';
                                                                            const grad = isPrebook ? 'from-orange-400 to-orange-600' : 'from-purple-500 to-purple-700';
                                                                            const shad = isPrebook ? 'shadow-[0_4px_15px_rgba(249,115,22,0.5)]' : 'shadow-[0_4px_15px_rgba(98,0,238,0.5)]';
                                                                            const btm = isPrebook ? 'bg-orange-600' : 'bg-purple-700';

                                                                            // Tạo Custom Marker
                                                                            const searchMarkerEl = document.createElement('div');
                                                                            searchMarkerEl.className = 'relative flex items-center justify-center';
                                                                            searchMarkerEl.innerHTML = `
                                                                                <div class="absolute w-24 h-24 \${color1} rounded-full animate-ping"></div>
                                                                                <div class="absolute w-12 h-12 \${color2} rounded-full animate-pulse"></div>
                                                                                <div class="relative flex flex-col items-center">
                                                                                    <div class="w-8 h-8 bg-gradient-to-br \${grad} border-[3px] border-white rounded-full \${shad} z-10 flex items-center justify-center">
                                                                                        <div class="w-2 h-2 bg-white rounded-full shadow-inner"></div>
                                                                                    </div>
                                                                                    <div class="w-1 h-3 \${btm} -mt-1 rounded-b-full"></div>
                                                                                </div>
                                                                            `;

                                                                            const marker = new vietmapgl.Marker({ element: searchMarkerEl, offset: [0, -15] })
                                                                                .setLngLat([lng, lat])
                                                                                .addTo(map);
                                                                                
                                                                            if (isPrebook) window.markerPreBook = marker;
                                                                            else window.markerOnDemand = marker;
                                                                                
                                                                            // Nếu cả 2 điểm đã được chọn, gọi hàm tính giá
                                                                            calculateRouteAndPrice();
                                                                        }
                                                                    })
                                                                    .catch(err => console.error("Place API error:", err));
                                                            }
                                                        };
                                                        suggestionsContainer.appendChild(div);
                                                    });
                                                    suggestionsContainer.classList.remove('hidden');
                                                } else {
                                                    suggestionsContainer.classList.add('hidden');
                                                }
                                            })
                                            .catch(err => console.error("Geocoding error:", err));
                                    }, 300);
                                });

                                // Hide suggestions when clicking outside
                                document.addEventListener('click', function (e) {
                                    if (e.target !== input && !suggestionsContainer.contains(e.target)) {
                                        suggestionsContainer.classList.add('hidden');
                                    }
                                });
                            }
                            
                            function calculateRouteAndPrice() {
                                const pLat = document.getElementById('pickup-lat').value;
                                const pLng = document.getElementById('pickup-lng').value;
                                const dLat = document.getElementById('dropoff-lat').value;
                                const dLng = document.getElementById('dropoff-lng').value;
                                
                                if(pLat && pLng && dLat && dLng) {
                                    const priceBox = document.getElementById('price-estimation-box');
                                    priceBox.classList.remove('hidden');
                                    document.getElementById('price-value').textContent = "Đang tính...";
                                    document.getElementById('distance-value').textContent = "Đang quét tuyến đường...";
                                    document.getElementById('duration-value').textContent = "";
                                    
                                    const contextPath = '${pageContext.request.contextPath}';
                                    const vehicleType = document.querySelector('input[name="vehicleType"]:checked').value;
                                    const routeUrl = `\${contextPath}/api/price-estimate?pLat=\${pLat}&pLng=\${pLng}&dLat=\${dLat}&dLng=\${dLng}&vehicleType=\${vehicleType}`;
                                    
                                    fetch(routeUrl)
                                        .then(res => res.json())
                                        .then(data => {
                                            if(data.success) {
                                                const distanceKm = data.distanceKm;
                                                const durationMins = data.durationMins;
                                                const totalPrice = data.totalPrice;
                                                
                                                // Hiển thị
                                                document.getElementById('distance-value').textContent = `Quãng đường: \${distanceKm} km`;
                                                document.getElementById('duration-value').textContent = `Thời gian: ~\${durationMins} phút`;
                                                document.getElementById('price-value').textContent = totalPrice.toLocaleString('vi-VN') + " đ";
                                                
                                                // Lưu vào hidden input
                                                document.getElementById('trip-price').value = totalPrice;
                                                document.getElementById('trip-distance').value = distanceKm;
                                                
                                                // Vẽ đường đi trên bản đồ
                                                const isPrebook = document.getElementById('tripType') ? document.getElementById('tripType').value === 'PRE_BOOK' : false;
                                                const routeId = isPrebook ? 'route-pre-book' : 'route-on-demand';
                                                const routeColor = isPrebook ? '#FF6D00' : '#6200EE';
                                                
                                                if (data.points) {
                                                    if (map.getSource(routeId)) {
                                                        map.getSource(routeId).setData(data.points);
                                                    } else {
                                                        map.addSource(routeId, {
                                                            'type': 'geojson',
                                                            'data': data.points
                                                        });
                                                        map.addLayer({
                                                            'id': routeId,
                                                            'type': 'line',
                                                            'source': routeId,
                                                            'layout': {
                                                                'line-join': 'round',
                                                                'line-cap': 'round'
                                                            },
                                                            'paint': {
                                                                'line-color': routeColor,
                                                                'line-width': 6,
                                                                'line-opacity': 0.8
                                                            }
                                                        });
                                                    }
                                                    
                                                    // Căn chỉnh bản đồ để vừa vặn với đường đi
                                                    if (data.bbox) {
                                                        map.fitBounds([
                                                            [data.bbox[0], data.bbox[1]], // [minLng, minLat]
                                                            [data.bbox[2], data.bbox[3]]  // [maxLng, maxLat]
                                                        ], {
                                                            padding: {top: 50, bottom: 50, left: 50, right: 400}, // Padding right để né cái panel
                                                            duration: 1000
                                                        });
                                                    }
                                                }
                                            } else {
                                                document.getElementById('distance-value').textContent = data.error || "Không tìm thấy đường đi";
                                                document.getElementById('price-value').textContent = "Chưa rõ";
                                            }
                                        })
                                        .catch(err => {
                                            console.error("Routing error:", err);
                                            document.getElementById('distance-value').textContent = "Lỗi tính toán quãng đường";
                                        });
                                }
                            }

                            document.addEventListener('DOMContentLoaded', function () {
                                setupAutocomplete('pickup-input', 'pickup-suggestions');
                                setupAutocomplete('dropoff-input', 'dropoff-suggestions');
                            });
                        </script>
                        <!-- Toast Notification Utility -->
                        <script
                            src="${pageContext.request.contextPath}/assets/js/toast.js?v=<%= System.currentTimeMillis() %>"></script>
                        <script
                            src="${pageContext.request.contextPath}/assets/js/landingpage.js?v=<%= System.currentTimeMillis() %>"></script>

            </body>

            </html>