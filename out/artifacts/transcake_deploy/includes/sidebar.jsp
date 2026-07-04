<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
            <div onclick="window.openHistoryView && window.openHistoryView()"
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

            <!-- Driver Posted Trips -->
            <div onclick="toggleBottomDriverTripsBar()"
                class="bg-white/70 hover:bg-white p-4 rounded-xl border border-slate-200/60 shadow-sm cursor-pointer transition-colors flex items-center gap-4 group">
                <div
                    class="w-10 h-10 rounded-full bg-orange-50 flex items-center justify-center text-[#FF6D00] relative group-hover:scale-110 transition-transform">
                    <span class="material-symbols-outlined">directions_car</span>
                </div>
                <div class="flex-1">
                    <h4 class="font-bold text-slate-800 text-sm">Chuyến đi ghép từ tài xế</h4>
                    <p class="text-xs text-slate-500 font-medium">Tìm chuyến xe tiện chuyến, giá rẻ</p>
                </div>
                <span
                    class="material-symbols-outlined text-slate-400 group-hover:text-slate-600 transition-colors">chevron_right</span>
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
                <button onclick="toggleBottomPostTripBar()"
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
                        <div onclick="window.openEarningsView && window.openEarningsView()"
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
                                <h4 class="font-bold text-slate-800 text-xs">Ví
                                    tài xế</h4>
                                <p
                                    class="text-[13px] font-black text-emerald-600 mt-0.5">
                                    Xem chi tiết →</p>
                            </div>
                        </div>
                    </div>

                    <!-- Driver Posted Trips Management -->
                    <div onclick="toggleBottomDriverTripsBar()"
                        class="bg-white/70 hover:bg-white p-4 rounded-xl border border-slate-200/60 shadow-sm cursor-pointer transition-colors flex flex-col justify-between min-h-[100px] group mb-3">
                        <span class="material-symbols-outlined text-slate-400 group-hover:text-blue-500 transition-colors mb-2">list_alt</span>
                        <div>
                            <h4 class="font-bold text-slate-800 text-xs">Quản lý chuyến đi đã đăng</h4>
                            <p class="text-[13px] font-medium text-slate-500 mt-0.5">Xem các chuyến đang chờ khách</p>
                        </div>
                    </div>

                    <!-- Driver History -->
                    <div onclick="window.openHistoryView && window.openHistoryView()"
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

                    <!-- Chuyến đi hiện tại Section -->
                    <div class="mt-4 pt-4 border-t border-slate-200/60">
                        <div class="flex items-center justify-between mb-3">
                            <h4 class="font-bold text-slate-800 text-sm flex items-center gap-2">
                                <span class="material-symbols-outlined text-blue-600 text-lg">navigation</span>
                                Chuyến đi hiện tại
                            </h4>
                            <span id="sidebar-active-trip-type-badge" class="hidden px-2 py-0.5 text-[10px] font-bold rounded bg-slate-100 text-slate-600">Đặt ngay</span>
                        </div>
                        
                        <!-- Empty State -->
                        <div id="sidebar-active-trip-empty" class="bg-white/70 p-4 rounded-xl border border-slate-200/60 flex flex-col items-center justify-center text-center">
                            <span class="material-symbols-outlined text-slate-300 text-3xl mb-2">location_off</span>
                            <p class="text-xs font-medium text-slate-500">Hiện không có chuyến xe nào đang chạy.</p>
                        </div>

                        <!-- Active State -->
                        <div id="sidebar-active-trip-content" class="hidden bg-white/70 p-4 rounded-xl border border-slate-200/60 flex flex-col gap-3">
                            <div class="flex items-center gap-3 border-b border-slate-100 pb-2">
                                <div class="w-10 h-10 rounded-full bg-slate-200 flex items-center justify-center overflow-hidden shrink-0">
                                    <img id="sidebar-active-trip-passenger-avatar" src="${pageContext.request.contextPath}/img/default-avatar.svg" alt="Avatar" class="w-full h-full object-cover">
                                </div>
                                <div class="flex-1 min-w-0">
                                    <h5 class="font-bold text-sm text-slate-800 truncate" id="sidebar-active-trip-passenger-name">Tên khách hàng</h5>
                                    <p class="text-xs text-slate-500 font-medium truncate" id="sidebar-active-trip-passenger-phone">Số điện thoại</p>
                                </div>
                                <div class="text-right shrink-0">
                                    <p class="text-xs font-bold text-[#FF6D00]" id="sidebar-active-trip-price">0đ</p>
                                    <p class="text-[10px] font-medium text-slate-500" id="sidebar-active-trip-distance">0 km</p>
                                </div>
                            </div>
                            <div class="flex flex-col gap-2 relative">
                                <div class="absolute left-1.5 top-3 bottom-3 w-px bg-slate-200"></div>
                                <div class="flex items-start gap-2 relative z-10">
                                    <div class="w-3 h-3 rounded-full bg-[#6200EE] mt-0.5 shrink-0 shadow-[0_0_0_2px_white]"></div>
                                    <div class="flex-1 min-w-0">
                                        <p class="text-[10px] font-bold text-slate-500 uppercase leading-none">Điểm đón</p>
                                        <p class="text-xs font-semibold text-slate-800 truncate" id="sidebar-active-trip-pickup">Địa chỉ đón</p>
                                    </div>
                                </div>
                                <div class="flex items-start gap-2 relative z-10 mt-1">
                                    <div class="w-3 h-3 rounded-full bg-[#FF6D00] mt-0.5 shrink-0 shadow-[0_0_0_2px_white]"></div>
                                    <div class="flex-1 min-w-0">
                                        <p class="text-[10px] font-bold text-slate-500 uppercase leading-none">Điểm đến</p>
                                        <p class="text-xs font-semibold text-slate-800 truncate" id="sidebar-active-trip-dropoff">Địa chỉ đến</p>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-1 flex gap-2" id="sidebar-driver-trip-actions">
                                <button id="btn-sidebar-driver-start-trip" onclick="startActiveTrip()" class="flex-1 bg-green-500 hover:bg-green-600 text-white font-bold py-2 rounded-lg text-xs shadow-sm transition-colors flex justify-center items-center gap-1"><span class="material-symbols-outlined text-[14px]">play_arrow</span> Bắt đầu</button>
                                <button id="btn-sidebar-driver-complete-trip" onclick="completeActiveTrip()" class="flex-1 bg-[#6200EE] hover:bg-[#5000c2] text-white font-bold py-2 rounded-lg text-xs shadow-sm transition-colors hidden flex justify-center items-center gap-1"><span class="material-symbols-outlined text-[14px]">check</span> Hoàn thành</button>
                                <button id="btn-sidebar-driver-cancel-trip" onclick="cancelActiveTrip()" class="flex-1 bg-red-50 hover:bg-red-100 text-red-600 font-bold py-2 rounded-lg text-xs border border-red-200 transition-colors flex justify-center items-center gap-1"><span class="material-symbols-outlined text-[14px]">close</span> Hủy</button>
                            </div>
                        </div>
                    </div>

                    <!-- Lịch trình sắp tới Section -->
                    <div class="mt-4 pt-4 border-t border-slate-200/60">
                        <div class="flex items-center justify-between mb-3">
                            <h4 class="font-bold text-slate-800 text-sm flex items-center gap-2">
                                <span class="material-symbols-outlined text-orange-500 text-lg">calendar_month</span>
                                Lịch trình sắp tới
                            </h4>
                        </div>
                        
                        <!-- Empty State -->
                        <div id="sidebar-upcoming-trips-empty" class="bg-white/70 p-4 rounded-xl border border-slate-200/60 flex flex-col items-center justify-center text-center">
                            <span class="material-symbols-outlined text-slate-300 text-3xl mb-2">event_busy</span>
                            <p class="text-xs font-medium text-slate-500">Chưa có lịch trình nào sắp tới.</p>
                        </div>

                        <!-- Active State (List) -->
                        <div id="sidebar-upcoming-trips-list" class="hidden flex-col gap-3 max-h-[300px] overflow-y-auto panel-scroll pr-1">
                            <!-- JS will inject upcoming trips here -->
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
                class="w-9 h-9 rounded-full bg-white hover:bg-slate-100 border border-slate-200 flex items-center justify-center shadow-sm transition-all cursor-pointer relative z-50">
                <span
                    class="material-symbols-outlined text-slate-600 text-lg">arrow_back</span>
            </button>
            <h3
                class="flex-1 text-center font-bold text-base text-slate-800 -ml-9">
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

    <div id="sidebar-earnings-view"
        class="transition-all duration-300 opacity-0 translate-x-10 absolute inset-0 pointer-events-none flex flex-col bg-gradient-to-b from-slate-50 to-white z-20">

        <!-- Fixed Header -->
        <div class="flex-none w-full flex items-center p-4 pb-2 bg-slate-50/90 backdrop-blur-md z-30 border-b border-transparent">
            <button id="btn-back-from-earnings" onclick="window.closeEarningsView && window.closeEarningsView()"
                class="w-9 h-9 rounded-full bg-white hover:bg-slate-100 border border-slate-200 flex items-center justify-center shadow-sm transition-all cursor-pointer relative z-50">
                <span class="material-symbols-outlined text-slate-600 text-lg">arrow_back</span>
            </button>
            <h3 class="flex-1 text-center font-bold text-base text-slate-800 -ml-9">Ví tài xế</h3>
        </div>

        <div class="flex-1 overflow-y-auto panel-scroll w-full px-4 pb-32 pt-2">
            <!-- Hero: Total Balance Card -->
            <div class="w-full bg-gradient-to-br from-emerald-500 via-emerald-600 to-teal-700 rounded-3xl p-5 shadow-[0_8px_30px_rgba(16,185,129,0.35)] text-white mb-5 relative overflow-hidden">
                <div class="absolute top-0 right-0 w-40 h-40 bg-white opacity-[0.07] rounded-full -mr-14 -mt-14"></div>
                <div class="absolute bottom-0 left-0 w-28 h-28 bg-white opacity-[0.05] rounded-full -ml-10 -mb-10"></div>

                <div class="relative z-10">
                    <p class="text-emerald-100 text-[11px] font-semibold uppercase tracking-widest mb-1">Tổng số dư</p>
                    <div class="flex items-baseline gap-1">
                        <h2 id="earnings-total-hero" class="text-[32px] font-black tracking-tight leading-none">0</h2>
                        <span class="text-lg font-bold text-emerald-200">đ</span>
                    </div>
                    <div class="mt-3 flex items-center gap-1.5">
                        <span id="earnings-total-trips-badge"
                            class="bg-white/20 backdrop-blur-sm text-white text-[10px] font-bold px-2.5 py-1 rounded-full">
                            0 chuyến hoàn thành
                        </span>
                    </div>
                </div>

                <!-- 7-Day Chart (real data from API) -->
                <div class="relative z-10 mt-5">
                    <div id="earnings-chart-bars" class="h-16 flex items-end gap-1.5 w-full">
                        <!-- 7 bars injected via JS -->
                    </div>
                    <div id="earnings-chart-labels" class="flex justify-between mt-1.5 w-full text-[9px] text-emerald-200 font-bold">
                        <!-- 7 day labels injected via JS -->
                    </div>
                </div>
            </div>

            <!-- Stats Grid: 3 columns -->
            <div class="w-full grid grid-cols-3 gap-3 mb-5">
                <!-- Hôm nay -->
                <div class="bg-white rounded-2xl p-3.5 shadow-sm border border-slate-100 flex flex-col">
                    <div class="flex items-center gap-1 mb-2">
                        <div class="w-6 h-6 bg-amber-50 rounded-lg flex items-center justify-center">
                            <span class="material-symbols-outlined text-amber-500 text-sm">today</span>
                        </div>
                    </div>
                    <p class="text-[10px] text-slate-400 font-semibold uppercase tracking-wide">Hôm nay</p>
                    <h4 id="earnings-today" class="text-sm font-black text-slate-800 mt-0.5">0đ</h4>
                    <p id="earnings-today-trips" class="text-[9px] text-slate-400 mt-1">0 chuyến</p>
                </div>
                <!-- Tuần này -->
                <div class="bg-white rounded-2xl p-3.5 shadow-sm border border-slate-100 flex flex-col">
                    <div class="flex items-center gap-1 mb-2">
                        <div class="w-6 h-6 bg-blue-50 rounded-lg flex items-center justify-center">
                            <span class="material-symbols-outlined text-blue-500 text-sm">date_range</span>
                        </div>
                    </div>
                    <p class="text-[10px] text-slate-400 font-semibold uppercase tracking-wide">Tuần này</p>
                    <h4 id="earnings-week" class="text-sm font-black text-slate-800 mt-0.5">0đ</h4>
                    <p id="earnings-week-trips" class="text-[9px] text-slate-400 mt-1">0 chuyến</p>
                </div>
                <!-- Tháng này -->
                <div class="bg-white rounded-2xl p-3.5 shadow-sm border border-slate-100 flex flex-col">
                    <div class="flex items-center gap-1 mb-2">
                        <div class="w-6 h-6 bg-purple-50 rounded-lg flex items-center justify-center">
                            <span class="material-symbols-outlined text-purple-500 text-sm">calendar_month</span>
                        </div>
                    </div>
                    <p class="text-[10px] text-slate-400 font-semibold uppercase tracking-wide">Tháng này</p>
                    <h4 id="earnings-month" class="text-sm font-black text-slate-800 mt-0.5">0đ</h4>
                    <p id="earnings-month-trips" class="text-[9px] text-slate-400 mt-1">0 chuyến</p>
                </div>
            </div>

            <!-- Transaction History -->
            <div class="w-full">
                <div class="flex items-center justify-between mb-3">
                    <h4 class="font-bold text-slate-800 text-sm flex items-center gap-2">
                        <span class="material-symbols-outlined text-emerald-500 text-lg">receipt_long</span>
                        Lịch sử giao dịch
                    </h4>
                    <span id="earnings-history-count" class="text-[10px] text-slate-400 font-semibold bg-slate-100 px-2 py-0.5 rounded-full">0 giao dịch</span>
                </div>

                <div id="earnings-recent-trips-list" class="flex flex-col gap-0">
                    <!-- Loading state -->
                    <div class="flex items-center justify-center py-10 text-slate-400">
                        <span class="material-symbols-outlined animate-spin mr-2 text-lg">sync</span>
                        <span class="text-xs">Đang tải dữ liệu...</span>
                    </div>
                </div>
            </div>
        </div>
        </div>
    
    <!-- STATE 5: HISTORY VIEW -->
    <div id="sidebar-history-view"
        class="transition-all duration-300 opacity-0 translate-x-10 absolute inset-0 pointer-events-none flex flex-col bg-gradient-to-b from-slate-50 to-white z-40">
        
        <!-- Fixed Header -->
        <div class="flex-none w-full flex items-center p-4 pb-2 bg-slate-50/90 backdrop-blur-md z-30 border-b border-transparent">
            <button id="btn-back-from-history" onclick="window.closeHistoryView && window.closeHistoryView()"
                class="w-9 h-9 rounded-full bg-white hover:bg-slate-100 border border-slate-200 flex items-center justify-center shadow-sm transition-all cursor-pointer relative z-50">
                <span class="material-symbols-outlined text-slate-600 text-lg">arrow_back</span>
            </button>
            <h3 class="flex-1 text-center font-bold text-base text-slate-800 -ml-9">Lịch sử chuyến đi</h3>
        </div>

        <div class="flex-1 overflow-y-auto panel-scroll w-full p-4 pt-2 flex flex-col gap-4 pb-24">
            <!-- Loading state -->
            <div id="sidebar-history-loading" class="flex flex-col items-center justify-center py-12 text-slate-400">
                <span class="material-symbols-outlined animate-spin text-3xl mb-2">sync</span>
                <p class="text-xs font-semibold">Đang tải lịch sử...</p>
            </div>

            <!-- Empty state -->
            <div id="sidebar-history-empty" class="hidden text-center py-12">
                <span class="material-symbols-outlined text-4xl text-slate-200 mb-2">history</span>
                <p class="text-xs text-slate-400 font-semibold">Chưa có chuyến đi nào</p>
                <p class="text-[10px] text-slate-300 mt-1">Hoàn thành chuyến đi đầu tiên để xem lịch sử</p>
            </div>

            <!-- Stats Dashboard -->
            <div id="sidebar-history-stats" class="w-full hidden mb-1 flex-col gap-3">
                <div class="grid grid-cols-2 gap-3">
                    <div class="bg-[#6200EE]/5 rounded-2xl p-3 flex flex-col justify-center items-center border border-[#6200EE]/10 shadow-sm">
                        <span class="text-[10px] font-bold text-[#6200EE] uppercase tracking-wider">Hoàn thành</span>
                        <span id="history-stat-completed" class="text-2xl font-black text-[#6200EE] mt-1">0</span>
                    </div>
                    <div class="bg-red-500/5 rounded-2xl p-3 flex flex-col justify-center items-center border border-red-500/10 shadow-sm">
                        <span class="text-[10px] font-bold text-red-600 uppercase tracking-wider">Đã hủy</span>
                        <span id="history-stat-cancelled" class="text-2xl font-black text-red-600 mt-1">0</span>
                    </div>
                </div>
                <!-- Spent for passenger only -->
                <div id="history-stat-spent-container" class="hidden bg-emerald-500/5 rounded-2xl p-3 flex flex-col justify-center items-center border border-emerald-500/10 shadow-sm">
                    <span class="text-[10px] font-bold text-emerald-600 uppercase tracking-wider">Tổng chi phí</span>
                    <span id="history-stat-spent" class="text-2xl font-black text-emerald-600 mt-1">0đ</span>
                </div>
            </div>

            <!-- Data List -->
            <div id="sidebar-history-list" class="w-full flex flex-col hidden">
                <!-- JS will inject trips here -->
            </div>
        </div>
    </div>

</div>


