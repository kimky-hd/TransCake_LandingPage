<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Auth Modal -->
<div id="authModal" class="fixed inset-0 z-[100] hidden flex items-center justify-center pointer-events-auto">
    <!-- Backdrop -->
    <div id="authModalBackdrop" class="absolute inset-0 bg-black/40 backdrop-blur-md transition-opacity opacity-0"></div>
    
    <!-- Modal Container -->
    <div id="authModalContent" class="relative bg-white rounded-3xl shadow-2xl overflow-hidden max-w-4xl w-full mx-4 flex flex-col md:flex-row transform scale-95 opacity-0 transition-all duration-300">
        
        <!-- Close Button -->
        <button id="closeAuthModalBtn" class="absolute top-4 right-4 z-10 w-10 h-10 flex items-center justify-center rounded-full bg-white/50 backdrop-blur-sm text-slate-800 hover:bg-white transition-colors shadow-sm">
            <span class="material-symbols-outlined font-bold">close</span>
        </button>

        <!-- Left Column: Forms -->
        <div class="w-full md:w-1/2 p-8 sm:p-12 flex flex-col justify-center">
            <div class="mb-8">
                <img src="${pageContext.request.contextPath}/img/transcake-03.png" alt="Transcake Logo" class="h-10 w-auto object-contain mb-6 filter brightness-0">
                <h2 class="text-3xl font-black text-slate-900 mb-2 font-['Playfair_Display']">Chào mừng bạn!</h2>
                <p class="text-slate-500 font-medium text-sm">Vui lòng đăng nhập hoặc đăng ký để tiếp tục trải nghiệm.</p>
            </div>

            <!-- Tabs -->
            <div class="flex gap-6 mb-8 border-b border-slate-200">
                <button id="tabLogin" class="pb-3 text-sm font-bold text-[#6200EE] border-b-2 border-[#6200EE] transition-colors">Đăng nhập</button>
                <button id="tabRegister" class="pb-3 text-sm font-bold text-slate-400 hover:text-slate-600 transition-colors">Đăng ký</button>
            </div>

            <!-- Login Form -->
            <form id="loginForm" class="space-y-4">
                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Email</label>
                    <input type="email" placeholder="Nhập email của bạn" class="w-full px-4 py-3 rounded-xl bg-slate-50 border border-slate-200 focus:outline-none focus:ring-2 focus:ring-[#6200EE]/50 focus:border-[#6200EE] transition-all text-sm font-medium placeholder:text-slate-400">
                </div>
                <div>
                    <div class="flex items-center justify-between mb-2">
                        <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider">Mật khẩu</label>
                        <a href="#" class="text-xs font-semibold text-[#6200EE] hover:underline">Quên mật khẩu?</a>
                    </div>
                    <input type="password" placeholder="Nhập mật khẩu" class="w-full px-4 py-3 rounded-xl bg-slate-50 border border-slate-200 focus:outline-none focus:ring-2 focus:ring-[#6200EE]/50 focus:border-[#6200EE] transition-all text-sm font-medium placeholder:text-slate-400">
                </div>
                <button type="button" class="w-full mt-6 bg-gradient-to-r from-[#6200EE] to-[#b84bf0] text-white py-3.5 rounded-xl font-bold shadow-lg shadow-purple-500/30 hover:scale-[1.02] transition-transform">Đăng nhập</button>
                
                <div class="mt-6 flex items-center justify-center gap-4">
                    <div class="h-px bg-slate-200 flex-1"></div>
                    <span class="text-xs font-semibold text-slate-400 uppercase">Hoặc đăng nhập với</span>
                    <div class="h-px bg-slate-200 flex-1"></div>
                </div>
                
                <div class="flex gap-4 mt-6">
                    <button type="button" class="flex-1 flex items-center justify-center gap-2 px-4 py-2.5 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors">
                        <img src="https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg" alt="Google" class="w-5 h-5">
                        <span class="text-sm font-semibold text-slate-700">Google</span>
                    </button>
                    <button type="button" class="flex-1 flex items-center justify-center gap-2 px-4 py-2.5 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors">
                        <img src="https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png" alt="Facebook" class="w-5 h-5">
                        <span class="text-sm font-semibold text-slate-700">Facebook</span>
                    </button>
                </div>
            </form>

            <!-- Register Form (Hidden initially) -->
            <form id="registerForm" class="space-y-4 hidden">
                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Họ và tên</label>
                    <input type="text" placeholder="Tên của bạn" class="w-full px-4 py-3 rounded-xl bg-slate-50 border border-slate-200 focus:outline-none focus:ring-2 focus:ring-[#6200EE]/50 focus:border-[#6200EE] transition-all text-sm font-medium placeholder:text-slate-400">
                </div>
                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Email</label>
                    <input type="email" placeholder="Nhập email" class="w-full px-4 py-3 rounded-xl bg-slate-50 border border-slate-200 focus:outline-none focus:ring-2 focus:ring-[#6200EE]/50 focus:border-[#6200EE] transition-all text-sm font-medium placeholder:text-slate-400">
                </div>
                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Mật khẩu</label>
                    <input type="password" placeholder="Tạo mật khẩu" class="w-full px-4 py-3 rounded-xl bg-slate-50 border border-slate-200 focus:outline-none focus:ring-2 focus:ring-[#6200EE]/50 focus:border-[#6200EE] transition-all text-sm font-medium placeholder:text-slate-400">
                </div>
                <button type="button" class="w-full mt-6 bg-[#FF6B00] text-white py-3.5 rounded-xl font-bold shadow-lg shadow-orange-500/30 hover:scale-[1.02] transition-transform">Đăng ký ngay</button>
                <p class="text-center text-xs font-medium text-slate-500 mt-4 leading-relaxed">Bằng việc đăng ký, bạn đồng ý với <a href="#" class="text-[#6200EE] hover:underline">Điều khoản dịch vụ</a> và <a href="#" class="text-[#6200EE] hover:underline">Chính sách bảo mật</a> của chúng tôi.</p>
            </form>
        </div>

        <!-- Right Column: Image -->
        <div class="w-full md:w-1/2 hidden md:block relative min-h-[500px]">
            <img src="${pageContext.request.contextPath}/img/Gemini_Generated_Image_tji7owtji7owtji7.png" class="absolute inset-0 w-full h-full object-cover">
            <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent"></div>
            <div class="absolute bottom-12 left-12 right-12 text-white">
                <span class="inline-block px-3 py-1 bg-white/20 backdrop-blur-md rounded-full text-xs font-bold uppercase tracking-wider mb-4 border border-white/30">Nền tảng số 1</span>
                <h3 class="text-3xl font-black mb-3 font-['Playfair_Display']">Kết nối những chuyến đi</h3>
                <p class="text-white/80 font-medium leading-relaxed">Cùng Transcake kiến tạo nên cộng đồng di chuyển thông minh, an toàn và cá nhân hóa.</p>
            </div>
        </div>
        
    </div>
</div>
