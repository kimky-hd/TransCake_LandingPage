<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:if test="${loggedInUser == null}">
    <c:redirect url="/login.jsp" />
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Lịch sử chuyến đi - TransCake</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/transcake-04.png" />
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
    </style>
</head>
<body>
    <div class="min-h-screen pb-10">
        <!-- Header -->
        <header class="bg-white shadow-sm sticky top-0 z-50">
            <div class="max-w-3xl mx-auto px-4 h-16 flex items-center gap-4">
                <a href="${pageContext.request.contextPath}/dashboard" class="w-10 h-10 rounded-full bg-slate-100 flex items-center justify-center text-slate-600 hover:bg-slate-200 transition-colors">
                    <span class="material-symbols-outlined">arrow_back</span>
                </a>
                <h1 class="text-xl font-black text-slate-800">Lịch sử chuyến đi</h1>
            </div>
        </header>

        <!-- Content -->
        <main class="max-w-3xl mx-auto px-4 mt-8">
            <c:if test="${empty historyList}">
                <div class="bg-white rounded-3xl p-10 text-center shadow-sm border border-slate-100">
                    <div class="w-24 h-24 bg-slate-100 rounded-full flex items-center justify-center mx-auto mb-6">
                        <span class="material-symbols-outlined text-slate-400 text-4xl">history</span>
                    </div>
                    <h3 class="text-xl font-bold text-slate-800 mb-2">Chưa có chuyến đi nào</h3>
                    <p class="text-slate-500">Bạn chưa thực hiện chuyến đi nào trên hệ thống.</p>
                    <a href="${pageContext.request.contextPath}/dashboard" class="inline-block mt-6 px-6 py-3 bg-[#6200EE] hover:bg-[#5000c2] text-white font-bold rounded-xl transition-colors">
                        Về trang chủ
                    </a>
                </div>
            </c:if>

            <c:if test="${not empty historyList}">
                <div class="space-y-4">
                    <c:forEach var="trip" items="${historyList}">
                        <div class="bg-white rounded-3xl p-6 shadow-sm border border-slate-100 hover:shadow-md transition-shadow">
                            <div class="flex justify-between items-start mb-4">
                                <div class="flex items-center gap-3">
                                    <c:choose>
                                        <c:when test="${trip.matchStatus == 'CANCELLED'}">
                                            <div class="w-12 h-12 rounded-full bg-red-100 text-red-500 flex items-center justify-center shrink-0">
                                                <span class="material-symbols-outlined">cancel</span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="w-12 h-12 rounded-full bg-green-100 text-green-500 flex items-center justify-center shrink-0">
                                                <span class="material-symbols-outlined">check_circle</span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div>
                                        <h3 class="font-bold text-slate-800 text-lg">
                                            <c:choose>
                                                <c:when test="${trip.matchStatus == 'CANCELLED'}">Đã hủy</c:when>
                                                <c:otherwise>Hoàn thành</c:otherwise>
                                            </c:choose>
                                        </h3>
                                        <p class="text-sm text-slate-500 font-medium">
                                            <fmt:formatDate value="${trip.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </p>
                                    </div>
                                </div>
                                <div class="text-right">
                                    <p class="font-black text-xl text-[#FF6D00]">
                                        <fmt:formatNumber value="${trip.price}" type="number" maxFractionDigits="0" />đ
                                    </p>
                                    <p class="text-sm font-medium text-slate-500">${trip.distance} km</p>
                                </div>
                            </div>
                            
                            <!-- Locations -->
                            <div class="bg-slate-50 rounded-2xl p-4 mb-4 relative">
                                <div class="absolute left-[27px] top-[32px] bottom-[32px] w-[2px] border-l-2 border-dashed border-slate-300"></div>
                                <div class="flex items-center gap-3 relative z-10 mb-4">
                                    <div class="w-4 h-4 rounded-full bg-[#6200EE] border-4 border-white shrink-0 shadow-sm"></div>
                                    <p class="text-sm font-medium text-slate-700 truncate" title="${trip.pickupLocation}">${trip.pickupLocation}</p>
                                </div>
                                <div class="flex items-center gap-3 relative z-10">
                                    <div class="w-4 h-4 rounded-full bg-[#FF6D00] border-4 border-white shrink-0 shadow-sm"></div>
                                    <p class="text-sm font-medium text-slate-700 truncate" title="${trip.dropoffLocation}">${trip.dropoffLocation}</p>
                                </div>
                            </div>
                            
                            <!-- Driver view specific passenger info -->
                            <c:if test="${loggedInUser.role == 'driver' and not empty trip.passengerName}">
                                <div class="flex items-center gap-2 text-sm text-slate-600 bg-blue-50 text-blue-700 px-4 py-3 rounded-xl font-medium">
                                    <span class="material-symbols-outlined text-[18px]">person</span>
                                    <span>Khách hàng: <strong>${trip.passengerName}</strong> (${trip.passengerPhone})</span>
                                </div>
                            </c:if>
                            
                            <!-- Passenger view specific driver info -->
                            <c:if test="${loggedInUser.role == 'passenger' and not empty trip.passengerName}">
                                <div class="flex items-center gap-2 text-sm text-slate-600 bg-emerald-50 text-emerald-700 px-4 py-3 rounded-xl font-medium">
                                    <span class="material-symbols-outlined text-[18px]">drive_eta</span>
                                    <span>Tài xế: <strong>${trip.passengerName}</strong> (${trip.passengerPhone})</span>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </main>
    </div>
</body>
</html>
