
                        let isSearchingOnDemand = null;
                        window.currentTripId = null;
                        
                        let hasPreBookTrip = null;
                        window.currentPreBookTripId = null;
                        
                        const tripData = {
                            ON_DEMAND: {
                                active: isSearchingOnDemand,
                                pickup: "null",
                                dropoff: "null"
                            },
                            PRE_BOOK: {
                                active: hasPreBookTrip,
                                pickup: "null",
                                dropoff: "null",
                                date: "null",
                                time: "null"
                            }
                        };
                        
                        // Phục hồi trạng thái UI nếu đã có chuyến xe đang tìm kiếm
                        document.addEventListener("DOMContentLoaded", function() {
                            if (isSearchingOnDemand) {
                                // Giao diện đang tìm kiếm
                                document.getElementById('empty-search-state').classList.add('hidden');
                                document.getElementById('empty-search-state').classList.remove('flex');
                                
                                document.getElementById('loading-search-state').classList.remove('hidden');
                                document.getElementById('loading-search-state').classList.add('flex');
                                
                                // Giao diện form
                                document.getElementById('pickup-input').value = tripData.ON_DEMAND.pickup;
                                document.getElementById('dropoff-input').value = tripData.ON_DEMAND.dropoff;
                                
                                // Giao diện popup
                                document.getElementById('mini-popup-pickup').textContent = "null";
                                document.getElementById('mini-popup-dropoff').textContent = "null";
                                
                                const btnSubmit = document.getElementById('btn-submit-search');
                                if (btnSubmit) {
                                    btnSubmit.type = 'button';
                                    btnSubmit.innerHTML = 'Hủy tìm kiếm <span class="material-symbols-outlined text-[20px]">cancel</span>';
                                    btnSubmit.className = 'w-full bg-red-500 hover:bg-red-600 text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                    btnSubmit.disabled = false;
                                    btnSubmit.onclick = cancelTripSearch;
                                }
                            }
                            
                            if (hasPreBookTrip) {
                                document.getElementById('mini-prebook-pickup').textContent = "null";
                                document.getElementById('mini-prebook-dropoff').textContent = "null";
                            }
                            
                            // Hiển thị popup nếu khung search đang ẩn
                            const searchBar = document.getElementById('bottom-search-bar');
                            if (searchBar && searchBar.classList.contains('translate-y-[150%]')) {
                                if (isSearchingOnDemand) {
                                    const miniPopup = document.getElementById('mini-search-popup');
                                    if (miniPopup) {
                                        miniPopup.classList.remove('translate-x-[150%]', 'opacity-0');
                                        miniPopup.classList.add('translate-x-0', 'opacity-100');
                                    }
                                }
                                if (hasPreBookTrip) {
                                    const prebookPopup = document.getElementById('mini-prebook-popup');
                                    if (prebookPopup) {
                                        prebookPopup.classList.remove('translate-x-[150%]', 'opacity-0');
                                        prebookPopup.classList.add('translate-x-0', 'opacity-100');
                                    }
                                }
                            }
                            
                            // Đóng băng form nếu tab hiện tại đang có chuyến
                            const currentTab = document.getElementById('tripType') ? document.getElementById('tripType').value : 'ON_DEMAND';
                            if (currentTab === 'ON_DEMAND') {
                                toggleFormInputs(isSearchingOnDemand);
                            } else {
                                toggleFormInputs(hasPreBookTrip);
                            }
                        });


                        function toggleFormInputs(disabled) {
                            const fields = ['pickup-input', 'dropoff-input', 'note-input', 'trip-date', 'trip-time'];
                            fields.forEach(id => {
                                const el = document.getElementById(id);
                                if (el) {
                                    el.disabled = disabled;
                                    if (disabled) {
                                        el.classList.add('bg-slate-100', 'cursor-not-allowed', 'opacity-60');
                                    } else {
                                        el.classList.remove('bg-slate-100', 'cursor-not-allowed', 'opacity-60');
                                    }
                                }
                            });
                            
                            const radios = document.querySelectorAll('input[name="vehicleType"]');
                            radios.forEach(radio => {
                                radio.disabled = disabled;
                                if (disabled) {
                                    radio.parentElement.classList.add('opacity-60', 'cursor-not-allowed');
                                } else {
                                    radio.parentElement.classList.remove('opacity-60', 'cursor-not-allowed');
                                }
                            });
                        }

                        function handleTripSearch(event) {
                            event.preventDefault(); // Ngăn chặn load lại trang
                            
                            // Validate if locations were selected from dropdown
                            const pickupLat = document.getElementById('pickup-lat').value;
                            const dropoffLat = document.getElementById('dropoff-lat').value;
                            
                            if(!pickupLat || !dropoffLat) {
                                showToast("Vui lòng chọn Điểm đón và Điểm đến từ danh sách gợi ý của bản đồ!", "error");
                                return;
                            }

                            const form = event.target;
                            
                            const tripType = document.getElementById('tripType') ? document.getElementById('tripType').value : 'ON_DEMAND';
                            if (tripType === 'ON_DEMAND') {
                                if (isSearchingOnDemand) {
                                    showToast("Bạn đang tìm kiếm một chuyến đi. Vui lòng chờ kết quả!", "warning");
                                    return; // Chặn không cho tìm thêm
                                }
                                isSearchingOnDemand = true;
                                
                                // Cập nhật thông tin lên mini popup
                                document.getElementById('mini-popup-pickup').textContent = document.getElementById('pickup-input').value || "Đang tải...";
                                document.getElementById('mini-popup-dropoff').textContent = document.getElementById('dropoff-input').value || "Đang tải...";
                                
                                // Disable nút tìm kiếm
                                const btnSubmit = document.getElementById('btn-submit-search');
                                if (btnSubmit) {
                                    btnSubmit.disabled = true;
                                    btnSubmit.classList.add('opacity-70', 'cursor-not-allowed');
                                    btnSubmit.innerHTML = 'Đang tìm kiếm... <span class="material-symbols-outlined text-[20px] animate-spin">sync</span>';
                                }
                            }
                            
                            // Ẩn state rỗng, hiện loading state
                            document.getElementById('empty-search-state').classList.add('hidden');
                            document.getElementById('empty-search-state').classList.remove('flex');
                            
                            document.getElementById('loading-search-state').classList.remove('hidden');
                            document.getElementById('loading-search-state').classList.add('flex');
                            
                            // Gửi data thực tế lên server (sử dụng x-www-form-urlencoded để tương thích với Servlet thông thường)
                            const formData = new URLSearchParams(new FormData(form));
                            formData.append("ajax", "true");
                            
                            fetch(form.action, {
                                method: form.method,
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded'
                                },
                                body: formData.toString()
                            })
                            .then(response => {
                                if (!response.ok) {
                                    throw new Error('Network response was not ok');
                                }
                                return response.json();
                            })
                            .then(data => {
                                if (data.success) {
                                    if (tripType === 'ON_DEMAND') {
                                        window.currentTripId = data.tripId;
                                        tripData.ON_DEMAND.active = true;
                                        toggleFormInputs(true);
                                        const btnSubmit = document.getElementById('btn-submit-search');
                                        if (btnSubmit) {
                                            // Đổi nút thành nút Hủy tìm kiếm
                                            btnSubmit.type = 'button';
                                            btnSubmit.innerHTML = 'Hủy tìm kiếm <span class="material-symbols-outlined text-[20px]">cancel</span>';
                                            btnSubmit.classList.remove('bg-slate-900', 'hover:bg-black', 'opacity-70', 'cursor-not-allowed');
                                            btnSubmit.classList.add('bg-red-500', 'hover:bg-red-600');
                                            btnSubmit.disabled = false;
                                            btnSubmit.onclick = cancelTripSearch;
                                        }
                                    } else if (tripType === 'PRE_BOOK') {
                                        window.currentPreBookTripId = data.tripId;
                                        hasPreBookTrip = true;
                                        tripData.PRE_BOOK.active = true;
                                        toggleFormInputs(true);
                                        const btnSubmit = document.getElementById('btn-submit-search');
                                        if (btnSubmit) {
                                            // Đổi nút thành nút Hủy đặt lịch
                                            btnSubmit.type = 'button';
                                            btnSubmit.innerHTML = 'Hủy đặt lịch <span class="material-symbols-outlined text-[20px]">cancel</span>';
                                            btnSubmit.classList.remove('bg-slate-900', 'hover:bg-black', 'opacity-70', 'cursor-not-allowed');
                                            btnSubmit.classList.add('bg-[#FF6D00]', 'hover:bg-orange-600');
                                            btnSubmit.disabled = false;
                                            btnSubmit.onclick = cancelPreBookTrip;
                                        }
                                    }
                                } else {
                                    showToast("Lỗi: " + (data.error || "Không thể tạo chuyến đi"), "error");
                                    resetSearchUI();
                                }
                            }).catch(error => {
                                console.error("Lỗi khi gửi yêu cầu tìm chuyến:", error);
                                showToast("Lỗi kết nối đến máy chủ. Hãy tải lại trang.", "error");
                                resetSearchUI();
                            });
                        }

                        function resetSearchUI() {
                            isSearchingOnDemand = false;
                            document.getElementById('loading-search-state').classList.add('hidden');
                            document.getElementById('loading-search-state').classList.remove('flex');
                            document.getElementById('empty-search-state').classList.remove('hidden');
                            document.getElementById('empty-search-state').classList.add('flex');
                            
                            const btnSubmit = document.getElementById('btn-submit-search');
                            if (btnSubmit) {
                                btnSubmit.type = 'submit';
                                btnSubmit.innerHTML = 'Tìm chuyến <span class="material-symbols-outlined text-[20px]">arrow_forward</span>';
                                btnSubmit.className = 'w-full bg-slate-900 hover:bg-black text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                btnSubmit.disabled = false;
                                btnSubmit.onclick = null;
                            }
                        }

                        function cancelTripSearch() {
                            if (!window.currentTripId) {
                                showToast("Đang xử lý, vui lòng thử lại sau giây lát.", "warning");
                                return;
                            }
                            
                            // Sử dụng Confirm Modal tuỳ chỉnh
                            showConfirmModal("Xác nhận hủy", "Bạn có chắc chắn muốn hủy yêu cầu tìm kiếm này?", function() {
                                fetch('${pageContext.request.contextPath}/trip-cancel', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                    body: 'tripId=' + window.currentTripId
                                })
                                .then(res => res.json())
                                .then(data => {
                                    if (data.success) {
                                        // Reset giao diện
                                        isSearchingOnDemand = false;
                                        window.currentTripId = null;
                                        tripData.ON_DEMAND.active = false;
                                        toggleFormInputs(false);
                                        
                                        // Xóa marker và đường đi
                                        if (window.markerOnDemand) {
                                            window.markerOnDemand.remove();
                                            window.markerOnDemand = null;
                                        }
                                        if (map.getSource('route-on-demand')) {
                                            map.removeLayer('route-on-demand');
                                            map.removeSource('route-on-demand');
                                        }
                                        
                                        // Reset fields
                                        document.getElementById('pickup-input').value = "";
                                        document.getElementById('dropoff-input').value = "";
                                        document.getElementById('pickup-lat').value = "";
                                        document.getElementById('pickup-lng').value = "";
                                        document.getElementById('dropoff-lat').value = "";
                                        document.getElementById('dropoff-lng').value = "";
                                        document.getElementById('trip-price').value = "";
                                        document.getElementById('trip-distance').value = "";
                                        document.getElementById('price-estimation-box').classList.add('hidden');
                                        
                                        // Trả lại nút Tìm chuyến nếu đang ở tab ON_DEMAND
                                        const btnSubmit = document.getElementById('btn-submit-search');
                                        if (btnSubmit && document.getElementById('tripType').value === 'ON_DEMAND') {
                                            btnSubmit.type = 'submit';
                                            btnSubmit.innerHTML = 'Tìm chuyến <span class="material-symbols-outlined text-[20px]">arrow_forward</span>';
                                            btnSubmit.className = 'w-full bg-slate-900 hover:bg-black text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                            btnSubmit.onclick = null;
                                            
                                            // Gọi lại setBookingType để làm sạch form
                                            if (window.setBookingType) window.setBookingType('ON_DEMAND');
                                        }
                                        
                                        // Ẩn loading state, hiện empty state
                                        document.getElementById('loading-search-state').classList.add('hidden');
                                        document.getElementById('loading-search-state').classList.remove('flex');
                                        document.getElementById('empty-search-state').classList.remove('hidden');
                                        document.getElementById('empty-search-state').classList.add('flex');
                                        
                                        // Ẩn mini popup
                                        const miniPopup = document.getElementById('mini-search-popup');
                                        if (miniPopup) {
                                            miniPopup.classList.add('translate-x-[150%]', 'opacity-0');
                                            miniPopup.classList.remove('translate-x-0', 'opacity-100');
                                        }
                                        
                                        showToast("Đã hủy chuyến đi thành công!", "success");
                                    } else {
                                        showToast("Lỗi khi hủy chuyến: " + (data.error || "Không xác định"), "error");
                                    }
                                });
                            });
                        }

                        function cancelPreBookTrip() {
                            if (!window.currentPreBookTripId) {
                                showToast("Đang xử lý, vui lòng thử lại sau giây lát.", "warning");
                                return;
                            }
                            
                            showConfirmModal("Xác nhận hủy", "Bạn có chắc chắn muốn hủy chuyến xe đặt trước này?", function() {
                                fetch('${pageContext.request.contextPath}/trip-cancel', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                    body: 'tripId=' + window.currentPreBookTripId
                                })
                                .then(res => res.json())
                                .then(data => {
                                    if (data.success) {
                                        hasPreBookTrip = false;
                                        window.currentPreBookTripId = null;
                                        tripData.PRE_BOOK.active = false;
                                        toggleFormInputs(false);
                                        
                                        // Xóa marker và đường đi
                                        if (window.markerPreBook) {
                                            window.markerPreBook.remove();
                                            window.markerPreBook = null;
                                        }
                                        if (map.getSource('route-pre-book')) {
                                            map.removeLayer('route-pre-book');
                                            map.removeSource('route-pre-book');
                                        }
                                        
                                        // Reset fields
                                        document.getElementById('pickup-input').value = "";
                                        document.getElementById('dropoff-input').value = "";
                                        document.getElementById('pickup-lat').value = "";
                                        document.getElementById('pickup-lng').value = "";
                                        document.getElementById('dropoff-lat').value = "";
                                        document.getElementById('dropoff-lng').value = "";
                                        document.getElementById('trip-date').value = "";
                                        document.getElementById('trip-time').value = "";
                                        document.getElementById('trip-price').value = "";
                                        document.getElementById('trip-distance').value = "";
                                        document.getElementById('price-estimation-box').classList.add('hidden');
                                        
                                        // Reset nút bấm nếu đang ở tab PRE_BOOK
                                        const btnSubmit = document.getElementById('btn-submit-search');
                                        if (btnSubmit && document.getElementById('tripType').value === 'PRE_BOOK') {
                                            btnSubmit.type = 'submit';
                                            btnSubmit.innerHTML = 'Tìm chuyến <span class="material-symbols-outlined text-[20px]">arrow_forward</span>';
                                            btnSubmit.className = 'w-full bg-slate-900 hover:bg-black text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                            btnSubmit.onclick = null;
                                            
                                            // Gọi lại setBookingType để làm sạch form
                                            if (window.setBookingType) window.setBookingType('PRE_BOOK');
                                        }
                                        
                                        // Ẩn loading state, hiện empty state
                                        document.getElementById('loading-search-state').classList.add('hidden');
                                        document.getElementById('loading-search-state').classList.remove('flex');
                                        document.getElementById('empty-search-state').classList.remove('hidden');
                                        document.getElementById('empty-search-state').classList.add('flex');

                                        // Ẩn mini popup đặt trước
                                        const prebookPopup = document.getElementById('mini-prebook-popup');
                                        if (prebookPopup) {
                                            prebookPopup.classList.add('translate-x-[150%]', 'opacity-0');
                                            prebookPopup.classList.remove('translate-x-0', 'opacity-100');
                                            
                                            const blogBar = document.getElementById('bottom-blog-bar');
                                            if (blogBar && !blogBar.classList.contains('translate-y-[150%]')) {
                                                blogBar.classList.add('translate-y-[150%]', 'opacity-0');
                                                blogBar.classList.remove('translate-y-0', 'opacity-100');
                                            }
                                            
                                            const tripPanel = document.getElementById('trip-proposals-panel');
                                            if (tripPanel && !tripPanel.classList.contains('translate-y-[150%]')) {
                                                tripPanel.classList.add('translate-y-[150%]', 'opacity-0');
                                                tripPanel.classList.remove('translate-y-0', 'opacity-100');
                                            }
                                        }
                                        
                                        showToast("Đã hủy chuyến xe đặt trước thành công!", "success");
                                    } else {
                                        showToast("Lỗi khi hủy chuyến: " + (data.error || "Không xác định"), "error");
                                    }
                                });
                            });
                        }

                        function toggleBottomSearchBar() {
                            const searchBar = document.getElementById('bottom-search-bar');
                            const blogBar = document.getElementById('bottom-blog-bar');
                            
                            if (searchBar) {
                                if (searchBar.classList.contains('translate-y-[150%]')) {
                                    // Close blog bar if open
                                    if (blogBar && !blogBar.classList.contains('translate-y-[150%]')) {
                                        blogBar.classList.add('translate-y-[150%]', 'opacity-0');
                                        blogBar.classList.remove('translate-y-0', 'opacity-100');
                                    }

                                    searchBar.classList.remove('translate-y-[150%]');
                                    searchBar.classList.remove('opacity-0');
                                    searchBar.classList.add('translate-y-0');
                                    searchBar.classList.add('opacity-100');
                                    
                                    // Ẩn mini popups khi mở search bar
                                    const miniPopup = document.getElementById('mini-search-popup');
                                    if (miniPopup) {
                                        miniPopup.classList.add('translate-x-[150%]', 'opacity-0');
                                        miniPopup.classList.remove('translate-x-0', 'opacity-100');
                                    }
                                    const prebookPopup = document.getElementById('mini-prebook-popup');
                                    if (prebookPopup) {
                                        prebookPopup.classList.add('translate-x-[150%]', 'opacity-0');
                                        prebookPopup.classList.remove('translate-x-0', 'opacity-100');
                                    }
                                } else {
                                    searchBar.classList.add('translate-y-[150%]');
                                    searchBar.classList.add('opacity-0');
                                    searchBar.classList.remove('translate-y-0');
                                    searchBar.classList.remove('opacity-100');
                                    
                                    // Hiện mini popups nếu đang tìm kiếm
                                    const miniPopup = document.getElementById('mini-search-popup');
                                    if (isSearchingOnDemand && miniPopup) {
                                        miniPopup.classList.remove('translate-x-[150%]', 'opacity-0');
                                        miniPopup.classList.add('translate-x-0', 'opacity-100');
                                    }
                                    const prebookPopup = document.getElementById('mini-prebook-popup');
                                    if (hasPreBookTrip && prebookPopup) {
                                        prebookPopup.classList.remove('translate-x-[150%]', 'opacity-0');
                                        prebookPopup.classList.add('translate-x-0', 'opacity-100');
                                    }
                                }
                            }
                        }

                        let proposalsInterval = null;

                        function toggleTripProposals() {
                            const panel = document.getElementById('trip-proposals-panel');
                            if (!panel) {
                                if (window.openAuthModal) {
                                    window.openAuthModal();
                                } else {
                                    showToast("Vui lòng đăng nhập để xem tính năng này!", "warning");
                                }
                                return;
                            }
                            
                            if (panel.classList.contains('translate-y-[150%]')) {
                                // Open panel
                                panel.classList.remove('translate-y-[150%]');
                                panel.classList.remove('opacity-0');
                                panel.classList.add('translate-y-0');
                                panel.classList.add('opacity-100');
                                
                                // Close search/blog if open
                                const searchBar = document.getElementById('bottom-search-bar');
                                if (searchBar) {
                                    searchBar.classList.add('translate-y-[150%]');
                                    searchBar.classList.add('opacity-0');
                                    searchBar.classList.remove('translate-y-0');
                                    searchBar.classList.remove('opacity-100');
                                }
                                const blogBar = document.getElementById('bottom-blog-bar');
                                if (blogBar) {
                                    blogBar.classList.add('translate-y-[150%]');
                                    blogBar.classList.add('opacity-0');
                                    blogBar.classList.remove('translate-y-0');
                                    blogBar.classList.remove('opacity-100');
                                }

                                fetchTripProposals();
                                if (proposalsInterval) clearInterval(proposalsInterval);
                                proposalsInterval = setInterval(fetchTripProposals, 30000);
                            } else {
                                // Close panel
                                panel.classList.add('translate-y-[150%]');
                                panel.classList.add('opacity-0');
                                panel.classList.remove('translate-y-0');
                                panel.classList.remove('opacity-100');
                                if (proposalsInterval) clearInterval(proposalsInterval);
                            }
                        }

                        function fetchTripProposals() {
                            const loadingEl = document.getElementById('proposals-loading');
                            const emptyEl = document.getElementById('proposals-empty');
                            const listEl = document.getElementById('proposals-list');
                            
                            if (loadingEl) loadingEl.classList.remove('hidden');
                            if (emptyEl) emptyEl.classList.add('hidden');
                            if (listEl) listEl.classList.add('hidden');
                            
                            let latQuery = "";
                            if (window.userLngLat) {
                                latQuery = "?lng=" + window.userLngLat[0] + "&lat=" + window.userLngLat[1];
                            }
                            
                            fetch('${pageContext.request.contextPath}/api/driver/proposals' + latQuery)
                                .then(res => res.json())
                                .then(data => {
                                    if (loadingEl) loadingEl.classList.add('hidden');
                                    const counterEl = document.getElementById('trip-proposals-counter');
                                    
                                    if (data.success && data.trips && data.trips.length > 0) {
                                        if (listEl) listEl.classList.remove('hidden');
                                        renderTripProposals(data.trips);
                                        // Update UI counter
                                        if (counterEl) counterEl.textContent = data.trips.length + " chuyến đang chờ";
                                    } else {
                                        if (emptyEl) emptyEl.classList.remove('hidden');
                                        if (counterEl) counterEl.textContent = "0 chuyến đang chờ";
                                    }
                                })
                                .catch(err => {
                                    console.error(err);
                                    if (loadingEl) loadingEl.classList.add('hidden');
                                    if (emptyEl) emptyEl.classList.remove('hidden');
                                    const counterEl = document.getElementById('trip-proposals-counter');
                                    if (counterEl) counterEl.textContent = "0 chuyến đang chờ";
                                });
                        }

                        function renderTripProposals(trips) {
                            const list = document.getElementById('proposals-list');
                            if (!list) return;
                            list.innerHTML = '';
                            trips.forEach(trip => {
                                const formattedPrice = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(trip.price);
                                const note = trip.noteForDriver ? trip.noteForDriver : 'Không có lưu ý';
                                
                                const html = '<div class="bg-white border border-slate-200 rounded-2xl p-4 flex flex-col gap-3 shadow-sm hover:shadow-md transition-shadow">' +
                                    '<div class="flex justify-between items-start">' +
                                        '<div class="flex-1 pr-4">' +
                                            '<div class="flex items-center gap-2 mb-1">' +
                                                '<div class="w-2.5 h-2.5 rounded-full bg-[#6200EE]"></div>' +
                                                '<p class="text-sm font-bold text-slate-800 truncate" title="' + trip.pickupLocation + '">' + trip.pickupLocation + '</p>' +
                                            '</div>' +
                                            '<div class="w-0.5 h-3 bg-slate-200 ml-1 mb-1"></div>' +
                                            '<div class="flex items-center gap-2">' +
                                                '<span class="material-symbols-outlined text-[#FF6D00] text-[14px]">location_on</span>' +
                                                '<p class="text-sm font-bold text-slate-800 truncate" title="' + trip.dropoffLocation + '">' + trip.dropoffLocation + '</p>' +
                                            '</div>' +
                                        '</div>' +
                                        '<div class="text-right shrink-0">' +
                                            '<p class="text-lg font-black text-[#FF6D00]">' + formattedPrice + '</p>' +
                                            '<p class="text-xs text-slate-500 font-medium">Khoảng cách: ' + trip.distance + ' km</p>' +
                                        '</div>' +
                                    '</div>' +
                                    '<div class="flex items-center gap-2 bg-orange-50 rounded-lg p-2 mt-1">' +
                                        '<span class="material-symbols-outlined text-[#FF6D00] text-[16px]">info</span>' +
                                        '<p class="text-xs text-slate-600">' + note + '</p>' +
                                    '</div>' +
                                    '<div class="flex gap-3 mt-2">' +
                                        '<button onclick="acceptTrip(' + trip.id + ')" class="flex-1 bg-slate-900 hover:bg-black text-white font-bold py-2.5 rounded-xl transition-colors shadow-sm flex items-center justify-center gap-2">' +
                                            '<span class="material-symbols-outlined text-[18px]">done_outline</span>' +
                                            'Nhận chuyến' +
                                        '</button>' +
                                    '</div>' +
                                '</div>';
                                list.insertAdjacentHTML('beforeend', html);
                            });
                        }

                        function acceptTrip(tripId) {
                            if (confirm('Bạn có chắc chắn muốn nhận chuyến này không?')) {
                                fetch('${pageContext.request.contextPath}/api/driver/accept', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                    body: 'tripId=' + tripId
                                })
                                .then(res => res.json())
                                .then(data => {
                                    if(data.success) {
                                        showToast('Nhận chuyến thành công! Vui lòng liên hệ hành khách.', 'success');
                                        
                                        const searchBar = document.getElementById('bottom-search-bar');
                                        if (searchBar && !searchBar.classList.contains('translate-y-[150%]')) {
                                            searchBar.classList.add('translate-y-[150%]');
                                            searchBar.classList.add('opacity-0');
                                            searchBar.classList.remove('translate-y-0');
                                            searchBar.classList.remove('opacity-100');
                                        }
                                        
                                        const tripPanel = document.getElementById('trip-proposals-panel');
                                        if (tripPanel && !tripPanel.classList.contains('translate-y-[150%]')) {
                                            tripPanel.classList.add('translate-y-[150%]');
                                            tripPanel.classList.add('opacity-0');
                                            tripPanel.classList.remove('translate-y-0');
                                            tripPanel.classList.remove('opacity-100');
                                        }

                                        const blogBar = document.getElementById('bottom-blog-bar');
                                        if (blogBar) {
                                            blogBar.classList.remove('translate-y-[150%]');
                                            blogBar.classList.remove('opacity-0');
                                            blogBar.classList.add('translate-y-0');
                                            blogBar.classList.add('opacity-100');
                                        }
                                        
                                        fetchTripProposals(); // Reload list
                                    } else {
                                        showToast('Lỗi: ' + data.message, 'error');
                                    }
                                })
                                .catch(err => {
                                    console.error(err);
                                    showToast('Lỗi kết nối máy chủ.', 'error');
                                });
                            }
                        }

                        function toggleBottomBlogBar() {
                            const searchBar = document.getElementById('bottom-search-bar');
                            const blogBar = document.getElementById('bottom-blog-bar');
                            if (blogBar) {
                                if (blogBar.classList.contains('translate-y-[150%]')) {
                                    // Đang ẩn -> Mở lên
                                    // Đóng search bar nếu đang mở
                                    if (searchBar && !searchBar.classList.contains('translate-y-[150%]')) {
                                        searchBar.classList.add('translate-y-[150%]', 'opacity-0');
                                        searchBar.classList.remove('translate-y-0', 'opacity-100');
                                    }

                                    blogBar.classList.remove('translate-y-[150%]', 'opacity-0');
                                    blogBar.classList.add('translate-y-0', 'opacity-100');
                                    
                                    // Ẩn mini popups
                                    const miniPopup = document.getElementById('mini-search-popup');
                                    if (miniPopup) {
                                        miniPopup.classList.add('translate-x-[150%]', 'opacity-0');
                                        miniPopup.classList.remove('translate-x-0', 'opacity-100');
                                    }
                                    const prebookPopup = document.getElementById('mini-prebook-popup');
                                    if (prebookPopup) {
                                        prebookPopup.classList.add('translate-x-[150%]', 'opacity-0');
                                        prebookPopup.classList.remove('translate-x-0', 'opacity-100');
                                    }
                                } else {
                                    // Đang mở -> Đóng lại
                                    blogBar.classList.add('translate-y-[150%]', 'opacity-0');
                                    blogBar.classList.remove('translate-y-0', 'opacity-100');
                                    
                                    // Hiện lại mini popups nếu đang có
                                    const miniPopup = document.getElementById('mini-search-popup');
                                    if (isSearchingOnDemand && miniPopup) {
                                        miniPopup.classList.remove('translate-x-[150%]', 'opacity-0');
                                        miniPopup.classList.add('translate-x-0', 'opacity-100');
                                    }
                                    const prebookPopup = document.getElementById('mini-prebook-popup');
                                    if (hasPreBookTrip && prebookPopup) {
                                        prebookPopup.classList.remove('translate-x-[150%]', 'opacity-0');
                                        prebookPopup.classList.add('translate-x-0', 'opacity-100');
                                    }
                                }
                            }
                        }
                    
