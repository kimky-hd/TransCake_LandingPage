<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <title>Một điều bí mật dành cho Khánh ✨</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/transcake-04.png" />
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@500;700&family=Quicksand:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        body {
            /* Màn nền chuyển màu gradient nhè nhẹ cực xinh */
            background: linear-gradient(-45deg, #FFE5EC, #FFC2D1, #FFF0F3, #FAD0C4);
            background-size: 400% 400%;
            animation: gradientBG 15s ease infinite;
            font-family: 'Quicksand', sans-serif; /* Đổi sang font Quicksand trông tròn trịa đáng yêu hơn Inter */
            overflow-x: hidden;
            color: #5A4A4A; 
        }

        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        
        .handwriting {
            font-family: 'Dancing Script', cursive;
            color: #D25E78;
        }
        
        /* Hiệu ứng trượt từng dòng chữ */
        .slide-up-item {
            opacity: 0;
            transform: translateY(30px);
            animation: slideUp 1s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards;
        }

        @keyframes slideUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Gán độ trễ cho từng khối text */
        .delay-1 { animation-delay: 1.0s; }
        .delay-2 { animation-delay: 2.5s; }
        .delay-3 { animation-delay: 4.5s; }
        .delay-4 { animation-delay: 6.5s; }
        .delay-5 { animation-delay: 8.5s; }
        .delay-6 { animation-delay: 9.5s; } /* Nút bấm xuất hiện sau cùng */

        /* Panel kính bo cong cực tròn trịa mềm mại */
        .glass-panel {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border-radius: 35px;
            box-shadow: 0 15px 45px rgba(255, 154, 158, 0.2);
            border: 2px solid rgba(255, 255, 255, 0.8);
            position: relative;
        }
        
        /* Cục bông sáng (glow) đằng sau panel */
        .glass-panel::before {
            content: '';
            position: absolute;
            top: -10px; right: -10px; bottom: -10px; left: -10px;
            background: linear-gradient(135deg, rgba(255,255,255,0.4), rgba(255,255,255,0));
            border-radius: 40px;
            z-index: -1;
        }

        /* Input Form */
        .romantic-input {
            background: rgba(255, 255, 255, 0.9);
            border: 2px solid #FFE5EC;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: inset 0 2px 5px rgba(0,0,0,0.02);
        }
        .romantic-input:focus {
            border-color: #FF9A9E;
            outline: none;
            transform: scale(1.02);
            box-shadow: 0 5px 20px rgba(255, 154, 158, 0.25);
        }
        
        /* Nút bấm nhảy nhẹ (Pulse) để gọi chú ý */
        .romantic-btn {
            background: linear-gradient(to right, #FF9A9E 0%, #FECFEF 50%, #FF9A9E 100%);
            background-size: 200% auto;
            color: #D25E78;
            border: 2px solid white;
            box-shadow: 0 8px 25px rgba(255, 154, 158, 0.5);
            transition: 0.5s;
            animation: pulse-soft 2s infinite;
        }
        .romantic-btn:hover {
            background-position: right center;
            transform: translateY(-3px) scale(1.03);
            box-shadow: 0 12px 30px rgba(255, 154, 158, 0.6);
            animation: none;
        }
        .romantic-btn:active {
            transform: scale(0.96);
        }

        @keyframes pulse-soft {
            0% { box-shadow: 0 0 0 0 rgba(255, 154, 158, 0.6); }
            70% { box-shadow: 0 0 0 15px rgba(255, 154, 158, 0); }
            100% { box-shadow: 0 0 0 0 rgba(255, 154, 158, 0); }
        }

        /* Hạt bụi / Emojis bay bay cực đáng yêu */
        .floating-element {
            position: absolute;
            pointer-events: none;
            animation: float-up-down ease-in-out infinite, sway ease-in-out infinite alternate;
        }
        @keyframes float-up-down {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-30px); }
        }
        @keyframes sway {
            from { margin-left: -15px; }
            to { margin-left: 15px; }
        }

        .heart-beat {
            display: inline-block;
            animation: heartbeat 1.5s infinite;
        }
        @keyframes heartbeat {
            0%, 100% { transform: scale(1); }
            25% { transform: scale(1.15); }
            50% { transform: scale(1); }
            75% { transform: scale(1.15); }
        }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center p-5 relative">

    <!-- Cảnh vật bay lơ lửng xung quanh (Floating elements) -->
    <div class="floating-element text-4xl" style="top: 15%; left: 5%; animation-duration: 6s, 8s;">🌸</div>
    <div class="floating-element text-2xl" style="top: 10%; right: 15%; animation-duration: 5s, 7s; animation-delay: 1s;">✨</div>
    <div class="floating-element text-5xl" style="bottom: 15%; left: 10%; animation-duration: 7s, 6s; animation-delay: 2s;">🎀</div>
    <div class="floating-element text-3xl" style="bottom: 20%; right: 8%; animation-duration: 8s, 5s; animation-delay: 0.5s;">💌</div>
    <div class="floating-element text-2xl" style="top: 40%; left: -2%; animation-duration: 9s, 6s;">🫧</div>
    <div class="floating-element text-4xl" style="top: 50%; right: -5%; animation-duration: 6s, 9s; animation-delay: 1.5s;">☁️</div>

    <!-- Khối hộp kính ở giữa -->
    <div class="glass-panel w-full max-w-sm px-7 py-10 md:max-w-md md:p-12 text-center z-10">
        
        <!-- Tiêu đề lãng mạn -->
        <h1 class="handwriting text-[38px] sm:text-5xl md:text-6xl font-bold mb-8 slide-up-item delay-1 whitespace-nowrap flex items-center justify-center gap-1">
            Chào Khánh xinh, <span class="heart-beat">🌸</span>
        </h1>
        
        <!-- Nội dung xuất hiện từng dòng -->
        <div class="space-y-6 text-[16px] font-medium leading-relaxed mb-10 text-left text-[#6E5A5A]">
            <p class="slide-up-item delay-2 bg-white/40 p-4 rounded-2xl shadow-sm border border-white/60">
                Sinh nhật này em đã có kế hoạch gì chưa? 🤔
            </p>
            
            <p class="slide-up-item delay-3 bg-white/40 p-4 rounded-2xl shadow-sm border border-white/60">
                Anh có một món quà nho nhỏ muốn tự tay gửi tặng cho em... <span class="text-xl inline-block animate-bounce">🎁</span><br>
                <span class="mt-2 block">Nhưng mà để bật mí món quà đó, em có sẵn sàng tham gia một chuyến phiêu lưu bí mật cùng anh không?</span>
            </p>
            
            <p class="slide-up-item delay-4 bg-white/40 p-4 rounded-2xl shadow-sm border border-white/60">
                Hành trình nhỏ của chúng mình sẽ bắt đầu từ lúc <strong>7h00 đến 12h00 ngày 09/07/2026</strong>. Và điều bất ngờ nhất sẽ đợi em ở cuối con đường đó nha! 🥰
            </p>
            
            <p class="slide-up-item delay-5 text-[14px] text-center italic text-[#8A7A7A] pt-2">
                Nếu em đồng ý đi chơi cùng anh, em nhập email vào đây để anh gửi timeline chi tiết qua cho em nhé: 👇
            </p>
        </div>

        <!-- Form nhập email (Xuất hiện cuối cùng) -->
        <form id="inviteForm" class="space-y-5 slide-up-item delay-6 relative">
            <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                    <span class="text-xl">💌</span>
                </div>
                <input type="email" id="emailInput" required
                    class="romantic-input w-full pl-12 pr-5 py-4 rounded-3xl text-gray-700 font-bold placeholder-[#D25E78]/40"
                    placeholder="Email của Khánh là...">
            </div>
            
            <button type="submit" id="submitBtn"
                class="romantic-btn w-full px-5 py-4 rounded-3xl font-bold text-[17px] flex items-center justify-center gap-2">
                <span>Đi thôi anh!</span>
                <span class="text-2xl heart-beat">💖</span>
            </button>
        </form>

        <!-- Trạng thái Loading / Success -->
        <div id="loadingMsg" class="hidden mt-6 text-[#D25E78] font-bold animate-pulse">
            <div class="flex items-center justify-center gap-2">
                <svg class="animate-spin h-5 w-5 text-[#D25E78]" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Đang cất giữ một bí mật... ✍️
            </div>
        </div>

        <div id="successMsg" class="hidden mt-6 p-6 bg-white/80 rounded-3xl border border-[#FFC2D1] shadow-lg transform transition-all duration-500 scale-100">
            <p class="handwriting text-4xl mb-3 text-[#D25E78]">Anh nhận được rồi! 📬</p>
            <p class="font-bold text-[#5A4A4A]">Email của em đã được lưu lại</p>
            <p class="text-[14px] mt-2 font-medium text-[#8A7A7A]">Anh sẽ đích thân gửi timeline bí mật vào email này cho em sớm nha! 💕</p>
        </div>

        <div id="errorMsg" class="hidden mt-5 text-red-500 text-[14px] font-bold bg-red-50/80 p-3 rounded-2xl">
            Có lỗi xíu xiu rồi, em thử lại nha! 😢
        </div>
    </div>

    <script>
        document.getElementById('inviteForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const email = document.getElementById('emailInput').value;
            const btn = document.getElementById('submitBtn');
            const form = document.getElementById('inviteForm');
            const loading = document.getElementById('loadingMsg');
            const success = document.getElementById('successMsg');
            const error = document.getElementById('errorMsg');

            // Hiệu ứng Loading
            btn.disabled = true;
            btn.classList.add('scale-95', 'opacity-50');
            loading.classList.remove('hidden');
            error.classList.add('hidden');

            fetch('${pageContext.request.contextPath}/moikhanhdichoi', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'email=' + encodeURIComponent(email)
            })
            .then(response => response.json())
            .then(data => {
                loading.classList.add('hidden');
                if(data.success) {
                    form.classList.add('hidden'); // Ẩn form đi
                    success.classList.remove('hidden');
                    
                    // Thả thêm tim rơi lả tả khi thành công
                    for(let i=0; i<10; i++) {
                        let heart = document.createElement('div');
                        heart.innerHTML = ['💕','✨','🌸','🎈'][Math.floor(Math.random()*4)];
                        heart.className = 'absolute text-3xl z-50 pointer-events-none';
                        heart.style.left = Math.random() * 100 + 'vw';
                        heart.style.top = '-50px';
                        heart.style.transition = 'top 3s ease-in, opacity 3s';
                        document.body.appendChild(heart);
                        
                        setTimeout(() => {
                            heart.style.top = '100vh';
                            heart.style.opacity = '0';
                        }, 100);
                        
                        setTimeout(() => heart.remove(), 3100);
                    }
                } else {
                    btn.disabled = false;
                    btn.classList.remove('scale-95', 'opacity-50');
                    error.textContent = data.message || "Có lỗi xíu xiu rồi, em thử lại nha! 😢";
                    error.classList.remove('hidden');
                }
            })
            .catch(err => {
                console.error(err);
                loading.classList.add('hidden');
                btn.disabled = false;
                btn.classList.remove('scale-95', 'opacity-50');
                error.textContent = "Lỗi mạng rồi, em thử bật 4G gửi lại nha!";
                error.classList.remove('hidden');
            });
        });
    </script>
</body>
</html>
