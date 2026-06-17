<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Header Section -->
<div class="p-4 pt-safe md:p-6 md:pb-4 shrink-0 border-b border-slate-200/50 bg-white md:bg-white/40 z-30 pointer-events-auto">
    <div class="flex items-center justify-between mb-6">
        <!-- Logo -->
        <div class="flex items-center relative h-8 w-28">
            <img src="${pageContext.request.contextPath}/img/transcake-03.png"
                alt="Transcake Logo"
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
