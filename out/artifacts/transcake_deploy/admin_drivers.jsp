<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - TransCake</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f4f5f7; }
        /* SAP Fiori Inspired Shadows and Cards */
        .fiori-card {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05), 0 1px 4px 0 rgba(0, 0, 0, 0.08);
            transition: box-shadow 0.2s ease-in-out;
        }
        .fiori-card:hover {
            box-shadow: 0 2px 8px 0 rgba(0, 0, 0, 0.1), 0 4px 16px 0 rgba(0, 0, 0, 0.08);
        }
        .fiori-header { background-color: #0854a0; }
        .fiori-button {
            border-radius: 4px;
            font-weight: 600;
            transition: background-color 0.2s;
        }
        .btn-approve { background-color: #0a6ed1; color: white; border: 1px solid #0a6ed1; }
        .btn-approve:hover { background-color: #0854a0; }
        .btn-reject { background-color: transparent; color: #bb0000; border: 1px solid #bb0000; }
        .btn-reject:hover { background-color: #bb0000; color: white; }
    </style>
</head>
<body>

    <!-- Header -->
    <header class="fiori-header h-14 w-full flex items-center px-6 shadow-md fixed top-0 z-50">
        <div class="flex items-center gap-3">
            <a href="${pageContext.request.contextPath}/admintranscake" class="text-white hover:text-blue-200 material-symbols-outlined mr-2" title="Quay lại Launchpad">arrow_back</a>
            <span class="material-symbols-outlined text-white">admin_panel_settings</span>
            <h1 class="text-white text-lg font-semibold tracking-wide">Duyệt Hồ Sơ Đối Tác</h1>
        </div>
        <div class="ml-auto flex items-center gap-4">
            <span class="text-blue-100 text-sm">Xin chào, Admin</span>
            <a href="#" onclick="fetch('${pageContext.request.contextPath}/api/logout').then(() => window.location.href='${pageContext.request.contextPath}/'); return false;" class="text-white hover:text-blue-200 material-symbols-outlined">logout</a>
        </div>
    </header>

    <!-- Main Content -->
    <main class="pt-20 px-6 pb-12 max-w-7xl mx-auto">
        <div class="mb-6 flex items-center justify-between">
            <h2 class="text-2xl font-normal text-slate-800">Duyệt Hồ Sơ Đối Tác</h2>
            <div class="text-sm text-slate-500">
                Hiển thị <span class="font-bold text-slate-700">${fn:length(pendingDrivers)}</span> hồ sơ chờ duyệt
            </div>
        </div>

        <c:choose>
            <c:when test="${empty pendingDrivers}">
                <div class="fiori-card p-12 text-center flex flex-col items-center justify-center">
                    <span class="material-symbols-outlined text-6xl text-slate-300 mb-4">task_alt</span>
                    <h3 class="text-lg font-medium text-slate-700">Không có hồ sơ nào cần duyệt!</h3>
                    <p class="text-slate-500 mt-2">Tất cả tài xế đã được xử lý.</p>
                </div>
            </c:when>
            <c:otherwise>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <c:forEach var="driver" items="${pendingDrivers}">
                    <div class="fiori-card overflow-hidden flex flex-col">
                        <div class="border-b border-slate-100 p-5 flex items-start gap-4">
                            <div class="w-12 h-12 rounded-full bg-slate-200 overflow-hidden flex-shrink-0 border border-slate-300">
                                <c:choose>
                                    <c:when test="${not empty driver.avatarUrl}">
                                        <img src="<c:out value='${driver.avatarUrl}' />" alt="Avatar" class="w-full h-full object-cover"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="material-symbols-outlined w-full h-full flex items-center justify-center text-slate-400">person</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="flex-1">
                                <h3 class="text-lg font-semibold text-slate-800 leading-tight"><c:out value="${driver.fullName}" /></h3>
                                <div class="text-sm text-slate-500 mt-1 flex items-center gap-1">
                                    <span class="material-symbols-outlined text-[16px]">mail</span> <c:out value="${driver.email}" />
                                </div>
                                <div class="text-sm text-slate-500 mt-1 flex items-center gap-1">
                                    <span class="material-symbols-outlined text-[16px]">call</span> <c:out value="${driver.phoneNumber}" />
                                </div>
                            </div>
                            <span class="px-2 py-1 bg-amber-100 text-amber-700 text-xs font-semibold rounded-sm">PENDING</span>
                        </div>

                        <div class="p-5 flex-1 bg-slate-50/50">
                            <div class="grid grid-cols-2 gap-y-4 gap-x-2 text-sm mb-6">
                                <div>
                                    <p class="text-slate-500 text-xs uppercase tracking-wider font-semibold mb-1">Loại Xe</p>
                                    <p class="text-slate-800 font-medium"><c:out value="${driver.vehicleType}" /></p>
                                </div>
                                <div>
                                    <p class="text-slate-500 text-xs uppercase tracking-wider font-semibold mb-1">Dòng Xe</p>
                                    <p class="text-slate-800 font-medium"><c:out value="${driver.vehicleName}" /> - <c:out value="${driver.vehicleColor}" /></p>
                                </div>
                                <div>
                                    <p class="text-slate-500 text-xs uppercase tracking-wider font-semibold mb-1">Biển Số</p>
                                    <p class="text-slate-800 font-medium"><c:out value="${driver.licensePlate}" /></p>
                                </div>
                                <div>
                                    <p class="text-slate-500 text-xs uppercase tracking-wider font-semibold mb-1">Số CCCD / Bằng Lái</p>
                                    <p class="text-slate-800 font-medium"><c:out value="${driver.idCardNumber}" /> / <c:out value="${driver.licenseNumber}" /></p>
                                </div>
                            </div>

                            <!-- Images Section -->
                            <div class="space-y-3">
                                <p class="text-slate-500 text-xs uppercase tracking-wider font-semibold">Tài liệu đính kèm</p>
                                <div class="grid grid-cols-4 gap-2">
                                    <a href="<c:out value='${driver.idCardFrontUrl}' />" target="_blank" class="block aspect-[4/3] rounded bg-slate-200 overflow-hidden relative group cursor-pointer" title="CCCD Mặt trước">
                                        <img src="<c:out value='${driver.idCardFrontUrl}' />" class="w-full h-full object-cover group-hover:scale-110 transition-transform"/>
                                        <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 flex items-center justify-center transition-opacity">
                                            <span class="material-symbols-outlined text-white text-sm">open_in_new</span>
                                        </div>
                                        <div class="absolute bottom-0 left-0 right-0 bg-black/60 text-[10px] text-white px-1 py-0.5 text-center truncate">CCCD Trước</div>
                                    </a>
                                    <a href="<c:out value='${driver.idCardBackUrl}' />" target="_blank" class="block aspect-[4/3] rounded bg-slate-200 overflow-hidden relative group cursor-pointer" title="CCCD Mặt sau">
                                        <img src="<c:out value='${driver.idCardBackUrl}' />" class="w-full h-full object-cover group-hover:scale-110 transition-transform"/>
                                        <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 flex items-center justify-center transition-opacity">
                                            <span class="material-symbols-outlined text-white text-sm">open_in_new</span>
                                        </div>
                                        <div class="absolute bottom-0 left-0 right-0 bg-black/60 text-[10px] text-white px-1 py-0.5 text-center truncate">CCCD Sau</div>
                                    </a>
                                    <a href="<c:out value='${driver.licenseImageUrl}' />" target="_blank" class="block aspect-[4/3] rounded bg-slate-200 overflow-hidden relative group cursor-pointer" title="Giấy Phép Lái Xe">
                                        <img src="<c:out value='${driver.licenseImageUrl}' />" class="w-full h-full object-cover group-hover:scale-110 transition-transform"/>
                                        <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 flex items-center justify-center transition-opacity">
                                            <span class="material-symbols-outlined text-white text-sm">open_in_new</span>
                                        </div>
                                        <div class="absolute bottom-0 left-0 right-0 bg-black/60 text-[10px] text-white px-1 py-0.5 text-center truncate">Bằng Lái</div>
                                    </a>
                                    <a href="<c:out value='${driver.vehicleRegistrationUrl}' />" target="_blank" class="block aspect-[4/3] rounded bg-slate-200 overflow-hidden relative group cursor-pointer" title="Cà Vẹt Xe">
                                        <img src="<c:out value='${driver.vehicleRegistrationUrl}' />" class="w-full h-full object-cover group-hover:scale-110 transition-transform"/>
                                        <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 flex items-center justify-center transition-opacity">
                                            <span class="material-symbols-outlined text-white text-sm">open_in_new</span>
                                        </div>
                                        <div class="absolute bottom-0 left-0 right-0 bg-black/60 text-[10px] text-white px-1 py-0.5 text-center truncate">Cà vẹt</div>
                                    </a>
                                </div>
                            </div>
                        </div>

                        <div class="border-t border-slate-100 p-4 bg-white flex justify-end gap-3 mt-auto">
                            <form action="${pageContext.request.contextPath}/admin/drivers" method="POST" class="inline">
                                <input type="hidden" name="userId" value="<c:out value='${driver.userId}' />">
                                <input type="hidden" name="email" value="<c:out value='${driver.email}' />">
                                <input type="hidden" name="driverName" value="<c:out value='${driver.fullName}' />">
                                <input type="hidden" name="action" value="REJECT">
                                <button type="submit" class="fiori-button btn-reject px-6 py-2 text-sm" onclick="return confirm('Bạn có chắc chắn muốn TỪ CHỐI hồ sơ này? Hệ thống sẽ gửi email yêu cầu tài xế nộp lại.');">
                                    Từ chối
                                </button>
                            </form>
                            
                            <form action="${pageContext.request.contextPath}/admin/drivers" method="POST" class="inline">
                                <input type="hidden" name="userId" value="<c:out value='${driver.userId}' />">
                                <input type="hidden" name="email" value="<c:out value='${driver.email}' />">
                                <input type="hidden" name="driverName" value="<c:out value='${driver.fullName}' />">
                                <input type="hidden" name="action" value="APPROVE">
                                <button type="submit" class="fiori-button btn-approve px-6 py-2 text-sm" onclick="return confirm('Xác nhận DUYỆT hồ sơ tài xế này?');">
                                    Phê duyệt
                                </button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </main>

</body>
</html>
