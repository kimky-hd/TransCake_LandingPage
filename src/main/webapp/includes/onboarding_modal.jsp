<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!-- Custom CSS styling for onboarding steps -->
    <style>
        /* Custom transitions for smooth step changes */
        .step-container {
            transition: opacity 0.35s ease-in-out, transform 0.35s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .hidden-step {
            opacity: 0;
            transform: translateY(15px);
            pointer-events: none;
            position: absolute;
            visibility: hidden;
            width: 100%;
        }

        .active-step {
            opacity: 1;
            transform: translateY(0);
            pointer-events: auto;
            position: relative;
            visibility: visible;
            width: 100%;
        }

        /* Custom scrollbar for tags area */
        .custom-scrollbar::-webkit-scrollbar {
            width: 5px;
        }

        .custom-scrollbar::-webkit-scrollbar-track {
            background: #f1f5f9;
            border-radius: 10px;
        }

        .custom-scrollbar::-webkit-scrollbar-thumb {
            background-color: #cbd5e1;
            border-radius: 10px;
        }

        .custom-scrollbar::-webkit-scrollbar-thumb:hover {
            background-color: #94a3b8;
        }
    </style>

    <!-- Onboarding Modal -->
    <div id="onboardingModal" class="fixed inset-0 z-[100] hidden flex items-center justify-center pointer-events-auto">
        <!-- Backdrop -->
        <div id="onboardingModalBackdrop"
            class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm transition-opacity opacity-0"></div>

        <!-- Modal Box -->
        <div id="onboardingModalContent"
            class="bg-white w-full max-w-xl rounded-2xl shadow-2xl overflow-hidden flex flex-col max-h-[90vh] md:max-h-[85vh] relative transform scale-95 opacity-0 transition-all duration-300">

            <!-- Progress indicator -->
            <div class="bg-slate-100 h-1.5 w-full flex">
                <div id="progressBar"
                    class="h-full bg-gradient-to-r from-primary to-purple-500 transition-all duration-500 ease-out w-1/3 rounded-r-full">
                </div>
            </div>

            <!-- Content Area -->
            <div class="p-6 md:p-8 flex-1 overflow-x-hidden overflow-y-auto custom-scrollbar relative flex items-start">

                <!-- STEP 1: Demographics -->
                <div id="step1" class="step-container active-step">
                    <h2 class="text-2xl md:text-[28px] font-extrabold text-primary mb-7 leading-tight">Bạn là ai? Hãy
                        cho chúng tôi biết nhé</h2>

                    <div class="space-y-6">
                        <!-- Full Name -->
                        <div>
                            <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Họ và
                                tên</label>
                            <input type="text" id="fullName" placeholder="Nhập tên của bạn"
                                class="w-full px-4 py-3.5 rounded-xl bg-slate-50 border border-slate-200 focus:outline-none focus:ring-2 focus:ring-primary/50 focus:border-primary transition-all text-sm font-semibold text-slate-800 placeholder:text-slate-400 placeholder:font-medium">
                        </div>

                        <!-- Gender -->
                        <div>
                            <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Giới
                                tính</label>
                            <div class="grid grid-cols-3 gap-2.5">
                                <label class="cursor-pointer group">
                                    <input type="radio" name="gender" value="male" class="peer sr-only" checked>
                                    <div
                                        class="text-center px-2 py-3 rounded-xl border border-slate-200 peer-checked:bg-primary/10 peer-checked:border-primary peer-checked:text-primary font-bold text-sm text-slate-500 transition-all group-hover:bg-slate-50 shadow-sm peer-checked:shadow-none">
                                        Nam
                                    </div>
                                </label>
                                <label class="cursor-pointer group">
                                    <input type="radio" name="gender" value="female" class="peer sr-only">
                                    <div
                                        class="text-center px-2 py-3 rounded-xl border border-slate-200 peer-checked:bg-primary/10 peer-checked:border-primary peer-checked:text-primary font-bold text-sm text-slate-500 transition-all group-hover:bg-slate-50 shadow-sm peer-checked:shadow-none">
                                        Nữ
                                    </div>
                                </label>
                                <label class="cursor-pointer group">
                                    <input type="radio" name="gender" value="other" class="peer sr-only">
                                    <div
                                        class="text-center px-2 py-3 rounded-xl border border-slate-200 peer-checked:bg-primary/10 peer-checked:border-primary peer-checked:text-primary font-bold text-[13px] text-slate-500 transition-all group-hover:bg-slate-50 shadow-sm peer-checked:shadow-none flex items-center justify-center">
                                        Không tiết lộ
                                    </div>
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="mt-10">
                        <button type="button" onclick="validateStep1AndGo()"
                            class="w-full bg-primary text-white py-3.5 rounded-xl font-bold shadow-lg shadow-primary/30 hover:scale-[1.02] hover:bg-[#5000c9] transition-all">
                            Tiếp tục
                        </button>
                    </div>
                </div>

                <!-- STEP 2: Vibe Tags -->
                <div id="step2" class="step-container hidden-step">
                    <h2 class="text-2xl md:text-[28px] font-extrabold text-primary mb-2">Sở thích của bạn là gì?</h2>
                    <p class="text-[13px] text-slate-500 font-medium mb-7">Chọn ít nhất <strong class="text-accent">4
                            chủ đề</strong> để chúng tôi ghép chuyến phù hợp nhất cho bạn.</p>

                    <div class="space-y-6">
                        <!-- Group 1 -->
                        <div>
                            <h3
                                class="text-[11px] font-bold text-slate-400 uppercase tracking-widest mb-3 flex items-center gap-2">
                                <span class="w-2 h-2 rounded-full bg-purple-400"></span> Giải trí & Nghệ thuật
                            </h3>
                            <div class="flex flex-wrap gap-2.5">
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Music</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Movies & TV</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Gaming</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Photography</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Anime & Manga</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Art & Design</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Podcasts</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Pop Culture</button>
                            </div>
                        </div>

                        <!-- Group 2 -->
                        <div>
                            <h3
                                class="text-[11px] font-bold text-slate-400 uppercase tracking-widest mb-3 flex items-center gap-2">
                                <span class="w-2 h-2 rounded-full bg-orange-400"></span> Phong cách sống
                            </h3>
                            <div class="flex flex-wrap gap-2.5">
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Travel</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Food & Drink</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Fashion</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Pets</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Coffee Hopping</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Astrology</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Nightlife</button>
                            </div>
                        </div>

                        <!-- Group 3 -->
                        <div>
                            <h3
                                class="text-[11px] font-bold text-slate-400 uppercase tracking-widest mb-3 flex items-center gap-2">
                                <span class="w-2 h-2 rounded-full bg-green-400"></span> Vận động & Sức khỏe
                            </h3>
                            <div class="flex flex-wrap gap-2.5">
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Sports</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Fitness & Gym</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Running/Cycling</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Yoga & Mindfulness</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Outdoor</button>
                            </div>
                        </div>

                        <!-- Group 4 -->
                        <div>
                            <h3
                                class="text-[11px] font-bold text-slate-400 uppercase tracking-widest mb-3 flex items-center gap-2">
                                <span class="w-2 h-2 rounded-full bg-blue-400"></span> Kiến thức & Phát triển
                            </h3>
                            <div class="flex flex-wrap gap-2.5">
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Tech</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Business</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Finance & Investing</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Books</button>
                                <button type="button"
                                    class="vibe-tag px-4 py-2 rounded-full border border-slate-200 text-sm font-semibold text-slate-600 transition-all hover:bg-slate-50 hover:border-slate-300 flex items-center gap-1.5"
                                    data-selected="false">Cars & Vehicles</button>
                            </div>
                        </div>
                    </div>

                    <div class="mt-10 flex gap-3">
                        <button type="button" onclick="goToStep(1)"
                            class="px-5 py-3.5 rounded-xl font-bold text-slate-600 bg-slate-100 hover:bg-slate-200 transition-colors">
                            Quay lại
                        </button>
                        <button type="button" id="step2ContinueBtn" onclick="goToStep(3)" disabled
                            class="flex-1 bg-primary text-white py-3.5 rounded-xl font-bold shadow-lg shadow-primary/30 opacity-50 cursor-not-allowed transition-all">
                            Tiếp tục (<span id="tagCount">0</span>/4)
                        </button>
                    </div>
                </div>

                <!-- STEP 3: Role Selection -->
                <div id="step3" class="step-container hidden-step">
                    <h2 class="text-2xl md:text-[28px] font-extrabold text-primary mb-8 text-center leading-tight">Bạn
                        muốn bắt đầu với <br class="hidden md:block">vai trò nào?</h2>

                    <div class="flex flex-col sm:flex-row gap-5 mb-8">
                        <!-- Passenger Card -->
                        <div onclick="submitOnboarding('passenger', this)"
                            class="role-card group cursor-pointer flex-1 bg-[#F5F3FF] hover:bg-[#EDE9FE] border-2 border-transparent hover:border-primary rounded-[20px] p-7 transition-all text-center relative overflow-hidden">
                            <!-- Subtle BG decoration -->
                            <div class="absolute -right-4 -top-4 w-16 h-16 bg-primary/5 rounded-full"></div>

                            <div
                                class="w-16 h-16 bg-white rounded-full flex items-center justify-center mx-auto mb-5 shadow-sm group-hover:scale-110 transition-transform duration-300">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-primary" fill="none"
                                    viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                    <path stroke-linecap="round" stroke-linejoin="round"
                                        d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                                </svg>
                            </div>
                            <h3 class="text-xl font-extrabold text-slate-800 mb-2">Hành khách</h3>
                            <p class="text-sm text-slate-600 font-medium leading-relaxed">Tìm người đồng hành và chia sẻ
                                chuyến đi</p>
                        </div>

                        <!-- Driver Card -->
                        <div onclick="submitOnboarding('driver', this)"
                            class="role-card group cursor-pointer flex-1 bg-slate-900 hover:bg-slate-800 border-2 border-transparent hover:border-accent rounded-[20px] p-7 transition-all text-center relative overflow-hidden">
                            <!-- Subtle BG decoration -->
                            <div class="absolute -right-4 -top-4 w-16 h-16 bg-white/5 rounded-full"></div>

                            <div
                                class="w-16 h-16 bg-slate-800 rounded-full flex items-center justify-center mx-auto mb-5 shadow-sm group-hover:scale-110 transition-transform duration-300">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-accent" fill="none"
                                    viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                    <path stroke-linecap="round" stroke-linejoin="round"
                                        d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z" />
                                </svg>
                            </div>
                            <h3 class="text-xl font-extrabold text-white mb-2">Đối tác</h3>
                            <p class="text-sm text-slate-400 font-medium leading-relaxed">Chia sẻ hành trình và tối ưu
                                thu nhập</p>
                        </div>
                    </div>

                    <div class="mt-4 text-center">
                        <button type="button" onclick="goToStep(2)"
                            class="px-5 py-2.5 rounded-xl font-semibold text-sm text-slate-400 hover:text-slate-600 transition-colors">
                            &larr; Quay lại chọn sở thích
                        </button>
                    </div>
                </div>

        </div>
    </div>

    <!-- Onboarding Modal Script -->
    <script>
        (function () {
            let currentStep = 1;
            let selectedTags = new Set();
            const minTagsRequired = 4;

            const step1 = document.getElementById('step1');
            const step2 = document.getElementById('step2');
            const step3 = document.getElementById('step3');
            const progressBar = document.getElementById('progressBar');
            const step2ContinueBtn = document.getElementById('step2ContinueBtn');
            const tagCountSpan = document.getElementById('tagCount');
            const tags = document.querySelectorAll('.vibe-tag');

            const modal = document.getElementById('onboardingModal');
            const backdrop = document.getElementById('onboardingModalBackdrop');
            const content = document.getElementById('onboardingModalContent');

            // SVG checkmark
            const checkIcon = `<svg class="w-[18px] h-[18px] check-icon animate-[ping_0.2s_ease-out_reverse]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"></path></svg>`;

            // Chuyển bước
            window.goToStep = function (step) {
                // Ẩn tất cả
                step1.classList.remove('active-step');
                step1.classList.add('hidden-step');
                step2.classList.remove('active-step');
                step2.classList.add('hidden-step');
                step3.classList.remove('active-step');
                step3.classList.add('hidden-step');

                // Scroll to top of modal content
                document.querySelector('.custom-scrollbar').scrollTop = 0;

                // Hiển thị bước tương ứng
                currentStep = step;
                if (step === 1) {
                    step1.classList.remove('hidden-step');
                    step1.classList.add('active-step');
                    progressBar.style.width = '33.33%';
                } else if (step === 2) {
                    step2.classList.remove('hidden-step');
                    step2.classList.add('active-step');
                    progressBar.style.width = '66.66%';
                } else if (step === 3) {
                    step3.classList.remove('hidden-step');
                    step3.classList.add('active-step');
                    progressBar.style.width = '100%';
                }
            };

            window.validateStep1AndGo = function () {
                const fullNameInput = document.getElementById('fullName');
                const fullName = fullNameInput ? fullNameInput.value.trim() : '';
                if (!fullName) {
                    showToast('Vui lòng nhập họ và tên.', 'warning');
                    if (fullNameInput) fullNameInput.focus();
                    return;
                }
                goToStep(2);
            };

            // Logic chọn Vibe Tags
            tags.forEach(tag => {
                tag.addEventListener('click', function () {
                    const isSelected = this.getAttribute('data-selected') === 'true';
                    const tagText = this.innerText.trim();

                    if (isSelected) {
                        // Bỏ chọn
                        this.setAttribute('data-selected', 'false');
                        this.classList.remove('bg-primary', 'text-white', 'border-primary', 'shadow-md', 'shadow-primary/20');
                        this.classList.add('border-slate-200', 'text-slate-600', 'hover:bg-slate-50', 'hover:border-slate-300');

                        const icon = this.querySelector('.check-icon');
                        if (icon) icon.remove();

                        selectedTags.delete(tagText);
                    } else {
                        // Chọn ngẫu nhiên màu tím hoặc màu cam cho sinh động
                        const colorClasses = Math.random() > 0.5
                            ? ['bg-primary', 'border-primary', 'shadow-primary/20']
                            : ['bg-accent', 'border-accent', 'shadow-accent/20'];

                        this.setAttribute('data-selected', 'true');
                        this.classList.remove('border-slate-200', 'text-slate-600', 'hover:bg-slate-50', 'hover:border-slate-300');

                        this.classList.add(...colorClasses, 'text-white', 'shadow-md');
                        this.insertAdjacentHTML('afterbegin', checkIcon);

                        selectedTags.add(tagText);
                    }

                    // Cập nhật số đếm và Validate
                    tagCountSpan.innerText = selectedTags.size;

                    if (selectedTags.size >= minTagsRequired) {
                        step2ContinueBtn.disabled = false;
                        step2ContinueBtn.classList.remove('opacity-50', 'cursor-not-allowed');
                        step2ContinueBtn.classList.add('hover:scale-[1.02]');
                        step2ContinueBtn.innerHTML = 'Tiếp tục &rarr;';
                    } else {
                        step2ContinueBtn.disabled = true;
                        step2ContinueBtn.classList.add('opacity-50', 'cursor-not-allowed');
                        step2ContinueBtn.classList.remove('hover:scale-[1.02]');
                        step2ContinueBtn.innerHTML = `Tiếp tục (<span id="tagCount">${selectedTags.size}</span>/4)`;
                    }
                });
            });

            // Xử lý hoàn tất và đóng modal
            window.finishAndRedirect = function () {
                closeOnboardingModal();
                setTimeout(() => {
                    window.location.href = window.CONTEXT_PATH + '/dashboard.jsp';
                }, 300);
            };

            // Click chọn vai trò
            window.submitOnboarding = function (role, element) {
                // Hiệu ứng highlight card được chọn
                const allCards = document.querySelectorAll('.role-card');
                allCards.forEach(c => c.style.opacity = '0.4'); // Làm mờ card kia
                element.style.opacity = '1';
                element.classList.add('ring-4', 'ring-primary/50', 'scale-[1.02]');

                const fullNameInput = document.getElementById('fullName');
                const fullName = fullNameInput ? fullNameInput.value.trim() : '';
                if (!fullName) {
                    showToast('Vui lòng nhập họ và tên của bạn.', 'warning');
                    element.style.pointerEvents = 'auto';
                    allCards.forEach(c => c.style.opacity = '1');
                    element.classList.remove('ring-4', 'ring-primary/50', 'scale-[1.02]');
                    goToStep(1);
                    return;
                }

                const genderInput = document.querySelector('input[name="gender"]:checked');
                const gender = genderInput ? genderInput.value : 'male';
                const tags = Array.from(selectedTags);

                // Disable button logic UI here
                element.style.pointerEvents = 'none';

                // Gọi API lưu Onboarding
                fetch(window.CONTEXT_PATH + '/api/onboarding', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        fullName: fullName,
                        gender: gender,
                        role: role,
                        tags: tags
                    })
                })
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            console.log("Onboarding lưu thành công!");
                            setTimeout(() => {
                                finishAndRedirect();
                            }, 400);
                        } else {
                            showToast(data.message, 'error');
                            element.style.pointerEvents = 'auto'; // Re-enable
                            allCards.forEach(c => c.style.opacity = '1');
                            element.classList.remove('ring-4', 'ring-primary/50', 'scale-[1.02]');
                        }
                    })
                    .catch(err => {
                        console.error("Lỗi:", err);
                        showToast("Đã xảy ra lỗi hệ thống khi lưu thông tin.", "error");
                        element.style.pointerEvents = 'auto';
                        allCards.forEach(c => c.style.opacity = '1');
                        element.classList.remove('ring-4', 'ring-primary/50', 'scale-[1.02]');
                    });
            };

            window.skipOnboarding = function () {
                finishAndRedirect();
            };

            window.openOnboardingModal = function () {
                modal.classList.remove('hidden');
                document.body.style.overflow = 'hidden';
                goToStep(1);

                // Reset fields
                const fullNameInput = document.getElementById('fullName');
                if (fullNameInput) fullNameInput.value = '';

                const genderRadio = document.querySelector('input[name="gender"][value="male"]');
                if (genderRadio) genderRadio.checked = true;

                selectedTags.clear();
                tags.forEach(tag => {
                    tag.setAttribute('data-selected', 'false');
                    tag.classList.remove('bg-primary', 'bg-accent', 'border-primary', 'border-accent', 'shadow-md', 'shadow-primary/20', 'shadow-accent/20', 'text-white');
                    tag.classList.add('border-slate-200', 'text-slate-600', 'hover:bg-slate-50', 'hover:border-slate-300');
                    const icon = tag.querySelector('.check-icon');
                    if (icon) icon.remove();
                });
                tagCountSpan.innerText = '0';
                step2ContinueBtn.disabled = true;
                step2ContinueBtn.classList.add('opacity-50', 'cursor-not-allowed');
                step2ContinueBtn.classList.remove('hover:scale-[1.02]');
                step2ContinueBtn.innerHTML = `Tiếp tục (0/4)`;

                const allCards = document.querySelectorAll('.role-card');
                allCards.forEach(c => {
                    c.style.opacity = '1';
                    c.style.pointerEvents = 'auto';
                    c.classList.remove('ring-4', 'ring-primary/50', 'scale-[1.02]');
                });

                setTimeout(() => {
                    backdrop.classList.remove('opacity-0');
                    backdrop.classList.add('opacity-100');
                    content.classList.remove('opacity-0', 'scale-95');
                    content.classList.add('opacity-100', 'scale-100');
                }, 10);
            };

            window.closeOnboardingModal = function () {
                backdrop.classList.remove('opacity-100');
                backdrop.classList.add('opacity-0');
                content.classList.remove('opacity-100', 'scale-100');
                content.classList.add('opacity-0', 'scale-95');
                document.body.style.overflow = '';
                setTimeout(() => {
                    modal.classList.add('hidden');
                }, 300);
            };

        })();
    </script>