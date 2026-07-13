<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Launchpad - TransCake</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f4f5f7; }
        /* SAP Fiori Inspired Shadows and Cards */
        .fiori-header { background-color: #0854a0; }
        .fiori-tile {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05), 0 1px 4px 0 rgba(0, 0, 0, 0.08);
            transition: all 0.2s ease-in-out;
            cursor: pointer;
            display: block;
        }
        .fiori-tile:hover {
            box-shadow: 0 2px 8px 0 rgba(0, 0, 0, 0.1), 0 4px 16px 0 rgba(0, 0, 0, 0.08);
            transform: translateY(-2px);
        }
        .tile-icon {
            color: #0854a0;
        }
    </style>
</head>
<body>

    <!-- Header -->
    <header class="fiori-header h-14 w-full flex items-center px-6 shadow-md fixed top-0 z-50">
        <div class="flex items-center gap-3">
            <span class="material-symbols-outlined text-white">grid_view</span>
            <h1 class="text-white text-lg font-semibold tracking-wide">TransCake Launchpad</h1>
        </div>
        <div class="ml-auto flex items-center gap-4">
            <span class="text-blue-100 text-sm">Xin chào, Admin</span>
            <a href="#" onclick="fetch('${pageContext.request.contextPath}/api/logout').then(() => window.location.href='${pageContext.request.contextPath}/'); return false;" class="text-white hover:text-blue-200 material-symbols-outlined" title="Đăng xuất">logout</a>
        </div>
    </header>

    <!-- Main Content -->
    <main class="pt-24 px-6 pb-12 max-w-7xl mx-auto">
        <div class="mb-8">
            <h2 class="text-2xl font-medium text-slate-800">My Apps</h2>
            <p class="text-slate-500 mt-1">Chọn ứng dụng để quản trị hệ thống</p>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            
            <!-- Dashboard Tile -->
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="fiori-tile p-6 flex flex-col h-40">
                <div class="flex justify-between items-start mb-auto">
                    <span class="material-symbols-outlined text-4xl tile-icon">bar_chart</span>
                </div>
                <div>
                    <h3 class="text-lg font-semibold text-slate-800">Dashboard</h3>
                    <p class="text-sm text-slate-500 mt-1">Thống kê tổng quan KPI</p>
                </div>
            </a>

            <!-- Duyệt Tài xế Tile -->
            <a href="${pageContext.request.contextPath}/admin/drivers" class="fiori-tile p-6 flex flex-col h-40">
                <div class="flex justify-between items-start mb-auto">
                    <span class="material-symbols-outlined text-4xl tile-icon">badge</span>
                </div>
                <div>
                    <h3 class="text-lg font-semibold text-slate-800">Duyệt Hồ Sơ Đối Tác</h3>
                    <p class="text-sm text-slate-500 mt-1">Quản lý hồ sơ tài xế mới</p>
                </div>
            </a>

            <!-- Quản lý User (Phase 2 Placeholder) -->
            <div class="fiori-tile p-6 flex flex-col h-40 opacity-60 cursor-not-allowed">
                <div class="flex justify-between items-start mb-auto">
                    <span class="material-symbols-outlined text-4xl tile-icon text-slate-400">group</span>
                    <span class="bg-slate-100 text-slate-500 text-xs px-2 py-1 rounded font-medium">Sắp ra mắt</span>
                </div>
                <div>
                    <h3 class="text-lg font-semibold text-slate-500">Quản lý Người dùng</h3>
                    <p class="text-sm text-slate-400 mt-1">Danh sách hành khách & tài xế</p>
                </div>
            </div>

            <!-- Quản lý Chuyến đi (Phase 2 Placeholder) -->
            <div class="fiori-tile p-6 flex flex-col h-40 opacity-60 cursor-not-allowed">
                <div class="flex justify-between items-start mb-auto">
                    <span class="material-symbols-outlined text-4xl tile-icon text-slate-400">route</span>
                    <span class="bg-slate-100 text-slate-500 text-xs px-2 py-1 rounded font-medium">Sắp ra mắt</span>
                </div>
                <div>
                    <h3 class="text-lg font-semibold text-slate-500">Quản lý Chuyến đi</h3>
                    <p class="text-sm text-slate-400 mt-1">Theo dõi các cuốc xe</p>
                </div>
            </div>

        </div>
    </main>

</body>
</html>
