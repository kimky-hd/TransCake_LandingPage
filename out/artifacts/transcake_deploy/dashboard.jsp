<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:if test="${isLoggedIn == null}">
    <c:redirect url="/dashboard" />
</c:if>
                                <!DOCTYPE html>
                                <html lang="vi">

                                <head>
                                    <meta charset="utf-8" />
                                    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" />
                                    <title>Transcake - Dashboard</title>
                                    <link rel="icon" type="image/png"
                                        href="${pageContext.request.contextPath}/img/transcake-04.png" />

                                    <!-- Tailwind CSS -->
                                    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                                    <script
                                        src="${pageContext.request.contextPath}/assets/js/tailwind-config.js?v=${cacheVersion}"></script>

                                    <!-- Custom CSS -->
                                    <link rel="stylesheet"
                                        href="${pageContext.request.contextPath}/assets/css/styles.css?v=${cacheVersion}" />
                                    <link rel="stylesheet"
                                        href="${pageContext.request.contextPath}/assets/css/landingpage.css?v=${cacheVersion}" />

                                    <!-- Google Fonts & Material Symbols -->
                                    <link
                                        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap"
                                        rel="stylesheet" />
                                    <link
                                        href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400..900;1,400..900&display=swap"
                                        rel="stylesheet" />
                                    <link
                                        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                                        rel="stylesheet" />

                                    <!-- VietMap GL JS -->
                                    <script
                                        src="https://unpkg.com/@vietmap/vietmap-gl-js@6.0.1/dist/vietmap-gl.js"></script>
                                    <link href="https://unpkg.com/@vietmap/vietmap-gl-js@6.0.1/dist/vietmap-gl.css"
                                        rel="stylesheet" />

                                    <style>
                                        @media (max-width: 767px) {
                                            .mobile-hidden {
                                                opacity: 0 !important;
                                                pointer-events: none !important;
                                                transform: scale(0.98) translateY(20px) !important;
                                            }
                                            /* Compact form inputs on mobile */
                                            #bottom-search-bar input,
                                            #bottom-search-bar textarea {
                                                font-size: 13px !important;
                                                padding-top: 0.4rem !important;
                                                padding-bottom: 0.4rem !important;
                                            }
                                            #bottom-search-bar .material-symbols-outlined {
                                                font-size: 18px !important;
                                            }
                                            /* Compact icon containers */
                                            #bottom-search-bar .w-10.h-10 {
                                                width: 2rem !important;
                                                height: 2rem !important;
                                            }
                                            /* Map takes remaining space above bottom sheet */
                                            #map {
                                                bottom: 50vh !important;
                                                transition: bottom 0.5s cubic-bezier(0.4, 0, 0.2, 1);
                                            }
                                            #map.map-fullscreen {
                                                bottom: 0 !important;
                                            }
                                        }
                                        body {
                                            font-family: 'Inter', sans-serif;
                                            /* Removed custom cursors to use system defaults */
                                        }
                                        #trip-proposals-panel {
                                            transition: transform 0.5s cubic-bezier(0.4, 0, 0.2, 1),
                                                        opacity 0.5s cubic-bezier(0.4, 0, 0.2, 1),
                                                        visibility 0s linear 0.5s;
                                        }
                                        #trip-proposals-panel.panel-open {
                                            transition: transform 0.5s cubic-bezier(0.4, 0, 0.2, 1),
                                                        opacity 0.5s cubic-bezier(0.4, 0, 0.2, 1),
                                                        visibility 0s linear 0s;
                                        }
                                    </style>

                                </head>

                                <body
                                    class="h-screen w-screen overflow-hidden bg-slate-100 flex relative text-slate-800">

                                    <!-- 1. Background (Main Stage): Mapbox Map Container -->
                                    <div id="map" class="absolute inset-0 z-0"></div>
                                    
                                    <!-- Mobile Floating Back Button (Visible when island is hidden) -->
                                    <button onclick="closeMobileMap()" 
                                        class="fixed top-4 left-4 z-10 w-10 h-10 bg-white rounded-full shadow-md flex md:hidden items-center justify-center text-slate-800 hover:bg-slate-100 transition-colors">
                                        <span class="material-symbols-outlined">arrow_back</span>
                                    </button>

                                    <!-- 2. Foreground (Left Dynamic Island) -->
                                    <div class="absolute inset-0 w-full md:w-[380px] md:left-8 md:top-8 md:bottom-8 z-20 flex flex-col bg-slate-50 md:bg-white/75 backdrop-blur-xl border border-transparent md:border-white/60 md:shadow-[0_30px_60px_rgba(0,0,0,0.15)] md:rounded-3xl overflow-hidden transition-all duration-500"
                                        id="dynamic-island">

                                        <!-- Header Section -->
                                        <jsp:include page="includes/header.jsp" />

                                        <jsp:include page="includes/sidebar.jsp" />
                                    </div>

                                    <!-- Bottom Navigation Menu (Always visible) -->
                                    <div id="bottom-navigation"
                                        class="fixed bottom-0 left-0 right-0 p-4 pb-safe md:absolute md:w-[380px] md:left-8 md:bottom-8 md:rounded-b-3xl bg-white/95 md:bg-white/40 backdrop-blur-xl border-t md:border-none border-slate-200/60 z-50 pointer-events-auto transition-transform duration-500">
                                        <div class="flex items-center justify-around">
                                            <button
                                                class="w-12 h-12 flex items-center justify-center rounded-xl bg-purple-50 text-[#6200EE] shadow-sm transition-colors relative"
                                                id="nav-home" onclick="switchTab('nav-home')">
                                                <span class="material-symbols-outlined font-bold">home</span>
                                                <span
                                                    class="absolute -top-1 -right-1 w-2.5 h-2.5 bg-red-500 border-2 border-white rounded-full"></span>
                                            </button>
                                            <button
                                                class="w-12 h-12 flex items-center justify-center rounded-xl text-slate-400 hover:bg-slate-100 hover:text-slate-600 transition-colors"
                                                id="nav-search"
                                                onclick="${isLoggedIn ? 'switchTab(\'nav-search\')' : 'window.openAuthModal && window.openAuthModal()'}">
                                                <span class="material-symbols-outlined">search</span>
                                            </button>
                                            <button
                                                class="w-12 h-12 flex items-center justify-center rounded-xl text-slate-400 hover:bg-slate-100 hover:text-slate-600 transition-colors"
                                                id="nav-blog" onclick="switchTab('nav-blog')">
                                                <span class="material-symbols-outlined">article</span>
                                            </button>
                                            <button
                                                class="w-12 h-12 flex items-center justify-center rounded-xl text-slate-400 hover:bg-slate-100 hover:text-slate-600 transition-colors"
                                                id="nav-profile"
                                                onclick="switchTab('nav-profile')">
                                                <span class="material-symbols-outlined">person</span>
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Bottom Trip Proposals Panel (Driver Only) -->
                                    <c:if test="${isLoggedIn}">
                                        <!-- (Removed OLD trip-proposals-panel to resolve ID conflicts) -->

                                        <!-- Bottom Search Bar (Passenger) -->
                                        <div id="bottom-search-bar"
                                            class="fixed bottom-[88px] left-0 right-0 md:bottom-8 md:left-[420px] md:right-8 z-30 bg-white md:bg-white/75 backdrop-blur-xl border-t border-slate-200 md:border-white/60 md:rounded-3xl p-3 md:p-6 transition-all duration-500 transform translate-y-[150%] opacity-0 flex flex-col w-auto max-h-[52vh] md:min-h-[360px] shadow-[0_-8px_30px_rgba(0,0,0,0.12)] md:shadow-none pb-safe">

                                            <!-- Handle for dragging/closing -->
                                            <div class="w-full flex justify-center mb-2 md:mb-4 cursor-pointer shrink-0"
                                                onclick="toggleBottomSearchBar()">
                                                <div
                                                    class="w-10 h-1 md:w-16 md:h-1.5 bg-slate-300 rounded-full hover:bg-slate-400 transition-colors">
                                                </div>
                                            </div>

                                            <!-- Header & Close -->
                                            <div class="flex justify-between items-center mb-3 md:mb-6 shrink-0">
                                                <h3 class="text-base md:text-2xl font-bold text-slate-800 tracking-tight">Tìm kiếm
                                                    chuyến đi</h3>
                                                <button onclick="toggleBottomSearchBar()"
                                                    class="w-7 h-7 md:w-10 md:h-10 rounded-full bg-slate-100 hover:bg-slate-200 flex items-center justify-center text-slate-600 transition-colors">
                                                    <span class="material-symbols-outlined text-[16px] md:text-[20px]">close</span>
                                                </button>
                                            </div>

                                            <!-- Split Layout: Left (Form) | Right (Results) -->
                                            <div class="flex flex-col lg:flex-row gap-3 md:gap-8 flex-1 min-h-0 overflow-y-auto panel-scroll pr-1 pb-4">

                                                <!-- LEFT: Search Form -->
                                                <form id="trip-search-form"
                                                    action="${pageContext.request.contextPath}/trip-search"
                                                    method="POST" onsubmit="handleTripSearch(event)"
                                                    class="w-full lg:w-[45%] flex flex-col gap-2 md:gap-5 md:border-r border-slate-200/60 md:pr-4">

                                                    <!-- Booking Type Toggle -->
                                                    <div
                                                        class="bg-slate-100/80 p-0.5 md:p-1 rounded-full flex relative border border-slate-200/50 shadow-inner w-full">
                                                        <input type="hidden" name="tripType" id="tripType"
                                                            value="ON_DEMAND">
                                                        <!-- Sliding background indicator -->
                                                        <div class="absolute top-0.5 md:top-1 bottom-0.5 md:bottom-1 left-0.5 md:left-1 w-[calc(50%-2px)] md:w-[calc(50%-4px)] bg-white rounded-full shadow-sm border border-slate-200 transition-transform duration-300 ease-out"
                                                            id="booking-type-bg"></div>

                                                        <button type="button"
                                                            class="flex-1 py-1.5 md:py-2 text-xs md:text-sm font-bold z-10 transition-colors duration-300 text-[#6200EE]"
                                                            id="btn-ondemand" onclick="setBookingType('ON_DEMAND')">Đặt
                                                            xe ngay</button>
                                                        <button type="button"
                                                            class="flex-1 py-1.5 md:py-2 text-xs md:text-sm font-bold z-10 transition-colors duration-300 text-slate-500 hover:text-slate-700"
                                                            id="btn-prebook" onclick="setBookingType('PRE_BOOK')">Đặt
                                                            lịch trước</button>
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
                                                                <div
                                                                    class="w-10 h-10 flex items-center justify-center shrink-0">
                                                                    <div
                                                                        class="w-3.5 h-3.5 rounded-full border-[3px] border-[#6200EE] bg-white">
                                                                    </div>
                                                                </div>
                                                                <input type="text" id="pickup-input" name="pickup"
                                                                    required autocomplete="off"
                                                                    placeholder="Điểm đón (VD: 123 Nguyễn Trãi)"
                                                                    class="w-full pr-4 py-2.5 bg-transparent text-base font-medium placeholder:text-slate-400 text-slate-700 border-none focus:ring-0 focus:outline-none">
                                                            </div>
                                                            <div id="pickup-suggestions"
                                                                class="absolute left-0 right-0 top-full mt-1 bg-white border border-slate-200 rounded-xl shadow-lg overflow-hidden hidden max-h-48 panel-scroll overflow-y-auto">
                                                            </div>
                                                        </div>

                                                        <!-- Dropoff -->
                                                        <div class="relative z-10">
                                                            <div
                                                                class="relative flex items-center p-1 bg-white border border-slate-200/80 rounded-full shadow-sm hover:border-[#6200EE]/50 transition-colors w-full">
                                                                <div
                                                                    class="w-10 h-10 flex items-center justify-center shrink-0">
                                                                    <span
                                                                        class="material-symbols-outlined text-[#FF6D00] text-[22px]">location_on</span>
                                                                </div>
                                                                <input type="text" id="dropoff-input" name="dropoff"
                                                                    required autocomplete="off"
                                                                    placeholder="Điểm đến (VD: Sân bay Nội Bài)"
                                                                    class="w-full pr-4 py-2.5 bg-transparent text-base font-medium placeholder:text-slate-400 text-slate-700 border-none focus:ring-0 focus:outline-none">
                                                            </div>
                                                            <div id="dropoff-suggestions"
                                                                class="absolute left-0 right-0 top-full mt-1 bg-white border border-slate-200 rounded-xl shadow-lg overflow-hidden hidden max-h-48 panel-scroll overflow-y-auto">
                                                            </div>
                                                        </div>
                                                        <!-- End of Location Input Group -->
                                                    </div>

                                                    <!-- Vehicle Selection -->
                                                    <div class="flex gap-2 md:gap-3 w-full mt-0 md:mt-1">
                                                        <label class="flex-1 cursor-pointer">
                                                            <input type="radio" name="vehicleType" value="MOTORBIKE"
                                                                class="peer hidden"
                                                                onchange="if(document.getElementById('pickup-lat').value && document.getElementById('dropoff-lat').value) calculateRouteAndPrice();">
                                                            <div
                                                                class="flex items-center justify-center gap-1.5 md:gap-2 p-2 md:p-3 bg-white border border-slate-200/80 rounded-xl shadow-sm peer-checked:border-[#6200EE] peer-checked:bg-purple-50 transition-colors">
                                                                <span
                                                                    class="material-symbols-outlined text-[18px] md:text-[20px] text-slate-500 peer-checked:text-[#6200EE]">two_wheeler</span>
                                                                <span
                                                                    class="text-xs md:text-sm font-semibold text-slate-600 peer-checked:text-[#6200EE]">Xe
                                                                    máy</span>
                                                            </div>
                                                        </label>
                                                        <label class="flex-1 cursor-pointer">
                                                            <input type="radio" name="vehicleType" value="CAR"
                                                                class="peer hidden" checked
                                                                onchange="if(document.getElementById('pickup-lat').value && document.getElementById('dropoff-lat').value) calculateRouteAndPrice();">
                                                            <div
                                                                class="flex items-center justify-center gap-1.5 md:gap-2 p-2 md:p-3 bg-white border border-slate-200/80 rounded-xl shadow-sm peer-checked:border-[#6200EE] peer-checked:bg-purple-50 transition-colors">
                                                                <span
                                                                    class="material-symbols-outlined text-[18px] md:text-[20px] text-slate-500 peer-checked:text-[#6200EE]">directions_car</span>
                                                                <span
                                                                    class="text-xs md:text-sm font-semibold text-slate-600 peer-checked:text-[#6200EE]">Ô
                                                                    tô</span>
                                                            </div>
                                                        </label>
                                                    </div>

                                                    <!-- Price Estimation Box -->
                                                    <div id="price-estimation-box"
                                                        class="hidden w-full bg-orange-50/80 border border-orange-200 rounded-2xl p-4 shadow-sm transition-all duration-300 mt-2">
                                                        <div class="flex justify-between items-center mb-1">
                                                            <span class="text-sm font-bold text-slate-700">Giá cước ước
                                                                tính</span>
                                                            <span id="price-value"
                                                                class="text-lg font-bold text-[#FF6D00]">...</span>
                                                        </div>
                                                        <div
                                                            class="flex justify-between items-center text-xs text-slate-500">
                                                            <span id="distance-value">Đang tính toán...</span>
                                                            <span id="duration-value"></span>
                                                        </div>
                                                        <input type="hidden" name="price" id="trip-price">
                                                        <input type="hidden" name="distance" id="trip-distance">
                                                    </div>

                                                    <!-- Note for Driver -->
                                                    <div class="w-full">
                                                        <div
                                                            class="relative flex items-start p-1 bg-white border border-slate-200/80 rounded-2xl shadow-sm hover:border-[#6200EE]/50 transition-colors w-full">
                                                            <div
                                                                class="w-10 h-10 flex items-center justify-center shrink-0 mt-1">
                                                                <span
                                                                    class="material-symbols-outlined text-slate-400 text-[20px]">edit_note</span>
                                                            </div>
                                                            <textarea id="note-input" name="note" rows="2"
                                                                placeholder="Lưu ý cho tài xế (VD: Đứng ở cổng chính, tôi mang nhiều đồ...)"
                                                                class="w-full pr-4 py-2.5 bg-transparent text-base placeholder:text-slate-400 text-slate-700 border-none focus:ring-0 focus:outline-none resize-none"></textarea>
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
                                                                    class="w-full pr-4 py-2.5 bg-transparent text-base font-semibold text-slate-700 border-none focus:ring-0 focus:outline-none">
                                                            </div>
                                                            <div
                                                                class="relative flex-1 bg-white border border-slate-200/80 rounded-full overflow-hidden shadow-sm flex items-center hover:border-[#6200EE]/50 transition-colors">
                                                                <div
                                                                    class="w-10 h-10 flex items-center justify-center text-slate-400 shrink-0 ml-1">
                                                                    <span
                                                                        class="material-symbols-outlined text-[18px]">schedule</span>
                                                                </div>
                                                                <input type="time" name="time" id="trip-time"
                                                                    class="w-full pr-4 py-2.5 bg-transparent text-base font-semibold text-slate-700 border-none focus:ring-0 focus:outline-none">
                                                            </div>
                                                        </div>

                                                        <!-- Share to Blog Toggle -->
                                                        <div class="flex items-center justify-between px-2 mt-1">
                                                            <div class="flex items-center gap-2">
                                                                <span
                                                                    class="material-symbols-outlined text-[#6200EE] text-[20px]">dynamic_feed</span>
                                                                <span class="text-sm font-semibold text-slate-700">Chia
                                                                    sẻ lên Cộng
                                                                    đồng</span>
                                                            </div>
                                                            <label
                                                                class="relative inline-flex items-center cursor-pointer">
                                                                <input type="checkbox" name="shareToBlog" value="true"
                                                                    class="sr-only peer" checked>
                                                                <div
                                                                    class="w-9 h-5 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-[#6200EE]">
                                                                </div>
                                                            </label>
                                                        </div>
                                                    </div>

                                                    <button type="submit" id="btn-submit-search"
                                                        class="w-full bg-slate-900 hover:bg-black text-white font-bold py-2.5 md:py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-sm md:text-lg mt-auto shrink-0">
                                                        Tìm chuyến
                                                        <span
                                                            class="material-symbols-outlined text-[20px]">arrow_forward</span>
                                                    </button>
                                                </form>

                                                <!-- RIGHT: Results Display -->
                                                <div
                                                    class="w-full lg:w-[55%] flex flex-col pl-4 relative h-full min-h-[300px]">
                                                    <!-- Empty State -->
                                                    <div id="empty-search-state"
                                                        class="absolute inset-0 flex flex-col items-center justify-center p-6 bg-white/50 border border-dashed border-slate-300/80 rounded-3xl ml-4">
                                                        <div
                                                            class="w-20 h-20 bg-slate-100/80 rounded-full flex items-center justify-center mb-5 shadow-inner">
                                                            <span
                                                                class="material-symbols-outlined text-[40px] text-slate-400">directions_car</span>
                                                        </div>
                                                        <h5 class="font-bold text-slate-800 text-lg mb-2">Tìm chuyến xe
                                                            của bạn</h5>
                                                        <p class="text-sm text-slate-500 text-center max-w-[280px]">Nhập
                                                            điểm đón và điểm đến, sau đó nhấn "Tìm chuyến" để bắt đầu.
                                                        </p>
                                                    </div>

                                                    <!-- Loading State -->
                                                    <div id="loading-search-state"
                                                        class="absolute inset-0 hidden flex-col ml-4">
                                                        <div class="flex items-center justify-between mb-4">
                                                            <h4 class="font-bold text-slate-800 text-lg">Kết quả nổi bật
                                                            </h4>
                                                            <span
                                                                class="bg-slate-100 text-slate-500 text-xs font-bold px-3 py-1.5 rounded-lg flex items-center gap-1 shadow-sm">
                                                                <span
                                                                    class="material-symbols-outlined text-[14px] animate-spin">sync</span>
                                                                Đang tìm kiếm
                                                            </span>
                                                        </div>
                                                        <div
                                                            class="flex-1 flex flex-col items-center justify-center p-6 bg-white/50 border border-slate-200/60 rounded-3xl shadow-inner">
                                                            <div class="relative w-16 h-16 mb-6">
                                                                <!-- Ripple/Pulse effect -->
                                                                <div
                                                                    class="absolute inset-0 bg-[#6200EE]/20 rounded-full animate-ping duration-1000">
                                                                </div>
                                                                <div
                                                                    class="absolute inset-2 bg-[#6200EE]/40 rounded-full animate-pulse">
                                                                </div>
                                                                <div
                                                                    class="absolute inset-0 flex items-center justify-center bg-white rounded-full shadow-sm z-10">
                                                                    <span
                                                                        class="material-symbols-outlined text-[#6200EE] text-[28px] animate-[spin_3s_linear_infinite]">radar</span>
                                                                </div>
                                                            </div>
                                                            <h5 class="font-bold text-slate-800 text-base mb-1">Đang
                                                                quét hệ thống...</h5>
                                                            <p class="text-sm text-slate-500 text-center max-w-[280px]">
                                                                Chúng tôi đang tìm kiếm các chuyến xe có lộ trình phù
                                                                hợp nhất với bạn.</p>
                                                        </div>
                                                    </div>

                                                    <!-- Matched Driver State -->
                                                    <div id="matched-driver-state"
                                                        class="absolute inset-0 hidden flex-col ml-4 z-10 bg-white">
                                                        <div class="flex items-center justify-between mb-4">
                                                            <h4 class="font-bold text-slate-800 text-lg">Tài xế đã nhận
                                                                chuyến</h4>
                                                            <span
                                                                class="bg-green-100 text-green-700 text-xs font-bold px-3 py-1.5 rounded-lg flex items-center gap-1 shadow-sm">
                                                                <span
                                                                    class="material-symbols-outlined text-[14px]">check_circle</span>
                                                                Đã xác nhận
                                                            </span>
                                                        </div>
                                                        <div
                                                            class="flex-1 flex flex-col items-center justify-center p-6 bg-white border border-green-200/60 rounded-3xl shadow-sm">
                                                            <div
                                                                class="w-16 h-16 bg-green-50 rounded-full flex items-center justify-center mb-4 border border-green-100 shadow-inner">
                                                                <span
                                                                    class="material-symbols-outlined text-[32px] text-green-500">local_taxi</span>
                                                            </div>
                                                            <h5 class="font-bold text-slate-800 text-lg mb-1"
                                                                id="inline-driver-name">---</h5>
                                                            <p class="text-sm text-slate-500 font-medium mb-4"
                                                                id="inline-driver-phone">---</p>

                                                            <div
                                                                class="w-full bg-slate-50 rounded-2xl p-4 flex flex-col gap-3">
                                                                <div class="flex justify-between items-center">
                                                                    <span class="text-xs text-slate-500">Phương
                                                                        tiện</span>
                                                                    <span class="text-sm font-semibold text-[#6200EE]"
                                                                        id="inline-driver-vehicle">---</span>
                                                                </div>
                                                                <div class="flex justify-between items-center">
                                                                    <span class="text-xs text-slate-500">Biển số</span>
                                                                    <span
                                                                        class="px-2 py-0.5 bg-white border border-slate-200 rounded font-mono text-xs font-bold text-slate-700 shadow-sm"
                                                                        id="inline-driver-plate">---</span>
                                                                </div>
                                                                <div class="flex flex-col gap-1 mt-1">
                                                                    <span class="text-xs text-slate-500">Sở thích</span>
                                                                    <span class="text-xs text-slate-700"
                                                                        id="inline-driver-hobbies">---</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Mini Search Popup (Top Right) -->
                                        <div id="mini-search-popup"
                                            class="fixed top-20 md:top-24 right-4 md:left-auto md:right-8 z-40 bg-white/95 md:bg-white/90 backdrop-blur-md border border-[#6200EE]/30 rounded-full md:rounded-2xl p-1.5 pr-3 md:p-4 shadow-sm md:shadow-[0_8px_30px_rgba(98,0,238,0.15)] transition-all duration-500 transform md:translate-y-0 translate-x-[150%] opacity-0 flex items-center gap-2 md:gap-4 w-auto md:w-[320px] cursor-pointer hover:bg-white"
                                            onclick="toggleBottomSearchBar(); if(window.setBookingType) window.setBookingType('ON_DEMAND');">
                                            <div class="relative w-6 h-6 md:w-10 md:h-10 shrink-0">
                                                <div class="absolute inset-0 bg-[#6200EE]/20 rounded-full animate-ping">
                                                </div>
                                                <div
                                                    class="absolute inset-0 bg-white border border-[#6200EE] md:border-2 rounded-full flex items-center justify-center shadow-inner">
                                                    <div class="w-2.5 h-2.5 md:w-4 md:h-4 bg-[#6200EE] rounded-full"></div>
                                                </div>
                                            </div>
                                            <div class="flex-1">
                                                <h4 class="text-[11px] md:text-sm font-bold text-slate-800 leading-none md:leading-tight">Đang tìm chuyến
                                                </h4>
                                                <p class="hidden md:block text-xs text-slate-500 mt-0.5">Bấm để xem hoặc
                                                    hủy</p>
                                            </div>
                                            <span
                                                class="hidden md:block material-symbols-outlined text-slate-400 text-[20px]">chevron_right</span>
                                        </div>

                                        <!-- Mini Prebook Popup (Top Right, Below OnDemand) -->
                                        <div id="mini-prebook-popup"
                                            class="fixed top-32 md:top-48 right-4 md:left-auto md:right-8 z-40 bg-white/95 md:bg-white/90 backdrop-blur-md border border-[#FF6D00]/30 rounded-full md:rounded-2xl p-1.5 pr-3 md:p-4 shadow-sm md:shadow-[0_8px_30px_rgba(255,109,0,0.15)] transition-all duration-500 transform md:translate-y-0 translate-x-[150%] opacity-0 flex items-center gap-2 md:gap-4 w-auto md:w-[320px] cursor-pointer hover:bg-white"
                                            onclick="toggleBottomSearchBar(); if(window.setBookingType) window.setBookingType('PRE_BOOK');">
                                            <div class="relative w-6 h-6 md:w-10 md:h-10 shrink-0">
                                                <div
                                                    class="absolute inset-0 bg-[#FF6D00]/20 rounded-full animate-pulse">
                                                </div>
                                                <div
                                                    class="absolute inset-0 bg-white border border-[#FF6D00] md:border-2 rounded-full flex items-center justify-center shadow-inner">
                                                    <span
                                                        class="material-symbols-outlined text-[#FF6D00] text-[12px] md:text-[20px]">schedule</span>
                                                </div>
                                            </div>
                                            <div class="flex-1 min-w-0">
                                                <h6 class="text-[11px] md:text-sm font-bold text-[#FF6D00] leading-none md:leading-tight mb-0 md:mb-1">Chuyến đặt trước
                                                </h6>
                                                <div class="hidden md:flex items-center gap-1 text-[10px] md:text-xs text-slate-600 truncate">
                                                    <div
                                                        class="w-1.5 h-1.5 rounded-full border-[2px] border-[#FF6D00] bg-white shrink-0">
                                                    </div>
                                                    <span id="mini-prebook-pickup" class="truncate"></span>
                                                </div>
                                                <div
                                                    class="hidden md:flex items-center gap-1 text-[10px] md:text-xs text-slate-600 truncate mt-0.5">
                                                    <span
                                                        class="material-symbols-outlined text-[#FF6D00] text-[10px] md:text-[12px] shrink-0">location_on</span>
                                                    <span id="mini-prebook-dropoff" class="truncate"></span>
                                                </div>
                                            </div>
                                            <span
                                                class="hidden md:block material-symbols-outlined text-slate-400 text-[20px]">chevron_right</span>
                                        </div>

                                        <!-- Mini Upcoming Trips Popup (Top Right, Below Prebook) -->
                                        <div id="mini-upcoming-trips-popup"
                                            class="fixed top-44 md:top-72 right-4 md:left-auto md:right-8 z-40 bg-white/95 md:bg-white/90 backdrop-blur-md border border-[#4CAF50]/30 rounded-full md:rounded-2xl p-1.5 pr-3 md:p-4 shadow-sm md:shadow-[0_8px_30px_rgba(76,175,80,0.15)] transition-all duration-500 transform md:translate-y-0 translate-x-[150%] opacity-0 flex items-center gap-2 md:gap-4 w-auto md:w-[320px] cursor-pointer hover:bg-white"
                                            onclick="toggleUpcomingTripsPanel()">
                                            <div class="relative w-6 h-6 md:w-10 md:h-10 shrink-0">
                                                <div class="absolute inset-0 bg-[#4CAF50]/20 rounded-full animate-pulse"></div>
                                                <div class="absolute inset-0 bg-white border border-[#4CAF50] md:border-2 rounded-full flex items-center justify-center shadow-inner">
                                                    <span class="material-symbols-outlined text-[#4CAF50] text-[12px] md:text-[20px]">event_available</span>
                                                </div>
                                            </div>
                                            <div class="flex-1 min-w-0">
                                                <h6 class="text-[11px] md:text-sm font-bold text-[#4CAF50] leading-none md:leading-tight mb-0 md:mb-1">Lịch trình sắp tới
                                                </h6>
                                                <div class="hidden md:flex items-center gap-1 text-[10px] md:text-xs text-slate-600 truncate">
                                                    <span id="mini-upcoming-trips-count" class="truncate font-semibold">0 chuyến chờ đi</span>
                                                </div>
                                            </div>
                                            <span class="hidden md:block material-symbols-outlined text-slate-400 text-[20px]">keyboard_arrow_up</span>
                                        </div>


                                        <!-- Bottom Blog Bar (Right of Dynamic Island) -->
                                        <div id="bottom-blog-bar"
                                            class="fixed inset-0 md:inset-auto md:bottom-8 md:left-[420px] md:right-8 z-30 bg-white/95 md:bg-white/75 backdrop-blur-xl border-none md:border md:border-white/60 rounded-none md:rounded-3xl p-4 pt-10 md:p-6 pb-[100px] md:pb-safe transition-all duration-500 transform translate-y-[150%] opacity-0 flex flex-col w-auto md:max-h-[80vh] md:min-h-[360px] shadow-none">

                                            <!-- Handle for dragging/closing -->
                                            <div class="hidden md:flex w-full justify-center mb-4 cursor-pointer shrink-0"
                                                onclick="toggleBottomBlogBar()">
                                                <div
                                                    class="w-16 h-1.5 bg-slate-300 rounded-full hover:bg-slate-400 transition-colors">
                                                </div>
                                            </div>

                                            <!-- Header & Close -->
                                            <div class="flex justify-between items-center mb-6 shrink-0">
                                                <div class="flex items-center gap-2">
                                                    <button onclick="switchTab('nav-home')"
                                                        class="flex items-center justify-center w-10 h-10 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-800 transition-colors mr-1">
                                                        <span class="material-symbols-outlined">arrow_back</span>
                                                    </button>
                                                    <h3
                                                        class="text-2xl font-bold text-slate-800 tracking-tight flex items-center gap-2">
                                                        <span
                                                            class="hidden md:block material-symbols-outlined text-[#6200EE]">diversity_3</span>
                                                        Cộng đồng & Chia sẻ
                                                    </h3>
                                                </div>
                                            </div>

                                            <!-- Split Layout -->
                                            <div
                                                class="flex flex-col lg:flex-row gap-8 flex-1 min-h-0 overflow-y-auto panel-scroll pr-2 relative">
                                                <!-- Left: Blog Feed (2/3) -->
                                                <div class="w-full lg:w-2/3 flex flex-col space-y-5 pb-4">
                                                    <c:choose>
                                                        <c:when test="${not empty blogPosts}">
                                                            <c:forEach var="post" items="${blogPosts}">
                                                                <div
                                                                    class="bg-white/90 border border-slate-200/80 rounded-3xl p-5 shadow-sm hover:shadow-md transition-shadow mb-4">
                                                                    <div class="flex items-center gap-3 mb-4">
                                                                        <!-- Empty Avatar -->
                                                                        <div
                                                                            class="w-10 h-10 rounded-full bg-slate-200 flex items-center justify-center shrink-0 text-slate-400">
                                                                            <span
                                                                                class="material-symbols-outlined text-[20px]">person</span>
                                                                        </div>
                                                                        <div>
                                                                            <h5 class="font-bold text-slate-800 text-sm">
                                                                                <c:out value="${not empty post.passengerName ? post.passengerName : 'Người dùng ẩn danh'}" />
                                                                            </h5>
                                                                            <p class="text-xs text-slate-500">
                                                                                <c:choose>
                                                                                    <c:when test="${not empty post.tripCreatedAt}">
                                                                                        <fmt:formatDate value="${post.tripCreatedAt}" pattern="dd/MM/yyyy HH:mm" />
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        Mới đây
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                                    • Nhóm Chia sẻ chuyến đi
                                                                            </p>
                                                                        </div>
                                                                    </div>
                                                                    <p
                                                                        class="text-slate-700 text-sm mb-3 leading-relaxed whitespace-pre-line">
                                                                        <strong>
                                                                            <c:out value="${post.title}" />
                                                                        </strong>

                                                                        <c:out value="${post.content}" />
                                                                    </p>
                                                                    <div
                                                                        class="flex items-center gap-6 border-t border-slate-100/50 pt-3 mt-2">
                                                                        <button
                                                                            class="flex items-center gap-2 text-slate-500 hover:text-[#6200EE] transition-colors text-sm font-medium">
                                                                            <span
                                                                                class="material-symbols-outlined text-[20px]">thumb_up</span>
                                                                            Thích (0)
                                                                        </button>
                                                                        <button
                                                                            class="flex items-center gap-2 text-slate-500 hover:text-[#6200EE] transition-colors text-sm font-medium">
                                                                            <span
                                                                                class="material-symbols-outlined text-[20px]">chat_bubble</span>
                                                                            Bình luận (0)
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div
                                                                class="text-center p-10 bg-white/50 border border-slate-200/80 rounded-3xl">
                                                                <span
                                                                    class="material-symbols-outlined text-[40px] text-slate-300 mb-2">inbox</span>
                                                                <p class="text-slate-500 font-medium">Hiện chưa có bài
                                                                    đăng nào.</p>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <!-- Right: Create Post & Friends (1/3) -->
                                                <div class="w-full lg:w-1/3">
                                                    <div class="sticky top-0 flex flex-col gap-6 pb-4">
                                                        <!-- Create Post -->
                                                        <div
                                                            class="bg-white/90 border border-slate-200/80 rounded-3xl p-5 shadow-sm shrink-0">
                                                            <h4
                                                                class="font-bold text-slate-800 mb-3 flex items-center gap-2">
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
                                                            <h4
                                                                class="font-bold text-slate-800 mb-4 flex items-center gap-2">
                                                                <span
                                                                    class="material-symbols-outlined text-[#FF6D00] text-[20px]">group</span>
                                                                Người liên hệ
                                                            </h4>
                                                            <div class="flex flex-col gap-4">
                                                                <div
                                                                    class="flex items-center gap-3 cursor-pointer group">
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
                                                                        <p class="text-xs text-slate-500 truncate">Trực
                                                                            tuyến</p>
                                                                    </div>
                                                                </div>
                                                                <div
                                                                    class="flex items-center gap-3 cursor-pointer group">
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
                                                                        <p class="text-xs text-slate-500 truncate">Trực
                                                                            tuyến</p>
                                                                    </div>
                                                                </div>
                                                                <div
                                                                    class="flex items-center gap-3 cursor-pointer group">
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
                                                                        <p class="text-xs text-slate-500 truncate">Hoạt
                                                                            động 5p trước</p>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <script>
                                            // --- WEBSOCKET INITIALIZATION ---
                                            const wsUrl = (window.location.protocol === 'https:' ? 'wss://' : 'ws://') + window.location.host + '${pageContext.request.contextPath}/ws/trip';
                                            let tripWs = null;
                                            let wsReconnectTimer = null;

                                            function connectTripWebSocket() {
                                                tripWs = new WebSocket(wsUrl);

                                                tripWs.onopen = function() {
                                                    console.log("[WS] Connected to Trip WebSocket");
                                                    if (wsReconnectTimer) { clearTimeout(wsReconnectTimer); wsReconnectTimer = null; }
                                                    tripWs.send(JSON.stringify({
                                                        action: "auth",
                                                        userId: ${loggedInUser.id},
                                                        role: "${loggedInUser.role}"
                                                    }));
                                                };

                                                tripWs.onmessage = function(event) {
                                                    const msg = JSON.parse(event.data);
                                                    console.log("[WS] Message received:", msg);
                                                    const currentRole = "${loggedInUser.role}";
                                                    
                                                    if (msg.action === "NEW_ON_DEMAND_TRIP") {
                                                        if (currentRole === "driver") {
                                                            if (typeof fetchTripProposals === "function") fetchTripProposals();
                                                        }
                                                    } else if (msg.action === "NEW_PRE_BOOK_TRIP") {
                                                        if (currentRole === "driver") {
                                                            if (typeof fetchTripProposals === "function") fetchTripProposals();
                                                            if (typeof fetchUpcomingTrips === "function") fetchUpcomingTrips();
                                                        }
                                                    } else if (msg.action === "TRIP_CANCELLED") {
                                                        if (currentRole === "driver") {
                                                            if (typeof fetchTripProposals === "function") fetchTripProposals();
                                                            if (typeof fetchUpcomingTrips === "function") fetchUpcomingTrips();
                                                            if (typeof checkDriverTripStatus === "function") checkDriverTripStatus();
                                                        }
                                                    } else if (msg.action === "TRIP_ACCEPTED") {
                                                        if (currentRole === "passenger") {
                                                            if (typeof checkPassengerTripStatus === "function") checkPassengerTripStatus();
                                                            if (typeof fetchUpcomingTrips === "function") fetchUpcomingTrips();
                                                        }
                                                        if (currentRole === "driver") {
                                                            // Refresh proposals and active trip for the accepting driver
                                                            if (typeof checkDriverTripStatus === "function") checkDriverTripStatus();
                                                            if (typeof fetchUpcomingTrips === "function") fetchUpcomingTrips();
                                                        }
                                                    } else if (msg.action === "TRIP_STARTED" || msg.action === "TRIP_COMPLETED" || msg.action === "TRIP_CANCELLED_BY_DRIVER") {
                                                        if (currentRole === "passenger") {
                                                            if (typeof checkPassengerTripStatus === "function") checkPassengerTripStatus();
                                                            if (typeof fetchUpcomingTrips === "function") fetchUpcomingTrips();
                                                        }
                                                    }
                                                };

                                                tripWs.onclose = function() {
                                                    console.log("[WS] Disconnected. Reconnecting in 3s...");
                                                    wsReconnectTimer = setTimeout(connectTripWebSocket, 3000);
                                                };

                                                tripWs.onerror = function(err) {
                                                    console.error("[WS] Error:", err);
                                                    tripWs.close();
                                                };
                                            }
                                            connectTripWebSocket();
                                            // --------------------------------

                                            let isSearchingOnDemand = ${not empty activeTrip};
                                            window.currentTripId = ${not empty activeTrip ? activeTrip.id : 'null'};

                                            let hasPreBookTrip = ${not empty activePreBookTrip};
                                            window.currentPreBookTripId = ${not empty activePreBookTrip ? activePreBookTrip.id : 'null'};

                                            const tripData = {
                                                ON_DEMAND: {
                                                    active: isSearchingOnDemand,
                                                    pickup: `${not empty activeTrip ? activeTrip.pickupLocation : ''}`,
                                                    dropoff: `${not empty activeTrip ? activeTrip.dropoffLocation : ''}`,
                                                    vehicleType: "${not empty activeTrip ? activeTrip.vehicleType : 'MOTORBIKE'}",
                                                    note: `${not empty activeTrip ? activeTrip.noteForDriver : ''}`,
                                                    matchStatus: "${not empty activeTrip ? activeTrip.matchStatus : ''}",
                                                    distance: ${not empty activeTrip and not empty activeTrip.distance ? activeTrip.distance : 0},
                                                    price: ${not empty activeTrip and not empty activeTrip.price ? activeTrip.price : 0}
                                                },
                                                PRE_BOOK: {
                                                    active: hasPreBookTrip,
                                                    pickup: `${not empty activePreBookTrip ? activePreBookTrip.pickupLocation : ''}`,
                                                    dropoff: `${not empty activePreBookTrip ? activePreBookTrip.dropoffLocation : ''}`,
                                                    vehicleType: "${not empty activePreBookTrip ? activePreBookTrip.vehicleType : 'MOTORBIKE'}",
                                                    note: `${not empty activePreBookTrip ? activePreBookTrip.noteForDriver : ''}`,
                                                    date: "${preBookDateStr}",
                                                    time: "${preBookTimeStr}",
                                                    matchStatus: "${not empty activePreBookTrip ? activePreBookTrip.matchStatus : ''}",
                                                    distance: ${not empty activePreBookTrip and not empty activePreBookTrip.distance ? activePreBookTrip.distance : 0},
                                                    price: ${not empty activePreBookTrip and not empty activePreBookTrip.price ? activePreBookTrip.price : 0}
                                                }
                                            };

                                            // Phục hồi trạng thái UI nếu đã có chuyến xe đang tìm kiếm
                                            document.addEventListener("DOMContentLoaded", function () {
                                                if (isSearchingOnDemand) {
                                                    // Giao diện đang tìm kiếm
                                                    document.getElementById('empty-search-state').classList.add('hidden');
                                                    document.getElementById('empty-search-state').classList.remove('flex');

                                                    document.getElementById('loading-search-state').classList.remove('hidden');
                                                    if (document.getElementById('matched-driver-state')) {
                                                        document.getElementById('matched-driver-state').classList.add('hidden');
                                                        document.getElementById('matched-driver-state').classList.remove('flex');
                                                    }
                                                    document.getElementById('loading-search-state').classList.add('flex');

                                                    // Giao diện form - địa chỉ
                                                    document.getElementById('pickup-input').value = tripData.ON_DEMAND.pickup;
                                                    document.getElementById('dropoff-input').value = tripData.ON_DEMAND.dropoff;

                                                    // Khôi phục loại phương tiện (radio button)
                                                    const vTypeOD = tripData.ON_DEMAND.vehicleType;
                                                    if (vTypeOD) {
                                                        const radio = document.querySelector('input[name="vehicleType"][value="' + vTypeOD + '"]');
                                                        if (radio) radio.checked = true;
                                                    }

                                                    // Khôi phục ghi chú cho tài xế
                                                    const noteInputOD = document.getElementById('note-input');
                                                    if (noteInputOD) noteInputOD.value = tripData.ON_DEMAND.note || '';

                                                    // Giao diện popup
                                                    const miniPickup = document.getElementById('mini-popup-pickup');
                                                    if (miniPickup) miniPickup.textContent = `${not empty activeTrip ? activeTrip.pickupLocation : ''}`;
                                                    const miniDropoff = document.getElementById('mini-popup-dropoff');
                                                    if (miniDropoff) miniDropoff.textContent = `${not empty activeTrip ? activeTrip.dropoffLocation : ''}`;

                                                    // Nút hành động
                                                    const btnSubmit = document.getElementById('btn-submit-search');
                                                    if (btnSubmit) {
                                                        if (tripData.ON_DEMAND.matchStatus === 'MATCHED') {
                                                            btnSubmit.type = 'button';
                                                            btnSubmit.innerHTML = 'Chuyến đi sắp bắt đầu <span class="material-symbols-outlined text-[20px]">check_circle</span>';
                                                            btnSubmit.className = 'w-full bg-green-500 text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(34,197,94,0.3)] flex items-center justify-center gap-2 text-lg mt-auto cursor-not-allowed';
                                                            btnSubmit.disabled = true;
                                                            btnSubmit.onclick = null;
                                                        } else {
                                                            btnSubmit.type = 'button';
                                                            btnSubmit.innerHTML = 'Hủy tìm kiếm <span class="material-symbols-outlined text-[20px]">cancel</span>';
                                                            btnSubmit.className = 'w-full bg-red-500 hover:bg-red-600 text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                                            btnSubmit.disabled = false;
                                                            btnSubmit.onclick = cancelTripSearch;
                                                        }
                                                    }
                                                }

                                                if (hasPreBookTrip) {
                                                    document.getElementById('mini-prebook-pickup').textContent = "${not empty activePreBookTrip ? activePreBookTrip.pickupLocation : ''}";
                                                    document.getElementById('mini-prebook-dropoff').textContent = "${not empty activePreBookTrip ? activePreBookTrip.dropoffLocation : ''}";
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

                                                // Bắt đầu polling tìm tài xế nếu có chuyến đang hoạt động
                                                if (isSearchingOnDemand || hasPreBookTrip) {
                                                    checkPassengerTripStatus(); // Check immediately to display matched driver info on reload
                                                    passengerStatusInterval = setInterval(checkPassengerTripStatus, 15000); // Fallback polling mỗi 15s
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

                                                if (!pickupLat || !dropoffLat) {
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

                                                    // Cập nhật thông tin lên mini popup (nếu element còn tồn tại)
                                                    const miniPickup = document.getElementById('mini-popup-pickup');
                                                    if (miniPickup) miniPickup.textContent = document.getElementById('pickup-input').value || "Đang tải...";
                                                    const miniDropoff = document.getElementById('mini-popup-dropoff');
                                                    if (miniDropoff) miniDropoff.textContent = document.getElementById('dropoff-input').value || "Đang tải...";

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
                                                if (document.getElementById('matched-driver-state')) {
                                                    document.getElementById('matched-driver-state').classList.add('hidden');
                                                    document.getElementById('matched-driver-state').classList.remove('flex');
                                                }
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
                                                    .then(response => {
                                                        if (!response.ok) {
                                                            throw new Error('Network response was not ok');
                                                        }
                                                        return response.json();
                                                    })
                                                    .then(data => {
                                                        if (data.success) {
                                                            if (tripType === 'ON_DEMAND') {
                                                                window.currentTripId = data.tripId;
                                                                tripData.ON_DEMAND.active = true;
                                                                tripData.ON_DEMAND.matchStatus = 'PENDING';
                                                                tripData.ON_DEMAND.pickup = document.getElementById('pickup-input').value;
                                                                tripData.ON_DEMAND.pickupLat = document.getElementById('pickup-lat').value;
                                                                tripData.ON_DEMAND.pickupLng = document.getElementById('pickup-lng').value;
                                                                tripData.ON_DEMAND.dropoff = document.getElementById('dropoff-input').value;
                                                                tripData.ON_DEMAND.dropoffLat = document.getElementById('dropoff-lat').value;
                                                                tripData.ON_DEMAND.dropoffLng = document.getElementById('dropoff-lng').value;
                                                                tripData.ON_DEMAND.note = document.getElementById('note-input').value;
                                                                const vtElem = document.querySelector('input[name="vehicleType"]:checked');
                                                                if(vtElem) tripData.ON_DEMAND.vehicleType = vtElem.value;
                                                                tripData.ON_DEMAND.price = document.getElementById('trip-price').value;
                                                                tripData.ON_DEMAND.distance = document.getElementById('trip-distance').value;
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
                                                                tripData.PRE_BOOK.matchStatus = 'PENDING';
                                                                tripData.PRE_BOOK.pickup = document.getElementById('pickup-input').value;
                                                                tripData.PRE_BOOK.pickupLat = document.getElementById('pickup-lat').value;
                                                                tripData.PRE_BOOK.pickupLng = document.getElementById('pickup-lng').value;
                                                                tripData.PRE_BOOK.dropoff = document.getElementById('dropoff-input').value;
                                                                tripData.PRE_BOOK.dropoffLat = document.getElementById('dropoff-lat').value;
                                                                tripData.PRE_BOOK.dropoffLng = document.getElementById('dropoff-lng').value;
                                                                tripData.PRE_BOOK.note = document.getElementById('note-input').value;
                                                                const vtElem = document.querySelector('input[name="vehicleType"]:checked');
                                                                if(vtElem) tripData.PRE_BOOK.vehicleType = vtElem.value;
                                                                tripData.PRE_BOOK.price = document.getElementById('trip-price').value;
                                                                tripData.PRE_BOOK.distance = document.getElementById('trip-distance').value;
                                                                tripData.PRE_BOOK.date = document.getElementById('trip-date').value;
                                                                tripData.PRE_BOOK.time = document.getElementById('trip-time').value;
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
                                                            
                                                            // Bắt đầu polling ngay lập tức để cập nhật thông tin tài xế khi nhận chuyến
                                                            if (!passengerStatusInterval) {
                                                                checkPassengerTripStatus();
                                                                passengerStatusInterval = setInterval(checkPassengerTripStatus, 15000);
                                                            }
                                                        } else {
                                                            showToast("Lỗi: " + (data.error || "Không thể tạo chuyến đi"), "error");
                                                            if (data.error && (data.error.includes("Bạn đang tìm chuyến Đặt ngay") || data.error.includes("Bạn đã có chuyến Đặt trước"))) {
                                                                setTimeout(() => { window.location.reload(); }, 1500);
                                                            }
                                                            resetSearchUI();
                                                        }
                                                    }).catch(error => {
                                                        console.error("Lỗi khi gửi yêu cầu tìm chuyến:", error);
                                                        showToast("Lỗi kết nối đến máy chủ. Hãy tải lại trang.", "error");
                                                        resetSearchUI();
                                                    });
                                            }

                                            function resetSearchUI() {
                                                isSearchingOnDemand = false;
                                                document.getElementById('loading-search-state').classList.add('hidden');
                                                document.getElementById('loading-search-state').classList.remove('flex');
                                                document.getElementById('empty-search-state').classList.remove('hidden');
                                                if (document.getElementById('matched-driver-state')) {
                                                    document.getElementById('matched-driver-state').classList.add('hidden');
                                                    document.getElementById('matched-driver-state').classList.remove('flex');
                                                }
                                                document.getElementById('empty-search-state').classList.add('flex');

                                                const btnSubmit = document.getElementById('btn-submit-search');
                                                if (btnSubmit) {
                                                    btnSubmit.type = 'submit';
                                                    btnSubmit.innerHTML = 'Tìm chuyến <span class="material-symbols-outlined text-[20px]">arrow_forward</span>';
                                                    btnSubmit.className = 'w-full bg-slate-900 hover:bg-black text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                                    btnSubmit.disabled = false;
                                                    btnSubmit.onclick = null;
                                                }
                                            }

                                            let passengerStatusInterval = null;

                                            function forceResetPassengerUI(msg, msgType, tripTypeToReset) {
                                                if (msg) showToast(msg, msgType);
                                                
                                                if (!tripTypeToReset || tripTypeToReset === 'ON_DEMAND') {
                                                    isSearchingOnDemand = false;
                                                    window.currentTripId = null;
                                                    tripData.ON_DEMAND.active = false;
                                                    tripData.ON_DEMAND.matchStatus = '';
                                                    tripData.ON_DEMAND.driver = null;
                                                }
                                                
                                                if (!tripTypeToReset || tripTypeToReset === 'PRE_BOOK') {
                                                    hasPreBookTrip = false;
                                                    window.currentPreBookTripId = null;
                                                    tripData.PRE_BOOK.active = false;
                                                    tripData.PRE_BOOK.matchStatus = '';
                                                    tripData.PRE_BOOK.driver = null;
                                                }
                                            
                                                // Only unlock forms if BOTH are false
                                                if (!isSearchingOnDemand && !hasPreBookTrip) {
                                                    toggleFormInputs(false);
                                                }
                                            
                                                if (!isSearchingOnDemand && !hasPreBookTrip && passengerStatusInterval) {
                                                    clearInterval(passengerStatusInterval);
                                                    passengerStatusInterval = null;
                                                }
                                            
                                                if (window.markerOnDemand) {
                                                    window.markerOnDemand.remove();
                                                    window.markerOnDemand = null;
                                                }
                                                if (window.map && window.map.getSource && window.map.getSource('route-on-demand')) {
                                                    window.map.removeLayer('route-on-demand');
                                                    window.map.removeSource('route-on-demand');
                                                }
                                                document.getElementById('pickup-input').value = "";
                                                document.getElementById('dropoff-input').value = "";
                                                document.getElementById('pickup-lat').value = "";
                                                document.getElementById('pickup-lng').value = "";
                                                document.getElementById('dropoff-lat').value = "";
                                                document.getElementById('dropoff-lng').value = "";
                                                document.getElementById('trip-price').value = "";
                                                document.getElementById('trip-distance').value = "";
                                                if (document.getElementById('price-estimation-box')) {
                                                    document.getElementById('price-estimation-box').classList.add('hidden');
                                                }
                                            
                                                const btnSubmit = document.getElementById('btn-submit-search');
                                                if (btnSubmit) {
                                                    btnSubmit.type = 'submit';
                                                    btnSubmit.innerHTML = 'Tìm chuyến <span class="material-symbols-outlined text-[20px]">arrow_forward</span>';
                                                    btnSubmit.className = 'w-full bg-slate-900 hover:bg-black text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                                    btnSubmit.onclick = null;
                                                    btnSubmit.disabled = false;
                                                }
                                            
                                                const currentTab = document.getElementById('tripType') ? document.getElementById('tripType').value : 'ON_DEMAND';
                                                if (window.setBookingType) window.setBookingType(currentTab);
                                            
                                                if (document.getElementById('loading-search-state')) {
                                                    document.getElementById('loading-search-state').classList.add('hidden');
                                                    document.getElementById('loading-search-state').classList.remove('flex');
                                                }
                                                const matchedState = document.getElementById('matched-driver-state');
                                                if (matchedState) {
                                                    matchedState.classList.add('hidden');
                                                    matchedState.classList.remove('flex');
                                                }
                                                if (document.getElementById('empty-search-state')) {
                                                    document.getElementById('empty-search-state').classList.remove('hidden');
                                                    document.getElementById('empty-search-state').classList.add('flex');
                                                }
                                            }

                                            function checkPassengerTripStatus() {
                                                // Kiểm tra cả 2 loại chuyến (ON_DEMAND và PRE_BOOK) nếu cả 2 tồn tại
                                                if (window.currentTripId) {
                                                    _checkOneTripStatus(window.currentTripId, 'ON_DEMAND');
                                                }
                                                if (window.currentPreBookTripId) {
                                                    _checkOneTripStatus(window.currentPreBookTripId, 'PRE_BOOK');
                                                }
                                            }
                                            
                                            function _checkOneTripStatus(tripId, tripType) {
                                                if (!tripId) return;
                                                const activeType = document.getElementById('tripType') ? document.getElementById('tripType').value : 'ON_DEMAND';
                                                fetch('${pageContext.request.contextPath}/api/passenger/trip-status?tripId=' + tripId)
                                                    .then(res => res.json())
                                                    .then(data => {
                                                        const isActiveTab = (tripType === activeType);
                                                        
                                                        if (data.success && data.status === 'MATCHED') {
                                                            tripData[tripType].matchStatus = 'MATCHED';
                                                            if (data.driver) {
                                                                tripData[tripType].driver = data.driver;
                                                            }
                                                            
                                                            if (isActiveTab) {
                                                                const btn = document.getElementById('btn-submit-search');
                                                                if (btn) {
                                                                    btn.type = 'button';
                                                                    btn.innerHTML = 'Chuyến đi sắp bắt đầu <span class="material-symbols-outlined text-[20px]">check_circle</span>';
                                                                    btn.className = 'w-full bg-green-500 text-white font-bold py-3.5 rounded-full flex items-center justify-center gap-2 text-lg mt-auto cursor-not-allowed';
                                                                    btn.disabled = true;
                                                                    btn.onclick = null;
                                                                }
                                                                
                                                                if (data.driver) {
                                                                    document.getElementById('inline-driver-name').textContent = data.driver.fullName || '---';
                                                                    document.getElementById('inline-driver-phone').textContent = data.driver.phoneNumber || '---';
                                                                    document.getElementById('inline-driver-vehicle').textContent = (data.driver.vehicleName || '---') + " (" + (data.driver.vehicleType || '---') + ")";
                                                                    document.getElementById('inline-driver-plate').textContent = data.driver.licensePlate || '---';
                                                                    document.getElementById('inline-driver-hobbies').textContent = data.driver.hobbies || 'Không có';
                                                                }
                                                                
                                                                const matchedState = document.getElementById('matched-driver-state');
                                                                if (matchedState) {
                                                                    document.getElementById('empty-search-state').classList.add('hidden');
                                                                    document.getElementById('loading-search-state').classList.add('hidden');
                                                                    matchedState.classList.remove('hidden');
                                                                    matchedState.classList.add('flex');
                                                                }
                                                            } else {
                                                                if (window.showToast) window.showToast('Tài xế đã nhận chuyến ' + (tripType === 'PRE_BOOK' ? 'Hẹn trước' : 'Đặt ngay') + ' của bạn!', 'info');
                                                            }
                                                        } else if (data.success && data.status === 'IN_PROGRESS') {
                                                            tripData[tripType].matchStatus = 'IN_PROGRESS';
                                                            if (data.driver) {
                                                                tripData[tripType].driver = data.driver;
                                                            }
                                                            
                                                            if (isActiveTab) {
                                                                const btn = document.getElementById('btn-submit-search');
                                                                if (btn) {
                                                                    btn.type = 'button';
                                                                    btn.innerHTML = 'Đang trong chuyến đi <span class="material-symbols-outlined text-[20px]">directions_car</span>';
                                                                    btn.className = 'w-full bg-[#FF6D00] text-white font-bold py-3.5 rounded-full flex items-center justify-center gap-2 text-lg mt-auto cursor-not-allowed';
                                                                    btn.disabled = true;
                                                                    btn.onclick = null;
                                                                }
                                                                
                                                                // Đảm bảo UI hiển thị thông tin tài xế
                                                                if (data.driver) {
                                                                    document.getElementById('inline-driver-name').textContent = data.driver.fullName || '---';
                                                                    document.getElementById('inline-driver-phone').textContent = data.driver.phoneNumber || '---';
                                                                    document.getElementById('inline-driver-vehicle').textContent = (data.driver.vehicleName || '---') + " (" + (data.driver.vehicleType || '---') + ")";
                                                                    document.getElementById('inline-driver-plate').textContent = data.driver.licensePlate || '---';
                                                                    document.getElementById('inline-driver-hobbies').textContent = data.driver.hobbies || 'Không có';
                                                                }
                                                                
                                                                const matchedState = document.getElementById('matched-driver-state');
                                                                if (matchedState) {
                                                                    document.getElementById('empty-search-state').classList.add('hidden');
                                                                    document.getElementById('loading-search-state').classList.add('hidden');
                                                                    matchedState.classList.remove('hidden');
                                                                    matchedState.classList.add('flex');
                                                                }
                                                            }
                                                        } else if (data.success && data.status === 'COMPLETED') {
                                                            const dist = tripData[tripType].distance || 0;
                                                            const price = tripData[tripType].price || 0;
                                                            openTripSummaryModal('Chuyến đi hoàn tất!', 'Cảm ơn bạn đã sử dụng dịch vụ TransCake.', dist, price);
                                                            forceResetPassengerUI("Chuyến đi của bạn đã hoàn thành!", "success", tripType);
                                                        } else if (data.success && data.status === 'CANCELLED') {
                                                            forceResetPassengerUI("Chuyến đi đã bị hủy bởi tài xế hoặc hệ thống.", "warning", tripType);
                                                        } else if (data.success && data.status === 'NO_ACTIVE_TRIP') {
                                                            // Chỉ xử lý NO_ACTIVE_TRIP khi load lại, có thể bỏ qua nếu là polling
                                                            // forceResetPassengerUI("Không tìm thấy chuyến đi hoạt động nào.", "info", tripType);
                                                        }
                                                    }).catch(err => console.error(err));
                                            }

                                            function cancelTripSearch() {
                                                if (!window.currentTripId) {
                                                    showToast("Đang xử lý, vui lòng thử lại sau giây lát.", "warning");
                                                    return;
                                                }

                                                // Chặn hủy nếu đã MATCHED
                                                if (tripData.ON_DEMAND.matchStatus === 'MATCHED') {
                                                    showToast("Chuyến đi đã được tài xế nhận. Bạn không thể hủy chuyến này.", "error");
                                                    return;
                                                }

                                                // Sử dụng Confirm Modal tuỳ chỉnh
                                                showConfirmModal("Xác nhận hủy", "Bạn có chắc chắn muốn hủy yêu cầu tìm kiếm này?", function () {
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
                                                                tripData.ON_DEMAND.matchStatus = '';
                                                                tripData.ON_DEMAND.driver = null;
                                                                toggleFormInputs(false);

                                                                // Dừng polling khi hủy chuyến đi
                                                                if (passengerStatusInterval) {
                                                                    clearInterval(passengerStatusInterval);
                                                                    passengerStatusInterval = null;
                                                                }

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
                                                                    btnSubmit.disabled = false;

                                                                    // Gọi lại setBookingType để làm sạch form
                                                                    if (window.setBookingType) window.setBookingType('ON_DEMAND');
                                                                }

                                                                // Ẩn loading state, hiện empty state
                                                                document.getElementById('loading-search-state').classList.add('hidden');
                                                                document.getElementById('loading-search-state').classList.remove('flex');
                                                                document.getElementById('empty-search-state').classList.remove('hidden');
                                                                if (document.getElementById('matched-driver-state')) {
                                                                    document.getElementById('matched-driver-state').classList.add('hidden');
                                                                    document.getElementById('matched-driver-state').classList.remove('flex');
                                                                }
                                                                document.getElementById('empty-search-state').classList.add('flex');

                                                                // Ẩn mini popup
                                                                const miniPopup = document.getElementById('mini-search-popup');
                                                                if (miniPopup) {
                                                                    miniPopup.classList.add('translate-x-[150%]', 'opacity-0');
                                                                    miniPopup.classList.remove('translate-x-0', 'opacity-100');
                                                                }

                                                                showToast("Đã hủy chuyến đi thành công!", "success");
                                                            } else if (data.blocked) {
                                                                showToast(data.error || "Không thể hủy: Chuyến đi đã được tài xế nhận.", "error");
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

                                                showConfirmModal("Xác nhận hủy", "Bạn có chắc chắn muốn hủy chuyến xe đặt trước này?", function () {
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

                                                                // Dừng polling khi hủy chuyến xe đặt trước
                                                                if (passengerStatusInterval) {
                                                                    clearInterval(passengerStatusInterval);
                                                                    passengerStatusInterval = null;
                                                                }

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
                                                                if (document.getElementById('matched-driver-state')) {
                                                                    document.getElementById('matched-driver-state').classList.add('hidden');
                                                                    document.getElementById('matched-driver-state').classList.remove('flex');
                                                                }
                                                                document.getElementById('empty-search-state').classList.add('flex');

                                                                // Ẩn mini popup đặt trước
                                                                const prebookPopup = document.getElementById('mini-prebook-popup');
                                                                if (prebookPopup) {
                                                                    prebookPopup.classList.add('translate-x-full', 'opacity-0');
                                                                    prebookPopup.classList.remove('translate-x-0', 'opacity-100');

                                                                    const blogBar = document.getElementById('bottom-blog-bar');
                                                                    if (blogBar && !blogBar.classList.contains('translate-y-full')) {
                                                                        blogBar.classList.add('translate-y-full', 'opacity-0');
                                                                        blogBar.classList.remove('translate-y-0', 'opacity-100');
                                                                    }

                                                                    closeTripProposalsPanel();

                                                                }

                                                                showToast("Đã hủy chuyến xe đặt trước thành công!", "success");
                                                            } else {
                                                                showToast("Lỗi khi hủy chuyến: " + (data.error || "Không xác định"), "error");
                                                            }
                                                        });
                                                });
                                            }

                                            function setActiveTab(tabId) {
                                                const tabs = ['nav-home', 'nav-search', 'nav-blog', 'nav-profile'];
                                                tabs.forEach(id => {
                                                    const btn = document.getElementById(id);
                                                    if (btn) {
                                                        if (id === tabId) {
                                                            btn.classList.remove('text-slate-400', 'hover:bg-slate-100', 'hover:text-slate-600');
                                                            btn.classList.add('bg-purple-50', 'text-[#6200EE]', 'shadow-sm');
                                                        } else {
                                                            btn.classList.remove('bg-purple-50', 'text-[#6200EE]', 'shadow-sm');
                                                            btn.classList.add('text-slate-400', 'hover:bg-slate-100', 'hover:text-slate-600');
                                                        }
                                                    }
                                                });
                                            }

                                            function switchTab(tabId) {
                                                const searchBar = document.getElementById('bottom-search-bar');
                                                const blogBar = document.getElementById('bottom-blog-bar');
                                                const profView = document.getElementById('sidebar-profile-view');

                                                // Helper to always reset profile to Home view
                                                const resetProfileToHome = () => {
                                                    if (profView && !profView.classList.contains('opacity-0')) {
                                                        document.getElementById('btn-back-from-profile')?.click();
                                                    }
                                                };

                                                if (tabId === 'nav-home') {
                                                    if (searchBar && !searchBar.classList.contains('translate-y-[150%]')) {
                                                        toggleBottomSearchBar();
                                                    }
                                                    if (blogBar && !blogBar.classList.contains('translate-y-[150%]')) {
                                                        toggleBottomBlogBar();
                                                    }
                                                    resetProfileToHome();
                                                    setActiveTab('nav-home');
                                                }
                                                else if (tabId === 'nav-search') {
                                                    resetProfileToHome();
                                                    if (blogBar && !blogBar.classList.contains('translate-y-[150%]')) {
                                                        toggleBottomBlogBar();
                                                    }
                                                    if (searchBar && searchBar.classList.contains('translate-y-[150%]')) {
                                                        toggleBottomSearchBar();
                                                    } else {
                                                        setActiveTab('nav-search');
                                                    }
                                                }
                                                else if (tabId === 'nav-blog') {
                                                    resetProfileToHome();
                                                    if (searchBar && !searchBar.classList.contains('translate-y-[150%]')) {
                                                        toggleBottomSearchBar();
                                                    }
                                                    if (blogBar && blogBar.classList.contains('translate-y-[150%]')) {
                                                        toggleBottomBlogBar();
                                                    } else {
                                                        setActiveTab('nav-blog');
                                                    }
                                                }
                                                else if (tabId === 'nav-profile') {
                                                    if (searchBar && !searchBar.classList.contains('translate-y-[150%]')) {
                                                        toggleBottomSearchBar();
                                                    }
                                                    if (blogBar && !blogBar.classList.contains('translate-y-[150%]')) {
                                                        toggleBottomBlogBar();
                                                    }
                                                    
                                                    if (window.openProfileView && profView && profView.classList.contains('opacity-0')) {
                                                        const drvView = document.getElementById('driver-view');
                                                        const role = (drvView && !drvView.classList.contains('opacity-0') && !drvView.classList.contains('pointer-events-none')) ? 'driver' : 'passenger';
                                                        window.openProfileView(role);
                                                    }
                                                    setActiveTab('nav-profile');
                                                }
                                            }

                                            function closeMobileMap() {
                                                switchTab('nav-home');
                                            }

                                            function toggleBottomSearchBar() {
                                                const searchBar = document.getElementById('bottom-search-bar');
                                                const blogBar = document.getElementById('bottom-blog-bar');

                                                if (searchBar) {
                                                    if (searchBar.classList.contains('translate-y-[150%]')) {
                                                        setActiveTab('nav-search');
                                                        // Close blog bar if open
                                                        if (blogBar && !blogBar.classList.contains('translate-y-[150%]')) {
                                                            blogBar.classList.add('translate-y-[150%]', 'opacity-0');
                                                            blogBar.classList.remove('translate-y-0', 'opacity-100');
                                                        }

                                                        searchBar.classList.remove('translate-y-[150%]');
                                                        searchBar.classList.remove('opacity-0');
                                                        searchBar.classList.add('translate-y-0');
                                                        searchBar.classList.add('opacity-100');
                                                        document.getElementById('dynamic-island')?.classList.add('mobile-hidden');
                                                        
                                                        // Khởi tạo map trên mobile nếu chưa có
                                                        if (typeof initVietMapIfNeeded === 'function') {
                                                            initVietMapIfNeeded();
                                                        }
                                                        // Map thu nhỏ để không bị che bởi bottom sheet
                                                        document.getElementById('map')?.classList.remove('map-fullscreen');
                                                        
                                                        // Hiện nút định vị
                                                        document.getElementById('btn-locate-me')?.classList.remove('hidden');
                                                        document.getElementById('btn-locate-me')?.classList.add('flex');

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
                                                        setActiveTab('nav-home');
                                                        searchBar.classList.add('translate-y-[150%]');
                                                        searchBar.classList.add('opacity-0');
                                                        searchBar.classList.remove('translate-y-0');
                                                        searchBar.classList.remove('opacity-100');
                                                        document.getElementById('dynamic-island')?.classList.remove('mobile-hidden');
                                                        document.getElementById('map')?.classList.add('map-fullscreen');

                                                        // Ẩn nút định vị
                                                        document.getElementById('btn-locate-me')?.classList.add('hidden');
                                                        document.getElementById('btn-locate-me')?.classList.remove('flex');

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

                                            // OLD proposalsInterval removed
                                            let tripPanelOpen = false; // Reliable state flag

                                            function openTripProposalsPanel() {
                                                const panel = document.getElementById('trip-proposals-panel');
                                                if (!panel || tripPanelOpen) return;
                                                tripPanelOpen = true;
                                                panel.classList.add('panel-open');
                                                panel.style.visibility = 'visible';
                                                panel.style.transform = 'translateY(0)';
                                                panel.style.opacity = '1';
                                                panel.style.pointerEvents = 'auto';
                                                console.log('[TripProposals] Panel OPENED');
                                            }


                                            function closeTripProposalsPanel() {
                                                const panel = document.getElementById('trip-proposals-panel');
                                                if (!panel || !tripPanelOpen) return;
                                                tripPanelOpen = false;
                                                panel.classList.remove('panel-open');
                                                panel.style.transform = 'translateY(150%)';
                                                panel.style.opacity = '0';
                                                panel.style.pointerEvents = 'none';
                                                setTimeout(() => { 
                                                    if (!tripPanelOpen) {
                                                        panel.style.visibility = 'hidden'; 
                                                    }
                                                }, 500);
                                                console.log('[TripProposals] Panel CLOSED');
                                                if (proposalsInterval) clearInterval(proposalsInterval);
                                            }

                                            function toggleTripProposals() {
                                                const panel = document.getElementById('trip-proposals-panel');
                                                if (!panel) {
                                                    if (window.openAuthModal) {
                                                        window.openAuthModal();
                                                    } else {
                                                        showToast("Vui lòng đăng nhập để xem tính năng này!", "warning");
                                                    }
                                                    return;
                                                }

                                                console.log('[TripProposals] toggle called, panelOpen:', tripPanelOpen);
                                                if (!tripPanelOpen) {
                                                    // OPEN
                                                    openTripProposalsPanel();

                                                    // Close search/blog if open
                                                    const searchBar = document.getElementById('bottom-search-bar');
                                                    if (searchBar && !searchBar.className.includes('translate-y-[150%]')) {
                                                        searchBar.classList.add('translate-y-[150%]', 'opacity-0');
                                                        searchBar.classList.remove('translate-y-0', 'opacity-100');
                                                    }
                                                    const blogBar = document.getElementById('bottom-blog-bar');
                                                    if (blogBar && !blogBar.className.includes('translate-y-[150%]')) {
                                                        blogBar.classList.add('translate-y-[150%]', 'opacity-0');
                                                        blogBar.classList.remove('translate-y-0', 'opacity-100');
                                                    }

                                                    fetchTripProposals();
                                                } else {
                                                    // CLOSE
                                                    closeTripProposalsPanel();
                                                }
                                            }


                                            function fetchTripProposals() {
                                                const loadingEl = document.getElementById('proposals-loading');
                                                const emptyEl = document.getElementById('proposals-empty');
                                                const listEl = document.getElementById('proposals-list');

                                                if (loadingEl) loadingEl.classList.remove('hidden');
                                                if (emptyEl) emptyEl.classList.add('hidden');
                                                if (listEl) listEl.classList.add('hidden');

                                                let latQuery = "";
                                                if (typeof userLngLat !== 'undefined' && userLngLat && userLngLat.length === 2) {
                                                    latQuery = "?lng=" + userLngLat[0] + "&lat=" + userLngLat[1];
                                                }

                                                fetch('${pageContext.request.contextPath}/api/driver/proposals' + latQuery)
                                                    .then(res => res.json())
                                                    .then(data => {
                                                        if (loadingEl) loadingEl.classList.add('hidden');
                                                        const counterEl = document.getElementById('trip-proposals-counter');

                                                        if (data.success && data.trips && data.trips.length > 0) {
                                                            if (listEl) listEl.classList.remove('hidden');
                                                            window.currentProposals = data.trips;
                                                            renderTripProposals();
                                                            // Update UI counter
                                                            if (counterEl) counterEl.textContent = data.trips.length + " chuyến đang chờ";
                                                        } else {
                                                            window.currentProposals = [];
                                                            renderTripProposals();
                                                            if (emptyEl) emptyEl.classList.remove('hidden');
                                                            if (counterEl) counterEl.textContent = "0 chuyến đang chờ";
                                                        }
                                                    })
                                                    .catch(err => {
                                                        console.error(err);
                                                        if (loadingEl) loadingEl.classList.add('hidden');
                                                        if (emptyEl) emptyEl.classList.remove('hidden');
                                                        const counterEl = document.getElementById('trip-proposals-counter');
                                                        if (counterEl) counterEl.textContent = "0 chuyến đang chờ";
                                                    });
                                            }

                                            let upcomingTripsPanelOpen = false;
                                            function openUpcomingTripsPanel() {
                                                const panel = document.getElementById('upcoming-trips-panel');
                                                if (!panel || upcomingTripsPanelOpen) return;
                                                upcomingTripsPanelOpen = true;
                                                panel.style.visibility = 'visible';
                                                panel.style.transform = 'translateY(0)';
                                                panel.style.opacity = '1';
                                                panel.style.pointerEvents = 'auto';
                                                fetchUpcomingTrips();
                                            }

                                            function closeUpcomingTripsPanel() {
                                                const panel = document.getElementById('upcoming-trips-panel');
                                                if (!panel || !upcomingTripsPanelOpen) return;
                                                upcomingTripsPanelOpen = false;
                                                panel.style.transform = 'translateY(150%)';
                                                panel.style.opacity = '0';
                                                panel.style.pointerEvents = 'none';
                                                setTimeout(() => { 
                                                    if (!upcomingTripsPanelOpen) {
                                                        panel.style.visibility = 'hidden'; 
                                                    }
                                                }, 500);
                                            }

                                            function toggleUpcomingTripsPanel() {
                                                if (!upcomingTripsPanelOpen) {
                                                    openUpcomingTripsPanel();
                                                    // Close other panels
                                                    closeTripProposalsPanel();
                                                } else {
                                                    closeUpcomingTripsPanel();
                                                }
                                            }

                                            function fetchUpcomingTrips() {
                                                fetch('${pageContext.request.contextPath}/api/upcoming-trips')
                                                    .then(res => res.json())
                                                    .then(data => {
                                                        const counterEl = document.getElementById('mini-upcoming-trips-count');
                                                        const miniPopup = document.getElementById('mini-upcoming-trips-popup');
                                                        
                                                        if (data.success && data.trips && data.trips.length > 0) {
                                                            renderUpcomingTrips(data.trips, data.role);
                                                            if (data.role === 'passenger') {
                                                                if (counterEl) counterEl.textContent = data.trips.length + " chuyến chờ đi";
                                                                if (miniPopup) {
                                                                    miniPopup.classList.remove('translate-x-[150%]', 'opacity-0');
                                                                    miniPopup.classList.add('translate-x-0', 'opacity-100');
                                                                }
                                                            }
                                                        } else {
                                                            renderUpcomingTrips([], data.role);
                                                            if (data.role === 'passenger') {
                                                                if (counterEl) counterEl.textContent = "0 chuyến chờ đi";
                                                                if (miniPopup) {
                                                                    miniPopup.classList.add('translate-x-[150%]', 'opacity-0');
                                                                    miniPopup.classList.remove('translate-x-0', 'opacity-100');
                                                                }
                                                            }
                                                        }
                                                    })
                                                    .catch(err => console.error("Lỗi lấy danh sách lịch trình:", err));
                                            }

                                            function renderUpcomingTrips(trips, role) {
                                                const listId = role === 'driver' ? 'sidebar-upcoming-trips-list' : 'upcoming-trips-list';
                                                const emptyId = role === 'driver' ? 'sidebar-upcoming-trips-empty' : 'upcoming-trips-empty';
                                                
                                                const list = document.getElementById(listId);
                                                const empty = document.getElementById(emptyId);
                                                if (!list) return;

                                                const counterEl = document.getElementById('mini-upcoming-trips-counter');
                                                const miniPopup = document.getElementById('mini-upcoming-trips-popup');

                                                if (!trips || trips.length === 0) {
                                                    list.innerHTML = '';
                                                    list.classList.add('hidden');
                                                    list.classList.remove('flex');
                                                    if (empty) empty.classList.remove('hidden');
                                                    if (role === 'passenger') {
                                                        if (counterEl) counterEl.textContent = "0 chuyến chờ đi";
                                                        if (miniPopup) {
                                                            miniPopup.classList.add('translate-x-[150%]', 'opacity-0');
                                                            miniPopup.classList.remove('translate-x-0', 'opacity-100');
                                                        }
                                                    }
                                                    return;
                                                }

                                                if (empty) empty.classList.add('hidden');
                                                list.classList.remove('hidden');
                                                list.classList.add('flex');
                                                list.innerHTML = '';

                                                if (role === 'passenger') {
                                                    if (counterEl) counterEl.textContent = trips.length + " chuyến chờ đi";
                                                    if (miniPopup) {
                                                        miniPopup.classList.remove('translate-x-[150%]', 'opacity-0');
                                                        miniPopup.classList.add('translate-x-0', 'opacity-100');
                                                    }
                                                }

                                                if (empty) empty.classList.add('hidden');
                                                list.innerHTML = '';

                                                trips.forEach(trip => {
                                                    const formattedPrice = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(trip.price);
                                                    const formattedDate = trip.scheduledTime ? new Date(trip.scheduledTime).toLocaleString('vi-VN') : 'Không xác định';
                                                    const contactName = trip.passengerName || 'Chưa cập nhật';
                                                    const contactPhone = trip.passengerPhone || 'Chưa cập nhật';

                                                    let actionBtnHtml = '<div class="flex gap-2 mt-4">';
                                                    if (role === 'driver') {
                                                        actionBtnHtml += '<button onclick="startPreBookTrip(' + trip.id + ')" class="flex-1 bg-[#4CAF50] hover:bg-green-600 text-white font-bold py-2.5 rounded-xl transition-colors shadow-sm flex items-center justify-center gap-2">' +
                                                                        '<span class="material-symbols-outlined text-[18px]">play_arrow</span>Bắt đầu</button>';
                                                        actionBtnHtml += '<button onclick="cancelUpcomingTrip(' + trip.id + ', \'driver\')" class="flex-1 bg-red-100 hover:bg-red-200 text-red-600 font-bold py-2.5 rounded-xl transition-colors shadow-sm flex items-center justify-center gap-2">' +
                                                                        '<span class="material-symbols-outlined text-[18px]">cancel</span>Hủy chuyến</button>';
                                                    } else {
                                                        actionBtnHtml += '<button onclick="cancelUpcomingTrip(' + trip.id + ', \'passenger\')" class="w-full bg-red-100 hover:bg-red-200 text-red-600 font-bold py-2.5 rounded-xl transition-colors shadow-sm flex items-center justify-center gap-2">' +
                                                                        '<span class="material-symbols-outlined text-[18px]">cancel</span>Hủy chuyến</button>';
                                                    }
                                                    actionBtnHtml += '</div>';
                                                    if (role === 'passenger') {
                                                        actionBtnHtml += '<div class="mt-2 text-center text-sm text-slate-500 font-medium">Tài xế sẽ liên hệ bạn khi đến nơi</div>';
                                                    }

                                                    const html = '<div class="bg-white border border-slate-200 rounded-2xl p-4 shadow-sm hover:shadow-md transition-shadow flex flex-col gap-3">' +
                                                        '<div class="flex justify-between items-start">' +
                                                            '<div class="flex items-center gap-2 text-sm font-bold text-[#4CAF50] bg-green-50 px-3 py-1 rounded-lg">' +
                                                                '<span class="material-symbols-outlined text-[16px]">schedule</span>' + formattedDate +
                                                            '</div>' +
                                                            '<div class="text-right">' +
                                                                '<p class="text-lg font-black text-[#FF6D00] whitespace-nowrap">' + formattedPrice + '</p>' +
                                                            '</div>' +
                                                        '</div>' +
                                                        '<div class="flex flex-col gap-2 mt-2">' +
                                                            '<div class="flex items-start gap-2">' +
                                                                '<div class="w-2.5 h-2.5 rounded-full bg-[#6200EE] shrink-0 mt-1.5"></div>' +
                                                                '<p class="text-sm font-bold text-slate-800">' + trip.pickupLocation + '</p>' +
                                                            '</div>' +
                                                            '<div class="flex items-start gap-2">' +
                                                                '<span class="material-symbols-outlined text-[#FF6D00] text-[14px] shrink-0 mt-0.5">location_on</span>' +
                                                                '<p class="text-sm font-bold text-slate-800">' + trip.dropoffLocation + '</p>' +
                                                            '</div>' +
                                                        '</div>' +
                                                        '<div class="bg-slate-50 p-3 rounded-xl flex items-center gap-3 mt-1">' +
                                                            '<div class="w-10 h-10 bg-slate-200 rounded-full flex items-center justify-center shrink-0">' +
                                                                '<span class="material-symbols-outlined text-slate-500">person</span>' +
                                                            '</div>' +
                                                            '<div>' +
                                                                '<p class="text-xs font-semibold text-slate-500">Liên hệ (' + (role === 'driver' ? 'Khách hàng' : 'Tài xế') + ')</p>' +
                                                                '<p class="text-sm font-bold text-slate-800">' + contactName + ' - ' + contactPhone + '</p>' +
                                                            '</div>' +
                                                        '</div>' + actionBtnHtml +
                                                    '</div>';
                                                    list.insertAdjacentHTML('beforeend', html);
                                                });
                                            }

                                            function startPreBookTrip(tripId) {
                                                if (confirm('Bắt đầu chạy chuyến này? Khách hàng sẽ nhận được thông báo.')) {
                                                    fetch('${pageContext.request.contextPath}/api/driver/start-prebook-trip', {
                                                        method: 'POST',
                                                        headers: { 'Content-Type': 'application/json' },
                                                        body: JSON.stringify({ tripId: tripId })
                                                    })
                                                    .then(res => res.json())
                                                    .then(data => {
                                                        if (data.success) {
                                                            showToast(data.message, "success");
                                                            closeUpcomingTripsPanel();
                                                            // Refresh active trip status and upcoming trips
                                                            checkDriverTripStatus();
                                                            fetchUpcomingTrips();
                                                        } else {
                                                            showToast(data.message, "error");
                                                        }
                                                    })
                                                    .catch(err => {
                                                        console.error(err);
                                                        showToast("Lỗi hệ thống khi bắt đầu chuyến đi.", "error");
                                                    });
                                                }
                                            }

                                            function cancelUpcomingTrip(tripId, role) {
                                                let message = role === 'driver' ? 'Bạn có chắc chắn muốn hủy chuyến hẹn trước này? Khách hàng sẽ nhận được thông báo.' : 'Bạn có chắc chắn muốn hủy chuyến hẹn trước này?';
                                                if (confirm(message)) {
                                                    fetch('${pageContext.request.contextPath}/trip-cancel', {
                                                        method: 'POST',
                                                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                                        body: 'tripId=' + tripId
                                                    })
                                                    .then(res => res.json())
                                                    .then(data => {
                                                        if (data.success) {
                                                            showToast('Đã hủy chuyến.', "success");
                                                            fetchUpcomingTrips();
                                                            // Force refresh passenger status to clear form if passenger
                                                            if (typeof forceResetPassengerUI === 'function' && role === 'passenger') {
                                                                checkPassengerTripStatus();
                                                            }
                                                        } else {
                                                            showToast(data.error || 'Có lỗi xảy ra, vui lòng thử lại.', "error");
                                                        }
                                                    })
                                                    .catch(err => {
                                                        console.error(err);
                                                        showToast("Lỗi hệ thống khi hủy chuyến đi.", "error");
                                                    });
                                                }
                                            }

                                            let currentProposalTab = 'ON_DEMAND';

                                            function switchProposalTab(type) {
                                                currentProposalTab = type;
                                                const btnOnDemand = document.getElementById('tab-proposals-ondemand');
                                                const btnPreBook = document.getElementById('tab-proposals-prebook');
                                                if (type === 'ON_DEMAND') {
                                                    btnOnDemand.className = 'flex-1 py-2 text-sm font-bold rounded-md bg-white text-[#6200EE] shadow-sm transition-all';
                                                    btnPreBook.className = 'flex-1 py-2 text-sm font-bold rounded-md text-slate-500 hover:text-slate-800 transition-all';
                                                } else {
                                                    btnPreBook.className = 'flex-1 py-2 text-sm font-bold rounded-md bg-white text-[#6200EE] shadow-sm transition-all';
                                                    btnOnDemand.className = 'flex-1 py-2 text-sm font-bold rounded-md text-slate-500 hover:text-slate-800 transition-all';
                                                }
                                                renderTripProposals();
                                            }

                                            function renderTripProposals() {
                                                const list = document.getElementById('proposals-list');
                                                const counterEl = document.getElementById('trip-proposals-counter');
                                                if (!list) return;
                                                list.innerHTML = '';
                                                
                                                const allTrips = window.currentProposals || [];
                                                const trips = allTrips.filter(t => (t.tripType || 'ON_DEMAND') === currentProposalTab);
                                                
                                                if (counterEl) {
                                                    counterEl.textContent = trips.length + " chuyến đang chờ";
                                                }

                                                if (trips.length === 0) {
                                                    list.innerHTML = '<div class="flex flex-col items-center justify-center h-full gap-3 mt-10"><span class="material-symbols-outlined text-slate-300 text-5xl">inbox</span><p class="text-slate-500 font-medium">Không có chuyến ' + (currentProposalTab === 'ON_DEMAND' ? 'đặt ngay' : 'hẹn trước') + ' nào</p></div>';
                                                    return;
                                                }

                                                trips.forEach(trip => {
                                                    const formattedPrice = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(trip.price);
                                                    const note = trip.noteForDriver ? trip.noteForDriver : 'Không có lưu ý';

                                                    const html = '<div id="proposal-' + trip.id + '" class="bg-white border border-slate-200 rounded-2xl p-4 shadow-sm hover:shadow-md transition-shadow grid grid-cols-[55%_45%] gap-4 items-stretch">' +
                                                        '<!-- Left Column: Trip Info -->' +
                                                        '<div class="flex flex-col gap-3 pr-4 border-r border-slate-100 min-w-0">' +
                                                        '<div class="flex justify-between items-start min-w-0">' +
                                                        '<div class="flex-1 min-w-0">' +
                                                        '<div class="flex items-center gap-2 mb-1">' +
                                                        '<div class="w-2.5 h-2.5 rounded-full bg-[#6200EE] shrink-0"></div>' +
                                                        '<p class="text-sm font-bold text-slate-800 truncate" title="' + trip.pickupLocation + '">' + trip.pickupLocation + '</p>' +
                                                        '</div>' +
                                                        '<div class="w-0.5 h-3 bg-slate-200 ml-1 mb-1"></div>' +
                                                        '<div class="flex items-center gap-2">' +
                                                        '<span class="material-symbols-outlined text-[#FF6D00] text-[14px] shrink-0">location_on</span>' +
                                                        '<p class="text-sm font-bold text-slate-800 truncate" title="' + trip.dropoffLocation + '">' + trip.dropoffLocation + '</p>' +
                                                        '</div>' +
                                                        '</div>' +
                                                        '<div class="text-right shrink-0 ml-3">' +
                                                        '<p class="text-lg font-black text-[#FF6D00] whitespace-nowrap">' + formattedPrice + '</p>' +
                                                        '<p class="text-xs text-slate-500 font-medium whitespace-nowrap">' + trip.distance + ' km</p>' +
                                                        '</div>' +
                                                        '</div>' +
                                                        '<div class="flex items-center gap-2 bg-orange-50 rounded-lg p-2 mt-1 min-w-0">' +
                                                        '<span class="material-symbols-outlined text-[#FF6D00] text-[16px] shrink-0">info</span>' +
                                                        '<p class="text-xs text-slate-600 truncate">' + note + '</p>' +
                                                        '</div>' +
                                                        '<div class="flex mt-auto pt-2">' +
                                                        '<button id="accept-btn-' + trip.id + '" onclick="acceptTrip(' + trip.id + ')" class="w-full bg-slate-900 hover:bg-black text-white font-bold py-2.5 rounded-xl transition-colors shadow-sm flex items-center justify-center gap-2">' +
                                                        '<span class="material-symbols-outlined text-[18px]">done_outline</span>' +
                                                        'Nhận chuyến' +
                                                        '</button>' +
                                                        '</div>' +
                                                        '</div>' +
                                                        '<!-- Right Column: Passenger Info Placeholder -->' +
                                                        '<div class="flex flex-col items-center justify-center gap-3 bg-slate-50 rounded-xl p-4 border border-dashed border-slate-200 h-full">' +
                                                        '<span class="material-symbols-outlined text-slate-300 text-[40px]">person_off</span>' +
                                                        '<p class="text-sm font-medium text-slate-400 text-center leading-relaxed">Thông tin hành khách<br>sẽ hiển thị sau khi nhận chuyến</p>' +
                                                        '</div>' +
                                                        '</div>';
                                                    list.insertAdjacentHTML('beforeend', html);
                                                });
                                            }

                                            function acceptTrip(tripId) {
                                                if (window.showConfirmModal) {
                                                    window.showConfirmModal('Nhận chuyến', 'Bạn có chắc chắn muốn nhận chuyến này không?', function () {
                                                        executeAcceptTrip(tripId);
                                                    });
                                                } else {
                                                    if (confirm('Bạn có chắc chắn muốn nhận chuyến này không?')) {
                                                        executeAcceptTrip(tripId);
                                                    }
                                                }
                                            }


                                            function openDriverActiveTripPopup() {
                                                // Function deprecated, UI is now static in sidebar
                                            }

                                            function closeDriverActiveTripPopup() {
                                                // Function deprecated, UI is now static in sidebar
                                            }

                                            function startActiveTrip() {
                                                const doStart = () => {
                                                    fetch('${pageContext.request.contextPath}/api/driver/start-trip', {
                                                        method: 'POST',
                                                        headers: { 'Content-Type': 'application/json' },
                                                        body: JSON.stringify({ tripId: window.currentActiveTripId })
                                                    })
                                                    .then(res => res.json())
                                                    .then(data => {
                                                        if (data.success) {
                                                            showToast('Đã bắt đầu chuyến đi!', 'success');
                                                            checkDriverTripStatus();
                                                        } else {
                                                            showToast(data.message, 'error');
                                                        }
                                                    }).catch(err => console.error(err));
                                                };

                                                if (window.showConfirmModal) {
                                                    window.showConfirmModal('Bắt đầu chuyến đi', 'Xác nhận bắt đầu chuyến đi? Hành khách sẽ được thông báo.', doStart);
                                                } else {
                                                    if (confirm('Xác nhận bắt đầu chuyến đi? Hành khách sẽ được thông báo.')) {
                                                        doStart();
                                                    }
                                                }
                                            }

                                            function completeActiveTrip() {
                                                const doComplete = () => {
                                                    fetch('${pageContext.request.contextPath}/api/driver/complete-trip', {
                                                        method: 'POST',
                                                        headers: { 'Content-Type': 'application/json' },
                                                        body: JSON.stringify({ tripId: window.currentActiveTripId })
                                                    })
                                                    .then(res => res.json())
                                                    .then(data => {
                                                        if (data.success) {
                                                            showToast('Hoàn thành chuyến đi!', 'success');
                                                            checkDriverTripStatus();
                                                            // Hiển thị modal cho tài xế
                                                            const distEl = document.getElementById('sidebar-active-trip-distance');
                                                            const priceEl = document.getElementById('sidebar-active-trip-price');
                                                            const dist = distEl ? distEl.textContent.replace(' km','') : '0';
                                                            const priceStr = priceEl ? priceEl.textContent.replace('đ','').replace(/\./g,'').replace(/,/g,'') : '0';
                                                            openTripSummaryModal('Cuốc xe hoàn tất!', 'Bạn đã hoàn thành chuyến đi xuất sắc.', dist, parseInt(priceStr) || 0);
                                                        } else {
                                                            showToast(data.message, 'error');
                                                        }
                                                    }).catch(err => console.error(err));
                                                };

                                                if (window.showConfirmModal) {
                                                    window.showConfirmModal('Hoàn thành chuyến đi', 'Xác nhận hoàn thành chuyến đi?', doComplete);
                                                } else {
                                                    if (confirm('Xác nhận hoàn thành chuyến đi?')) {
                                                        doComplete();
                                                    }
                                                }
                                            }

                                            function cancelActiveTrip() {
                                                const modal = document.getElementById('driver-cancel-reason-modal');
                                                if(modal) {
                                                    modal.classList.remove('hidden');
                                                    modal.classList.add('flex');
                                                }
                                            }
                                            
                                            function submitDriverCancelTrip() {
                                                const reasonSelect = document.querySelector('input[name="cancel_reason"]:checked');
                                                if (!reasonSelect) {
                                                    if(window.showToast) window.showToast('Vui lòng chọn lý do hủy chuyến.', 'warning');
                                                    return;
                                                }
                                                const cancelReason = reasonSelect.value;

                                                const btn = document.getElementById('btn-submit-cancel-reason');
                                                if(btn) {
                                                    btn.disabled = true;
                                                    btn.innerHTML = 'Đang xử lý...';
                                                }

                                                fetch('${pageContext.request.contextPath}/api/driver/cancel-trip', {
                                                    method: 'POST',
                                                    headers: { 'Content-Type': 'application/json' },
                                                    body: JSON.stringify({ tripId: window.currentActiveTripId, cancelReason: cancelReason })
                                                })
                                                .then(res => res.json())
                                                .then(data => {
                                                    closeDriverCancelReasonModal();
                                                    if (data.success) {
                                                        if(window.showToast) window.showToast('Đã hủy chuyến đi.', 'info');
                                                        checkDriverTripStatus();
                                                        fetchUpcomingTrips();
                                                    } else {
                                                        if(window.showToast) window.showToast(data.message, 'error');
                                                    }
                                                }).catch(err => {
                                                    console.error(err);
                                                    closeDriverCancelReasonModal();
                                                });
                                            }

                                            function closeDriverCancelReasonModal() {
                                                const modal = document.getElementById('driver-cancel-reason-modal');
                                                if(modal) {
                                                    modal.classList.add('hidden');
                                                    modal.classList.remove('flex');
                                                }
                                                const btn = document.getElementById('btn-submit-cancel-reason');
                                                if (btn) {
                                                    btn.disabled = false;
                                                    btn.innerHTML = 'Xác nhận hủy chuyến';
                                                }
                                                // Reset radio buttons
                                                const radios = document.querySelectorAll('input[name="cancel_reason"]');
                                                radios.forEach(r => r.checked = false);
                                            }

                                            function executeAcceptTrip(tripId) {
                                                fetch('${pageContext.request.contextPath}/api/driver/accept-trip', {
                                                    method: 'POST',
                                                    headers: { 'Content-Type': 'application/json' },
                                                    body: JSON.stringify({ tripId: tripId })
                                                })
                                                    .then(res => res.json())
                                                    .then(data => {
                                                        if (data.success) {
                                                            showToast('Nhận chuyến thành công! Vui lòng liên hệ hành khách.', 'success');

                                                            // Auto close the trip proposals panel using proper state management
                                                            closeTripProposalsPanel();


                                                            const searchBar = document.getElementById('bottom-search-bar');
                                                            if (searchBar && !searchBar.classList.contains('translate-y-[150%]')) {
                                                                searchBar.classList.add('translate-y-[150%]');
                                                                searchBar.classList.add('opacity-0');
                                                                searchBar.classList.remove('translate-y-0');
                                                                searchBar.classList.remove('opacity-100');
                                                            }

                                                            const acceptedProposal = document.getElementById('proposal-' + tripId);
                                                            if (acceptedProposal) acceptedProposal.remove();
                                                            checkDriverTripStatus(); // Switch to active trip UI
                                                        } else {
                                                            showToast(data.message || 'Có lỗi xảy ra, vui lòng thử lại.', 'error');
                                                        }
                                                    })
                                                    .catch(err => {
                                                        console.error("Lỗi acceptTrip:", err);
                                                        showToast('Lỗi kết nối máy chủ.', 'error');
                                                    });
                                            }

                                            let driverStatusInterval = null;

                                            function startDriverStatusPolling() {
                                                if (driverStatusInterval) clearInterval(driverStatusInterval);
                                                checkDriverTripStatus();
                                                driverStatusInterval = setInterval(checkDriverTripStatus, 15000); // Fallback polling mỗi 15s
                                            }

                                            function stopDriverStatusPolling() {
                                                if (driverStatusInterval) clearInterval(driverStatusInterval);
                                                driverStatusInterval = null;
                                            }

                                            function checkDriverTripStatus() {
                                                fetch('${pageContext.request.contextPath}/api/driver/active-trip')
                                                    .then(res => res.json())
                                                    .then(data => {
                                                        const emptyTripUI = document.getElementById('sidebar-active-trip-empty');
                                                        const activeTripUI = document.getElementById('sidebar-active-trip-content');

                                                        if (data.active && data.trip) {
                                                            const trip = data.trip;
                                                            window.currentActiveTripId = trip.id;
                                                            
                                                            if (emptyTripUI) emptyTripUI.classList.add('hidden');
                                                            if (activeTripUI) {
                                                                activeTripUI.classList.remove('hidden');
                                                                activeTripUI.classList.add('flex');
                                                            }
                                                            
                                                            // Badge loại chuyến
                                                            const badgeEl = document.getElementById('sidebar-active-trip-type-badge');
                                                            if (badgeEl) {
                                                                badgeEl.classList.remove('hidden');
                                                                if (trip.tripType === 'PRE_BOOK') {
                                                                    badgeEl.textContent = 'Hẹn trước';
                                                                    badgeEl.className = 'px-2 py-0.5 text-[10px] font-bold rounded bg-orange-100 text-orange-600';
                                                                } else {
                                                                    badgeEl.textContent = 'Đặt ngay';
                                                                    badgeEl.className = 'px-2 py-0.5 text-[10px] font-bold rounded bg-slate-100 text-slate-600';
                                                                }
                                                            }
                                                            
                                                            // Nút hành động
                                                            const btnStart = document.getElementById('btn-sidebar-driver-start-trip');
                                                            const btnComplete = document.getElementById('btn-sidebar-driver-complete-trip');
                                                            const btnCancel = document.getElementById('btn-sidebar-driver-cancel-trip');
                                                            if (trip.completionStatus === 'IN_PROGRESS') {
                                                                if(btnStart) btnStart.classList.add('hidden');
                                                                if(btnCancel) btnCancel.classList.remove('hidden');
                                                                if(btnComplete) btnComplete.classList.remove('hidden');
                                                            } else {
                                                                if(btnStart) btnStart.classList.remove('hidden');
                                                                if(btnCancel) btnCancel.classList.remove('hidden');
                                                                if(btnComplete) btnComplete.classList.add('hidden');
                                                            }
                                                            
                                                            // Dữ liệu chuyến đi -> sidebar (SỬA: dùng sidebar-active-trip-* thay vì popup-active-trip-*)
                                                            const elPickup = document.getElementById('sidebar-active-trip-pickup');
                                                            if(elPickup) elPickup.textContent = trip.pickupLocation || 'N/A';
                                                            const elDropoff = document.getElementById('sidebar-active-trip-dropoff');
                                                            if(elDropoff) elDropoff.textContent = trip.dropoffLocation || 'N/A';
                                                            const elDistance = document.getElementById('sidebar-active-trip-distance');
                                                            if(elDistance) elDistance.textContent = (trip.distance || 0) + ' km';
                                                            const elPrice = document.getElementById('sidebar-active-trip-price');
                                                            if(elPrice) elPrice.textContent = new Intl.NumberFormat('vi-VN').format(trip.price || 0) + 'đ';
                                                            
                                                            // Thông tin hành khách
                                                            const elPassengerName = document.getElementById('sidebar-active-trip-passenger-name');
                                                            if(elPassengerName) elPassengerName.textContent = trip.passengerName || 'Khách hàng';
                                                            const elPassengerPhone = document.getElementById('sidebar-active-trip-passenger-phone');
                                                            if(elPassengerPhone) elPassengerPhone.textContent = trip.passengerPhone || '09xxxxxx';
                                                            
                                                            const elPassengerAvatar = document.getElementById('sidebar-active-trip-passenger-avatar');
                                                            if(elPassengerAvatar) {
                                                                elPassengerAvatar.src = (trip.passengerAvatar && trip.passengerAvatar.trim() !== '') 
                                                                    ? trip.passengerAvatar 
                                                                    : '${pageContext.request.contextPath}/img/default-avatar.svg';
                                                            }
                                                        } else {
                                                            // Không có chuyến đi -> hiện Empty State
                                                            window.currentActiveTripId = null;
                                                            if (emptyTripUI) emptyTripUI.classList.remove('hidden');
                                                            if (activeTripUI) {
                                                                activeTripUI.classList.add('hidden');
                                                                activeTripUI.classList.remove('flex');
                                                            }
                                                            // Reset badge
                                                            const badgeEl = document.getElementById('sidebar-active-trip-type-badge');
                                                            if (badgeEl) badgeEl.classList.add('hidden');
                                                        }
                                                        
                                                        // Always fetch proposals for the list
                                                        fetchTripProposals();
                                                    })
                                                    .catch(err => console.error("Lỗi checkDriverTripStatus:", err));
                                            }
                                            function toggleBottomBlogBar() {
                                                const searchBar = document.getElementById('bottom-search-bar');
                                                const blogBar = document.getElementById('bottom-blog-bar');
                                                if (blogBar) {
                                                    if (blogBar.classList.contains('translate-y-[150%]')) {
                                                        // Đang ẩn -> Mở lên
                                                        setActiveTab('nav-blog');
                                                        // Đóng search bar nếu đang mở
                                                        if (searchBar && !searchBar.classList.contains('translate-y-[150%]')) {
                                                            searchBar.classList.add('translate-y-[150%]', 'opacity-0');
                                                            searchBar.classList.remove('translate-y-0', 'opacity-100');
                                                        }

                                                        blogBar.classList.remove('translate-y-[150%]', 'opacity-0');
                                                        blogBar.classList.add('translate-y-0', 'opacity-100');
                                                        document.getElementById('dynamic-island')?.classList.add('mobile-hidden');

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
                                                        setActiveTab('nav-home');
                                                        blogBar.classList.add('translate-y-[150%]', 'opacity-0');
                                                        blogBar.classList.remove('translate-y-0', 'opacity-100');
                                                        document.getElementById('dynamic-island')?.classList.remove('mobile-hidden');

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
                                        </c:if>

                                            <!-- Locate Me Button (Hidden on Mobile Home Screen) -->
                                            <button onclick="recenterMap()" id="btn-locate-me"
                                                class="hidden md:flex absolute bottom-[55vh] md:bottom-8 right-4 md:right-8 z-20 w-10 h-10 md:w-14 md:h-14 bg-white text-slate-700 hover:text-[#6200EE] rounded-full shadow-lg md:shadow-[0_8px_20px_rgba(0,0,0,0.15)] items-center justify-center transition-all hover:scale-105 border border-slate-200"
                                                title="Vị trí của tôi">
                                                <span class="material-symbols-outlined text-[20px] md:text-[28px]">my_location</span>
                                            </button>

                                            <!-- Script to handle switching roles -->
                                            <script>
                                                const vietmapSearchApiKey = '663154c8a54428313795b6799a4e6dc463c0f678b38f7648';
                                                const vietmapMapApiKey = '7b895685ca3fbced0955461bcbbeb5b50cb8e5a2943fdc49';
                                                let map; // Global map instance
                                                const initialUserRole = '${not empty userRole ? userRole : "passenger"}';
                                                const hasVehicle = ${not empty hasVehicle ? hasVehicle : false};
                                                window.verificationStatus = '${not empty verificationStatus ? verificationStatus : ""}';
                                                let currentUserRole = 'passenger'; // default UI state is passenger
                                                window.userFullName = '${not empty fullName && fullName != "Người dùng" ? fullName : ""}';

                                                document.addEventListener('DOMContentLoaded', function () {
                                                    // Immediately request geolocation to update userLngLat without waiting for the map
                                                    if (navigator.geolocation) {
                                                        navigator.geolocation.getCurrentPosition(
                                                            (position) => {
                                                                userLngLat = [position.coords.longitude, position.coords.latitude];
                                                                console.log("Vị trí đã được cập nhật qua Geolocation:", userLngLat);
                                                                // If driver, fetch proposals immediately with the new location
                                                                if (currentUserRole === 'driver') {
                                                                    fetchTripProposals();
                                                                    fetchUpcomingTrips();
                                                                } else if (currentUserRole === 'passenger') {
                                                                    fetchUpcomingTrips();
                                                                }
                                                            },
                                                            (error) => {
                                                                console.error("Lỗi lấy vị trí ban đầu: ", error.message);
                                                            },
                                                            { enableHighAccuracy: true, timeout: 5000, maximumAge: 0 }
                                                        );
                                                    }

                                                    if (initialUserRole === 'driver') {
                                                        currentUserRole = 'driver';
                                                        setRole('driver', true);
                                                        startDriverStatusPolling();
                                                    } else {
                                                        currentUserRole = 'passenger';
                                                    }
                                                });

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

                                                function setRole(role, bypassConfirm = false) {
                                                    if (role === currentUserRole && !bypassConfirm) return;

                                                    if (role === 'driver' && (!hasVehicle || window.verificationStatus === 'REJECTED')) {
                                                        if (window.showConfirmModal) {
                                                            let modalTitle = 'Đăng ký Đối tác Tài xế';
                                                            let modalMsg = 'Bạn cần bổ sung thông tin phương tiện để có thể chuyển sang tab này. Bạn có muốn điền thông tin đăng ký ngay không?';

                                                            if (window.verificationStatus === 'REJECTED') {
                                                                modalTitle = 'Cập nhật lại Hồ sơ Đối tác';
                                                                modalMsg = 'Hồ sơ của bạn đã bị từ chối do không hợp lệ. Vui lòng điền lại thông tin và tải lên hình ảnh rõ nét, chính xác hơn để được phê duyệt.';
                                                            }

                                                            window.showConfirmModal(
                                                                modalTitle,
                                                                modalMsg,
                                                                function () {
                                                                    if (typeof window.openDriverUpgradeModal === 'function') {
                                                                        window.openDriverUpgradeModal();
                                                                    } else if (typeof window.openOnboardingModal === 'function') {
                                                                        window.openOnboardingModal();
                                                                    } else {
                                                                        const obModal = document.getElementById('onboardingModal');
                                                                        if (obModal) {
                                                                            obModal.classList.remove('hidden');
                                                                            if (typeof window.goToStep === 'function') {
                                                                                window.goToStep(1);
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            );
                                                        } else {
                                                            if (window.showToast) {
                                                                window.showToast('Vui lòng đăng ký thông tin tài xế!', 'warning');
                                                            } else {
                                                                alert('Vui lòng đăng ký thông tin tài xế!');
                                                            }
                                                        }
                                                        return; // Không chuyển tab
                                                    }

                                                    if (!bypassConfirm && role !== currentUserRole) {
                                                        if (window.showConfirmModal) {
                                                            window.showConfirmModal(
                                                                'Xác nhận chuyển đổi vai trò',
                                                                'CẢNH BÁO: Việc chuyển đổi vai trò sẽ khiến hệ thống HỦY toàn bộ chuyến xe bạn đang đặt (hoặc đang nhận). Bạn có chắc chắn muốn chuyển đổi?',
                                                                function () {
                                                                    // Gọi API để thực hiện chuyển đổi
                                                                    fetch('${pageContext.request.contextPath}/api/switch-role', {
                                                                        method: 'POST',
                                                                        headers: { 'Content-Type': 'application/json' },
                                                                        body: JSON.stringify({ newRole: role })
                                                                    })
                                                                        .then(res => {
                                                                            console.log("API Response status:", res.status);
                                                                            if (!res.ok) {
                                                                                throw new Error("HTTP error " + res.status);
                                                                            }
                                                                            return res.json();
                                                                        })
                                                                        .then(data => {
                                                                            if (data.success) {
                                                                                currentUserRole = role;
                                                                                setRole(role, true); // Gọi lại để đổi giao diện

                                                                                // Tải lại trang để xoá hẳn trạng thái rác và cập nhật db
                                                                                window.location.reload();
                                                                            } else {
                                                                                if (window.showToast) {
                                                                                    window.showToast(data.message || 'Lỗi khi chuyển đổi vai trò', 'error');
                                                                                } else {
                                                                                    alert(data.message || 'Lỗi khi chuyển đổi vai trò');
                                                                                }
                                                                            }
                                                                        })
                                                                        .catch(err => {
                                                                            console.error(err);
                                                                            if (window.showToast) {
                                                                                window.showToast('Lỗi kết nối mạng khi gọi API: ' + err.message, 'error');
                                                                            } else {
                                                                                alert('Lỗi kết nối mạng khi gọi API: ' + err.message);
                                                                            }
                                                                        });
                                                                }
                                                            );
                                                        }
                                                        return;
                                                    }

                                                    const toggleBg = document.getElementById('toggle-bg');
                                                    const btnPassenger = document.getElementById('btn-passenger');
                                                    const btnDriver = document.getElementById('btn-driver');

                                                    const passView = document.getElementById('passenger-view');
                                                    const drvView = document.getElementById('driver-view');

                                                    const markerPulse = document.getElementById('marker-pulse');
                                                    const markerDot = document.getElementById('marker-dot');

                                                    const navHome = document.getElementById('nav-home');

                                                    if (role === 'passenger') {
                                                        stopDriverStatusPolling();
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

                                                        // Update map marker colors (if marker exists)
                                                        if (window.userMarkerEl) {
                                                            const pulse = window.userMarkerEl.querySelector('.animate-ping');
                                                            const dot = window.userMarkerEl.querySelector('.shadow-xl');
                                                            if (pulse) pulse.className = 'absolute w-20 h-20 bg-[#6200EE]/30 rounded-full animate-ping';
                                                            if (dot) dot.className = 'relative w-8 h-8 bg-[#6200EE] border-[3px] border-white rounded-full shadow-xl';
                                                        }

                                                        // Update nav active color
                                                        navHome.classList.replace('text-[#FF6D00]', 'text-[#6200EE]');
                                                        navHome.classList.replace('bg-orange-50', 'bg-purple-50');

                                                    } else {
                                                        startDriverStatusPolling();
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

                                                function initVietMapIfNeeded() {
                                                    if (window.mapInstance) return;

                                                    // ==========================================
                                                    // VIETMAP INITIALIZATION & GEOLOCATION
                                                    // ==========================================

                                                    // ==========================================
                                                    
                                                    // Khởi tạo bản đồ Vietmap
                                                    map = new vietmapgl.Map({
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
                                                }

                                                // Only init map immediately on Desktop. On mobile, init lazily when searching trip.
                                                if (window.innerWidth >= 768) {
                                                    initVietMapIfNeeded();
                                                }

                                            </script>

                                            <!-- Auth Modal Include & Script -->
                                            <jsp:include page="includes/auth_modal.jsp" />
                                            <!-- Onboarding Modal -->
                                            <jsp:include page="includes/onboarding_modal.jsp" />

                                            <script>
                                                window.CONTEXT_PATH = '${pageContext.request.contextPath}';
                    <c:if test="${!isLoggedIn}">
                                                    // Auto-open modal if not logged in
                                                    document.addEventListener('DOMContentLoaded', () => {
                                                        setTimeout(() => {
                                                            if (window.openAuthModal) window.openAuthModal();
                                                        }, 500);
                                                    });
                    </c:if>

                                                    // Bind dynamic events after DOM content is loaded
                                                    document.addEventListener('DOMContentLoaded', function () {
                                                        window.openProfileView = function (role) {
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
                                                                backBtn.onclick = function () {
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
                                                                    setActiveTab('nav-home');
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
                                                            // Khôi phục loại phương tiện
                                                            const vt = tripData.ON_DEMAND.vehicleType;
                                                            if (vt) {
                                                                const r = document.querySelector('input[name="vehicleType"][value="' + vt + '"]');
                                                                if (r) r.checked = true;
                                                            }
                                                            // Khôi phục ghi chú cho tài xế
                                                            const ni = document.getElementById('note-input');
                                                            if (ni) ni.value = tripData.ON_DEMAND.note || '';
                                                        } else if (tripData.PRE_BOOK.active) {
                                                            // Xóa form nếu tab cũ có active trip
                                                            document.getElementById('pickup-input').value = "";
                                                            document.getElementById('dropoff-input').value = "";
                                                            const ni = document.getElementById('note-input');
                                                            if (ni) ni.value = '';
                                                        }

                                                        // Nút hành động căn cứ trạng thái thực tế
                                                        const btnSubmit = document.getElementById('btn-submit-search');
                                                        if (btnSubmit) {
                                                            if (isSearchingOnDemand) {
                                                                        if (tripData.ON_DEMAND.matchStatus === 'MATCHED' || tripData.ON_DEMAND.matchStatus === 'IN_PROGRESS') {
                                                                    // Đã ghép tài xế hoặc đang đi → vô hiệu hóa nút
                                                                    btnSubmit.type = 'button';
                                                                    
                                                                    if (tripData.ON_DEMAND.matchStatus === 'IN_PROGRESS') {
                                                                        btnSubmit.innerHTML = 'Đang trong chuyến đi <span class="material-symbols-outlined text-[20px]">directions_car</span>';
                                                                        btnSubmit.className = 'w-full bg-[#FF6D00] text-white font-bold py-3.5 rounded-full flex items-center justify-center gap-2 text-lg mt-auto cursor-not-allowed';
                                                                    } else {
                                                                        btnSubmit.innerHTML = 'Chuyến đi sắp bắt đầu <span class="material-symbols-outlined text-[20px]">check_circle</span>';
                                                                        btnSubmit.className = 'w-full bg-green-500 text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(34,197,94,0.3)] flex items-center justify-center gap-2 text-lg mt-auto cursor-not-allowed';
                                                                    }
                                                                    
                                                                    btnSubmit.disabled = true;
                                                                    btnSubmit.onclick = null;

                                                                    // Hiển thị thông tin tài xế nếu đã lưu
                                                                    const matchedState = document.getElementById('matched-driver-state');
                                                                    document.getElementById('empty-search-state').classList.add('hidden');
                                                                    document.getElementById('empty-search-state').classList.remove('flex');
                                                                    document.getElementById('loading-search-state').classList.add('hidden');
                                                                    document.getElementById('loading-search-state').classList.remove('flex');
                                                                    if (matchedState) {
                                                                        if (tripData.ON_DEMAND.driver) {
                                                                            document.getElementById('inline-driver-name').textContent = tripData.ON_DEMAND.driver.fullName || '';
                                                                            document.getElementById('inline-driver-phone').textContent = tripData.ON_DEMAND.driver.phoneNumber || '';
                                                                            document.getElementById('inline-driver-vehicle').textContent = (tripData.ON_DEMAND.driver.vehicleName || '') + " (" + (tripData.ON_DEMAND.driver.vehicleType || '') + ")";
                                                                            document.getElementById('inline-driver-plate').textContent = tripData.ON_DEMAND.driver.licensePlate || '';
                                                                            document.getElementById('inline-driver-hobbies').textContent = tripData.ON_DEMAND.driver.hobbies || 'Không có';
                                                                        }
                                                                        matchedState.classList.remove('hidden');
                                                                        matchedState.classList.add('flex');
                                                                    }
                                                                } else {
                                                                    // Đang tìm kiếm (PENDING) → nút đỏ hủy
                                                                    btnSubmit.type = 'button';
                                                                    btnSubmit.innerHTML = 'Hủy tìm kiếm <span class="material-symbols-outlined text-[20px]">cancel</span>';
                                                                    btnSubmit.className = 'w-full bg-red-500 hover:bg-red-600 text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                                                    btnSubmit.disabled = false;
                                                                    btnSubmit.onclick = cancelTripSearch;

                                                                    document.getElementById('empty-search-state').classList.add('hidden');
                                                                    document.getElementById('empty-search-state').classList.remove('flex');
                                                                    document.getElementById('loading-search-state').classList.remove('hidden');
                                                                    if (document.getElementById('matched-driver-state')) {
                                                                        document.getElementById('matched-driver-state').classList.add('hidden');
                                                                        document.getElementById('matched-driver-state').classList.remove('flex');
                                                                    }
                                                                    document.getElementById('loading-search-state').classList.add('flex');
                                                                }
                                                            } else {
                                                                // Không có chuyến ON_DEMAND → nút Tìm chuyến
                                                                btnSubmit.type = 'submit';
                                                                btnSubmit.innerHTML = 'Tìm chuyến <span class="material-symbols-outlined text-[20px]">arrow_forward</span>';
                                                                btnSubmit.className = 'w-full bg-slate-900 hover:bg-black text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                                                btnSubmit.onclick = null;
                                                                btnSubmit.disabled = false;

                                                                document.getElementById('loading-search-state').classList.add('hidden');
                                                                document.getElementById('loading-search-state').classList.remove('flex');
                                                                document.getElementById('empty-search-state').classList.remove('hidden');
                                                                if (document.getElementById('matched-driver-state')) {
                                                                    document.getElementById('matched-driver-state').classList.add('hidden');
                                                                    document.getElementById('matched-driver-state').classList.remove('flex');
                                                                }
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
                                                            // Khôi phục loại phương tiện
                                                            const vt = tripData.PRE_BOOK.vehicleType;
                                                            if (vt) {
                                                                const r = document.querySelector('input[name="vehicleType"][value="' + vt + '"]');
                                                                if (r) r.checked = true;
                                                            }
                                                            // Khôi phục ghi chú cho tài xế
                                                            const ni = document.getElementById('note-input');
                                                            if (ni) ni.value = tripData.PRE_BOOK.note || '';
                                                        } else if (tripData.ON_DEMAND.active) {
                                                            // Xóa form nếu tab cũ có active trip
                                                            document.getElementById('pickup-input').value = "";
                                                            document.getElementById('dropoff-input').value = "";
                                                            document.getElementById('trip-date').value = "";
                                                            document.getElementById('trip-time').value = "";
                                                            const ni = document.getElementById('note-input');
                                                            if (ni) ni.value = '';
                                                        }

                                                        // Nút hành động căn cứ trạng thái thực tế
                                                        const btnSubmit = document.getElementById('btn-submit-search');
                                                        if (btnSubmit) {
                                                            if (hasPreBookTrip) {
                                                                    if (tripData.PRE_BOOK.matchStatus === 'MATCHED' || tripData.PRE_BOOK.matchStatus === 'IN_PROGRESS') {
                                                                    // Đã ghép tài xế → nút xanh disabled
                                                                    btnSubmit.type = 'button';
                                                                    
                                                                    if (tripData.PRE_BOOK.matchStatus === 'IN_PROGRESS') {
                                                                        btnSubmit.innerHTML = 'Đang trong chuyến đi <span class="material-symbols-outlined text-[20px]">directions_car</span>';
                                                                        btnSubmit.className = 'w-full bg-[#FF6D00] text-white font-bold py-3.5 rounded-full flex items-center justify-center gap-2 text-lg mt-auto cursor-not-allowed';
                                                                    } else {
                                                                        btnSubmit.innerHTML = 'Chuyến đi sắp bắt đầu <span class="material-symbols-outlined text-[20px]">check_circle</span>';
                                                                        btnSubmit.className = 'w-full bg-green-500 text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(34,197,94,0.3)] flex items-center justify-center gap-2 text-lg mt-auto cursor-not-allowed';
                                                                    }
                                                                    
                                                                    btnSubmit.disabled = true;
                                                                    btnSubmit.onclick = null;

                                                                    // Hiển thị matched-driver-state
                                                                    const matchedState = document.getElementById('matched-driver-state');
                                                                    document.getElementById('empty-search-state').classList.add('hidden');
                                                                    document.getElementById('empty-search-state').classList.remove('flex');
                                                                    document.getElementById('loading-search-state').classList.add('hidden');
                                                                    document.getElementById('loading-search-state').classList.remove('flex');
                                                                    if (matchedState) {
                                                                        if (tripData.PRE_BOOK.driver) {
                                                                            document.getElementById('inline-driver-name').textContent = tripData.PRE_BOOK.driver.fullName || '';
                                                                            document.getElementById('inline-driver-phone').textContent = tripData.PRE_BOOK.driver.phoneNumber || '';
                                                                            document.getElementById('inline-driver-vehicle').textContent = (tripData.PRE_BOOK.driver.vehicleName || '') + " (" + (tripData.PRE_BOOK.driver.vehicleType || '') + ")";
                                                                            document.getElementById('inline-driver-plate').textContent = tripData.PRE_BOOK.driver.licensePlate || '';
                                                                            document.getElementById('inline-driver-hobbies').textContent = tripData.PRE_BOOK.driver.hobbies || 'Không có';
                                                                        }
                                                                        matchedState.classList.remove('hidden');
                                                                        matchedState.classList.add('flex');
                                                                    }
                                                                } else {
                                                                    // Đang chờ (PENDING) → nút cam hủy
                                                                    btnSubmit.type = 'button';
                                                                    btnSubmit.innerHTML = 'Hủy đặt lịch <span class="material-symbols-outlined text-[20px]">cancel</span>';
                                                                    btnSubmit.className = 'w-full bg-[#FF6D00] hover:bg-orange-600 text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                                                    btnSubmit.disabled = false;
                                                                    btnSubmit.onclick = cancelPreBookTrip;

                                                                    document.getElementById('empty-search-state').classList.add('hidden');
                                                                    document.getElementById('empty-search-state').classList.remove('flex');
                                                                    document.getElementById('loading-search-state').classList.remove('hidden');
                                                                    if (document.getElementById('matched-driver-state')) {
                                                                        document.getElementById('matched-driver-state').classList.add('hidden');
                                                                        document.getElementById('matched-driver-state').classList.remove('flex');
                                                                    }
                                                                    document.getElementById('loading-search-state').classList.add('flex');
                                                                }
                                                            } else {
                                                                // Không có chuyến PRE_BOOK → nút Tìm chuyến
                                                                btnSubmit.type = 'submit';
                                                                btnSubmit.innerHTML = 'Tìm chuyến <span class="material-symbols-outlined text-[20px]">arrow_forward</span>';
                                                                btnSubmit.className = 'w-full bg-slate-900 hover:bg-black text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                                                btnSubmit.onclick = null;
                                                                btnSubmit.disabled = false;

                                                                document.getElementById('loading-search-state').classList.add('hidden');
                                                                document.getElementById('loading-search-state').classList.remove('flex');
                                                                document.getElementById('empty-search-state').classList.remove('hidden');
                                                                if (document.getElementById('matched-driver-state')) {
                                                                    document.getElementById('matched-driver-state').classList.add('hidden');
                                                                    document.getElementById('matched-driver-state').classList.remove('flex');
                                                                }
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
                                                        if (inputId === 'pickup-input') {
                                                            document.getElementById('pickup-lat').value = '';
                                                            document.getElementById('pickup-lng').value = '';
                                                        } else if (inputId === 'dropoff-input') {
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

                                                    if (pLat && pLng && dLat && dLng) {
                                                        const priceBox = document.getElementById('price-estimation-box');
                                                        priceBox.classList.remove('hidden');
                                                        document.getElementById('price-value').textContent = "Đang tính...";
                                                        document.getElementById('distance-value').textContent = "Đang quét tuyến đường...";
                                                        document.getElementById('duration-value').textContent = "";

                                                        const contextPath = '${pageContext.request.contextPath}';
                                                        const vehicleType = document.querySelector('input[name="vehicleType"]:checked').value;
                                                        const tripType = document.getElementById('tripType') ? document.getElementById('tripType').value : 'ON_DEMAND';
                                                        const routeUrl = `\${contextPath}/api/price-estimate?pLat=\${pLat}&pLng=\${pLng}&dLat=\${dLat}&dLng=\${dLng}&vehicleType=\${vehicleType}&tripType=\${tripType}`;

                                                        fetch(routeUrl)
                                                            .then(res => res.json())
                                                            .then(data => {
                                                                if (data.success) {
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
                                                                    const isPrebook = tripType === 'PRE_BOOK';
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
                                                                                padding: { top: 50, bottom: 50, left: 50, right: 400 }, // Padding right để né cái panel
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
                                                src="${pageContext.request.contextPath}/assets/js/toast.js?v=${cacheVersion}"></script>
                                            <script
                                                src="${pageContext.request.contextPath}/assets/js/landingpage.js?v=${cacheVersion}"></script>

                                            <!-- Trip Proposals Panel (moved to body to avoid backdrop-blur stacking context) -->
                                    <div id="trip-proposals-panel"
                                        class="fixed bottom-0 left-0 right-0 md:bottom-8 md:left-[420px] md:right-8 z-40 bg-white/95 md:bg-white/90 backdrop-blur-xl border-t md:border border-white/60 shadow-[0_-10px_30px_rgba(0,0,0,0.1)] md:shadow-[0_30px_60px_rgba(0,0,0,0.15)] rounded-t-3xl md:rounded-3xl overflow-hidden transition-all duration-500 transform translate-y-[150%] opacity-0 flex flex-col w-auto h-[75vh] pointer-events-none pb-safe">

                                        <!-- Handle for dragging/closing -->
                                        <div class="w-full flex justify-center mb-2 cursor-pointer shrink-0 mt-4" onclick="toggleTripProposals()">
                                            <div class="w-16 h-1.5 bg-slate-300 rounded-full hover:bg-slate-400 transition-colors"></div>
                                        </div>

                                        <!-- Header -->
                                        <div class="p-6 pt-2 pb-4 shrink-0 border-b border-slate-200/50 flex flex-col gap-4 bg-white/40">
                                            <div class="flex justify-between items-center">
                                                <div>
                                                    <h3 class="text-xl font-bold text-slate-800 tracking-tight">
                                                        Chuyến đi dành cho bạn</h3>
                                                    <p class="text-[11px] font-semibold text-slate-500 mt-1 uppercase tracking-wider"
                                                        id="proposals-vehicle-info">Đang tải phương tiện...</p>
                                                </div>
                                                <button onclick="toggleTripProposals()"
                                                    class="w-10 h-10 rounded-full bg-white/80 hover:bg-white border border-slate-200 flex items-center justify-center shadow-sm transition-all text-slate-500 hover:text-slate-800">
                                                    <span class="material-symbols-outlined">close</span>
                                                </button>
                                            </div>
                                            <!-- Tabs -->
                                            <div class="flex gap-2 p-1 bg-slate-100 rounded-lg">
                                                <button onclick="switchProposalTab('ON_DEMAND')" id="tab-proposals-ondemand" class="flex-1 py-2 text-sm font-bold rounded-md bg-white text-[#6200EE] shadow-sm transition-all">Đặt ngay</button>
                                                <button onclick="switchProposalTab('PRE_BOOK')" id="tab-proposals-prebook" class="flex-1 py-2 text-sm font-bold rounded-md text-slate-500 hover:text-slate-800 transition-all">Hẹn trước</button>
                                            </div>
                                        </div>

                                        <!-- List -->
                                        <div id="proposals-list"
                                            class="flex-1 min-h-0 overflow-y-auto overscroll-contain panel-scroll p-4 pb-28 md:pb-4 space-y-4 bg-slate-50/50">
                                            <!-- Loading skeleton -->
                                            <div class="animate-pulse space-y-4">
                                                <div class="h-32 bg-slate-200 rounded-2xl w-full"></div>
                                                <div class="h-32 bg-slate-200 rounded-2xl w-full"></div>
                                            </div>
                                        </div>

                                    </div>

                                    <!-- Upcoming Trips Panel -->
                                    <div id="upcoming-trips-panel"
                                        class="fixed bottom-0 left-0 right-0 md:bottom-8 md:left-[420px] md:right-8 z-40 bg-white/95 md:bg-white/90 backdrop-blur-xl border-t md:border border-white/60 shadow-[0_-10px_30px_rgba(0,0,0,0.1)] md:shadow-[0_30px_60px_rgba(0,0,0,0.15)] rounded-t-3xl md:rounded-3xl overflow-hidden transition-all duration-500 transform translate-y-[150%] opacity-0 flex flex-col w-auto h-[75vh] pointer-events-none pb-safe">
                                        <div class="w-full flex justify-center mb-2 cursor-pointer shrink-0 mt-4" onclick="toggleUpcomingTripsPanel()">
                                            <div class="w-16 h-1.5 bg-slate-300 rounded-full hover:bg-slate-400 transition-colors"></div>
                                        </div>
                                        <div class="p-6 pt-2 pb-4 shrink-0 border-b border-slate-200/50 flex justify-between items-center bg-white/40">
                                            <div>
                                                <h3 class="text-xl font-bold text-slate-800 tracking-tight">
                                                    Lịch trình sắp tới</h3>
                                                <p class="text-[11px] font-semibold text-slate-500 mt-1 tracking-wider"
                                                    id="upcoming-trips-info">Danh sách chuyến xe đặt trước</p>
                                            </div>
                                            <button onclick="toggleUpcomingTripsPanel()"
                                                class="w-10 h-10 rounded-full bg-white/80 hover:bg-white border border-slate-200 flex items-center justify-center shadow-sm transition-all text-slate-500 hover:text-slate-800">
                                                <span class="material-symbols-outlined">close</span>
                                            </button>
                                        </div>
                                        <div id="upcoming-trips-list"
                                            class="flex-1 min-h-0 overflow-y-auto overscroll-contain panel-scroll p-4 pb-28 md:pb-4 space-y-4 bg-slate-50/50">
                                            <div id="upcoming-trips-empty" class="hidden flex flex-col items-center justify-center p-8 text-center">
                                                <span class="material-symbols-outlined text-slate-300 text-6xl mb-4">event_busy</span>
                                                <p class="text-slate-500 font-medium">Chưa có lịch trình nào sắp tới</p>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Driver Active Trip Popup (Removed - UI is now in sidebar) -->

                                    <!-- Driver Cancel Reason Modal -->
                                    <div id="driver-cancel-reason-modal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-[110] hidden items-center justify-center transition-all duration-300">
                                        <div class="bg-white rounded-3xl w-full max-w-[400px] p-6 shadow-2xl mx-4">
                                            <div class="flex justify-between items-center mb-6">
                                                <h3 class="text-xl font-bold text-slate-800">Lý do hủy chuyến</h3>
                                                <button onclick="closeDriverCancelReasonModal()" class="w-8 h-8 rounded-full bg-slate-100 flex items-center justify-center text-slate-500 hover:bg-slate-200">
                                                    <span class="material-symbols-outlined text-[20px]">close</span>
                                                </button>
                                            </div>
                                            
                                            <div class="space-y-3 mb-6">
                                                <label class="flex items-center gap-3 p-3 rounded-xl border border-slate-200 cursor-pointer hover:bg-slate-50 transition-colors">
                                                    <input type="radio" name="cancel_reason" value="Khách không xuất hiện" class="w-5 h-5 text-red-500 border-slate-300 focus:ring-red-500">
                                                    <span class="text-sm font-medium text-slate-700">Khách không xuất hiện</span>
                                                </label>
                                                <label class="flex items-center gap-3 p-3 rounded-xl border border-slate-200 cursor-pointer hover:bg-slate-50 transition-colors">
                                                    <input type="radio" name="cancel_reason" value="Không thể liên lạc được với khách" class="w-5 h-5 text-red-500 border-slate-300 focus:ring-red-500">
                                                    <span class="text-sm font-medium text-slate-700">Không liên lạc được với khách</span>
                                                </label>
                                                <label class="flex items-center gap-3 p-3 rounded-xl border border-slate-200 cursor-pointer hover:bg-slate-50 transition-colors">
                                                    <input type="radio" name="cancel_reason" value="Kẹt xe, không thể di chuyển" class="w-5 h-5 text-red-500 border-slate-300 focus:ring-red-500">
                                                    <span class="text-sm font-medium text-slate-700">Kẹt xe, không thể di chuyển</span>
                                                </label>
                                                <label class="flex items-center gap-3 p-3 rounded-xl border border-slate-200 cursor-pointer hover:bg-slate-50 transition-colors">
                                                    <input type="radio" name="cancel_reason" value="Xe gặp sự cố hỏng hóc" class="w-5 h-5 text-red-500 border-slate-300 focus:ring-red-500">
                                                    <span class="text-sm font-medium text-slate-700">Xe gặp sự cố hỏng hóc</span>
                                                </label>
                                                <label class="flex items-center gap-3 p-3 rounded-xl border border-slate-200 cursor-pointer hover:bg-slate-50 transition-colors">
                                                    <input type="radio" name="cancel_reason" value="Lý do khác" class="w-5 h-5 text-red-500 border-slate-300 focus:ring-red-500">
                                                    <span class="text-sm font-medium text-slate-700">Lý do khác</span>
                                                </label>
                                            </div>
                                            
                                            <button id="btn-submit-cancel-reason" onclick="submitDriverCancelTrip()" class="w-full bg-red-50 hover:bg-red-100 text-red-600 font-bold py-3.5 rounded-xl border border-red-200 transition-colors flex items-center justify-center gap-2">
                                                Xác nhận hủy chuyến
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Trip Summary Modal -->
                                    <div id="trip-summary-modal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-[100] hidden items-center justify-center opacity-0 transition-all duration-300">
                                        <div class="bg-white rounded-3xl w-full max-w-[400px] p-6 shadow-2xl transform scale-95 transition-all duration-300 mx-4">
                                            <div class="text-center mb-6">
                                                <div class="w-16 h-16 bg-green-100 text-green-500 rounded-full flex items-center justify-center mx-auto mb-4">
                                                    <span class="material-symbols-outlined text-3xl">check_circle</span>
                                                </div>
                                                <h3 class="text-2xl font-black text-slate-800" id="trip-summary-title">Chuyến đi hoàn tất!</h3>
                                                <p class="text-slate-500 mt-2 text-sm" id="trip-summary-subtitle">Cảm ơn bạn đã sử dụng dịch vụ.</p>
                                            </div>
                                            
                                            <div class="bg-slate-50 rounded-2xl p-4 mb-6 space-y-4 border border-slate-100">
                                                <div class="flex justify-between items-center pb-4 border-b border-slate-200">
                                                    <span class="text-slate-500 font-medium">Tổng quãng đường</span>
                                                    <span class="text-slate-800 font-bold" id="trip-summary-distance">0 km</span>
                                                </div>
                                                <div class="flex justify-between items-center pt-2">
                                                    <span class="text-slate-500 font-medium">Thanh toán (Tiền mặt)</span>
                                                    <span class="text-[#FF6D00] font-black text-xl" id="trip-summary-price">0đ</span>
                                                </div>
                                            </div>
                                            
                                            <button onclick="closeTripSummaryModal()" class="w-full bg-[#6200EE] hover:bg-[#5000c2] text-white font-bold py-3.5 rounded-xl transition-all shadow-[0_8px_20px_rgba(98,0,238,0.3)] text-lg">Đóng</button>
                                        </div>
                                    </div>
                                    <script>
                                    function openTripSummaryModal(title, subtitle, distance, price) {
                                        document.getElementById('trip-summary-title').textContent = title;
                                        document.getElementById('trip-summary-subtitle').textContent = subtitle;
                                        document.getElementById('trip-summary-distance').textContent = distance + ' km';
                                        document.getElementById('trip-summary-price').textContent = new Intl.NumberFormat('vi-VN').format(price) + 'đ';
                                        
                                        const modal = document.getElementById('trip-summary-modal');
                                        modal.classList.remove('hidden');
                                        modal.classList.add('flex');
                                        setTimeout(() => {
                                            modal.classList.remove('opacity-0');
                                            modal.firstElementChild.classList.remove('scale-95');
                                        }, 10);
                                    }
                                    function closeTripSummaryModal() {
                                        const modal = document.getElementById('trip-summary-modal');
                                        modal.classList.add('opacity-0');
                                        modal.firstElementChild.classList.add('scale-95');
                                        setTimeout(() => {
                                            modal.classList.remove('flex');
                                            modal.classList.add('hidden');
                                        }, 300);
                                    }
                                    </script>
                                </body>

                                </html>

