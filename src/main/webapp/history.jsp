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
        .panel-scroll::-webkit-scrollbar { width: 4px; }
        .panel-scroll::-webkit-scrollbar-track { background: transparent; }
        .panel-scroll::-webkit-scrollbar-thumb { background-color: #cbd5e1; border-radius: 20px; }
    </style>
</head>
<body class="bg-slate-50 min-h-screen pb-10 overflow-x-hidden">

    <!-- Sticky Header (Synced with Earnings View) -->
    <div class="w-full flex items-center p-4 pb-2 sticky top-0 bg-slate-50/90 backdrop-blur-md z-30 max-w-xl mx-auto border-b border-slate-200/50">
        <a href="${pageContext.request.contextPath}/dashboard"
            class="w-9 h-9 rounded-full bg-white hover:bg-slate-100 border border-slate-200 flex items-center justify-center shadow-sm transition-all cursor-pointer relative z-50">
            <span class="material-symbols-outlined text-slate-600 text-lg">arrow_back</span>
        </a>
        <h3 class="flex-1 text-center font-bold text-base text-slate-800 -ml-9">Lịch sử chuyến đi</h3>
    </div>

    <!-- Content -->
    <main class="max-w-xl mx-auto px-4 mt-6">
        <c:if test="${empty historyList}">
            <div class="text-center py-12">
                <span class="material-symbols-outlined text-4xl text-slate-200 mb-2">history</span>
                <p class="text-xs text-slate-400 font-semibold">Chưa có chuyến đi nào</p>
                <p class="text-[10px] text-slate-300 mt-1">Hoàn thành chuyến đi đầu tiên để xem lịch sử</p>
                <a href="${pageContext.request.contextPath}/dashboard" class="inline-block mt-6 px-6 py-2 bg-[#6200EE] hover:bg-[#5000c2] text-white font-bold text-xs rounded-xl shadow-sm transition-colors">
                    Về trang chủ
                </a>
            </div>
        </c:if>

        <c:if test="${not empty historyList}">
            <div class="bg-white rounded-2xl shadow-sm border border-slate-100 p-2">
                <c:forEach var="trip" items="${historyList}">
                    <c:set var="isMotorbike" value="${trip.vehicleType == 'MOTORBIKE'}" />
                    <c:set var="typeIcon" value="${isMotorbike ? 'two_wheeler' : 'directions_car'}" />
                    <c:set var="typeBg" value="${isMotorbike ? 'bg-orange-50 text-orange-500' : 'bg-blue-50 text-blue-500'}" />
                    <c:set var="isPreBook" value="${trip.tripType == 'PRE_BOOK'}" />
                    <c:set var="tripTypeBadge" value="${isPreBook ? '<span class=\"bg-blue-100 text-blue-600 text-[9px] px-1.5 py-0.5 rounded font-bold ml-1\">ĐẶT TRƯỚC</span>' : '<span class=\"bg-emerald-100 text-emerald-600 text-[9px] px-1.5 py-0.5 rounded font-bold ml-1\">ĐẶT NGAY</span>'}" />
                    
                    <c:set var="passengerName" value="${empty trip.passengerName ? 'Khách hàng' : trip.passengerName}" />
                    <!-- Swap role display context -->
                    <c:if test="${loggedInUser.role == 'passenger'}">
                        <c:set var="passengerName" value="${empty trip.passengerName ? 'Tài xế' : trip.passengerName}" />
                    </c:if>

                    <div class="flex flex-col py-3 px-2 border-b border-slate-50 last:border-0 hover:bg-slate-50/50 transition-colors rounded-xl">
                        <div class="flex items-center justify-between mb-2">
                            <div class="flex items-center gap-2">
                                <div class="w-8 h-8 rounded-full ${typeBg} flex items-center justify-center shrink-0">
                                    <span class="material-symbols-outlined text-sm">${typeIcon}</span>
                                </div>
                                <div>
                                    <h5 class="text-xs font-bold text-slate-800">${passengerName} ${tripTypeBadge}</h5>
                                    <p class="text-[10px] text-slate-500"><fmt:formatDate value="${trip.createdAt}" pattern="dd/MM/yyyy · HH:mm" /></p>
                                </div>
                            </div>
                            <div class="text-right">
                                <c:choose>
                                    <c:when test="${trip.matchStatus == 'CANCELLED'}">
                                        <p class="text-sm font-black text-red-500">Đã hủy</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-sm font-black text-[#6200EE]">
                                            <fmt:formatNumber value="${trip.price}" type="number" maxFractionDigits="0" />đ
                                        </p>
                                        <p class="text-[9px] text-slate-400 font-medium">${trip.distance} km</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="pl-10 space-y-1.5">
                            <div class="flex items-start gap-1.5">
                                <div class="w-1.5 h-1.5 rounded-full bg-purple-500 mt-1 shrink-0"></div>
                                <p class="text-[11px] text-slate-600 leading-tight"><span class="font-semibold text-slate-700">Từ:</span> ${trip.pickupLocation}</p>
                            </div>
                            <div class="flex items-start gap-1.5">
                                <div class="w-1.5 h-1.5 rounded-full bg-orange-500 mt-1 shrink-0"></div>
                                <p class="text-[11px] text-slate-600 leading-tight"><span class="font-semibold text-slate-700">Đến:</span> ${trip.dropoffLocation}</p>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </main>
</body>
</html>
