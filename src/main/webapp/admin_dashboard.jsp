<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - TransCake Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />

    <!-- jQuery FIRST (DataTables depends on it) -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <!-- DataTables CSS & JS -->
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <!-- Tailwind -->
    <script src="https://cdn.tailwindcss.com"></script>

    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f4f5f7; }
        .fiori-header { background-color: #0854a0; }
        .fiori-card {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05), 0 1px 4px 0 rgba(0, 0, 0, 0.08);
        }
        .kpi-title { font-size: 0.875rem; color: #64748b; font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; }
        .kpi-value { font-size: 1.875rem; color: #1e293b; font-weight: 700; margin-top: 0.25rem; }

        /* Custom DataTables styling to match Fiori */
        .dataTables_wrapper .dataTables_filter input {
            border: 1px solid #cbd5e1; border-radius: 4px; padding: 4px 8px; margin-left: 8px;
        }
        .dataTables_wrapper .dataTables_length select {
            border: 1px solid #cbd5e1; border-radius: 4px; padding: 4px;
        }
        table.dataTable.no-footer { border-bottom: 1px solid #e2e8f0; }
        table.dataTable thead th, table.dataTable thead td { border-bottom: 1px solid #e2e8f0; }
        .dataTables_wrapper .dataTables_paginate .paginate_button {
            padding: 4px 10px !important; margin: 0 2px; border-radius: 4px !important;
        }
        .dataTables_wrapper .dataTables_paginate .paginate_button.current {
            background: #3b82f6 !important; color: white !important; border-color: #3b82f6 !important;
        }
        .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
            background: #e2e8f0 !important; border-color: #e2e8f0 !important; color: #1e293b !important;
        }
    </style>
</head>
<body>

    <!-- Header -->
    <header class="fiori-header h-14 w-full flex items-center px-6 shadow-md fixed top-0 z-50">
        <div class="flex items-center gap-3">
            <a href="${pageContext.request.contextPath}/admintranscake" class="text-white hover:text-blue-200 material-symbols-outlined mr-2" title="Quay lại Launchpad">arrow_back</a>
            <span class="material-symbols-outlined text-white">bar_chart</span>
            <h1 class="text-white text-lg font-semibold tracking-wide">Dashboard Tổng Quan</h1>
        </div>
        <div class="ml-auto flex items-center gap-4">
            <span class="text-blue-100 text-sm">Xin chào, Admin</span>
            <a href="#" onclick="fetch('${pageContext.request.contextPath}/api/logout').then(() => window.location.href='${pageContext.request.contextPath}/'); return false;" class="text-white hover:text-blue-200 material-symbols-outlined" title="Đăng xuất">logout</a>
        </div>
    </header>

    <!-- Main Content -->
    <main class="pt-24 px-6 pb-12 max-w-7xl mx-auto space-y-6">

        <!-- Filter Form -->
        <div class="fiori-card p-4">
            <form action="${pageContext.request.contextPath}/admin/dashboard" method="GET" class="flex flex-wrap items-end gap-4 w-full">
                <div>
                    <label class="block text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">Từ ngày</label>
                    <input type="date" name="startDate" value="${startDate}" class="border border-slate-300 rounded px-3 py-2 text-sm text-slate-700 outline-none focus:border-blue-500">
                </div>
                <div>
                    <label class="block text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">Đến ngày</label>
                    <input type="date" name="endDate" value="${endDate}" class="border border-slate-300 rounded px-3 py-2 text-sm text-slate-700 outline-none focus:border-blue-500">
                </div>
                <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-6 rounded text-sm transition-colors">
                    Lọc dữ liệu
                </button>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="text-blue-600 text-sm font-medium hover:underline py-2">Xóa bộ lọc (Toàn thời gian)</a>
            </form>
        </div>

        <!-- Row 1: KPI Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <!-- Total Users -->
            <div class="fiori-card p-5 border-t-4 border-blue-500">
                <div class="flex justify-between items-start">
                    <div>
                        <h3 class="kpi-title">Tổng Người Dùng</h3>
                        <p class="kpi-value"><fmt:formatNumber value="${stats.totalUsers}" pattern="#,###" /></p>
                    </div>
                    <div class="p-2 bg-blue-50 rounded-lg text-blue-500">
                        <span class="material-symbols-outlined">group</span>
                    </div>
                </div>
                <div class="mt-4 text-sm text-slate-500 flex gap-2">
                    <span>${stats.totalPassengers} Khách</span> &bull;
                    <span>${stats.totalDrivers} Tài xế</span>
                </div>
            </div>

            <!-- Total Trips -->
            <div class="fiori-card p-5 border-t-4 border-indigo-500">
                <div class="flex justify-between items-start">
                    <div>
                        <h3 class="kpi-title">Tổng Chuyến Đi</h3>
                        <p class="kpi-value"><fmt:formatNumber value="${stats.totalTrips}" pattern="#,###" /></p>
                    </div>
                    <div class="p-2 bg-indigo-50 rounded-lg text-indigo-500">
                        <span class="material-symbols-outlined">route</span>
                    </div>
                </div>
                <div class="mt-4 text-sm text-slate-500 flex gap-4">
                    <span><span class="font-medium text-slate-700">${stats.completedTrips}</span> hoàn thành</span>
                    <span><span class="font-medium text-slate-700">${stats.inProgressTrips}</span> đang chạy</span>
                </div>
            </div>

            <!-- Revenue -->
            <div class="fiori-card p-5 border-t-4 border-emerald-500">
                <div class="flex justify-between items-start">
                    <div>
                        <h3 class="kpi-title">Tổng Doanh Thu</h3>
                        <p class="kpi-value text-emerald-600"><fmt:formatNumber value="${stats.totalRevenue}" pattern="#,###" /> ₫</p>
                    </div>
                    <div class="p-2 bg-emerald-50 rounded-lg text-emerald-500">
                        <span class="material-symbols-outlined">payments</span>
                    </div>
                </div>
                <div class="mt-4 text-sm text-slate-500">
                    TB: <span class="font-medium text-slate-700"><fmt:formatNumber value="${stats.avgTripPrice}" pattern="#,###" /> ₫/chuyến</span>
                    &bull; <span class="font-medium text-slate-700"><fmt:formatNumber value="${stats.totalDistance}" pattern="#,###.#" /> km</span>
                </div>
            </div>

            <!-- Pending Drivers -->
            <div class="fiori-card p-5 border-t-4 border-amber-500">
                <div class="flex justify-between items-start">
                    <div>
                        <h3 class="kpi-title">Hồ Sơ Chờ Duyệt</h3>
                        <p class="kpi-value"><fmt:formatNumber value="${stats.pendingDriverApps}" pattern="#,###" /></p>
                    </div>
                    <div class="p-2 bg-amber-50 rounded-lg text-amber-500">
                        <span class="material-symbols-outlined">pending_actions</span>
                    </div>
                </div>
                <div class="mt-4 text-sm text-slate-500">
                    <a href="${pageContext.request.contextPath}/admin/drivers" class="text-blue-600 hover:underline font-medium">Tới trang Duyệt tài xế →</a>
                </div>
            </div>
        </div>

        <!-- Row 2: Charts -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Revenue Chart -->
            <div class="fiori-card p-5 lg:col-span-2">
                <h3 class="text-lg font-semibold text-slate-800 mb-4">Biểu đồ Doanh thu</h3>
                <div class="relative h-[300px] w-full">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>

            <!-- SEO Hobbies Chart -->
            <div class="fiori-card p-5">
                <h3 class="text-lg font-semibold text-slate-800 mb-4">Phân tích Sở thích (SEO)</h3>
                <div class="relative h-[250px] w-full flex justify-center">
                    <canvas id="hobbiesChart"></canvas>
                </div>
                <div class="mt-4 text-center">
                    <p class="text-sm text-slate-500">Gợi ý target quảng cáo dựa trên hồ sơ User.</p>
                </div>
            </div>
        </div>

        <!-- Row 3: All Users Table -->
        <div class="fiori-card p-5">
            <h3 class="text-lg font-semibold text-slate-800 mb-4">Quản lý Toàn bộ Người dùng</h3>
            <div class="w-full overflow-x-auto">
                <table id="usersTable" class="display" style="width:100%">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Người Dùng</th>
                            <th>SĐT</th>
                            <th>Email</th>
                            <th>Vai Trò</th>
                            <th>Trạng Thái</th>
                            <th>Ngày Tạo</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${stats.allUsers}" var="usr">
                            <tr>
                                <td><c:out value="${usr.id}" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty usr.fullName}"><c:out value="${usr.fullName}" /></c:when>
                                        <c:otherwise>Chưa cập nhật</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><c:out value="${usr.phoneNumber}" /></td>
                                <td><c:out value="${usr.email}" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${usr.role == 'driver'}">Tài xế</c:when>
                                        <c:when test="${usr.role == 'passenger'}">Khách</c:when>
                                        <c:when test="${usr.role == 'admin'}">Admin</c:when>
                                        <c:otherwise>Mới</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${usr.status == 'ACTIVE'}">Hoạt động</c:when>
                                        <c:when test="${usr.status == 'REQUIRE_RESET'}">Chưa đổi MK</c:when>
                                        <c:otherwise><c:out value="${usr.status}" /></c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${usr.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Row 4: All Trips Table -->
        <div class="fiori-card p-5">
            <h3 class="text-lg font-semibold text-slate-800 mb-4">Quản lý Toàn bộ Chuyến đi</h3>
            <div class="w-full overflow-x-auto">
                <table id="tripsTable" class="display" style="width:100%">
                    <thead>
                        <tr>
                            <th>Mã</th>
                            <th>Khách Hàng</th>
                            <th>Điểm đón</th>
                            <th>Điểm trả</th>
                            <th>Giá</th>
                            <th>Trạng Thái</th>
                            <th>Ngày Đặt</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${stats.allTrips}" var="trip">
                            <tr>
                                <td><c:out value="${trip.id}" /></td>
                                <td><c:out value="${trip.passengerName}" /></td>
                                <td><c:out value="${trip.pickupLocation}" /></td>
                                <td><c:out value="${trip.dropoffLocation}" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty trip.price}">
                                            <fmt:formatNumber value="${trip.price}" pattern="#,###" />đ
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${trip.completionStatus == 'COMPLETED'}">Đã xong</c:when>
                                        <c:when test="${trip.matchStatus == 'CANCELLED'}">Đã hủy</c:when>
                                        <c:when test="${trip.completionStatus == 'IN_PROGRESS'}">Đang chạy</c:when>
                                        <c:otherwise>Đang chờ</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${trip.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- Scripts -->
    <script>
        $(document).ready(function() {
            // ============ DataTables ============
            var vnLang = {
                "sProcessing":   "Đang xử lý...",
                "sLengthMenu":   "Xem _MENU_ mục",
                "sZeroRecords":  "Không tìm thấy dòng nào phù hợp",
                "sInfo":         "Đang xem _START_ đến _END_ trong tổng số _TOTAL_ mục",
                "sInfoEmpty":    "Đang xem 0 đến 0 trong tổng số 0 mục",
                "sInfoFiltered": "(được lọc từ _MAX_ mục)",
                "sSearch":       "Tìm kiếm:",
                "oPaginate": {
                    "sFirst":    "Đầu",
                    "sPrevious": "Trước",
                    "sNext":     "Tiếp",
                    "sLast":     "Cuối"
                }
            };

            $('#usersTable').DataTable({
                language: vnLang,
                order: [[ 0, "desc" ]],
                pageLength: 10,
                lengthMenu: [10, 25, 50, 100]
            });

            $('#tripsTable').DataTable({
                language: vnLang,
                order: [[ 0, "desc" ]],
                pageLength: 10,
                lengthMenu: [10, 25, 50, 100]
            });

            // ============ Revenue Bar Chart ============
            var revLabels = [];
            var revData = [];
            <c:forEach items="${stats.dailyRevenue}" var="day">
            revLabels.push("${day.label}");
            revData.push(${day.amount});
            </c:forEach>

            if (document.getElementById('revenueChart')) {
                new Chart(document.getElementById('revenueChart').getContext('2d'), {
                    type: 'bar',
                    data: {
                        labels: revLabels,
                        datasets: [{
                            label: 'Doanh thu (VNĐ)',
                            data: revData,
                            backgroundColor: '#3b82f6',
                            borderRadius: 4,
                            barThickness: 'flex',
                            maxBarThickness: 40
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { display: false },
                            tooltip: {
                                callbacks: {
                                    label: function(ctx) { return ctx.raw.toLocaleString('vi-VN') + ' đ'; }
                                }
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: { borderDash: [4, 4], color: '#f1f5f9' },
                                ticks: {
                                    callback: function(v) {
                                        if(v >= 1000000) return (v / 1000000) + 'M';
                                        if(v >= 1000) return (v / 1000) + 'k';
                                        return v;
                                    }
                                }
                            },
                            x: { grid: { display: false }, ticks: { maxRotation: 45, minRotation: 0 } }
                        }
                    }
                });
            }

            // ============ Hobbies Pie Chart ============
            var hobLabels = [];
            var hobData = [];
            <c:forEach items="${stats.hobbiesStats}" var="entry">
            hobLabels.push("${entry.key}");
            hobData.push(${entry.value});
            </c:forEach>

            var hobColors = ['#f43f5e','#ec4899','#d946ef','#a855f7','#8b5cf6','#6366f1','#3b82f6','#0ea5e9','#06b6d4','#14b8a6','#10b981','#22c55e','#84cc16','#eab308','#f59e0b','#f97316'];

            if (document.getElementById('hobbiesChart')) {
                new Chart(document.getElementById('hobbiesChart').getContext('2d'), {
                    type: 'pie',
                    data: {
                        labels: hobLabels.length > 0 ? hobLabels : ['Chưa có dữ liệu'],
                        datasets: [{
                            data: hobData.length > 0 ? hobData : [1],
                            backgroundColor: hobData.length > 0 ? hobColors.slice(0, hobData.length) : ['#cbd5e1'],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { position: 'right', labels: { boxWidth: 12, font: {size: 10} } }
                        }
                    }
                });
            }
        });
    </script>
</body>
</html>
