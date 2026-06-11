<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
                <c:choose>
                    <c:when test="${isLoggedIn}">
                        <h3 class="font-bold text-lg text-slate-900 leading-tight">
                            <c:out value="${fullName}" />
                        </h3>
                        <div class="flex flex-col mt-1.5">
                            <div class="flex items-center justify-between mb-1.5">
                                <span
                                    class="text-[10px] font-bold text-[#6200EE] uppercase tracking-wider bg-purple-100 border border-purple-200 px-2 py-0.5 rounded-md">Điểm
                                    uy tín: 10</span>
                            </div>
                            <div
                                class="w-2/3 bg-purple-100 rounded-full h-1.5 overflow-hidden">
                                <div class="bg-[#6200EE] h-full rounded-full"
                                    style="width: 100%"></div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="flex flex-col justify-center h-full gap-1">
                            <button
                                onclick="window.openAuthModal && window.openAuthModal()"
                                class="w-fit px-4 py-1.5 bg-[#6200EE] hover:bg-[#5000C8] text-white font-bold rounded-lg shadow-sm transition-colors text-sm">Đăng
                                nhập</button>
                            <p class="text-[11px] text-slate-500">để sử dụng đầy
                                đủ tính năng</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Primary CTA & Search Form -->
        <div class="mb-8 relative">
            <button onclick="${isLoggedIn ? 'toggleBottomSearchBar()' : 'window.openAuthModal && window.openAuthModal()'}"
                        class="w-full bg-gradient-to-r from-[#6200EE]
                        to-[#8C3AFF]
                        hover:from-[#5000C8] hover:to-[#7A26F0] text-white
                        font-bold text-lg py-4
                        rounded-2xl shadow-[0_10px_25px_rgba(98,0,238,0.35)]
                        transition-all
                        transform hover:-translate-y-1
                        hover:shadow-[0_15px_30px_rgba(98,0,238,0.4)]
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
                    <h4 class="font-bold text-slate-800 text-sm">Lịch sử chuyến
                        đi</h4>
                    <p class="text-xs text-slate-500 font-medium">Xem lịch sử
                        chuyến đi</p>
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
                    <h4 class="font-bold text-slate-800 text-sm">Kết nối cộng
                        đồng</h4>
                    <p class="text-xs text-slate-500 font-medium">Kết nối với
                        cộng đồng của bạn</p>
                </div>
                <span
                    class="material-symbols-outlined text-slate-400 group-hover:text-slate-600 transition-colors">chevron_right</span>
            </div>

            <!-- Desktop Extension: Vibe Filters -->
            <div class="mt-6 pt-6 border-t border-slate-200/60">
                <div class="flex items-center justify-between mb-3.5">
                    <h4 class="font-bold text-slate-800 text-sm">Vibe Filters
                    </h4>
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
                <c:choose>
                    <c:when test="${isLoggedIn}">
                        <h3 class="font-bold text-lg text-slate-900 leading-tight">
                            <c:out value="${fullName}" />
                        </h3>
                        <div class="flex flex-col mt-1.5">
                            <div class="flex items-center justify-between">
                                <span
                                    class="text-[10px] font-bold text-[#FF6D00] uppercase tracking-wider bg-orange-100 border border-orange-200 px-2 py-0.5 rounded-md">Điểm
                                    uy tín: 10</span>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="flex flex-col justify-center h-full gap-1">
                            <button
                                onclick="window.openAuthModal && window.openAuthModal()"
                                class="w-fit px-4 py-1.5 bg-[#FF6D00] hover:bg-[#E66200] text-white font-bold rounded-lg shadow-sm transition-colors text-sm">Đăng
                                nhập</button>
                            <p class="text-[11px] text-slate-500">để sử dụng đầy
                                đủ tính năng</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <c:choose>
            <c:when test="${isLoggedIn && verificationStatus == 'PENDING'}">
                <!-- Pending Verification State -->
                <div
                    class="bg-orange-50 border border-orange-200 rounded-2xl p-5 mb-8 flex flex-col items-center text-center">
                    <div
                        class="w-12 h-12 bg-orange-100 rounded-full flex items-center justify-center mb-3">
                        <span
                            class="material-symbols-outlined text-orange-500 text-2xl">hourglass_empty</span>
                    </div>
                    <h4 class="font-bold text-orange-800 text-base mb-1">Tài khoản
                        đang chờ duyệt</h4>
                    <p class="text-sm text-orange-600">Thông tin xe của bạn đang
                        được hệ thống kiểm duyệt. Quá trình này có thể mất tới 24h.
                    </p>
                </div>
            </c:when>
            <c:otherwise>
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
                        <div onclick="toggleTripProposals()"
                            class="bg-white/70 hover:bg-white p-4 rounded-xl border border-slate-200/60 shadow-sm cursor-pointer transition-colors flex flex-col justify-between min-h-[100px] group">
                            <span
                                class="material-symbols-outlined text-slate-400 group-hover:text-red-500 transition-colors mb-2">person_add</span>
                            <div>
                                <h4 class="font-bold text-slate-800 text-xs">Đề
                                    xuất chuyến đi</h4>
                                <p id="trip-proposals-counter"
                                    class="text-[13px] font-black text-red-500 mt-0.5">
                                    Đang tải...</p>
                            </div>
                        </div>
                        <!-- Card 2: Earnings -->
                        <div
                            class="bg-white/70 hover:bg-white p-4 rounded-xl border border-slate-200/60 shadow-sm cursor-pointer transition-colors flex flex-col justify-between min-h-[100px] relative overflow-hidden group">
                            <!-- Mini line chart background -->
                            <svg class="absolute bottom-0 left-0 w-full h-12 opacity-20"
                                viewBox="0 0 100 40" preserveAspectRatio="none">
                                <path
                                    d="M0,40 L0,30 L20,35 L40,15 L60,25 L80,5 L100,20 L100,40 Z"
                                    fill="#10B981" />
                                <path
                                    d="M0,30 L20,35 L40,15 L60,25 L80,5 L100,20"
                                    fill="none" stroke="#10B981"
                                    stroke-width="2" />
                            </svg>
                            <span
                                class="material-symbols-outlined text-slate-400 group-hover:text-emerald-500 transition-colors mb-2 relative z-10">account_balance_wallet</span>
                            <div class="relative z-10">
                                <h4 class="font-bold text-slate-800 text-xs">Thu
                                    nhập</h4>
                                <p
                                    class="text-[13px] font-black text-emerald-600 mt-0.5">
                                    800.000đ/wk</p>
                            </div>
                        </div>
                    </div>

                    <!-- Driver History -->
                    <div
                        class="bg-white/70 hover:bg-white p-4 rounded-xl border border-slate-200/60 shadow-sm cursor-pointer transition-colors flex items-center gap-4 mt-1 group">
                        <div
                            class="w-10 h-10 rounded-full bg-orange-50 flex items-center justify-center text-[#FF6D00] group-hover:scale-110 transition-transform">
                            <span
                                class="material-symbols-outlined">directions_car</span>
                        </div>
                        <div class="flex-1">
                            <h4 class="font-bold text-slate-800 text-sm">Lịch sử
                                chuyến đi</h4>
                            <p class="text-xs text-slate-500 font-medium">Xem
                                lịch sử chuyến đi</p>
                        </div>
                        <span
                            class="material-symbols-outlined text-slate-400 group-hover:text-slate-600 transition-colors">chevron_right</span>
                    </div>

                    <!-- Driver Active Trip Shortcut -->
                    <div id="sidebar-driver-active-trip"
                        onclick="openDriverActiveTripPopup()"
                        class="bg-white/70 hover:bg-white p-4 rounded-xl border border-slate-200/60 shadow-sm cursor-pointer transition-colors flex items-center gap-4 mt-1 group hidden">
                        <div
                            class="w-10 h-10 rounded-full bg-blue-50 flex items-center justify-center text-blue-600 group-hover:scale-110 transition-transform">
                            <span
                                class="material-symbols-outlined">navigation</span>
                        </div>
                        <div class="flex-1">
                            <h4 class="font-bold text-slate-800 text-sm">Chuyến đi
                                hiện tại</h4>
                            <p class="text-xs text-slate-500 font-medium">Đang diễn ra</p>
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
                                    <span
                                        class="material-symbols-outlined text-sm">map</span>
                                </div>
                                <div>
                                    <h4
                                        class="font-bold text-slate-800 text-sm">
                                        Heatmap Overlay</h4>
                                    <p
                                        class="text-[10px] text-slate-500 font-medium">
                                        Show high-demand areas
                                    </p>
                                </div>
                            </div>
                            <!-- Toggle switch -->
                            <label
                                class="relative inline-flex items-center cursor-pointer">
                                <input type="checkbox" value=""
                                    class="sr-only peer">
                                <div
                                    class="w-9 h-5 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-[#FF6D00]">
                                </div>
                            </label>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- STATE 3: PROFILE VIEW -->
    <div id="sidebar-profile-view"
        class="transition-all duration-300 opacity-0 translate-x-10 absolute inset-x-0 top-0 p-6 pb-24 pointer-events-none flex flex-col items-center justify-start min-h-[400px]">

        <div class="w-full flex items-center mb-8">
            <button id="btn-back-from-profile"
                class="w-10 h-10 rounded-full bg-white hover:bg-slate-100 border border-slate-200 flex items-center justify-center shadow-sm transition-all relative z-10 cursor-pointer">
                <span
                    class="material-symbols-outlined text-slate-600">arrow_back</span>
            </button>
            <h3
                class="flex-1 text-center font-bold text-lg text-slate-800 -ml-10">
                Hồ sơ cá nhân</h3>
        </div>

        <div class="flex flex-col items-center mb-8">
            <div
                class="w-24 h-24 text-slate-400 bg-slate-100 rounded-full border-[4px] border-white shadow-lg flex items-center justify-center mb-4 relative">
                <span
                    class="material-symbols-outlined text-[48px]">person</span>
            </div>
            <h3 class="font-bold text-xl text-slate-900 leading-tight mb-1">
                <c:out value="${not empty fullName ? fullName : 'Khách'}" />
            </h3>
            <p class="text-sm text-slate-500">
                <c:out value="${isLoggedIn ? 'Thành viên Transcake' : 'Chưa đăng nhập'}" />
            </p>
        </div>

        <c:if test="${isLoggedIn}">
            <div
                class="w-full space-y-3 px-4 mt-auto pt-8 border-t border-slate-200/50">
                <!-- Other functions can be added here later -->
                <button id="profile-logout-btn" onclick="handleProfileLogout()"
                    class="w-full bg-red-50 hover:bg-red-100 text-red-600 font-bold text-sm py-3 rounded-xl border border-red-200 shadow-sm transition-all flex items-center justify-center gap-2 cursor-pointer relative z-50">
                    <span
                        class="material-symbols-outlined text-[18px]">logout</span>
                    Đăng xuất
                </button>
                <script>
                    function handleProfileLogout() {
                        if (window.showConfirmModal) {
                            window.showConfirmModal('Đăng xuất', 'Bạn có chắc chắn muốn đăng xuất không? Bạn sẽ cần đăng nhập lại để tiếp tục sử dụng.', function () {
                                var ctx = window.CONTEXT_PATH || '';
                                var btn = document.getElementById('profile-logout-btn');
                                if (btn) { btn.innerHTML = '<span class="material-symbols-outlined text-[18px] animate-spin">sync</span> Đang xử lý...'; }

                                fetch(ctx + '/api/logout', { method: 'POST' })
                                    .then(function (r) { return r.json(); })
                                    .then(function (d) {
                                        if (d.success) {
                                            if (window.showToast) window.showToast(d.message || 'Đăng xuất thành công!', 'success');
                                            setTimeout(function () { window.location.href = ctx + '/dashboard'; }, 1000);
                                        } else {
                                            if (window.showToast) window.showToast(d.message || 'Đăng xuất thất bại', 'error');
                                            if (btn) { btn.innerHTML = '<span class="material-symbols-outlined text-[18px]">logout</span> Đăng xuất'; }
                                        }
                                    })
                                    .catch(function () {
                                        if (window.showToast) window.showToast('Lỗi kết nối, đang chuyển hướng...', 'error');
                                        setTimeout(function () { window.location.href = ctx + '/dashboard'; }, 1500);
                                    });
                            });
                        } else {
                            alert('Lỗi: Không tìm thấy hàm showConfirmModal!');
                        }
                    }
                </script>
            </div>
        </c:if>
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
            id="nav-profile"
            onclick="window.openProfileView(document.getElementById('passenger-view').classList.contains('opacity-0') ? 'driver' : 'passenger')">
            <span class="material-symbols-outlined">person</span>
        </button>
    </div>
</div>
