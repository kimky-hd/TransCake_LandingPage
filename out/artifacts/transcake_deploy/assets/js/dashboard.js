                                            let isSearchingOnDemand = <%= activeTrip != null ? "true" : "false" %>;
                                            window.currentTripId = <%= activeTrip != null ? activeTrip.getId() : "null" %>;

                                            let hasPreBookTrip = <%= activePreBookTrip != null ? "true" : "false" %>;
                                            window.currentPreBookTripId = <%= activePreBookTrip != null ? activePreBookTrip.getId() : "null" %>;

                                            const tripData = window.TransCakeConfig.tripData;

                                            // Phục hồi trạng thái UI nếu đã có chuyến xe đang tìm kiếm
                                            document.addEventListener("DOMContentLoaded", function () {
                                                if (isSearchingOnDemand) {
                                                    // Giao diện đang tìm kiếm
                                                    document.getElementById('empty-search-state').classList.add('hidden');
                                                    document.getElementById('empty-search-state').classList.remove('flex');

                                                    document.getElementById('loading-search-state').classList.remove('hidden');
                                                    if (document.getElementById('matched-driver-state')) {
                                                        document.getElementById('matched-driver-state').classList.add('hidden');
                                                        document.getElementById('matched-driver-state').classList.remove('flex');
                                                    }
                                                    document.getElementById('loading-search-state').classList.add('flex');

                                                    // Giao diện form
                                                    document.getElementById('pickup-input').value = tripData.ON_DEMAND.pickup;
                                                    document.getElementById('dropoff-input').value = tripData.ON_DEMAND.dropoff;

                                                    // Giao diện popup
                                                    document.getElementById('mini-popup-pickup').textContent = tripData.ON_DEMAND.pickup;
                                                    document.getElementById('mini-popup-dropoff').textContent = tripData.ON_DEMAND.dropoff;

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
                                                    document.getElementById('mini-prebook-pickup').textContent = tripData.PRE_BOOK.pickup;
                                                    document.getElementById('mini-prebook-dropoff').textContent = tripData.PRE_BOOK.dropoff;
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

                                                // Bắt đầu polling tìm tài xế nếu có chuyến đang hoạt động
                                                if (isSearchingOnDemand || hasPreBookTrip) {
                                                    checkPassengerTripStatus(); // Check immediately to display matched driver info on reload
                                                    passengerStatusInterval = setInterval(checkPassengerTripStatus, 5000);
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

                                                if (!pickupLat || !dropoffLat) {
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
                                                if (document.getElementById('matched-driver-state')) {
                                                    document.getElementById('matched-driver-state').classList.add('hidden');
                                                    document.getElementById('matched-driver-state').classList.remove('flex');
                                                }
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
                                                if (document.getElementById('matched-driver-state')) {
                                                    document.getElementById('matched-driver-state').classList.add('hidden');
                                                    document.getElementById('matched-driver-state').classList.remove('flex');
                                                }
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

                                            let passengerStatusInterval = null;

                                            function checkPassengerTripStatus() {
                                                fetch((window.TransCakeConfig.contextPath + ''))
                                                    .then(res => res.json())
                                                    .then(data => {
                                                        if (data.success && data.status === 'MATCHED' && data.driver) {
                                                            // Ẩn mini-search-popup và mini-prebook-popup
                                                            const searchPopup = document.getElementById('mini-search-popup');
                                                            if (searchPopup) {
                                                                searchPopup.classList.add('translate-x-[150%]', 'opacity-0');
                                                                searchPopup.classList.remove('translate-x-0', 'opacity-100');
                                                            }
                                                            const prebookPopup = document.getElementById('mini-prebook-popup');
                                                            if (prebookPopup) {
                                                                prebookPopup.classList.add('translate-x-[150%]', 'opacity-0');
                                                                prebookPopup.classList.remove('translate-x-0', 'opacity-100');
                                                            }

                                                            // Hiển thị matched-driver-state trong "Kết quả nổi bật"
                                                            document.getElementById('loading-search-state').classList.add('hidden');
                                                            document.getElementById('loading-search-state').classList.remove('flex');

                                                            const matchedState = document.getElementById('matched-driver-state');
                                                            if (matchedState) {
                                                                document.getElementById('inline-driver-name').textContent = data.driver.fullName;
                                                                document.getElementById('inline-driver-phone').textContent = data.driver.phoneNumber;
                                                                document.getElementById('inline-driver-vehicle').textContent = data.driver.vehicleName + " (" + data.driver.vehicleType + ")";
                                                                document.getElementById('inline-driver-plate').textContent = data.driver.licensePlate;
                                                                document.getElementById('inline-driver-hobbies').textContent = data.driver.hobbies ? data.driver.hobbies : "Không có";

                                                                matchedState.classList.remove('hidden');
                                                                matchedState.classList.add('flex');
                                                            }

                                                            // Thay đổi nút "Hủy tìm kiếm" thành "Chuyến đi sắp bắt đầu"
                                                            const btnSubmit = document.getElementById('btn-submit-search');
                                                            if (btnSubmit) {
                                                                btnSubmit.innerHTML = 'Chuyến đi sắp bắt đầu <span class="material-symbols-outlined text-[20px]">check_circle</span>';
                                                                btnSubmit.className = 'w-full bg-green-500 text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(34,197,94,0.3)] flex items-center justify-center gap-2 text-lg mt-auto cursor-not-allowed';
                                                                btnSubmit.onclick = null;
                                                            }

                                                            // Dừng polling khi đã tìm thấy tài xế
                                                            if (passengerStatusInterval) {
                                                                clearInterval(passengerStatusInterval);
                                                                passengerStatusInterval = null;
                                                            }
                                                        } else if (data.success && data.status === 'NO_ACTIVE_TRIP') {
                                                            // Chuyến đi bị xoá hoặc huỷ từ đâu đó, có thể dọn giao diện, hoặc ngừng polling
                                                            if (passengerStatusInterval) {
                                                                clearInterval(passengerStatusInterval);
                                                                passengerStatusInterval = null;
                                                            }
                                                        }
                                                    })
                                                    .catch(err => console.error('Lỗi khi cập nhật trạng thái cuốc xe:', err));
                                            }

                                            function cancelTripSearch() {
                                                if (!window.currentTripId) {
                                                    showToast("Đang xử lý, vui lòng thử lại sau giây lát.", "warning");
                                                    return;
                                                }

                                                // Sử dụng Confirm Modal tuỳ chỉnh
                                                showConfirmModal("Xác nhận hủy", "Bạn có chắc chắn muốn hủy yêu cầu tìm kiếm này?", function () {
                                                    fetch((window.TransCakeConfig.contextPath + ''), {
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
                                                                if (document.getElementById('matched-driver-state')) {
                                                                    document.getElementById('matched-driver-state').classList.add('hidden');
                                                                    document.getElementById('matched-driver-state').classList.remove('flex');
                                                                }
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

                                                showConfirmModal("Xác nhận hủy", "Bạn có chắc chắn muốn hủy chuyến xe đặt trước này?", function () {
                                                    fetch((window.TransCakeConfig.contextPath + ''), {
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
                                                                if (document.getElementById('matched-driver-state')) {
                                                                    document.getElementById('matched-driver-state').classList.add('hidden');
                                                                    document.getElementById('matched-driver-state').classList.remove('flex');
                                                                }
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
                                                if (typeof userLngLat !== 'undefined' && userLngLat && userLngLat.length === 2) {
                                                    latQuery = "?lng=" + userLngLat[0] + "&lat=" + userLngLat[1];
                                                }

                                                fetch((window.TransCakeConfig.contextPath + '') + latQuery)
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

                                                    const html = '<div class="bg-white border border-slate-200 rounded-2xl p-4 shadow-sm hover:shadow-md transition-shadow grid grid-cols-[55%_45%] gap-4 items-stretch">' +
                                                        '<!-- Left Column: Trip Info -->' +
                                                        '<div class="flex flex-col gap-3 pr-4 border-r border-slate-100 min-w-0">' +
                                                        '<div class="flex justify-between items-start min-w-0">' +
                                                        '<div class="flex-1 min-w-0">' +
                                                        '<div class="flex items-center gap-2 mb-1">' +
                                                        '<div class="w-2.5 h-2.5 rounded-full bg-[#6200EE] shrink-0"></div>' +
                                                        '<p class="text-sm font-bold text-slate-800 truncate" title="' + trip.pickupLocation + '">' + trip.pickupLocation + '</p>' +
                                                        '</div>' +
                                                        '<div class="w-0.5 h-3 bg-slate-200 ml-1 mb-1"></div>' +
                                                        '<div class="flex items-center gap-2">' +
                                                        '<span class="material-symbols-outlined text-[#FF6D00] text-[14px] shrink-0">location_on</span>' +
                                                        '<p class="text-sm font-bold text-slate-800 truncate" title="' + trip.dropoffLocation + '">' + trip.dropoffLocation + '</p>' +
                                                        '</div>' +
                                                        '</div>' +
                                                        '<div class="text-right shrink-0 ml-3">' +
                                                        '<p class="text-lg font-black text-[#FF6D00] whitespace-nowrap">' + formattedPrice + '</p>' +
                                                        '<p class="text-xs text-slate-500 font-medium whitespace-nowrap">' + trip.distance + ' km</p>' +
                                                        '</div>' +
                                                        '</div>' +
                                                        '<div class="flex items-center gap-2 bg-orange-50 rounded-lg p-2 mt-1 min-w-0">' +
                                                        '<span class="material-symbols-outlined text-[#FF6D00] text-[16px] shrink-0">info</span>' +
                                                        '<p class="text-xs text-slate-600 truncate">' + note + '</p>' +
                                                        '</div>' +
                                                        '<div class="flex mt-auto pt-2">' +
                                                        '<button onclick="acceptTrip(' + trip.id + ')" class="w-full bg-slate-900 hover:bg-black text-white font-bold py-2.5 rounded-xl transition-colors shadow-sm flex items-center justify-center gap-2">' +
                                                        '<span class="material-symbols-outlined text-[18px]">done_outline</span>' +
                                                        'Nhận chuyến' +
                                                        '</button>' +
                                                        '</div>' +
                                                        '</div>' +
                                                        '<!-- Right Column: Passenger Info Placeholder -->' +
                                                        '<div class="flex flex-col items-center justify-center gap-3 bg-slate-50 rounded-xl p-4 border border-dashed border-slate-200 h-full">' +
                                                        '<span class="material-symbols-outlined text-slate-300 text-[40px]">person_off</span>' +
                                                        '<p class="text-sm font-medium text-slate-400 text-center leading-relaxed">Thông tin hành khách<br>sẽ hiển thị sau khi nhận chuyến</p>' +
                                                        '</div>' +
                                                        '</div>';
                                                    list.insertAdjacentHTML('beforeend', html);
                                                });
                                            }

                                            function acceptTrip(tripId) {
                                                if (window.showConfirmModal) {
                                                    window.showConfirmModal('Nhận chuyến', 'Bạn có chắc chắn muốn nhận chuyến này không?', function () {
                                                        executeAcceptTrip(tripId);
                                                    });
                                                } else {
                                                    if (confirm('Bạn có chắc chắn muốn nhận chuyến này không?')) {
                                                        executeAcceptTrip(tripId);
                                                    }
                                                }
                                            }

                                            function executeAcceptTrip(tripId) {
                                                fetch((window.TransCakeConfig.contextPath + ''), {
                                                    method: 'POST',
                                                    headers: { 'Content-Type': 'application/json' },
                                                    body: JSON.stringify({ tripId: tripId })
                                                })
                                                    .then(res => res.json())
                                                    .then(data => {
                                                        if (data.success) {
                                                            showToast('Nhận chuyến thành công! Vui lòng liên hệ hành khách.', 'success');

                                                            const searchBar = document.getElementById('bottom-search-bar');
                                                            if (searchBar && !searchBar.classList.contains('translate-y-[150%]')) {
                                                                searchBar.classList.add('translate-y-[150%]');
                                                                searchBar.classList.add('opacity-0');
                                                                searchBar.classList.remove('translate-y-0');
                                                                searchBar.classList.remove('opacity-100');
                                                            }

                                                            checkDriverTripStatus(); // Switch to active trip UI
                                                        } else {
                                                            showToast(data.message || 'Có lỗi xảy ra, vui lòng thử lại.', 'error');
                                                        }
                                                    })
                                                    .catch(err => {
                                                        console.error("Lỗi acceptTrip:", err);
                                                        showToast('Lỗi kết nối máy chủ.', 'error');
                                                    });
                                            }

                                            let driverStatusInterval = null;

                                            function checkDriverTripStatus() {
                                                fetch((window.TransCakeConfig.contextPath + ''))
                                                    .then(res => res.json())
                                                    .then(data => {
                                                        const listEl = document.getElementById('proposals-list');
                                                        const activeStateEl = document.getElementById('driver-active-trip-state');
                                                        const titleEl = document.getElementById('trip-proposals-title');

                                                        if (data.active && data.trip) {
                                                            // Show active trip UI
                                                            if (listEl) listEl.classList.add('hidden');
                                                            if (activeStateEl) {
                                                                activeStateEl.classList.remove('hidden');
                                                                activeStateEl.classList.add('flex');
                                                            }

                                                            // Open trip-proposals-panel if it's hidden
                                                            const tripPanel = document.getElementById('trip-proposals-panel');
                                                            if (tripPanel && tripPanel.classList.contains('translate-x-[150%]')) {
                                                                tripPanel.classList.remove('translate-x-[150%]', 'opacity-0');
                                                                tripPanel.classList.add('translate-x-0', 'opacity-100');
                                                            }
                                                            if (titleEl) titleEl.textContent = 'Chuyến đi đang thực hiện';

                                                            // Populate data
                                                            const trip = data.trip;
                                                            document.getElementById('active-trip-pickup').textContent = trip.pickupLocation;
                                                            document.getElementById('active-trip-dropoff').textContent = trip.dropoffLocation;
                                                            const formattedPrice = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(trip.price);
                                                            document.getElementById('active-trip-price').textContent = formattedPrice;
                                                            document.getElementById('active-trip-distance').textContent = trip.distance + ' km';

                                                            document.getElementById('active-trip-passenger-name').textContent = trip.passengerName || 'Khách hàng';
                                                            document.getElementById('active-trip-passenger-phone').textContent = trip.passengerPhone || 'Không có';

                                                            if (trip.passengerGender === 'MALE') {
                                                                document.getElementById('active-trip-passenger-gender').textContent = 'Nam';
                                                            } else if (trip.passengerGender === 'FEMALE') {
                                                                document.getElementById('active-trip-passenger-gender').textContent = 'Nữ';
                                                            } else {
                                                                document.getElementById('active-trip-passenger-gender').textContent = 'Khác';
                                                            }

                                                            if (trip.passengerPhone) {
                                                                document.getElementById('active-trip-call-btn').href = 'tel:' + trip.passengerPhone;
                                                            }
                                                        } else {
                                                            // Show proposals list
                                                            if (activeStateEl) {
                                                                activeStateEl.classList.add('hidden');
                                                                activeStateEl.classList.remove('flex');
                                                            }
                                                            if (titleEl) titleEl.textContent = 'Chuyến đi dành cho bạn';
                                                            if (listEl) listEl.classList.remove('hidden');
                                                            fetchTripProposals();
                                                        }
                                                    })
                                                    .catch(err => console.error("Lỗi checkDriverTripStatus:", err));
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
                                        </script>
                                        <% } %>

                                            <!-- Locate Me Button -->
                                            <button onclick="recenterMap()"
                                                class="absolute bottom-8 right-8 z-20 w-14 h-14 bg-white text-slate-700 hover:text-[#6200EE] rounded-full shadow-[0_8px_20px_rgba(0,0,0,0.15)] flex items-center justify-center transition-all hover:scale-105 border border-slate-200"
                                                title="Vị trí của tôi">
                                                <span class="material-symbols-outlined text-[28px]">my_location</span>
                                            </button>

                                            <!-- Script to handle switching roles -->
                                            <script>
                                                const initialUserRole = window.TransCakeConfig.userRole;
                                                const hasVehicle = window.TransCakeConfig.hasVehicle;
                                                window.verificationStatus = window.TransCakeConfig.verificationStatus;
                                                let currentUserRole = 'passenger'; // default UI state is passenger
                                                window.userFullName = window.TransCakeConfig.userFullName;

                                                document.addEventListener('DOMContentLoaded', function () {
                                                    if (initialUserRole === 'driver') {
                                                        currentUserRole = 'driver';
                                                        setRole('driver', true);
                                                        checkDriverTripStatus();
                                                    } else {
                                                        currentUserRole = 'passenger';
                                                    }
                                                });

                                                let userLngLat = [105.8542, 21.0285]; // Default: Hanoi

                                                function recenterMap() {
                                                    if (window.mapInstance) {
                                                        window.mapInstance.flyTo({
                                                            center: userLngLat,
                                                            zoom: 15,
                                                            speed: 1.2
                                                        });
                                                    }
                                                }

                                                function setRole(role, bypassConfirm = false) {
                                                    if (role === currentUserRole && !bypassConfirm) return;

                                                    if (role === 'driver' && (!hasVehicle || window.verificationStatus === 'REJECTED')) {
                                                        if (window.showConfirmModal) {
                                                            let modalTitle = 'Đăng ký Đối tác Tài xế';
                                                            let modalMsg = 'Bạn cần bổ sung thông tin phương tiện để có thể chuyển sang tab này. Bạn có muốn điền thông tin đăng ký ngay không?';

                                                            if (window.verificationStatus === 'REJECTED') {
                                                                modalTitle = 'Cập nhật lại Hồ sơ Đối tác';
                                                                modalMsg = 'Hồ sơ của bạn đã bị từ chối do không hợp lệ. Vui lòng điền lại thông tin và tải lên hình ảnh rõ nét, chính xác hơn để được phê duyệt.';
                                                            }

                                                            window.showConfirmModal(
                                                                modalTitle,
                                                                modalMsg,
                                                                function () {
                                                                    if (typeof window.openDriverUpgradeModal === 'function') {
                                                                        window.openDriverUpgradeModal();
                                                                    } else if (typeof window.openOnboardingModal === 'function') {
                                                                        window.openOnboardingModal();
                                                                    } else {
                                                                        const obModal = document.getElementById('onboardingModal');
                                                                        if (obModal) {
                                                                            obModal.classList.remove('hidden');
                                                                            if (typeof window.goToStep === 'function') {
                                                                                window.goToStep(1);
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            );
                                                        } else {
                                                            alert('Vui lòng đăng ký thông tin tài xế!');
                                                        }
                                                        return; // Không chuyển tab
                                                    }

                                                    if (!bypassConfirm && role !== currentUserRole) {
                                                        if (window.showConfirmModal) {
                                                            window.showConfirmModal(
                                                                'Xác nhận chuyển đổi vai trò',
                                                                'CẢNH BÁO: Việc chuyển đổi vai trò sẽ khiến hệ thống HỦY toàn bộ chuyến xe bạn đang đặt (hoặc đang nhận). Bạn có chắc chắn muốn chuyển đổi?',
                                                                function () {
                                                                    // Gọi API để thực hiện chuyển đổi
                                                                    fetch((window.TransCakeConfig.contextPath + ''), {
                                                                        method: 'POST',
                                                                        headers: { 'Content-Type': 'application/json' },
                                                                        body: JSON.stringify({ newRole: role })
                                                                    })
                                                                        .then(res => {
                                                                            console.log("API Response status:", res.status);
                                                                            if (!res.ok) {
                                                                                throw new Error("HTTP error " + res.status);
                                                                            }
                                                                            return res.json();
                                                                        })
                                                                        .then(data => {
                                                                            if (data.success) {
                                                                                currentUserRole = role;
                                                                                setRole(role, true); // Gọi lại để đổi giao diện

                                                                                // Tải lại trang để xoá hẳn trạng thái rác và cập nhật db
                                                                                window.location.reload();
                                                                            } else {
                                                                                alert(data.message || 'Lỗi khi chuyển đổi vai trò');
                                                                            }
                                                                        })
                                                                        .catch(err => {
                                                                            console.error(err);
                                                                            alert('Lỗi kết nối mạng khi gọi API: ' + err.message);
                                                                        });
                                                                }
                                                            );
                                                        }
                                                        return;
                                                    }

                                                    const toggleBg = document.getElementById('toggle-bg');
                                                    const btnPassenger = document.getElementById('btn-passenger');
                                                    const btnDriver = document.getElementById('btn-driver');

                                                    const passView = document.getElementById('passenger-view');
                                                    const drvView = document.getElementById('driver-view');

                                                    const markerPulse = document.getElementById('marker-pulse');
                                                    const markerDot = document.getElementById('marker-dot');

                                                    const navHome = document.getElementById('nav-home');

                                                    if (role === 'passenger') {
                                                        // UI Toggle position
                                                        toggleBg.style.transform = 'translateX(0)';

                                                        // Text colors
                                                        btnPassenger.classList.remove('text-slate-500', 'hover:text-slate-700');
                                                        btnPassenger.classList.add('text-[#6200EE]');

                                                        btnDriver.classList.remove('text-[#FF6D00]');
                                                        btnDriver.classList.add('text-slate-500', 'hover:text-slate-700');

                                                        // View transition
                                                        passView.classList.replace('opacity-0', 'opacity-100');
                                                        passView.classList.replace('-translate-x-10', 'translate-x-0');
                                                        passView.classList.remove('pointer-events-none');

                                                        drvView.classList.replace('opacity-100', 'opacity-0');
                                                        drvView.classList.replace('translate-x-0', 'translate-x-10');
                                                        drvView.classList.add('pointer-events-none');

                                                        // Update map marker colors (if marker exists)
                                                        if (window.userMarkerEl) {
                                                            const pulse = window.userMarkerEl.querySelector('.animate-ping');
                                                            const dot = window.userMarkerEl.querySelector('.shadow-xl');
                                                            if (pulse) pulse.className = 'absolute w-20 h-20 bg-[#6200EE]/30 rounded-full animate-ping';
                                                            if (dot) dot.className = 'relative w-8 h-8 bg-[#6200EE] border-[3px] border-white rounded-full shadow-xl';
                                                        }

                                                        // Update nav active color
                                                        navHome.classList.replace('text-[#FF6D00]', 'text-[#6200EE]');
                                                        navHome.classList.replace('bg-orange-50', 'bg-purple-50');

                                                    } else {
                                                        // UI Toggle position
                                                        toggleBg.style.transform = 'translateX(100%)';

                                                        // Text colors
                                                        btnDriver.classList.remove('text-slate-500', 'hover:text-slate-700');
                                                        btnDriver.classList.add('text-[#FF6D00]');

                                                        btnPassenger.classList.remove('text-[#6200EE]');
                                                        btnPassenger.classList.add('text-slate-500', 'hover:text-slate-700');

                                                        // View transition
                                                        drvView.classList.replace('opacity-0', 'opacity-100');
                                                        drvView.classList.replace('translate-x-10', 'translate-x-0');
                                                        drvView.classList.remove('pointer-events-none');

                                                        passView.classList.replace('opacity-100', 'opacity-0');
                                                        passView.classList.replace('translate-x-0', '-translate-x-10');
                                                        passView.classList.add('pointer-events-none');

                                                        // Update map marker colors (if marker exists)
                                                        if (window.userMarkerEl) {
                                                            const pulse = window.userMarkerEl.querySelector('.animate-ping');
                                                            const dot = window.userMarkerEl.querySelector('.shadow-xl');
                                                            if (pulse) pulse.className = 'absolute w-20 h-20 bg-[#FF6D00]/30 rounded-full animate-ping';
                                                            if (dot) dot.className = 'relative w-8 h-8 bg-[#FF6D00] border-[3px] border-white rounded-full shadow-xl';
                                                        }

                                                        // Update nav active color
                                                        navHome.classList.replace('text-[#6200EE]', 'text-[#FF6D00]');
                                                        navHome.classList.replace('bg-purple-50', 'bg-orange-50');
                                                    }
                                                }

                                                // ==========================================
                                                // VIETMAP INITIALIZATION & GEOLOCATION
                                                // ==========================================

                                                // Vietmap API Keys (Vietmap tách riêng key cho Map và Search)
                                                const vietmapMapApiKey = '7b895685ca3fbced0955461bcbbeb5b50cb8e5a2943fdc49';
                                                const vietmapSearchApiKey = '663154c8a54428313795b6799a4e6dc463c0f678b38f7648';

                                                // Khởi tạo bản đồ Vietmap
                                                const map = new vietmapgl.Map({
                                                    container: 'map', // id của thẻ div
                                                    style: 'https://maps.vietmap.vn/maps/styles/tm/style.json?apikey=' + vietmapMapApiKey, // giao diện mặc định
                                                    center: [105.8542, 21.0285], // Tọa độ mặc định (Hà Nội)
                                                    zoom: 13,
                                                    attributionControl: false, // Ẩn logo nếu muốn UI sạch hơn
                                                    transformRequest: (url, resourceType) => {
                                                        if (url.indexOf('vietmap.vn') > -1 && url.indexOf('apikey=') === -1) {
                                                            return { url: url + (url.indexOf('?') === -1 ? '?' : '&') + 'apikey=' + vietmapMapApiKey };
                                                        }
                                                        return { url: url };
                                                    }
                                                });
                                                window.mapInstance = map;

                                                // Tạo DOM element cho Custom Marker
                                                const markerEl = document.createElement('div');
                                                markerEl.className = 'relative flex items-center justify-center';
                                                markerEl.innerHTML = `
            <div class="absolute w-20 h-20 bg-[#6200EE]/30 rounded-full animate-ping"></div>
            <div class="relative w-8 h-8 bg-[#6200EE] border-[3px] border-white rounded-full shadow-xl">
                <div class="absolute inset-0 rounded-full border border-black/10"></div>
            </div>
        `;
                                                // Lưu lại để có thể đổi màu khi toggle role
                                                window.userMarkerEl = markerEl;

                                                // Khởi tạo đối tượng Marker của Vietmap (nhưng chưa add vào map)
                                                const userMarker = new vietmapgl.Marker({ element: markerEl, offset: [0, 0] });

                                                // Khi bản đồ load xong, ta sẽ lấy vị trí thực của user
                                                map.on('load', () => {
                                                    if (navigator.geolocation) {
                                                        // Yêu cầu quyền truy cập vị trí và lấy tọa độ
                                                        navigator.geolocation.getCurrentPosition(
                                                            (position) => {
                                                                const lng = position.coords.longitude;
                                                                const lat = position.coords.latitude;
                                                                userLngLat = [lng, lat]; // Cập nhật vị trí toàn cục

                                                                // Di chuyển bản đồ (FlyTo) tới vị trí của user với hiệu ứng mượt
                                                                map.flyTo({
                                                                    center: [lng, lat],
                                                                    zoom: 15,
                                                                    speed: 1.2
                                                                });

                                                                // Đặt custom marker lên vị trí của user
                                                                userMarker.setLngLat([lng, lat]).addTo(map);
                                                            },
                                                            (error) => {
                                                                console.error("Lỗi khi lấy vị trí: ", error.message);
                                                                // Nếu user từ chối, marker có thể được đặt ở tọa độ mặc định
                                                                userMarker.setLngLat([105.8542, 21.0285]).addTo(map);
                                                            },
                                                            {
                                                                enableHighAccuracy: true,
                                                                timeout: 5000,
                                                                maximumAge: 0
                                                            }
                                                        );
                                                    } else {
                                                        console.log("Trình duyệt không hỗ trợ Geolocation.");
                                                    }
                                                });

                                            </script>

                                            <!-- Auth Modal Include & Script -->
                                            <jsp:include page="includes/auth_modal.jsp" />
                                            <!-- Onboarding Modal -->
                                            <jsp:include page="includes/onboarding_modal.jsp" />

                                            <script>
                                                window.CONTEXT_PATH = (window.TransCakeConfig.contextPath + '');
                    <% if (!isLoggedIn) { %>
                                                    // Auto-open modal if not logged in
                                                    document.addEventListener('DOMContentLoaded', () => {
                                                        setTimeout(() => {
                                                            if (window.openAuthModal) window.openAuthModal();
                                                        }, 500);
                                                    });
                    <% } %>

                                                    // Bind dynamic events after DOM content is loaded
                                                    document.addEventListener('DOMContentLoaded', function () {
                                                        window.openProfileView = function (role) {
                                                            const passView = document.getElementById('passenger-view');
                                                            const drvView = document.getElementById('driver-view');
                                                            const profView = document.getElementById('sidebar-profile-view');

                                                            if (!profView) return;

                                                            if (role === 'passenger' && passView) {
                                                                passView.classList.replace('opacity-100', 'opacity-0');
                                                                passView.classList.replace('translate-x-0', '-translate-x-10');
                                                                passView.classList.add('pointer-events-none');
                                                            } else if (role === 'driver' && drvView) {
                                                                drvView.classList.replace('opacity-100', 'opacity-0');
                                                                drvView.classList.replace('translate-x-0', '-translate-x-10');
                                                                drvView.classList.add('pointer-events-none');
                                                            }

                                                            profView.classList.replace('opacity-0', 'opacity-100');
                                                            profView.classList.replace('translate-x-10', 'translate-x-0');
                                                            profView.classList.remove('pointer-events-none');

                                                            const backBtn = document.getElementById('btn-back-from-profile');
                                                            if (backBtn) {
                                                                backBtn.onclick = function () {
                                                                    profView.classList.replace('opacity-100', 'opacity-0');
                                                                    profView.classList.replace('translate-x-0', 'translate-x-10');
                                                                    profView.classList.add('pointer-events-none');

                                                                    if (role === 'passenger' && passView) {
                                                                        passView.classList.replace('opacity-0', 'opacity-100');
                                                                        passView.classList.replace('-translate-x-10', 'translate-x-0');
                                                                        passView.classList.remove('pointer-events-none');
                                                                    } else if (role === 'driver' && drvView) {
                                                                        drvView.classList.replace('opacity-0', 'opacity-100');
                                                                        drvView.classList.replace('-translate-x-10', 'translate-x-0');
                                                                        drvView.classList.remove('pointer-events-none');
                                                                    }
                                                                };
                                                            }
                                                        };


                                                        // 1. Avatar Triggers
                                                        const pAvatarTrigger = document.getElementById('passenger-avatar-trigger');
                                                        if (pAvatarTrigger) {
                                                            pAvatarTrigger.addEventListener('click', function (e) {
                                                                e.stopPropagation();
                                                                window.openProfileView('passenger');
                                                            });
                                                        }
                                                        const dAvatarTrigger = document.getElementById('driver-avatar-trigger');
                                                        if (dAvatarTrigger) {
                                                            dAvatarTrigger.addEventListener('click', function (e) {
                                                                e.stopPropagation();
                                                                window.openProfileView('driver');
                                                            });
                                                        }
                                                    });

                                                // Function to handle booking type toggle (On-demand vs Pre-book)
                                                window.setBookingType = function (type) {
                                                    const inputTripType = document.getElementById('tripType');
                                                    const bg = document.getElementById('booking-type-bg');
                                                    const btnOnDemand = document.getElementById('btn-ondemand');
                                                    const btnPreBook = document.getElementById('btn-prebook');
                                                    const datetimeContainer = document.getElementById('datetime-container');
                                                    const tripDate = document.getElementById('trip-date');
                                                    const tripTime = document.getElementById('trip-time');

                                                    if (!inputTripType || !bg) return;

                                                    inputTripType.value = type;

                                                    if (type === 'ON_DEMAND') {
                                                        // Set Toggle UI
                                                        bg.style.transform = 'translateX(0)';
                                                        btnOnDemand.classList.remove('text-slate-500');
                                                        btnOnDemand.classList.add('text-[#6200EE]');
                                                        btnPreBook.classList.remove('text-[#6200EE]');
                                                        btnPreBook.classList.add('text-slate-500');

                                                        // Hide Date/Time fields smoothly and remove 'required'
                                                        datetimeContainer.classList.add('opacity-0', '-translate-y-2');
                                                        setTimeout(() => {
                                                            datetimeContainer.classList.add('hidden');
                                                            datetimeContainer.classList.remove('flex');
                                                        }, 300);

                                                        tripDate.removeAttribute('required');
                                                        tripTime.removeAttribute('required');

                                                        // Điền form nếu có dữ liệu chuyến đang tìm
                                                        if (tripData.ON_DEMAND.active) {
                                                            document.getElementById('pickup-input').value = tripData.ON_DEMAND.pickup;
                                                            document.getElementById('dropoff-input').value = tripData.ON_DEMAND.dropoff;
                                                        } else if (tripData.PRE_BOOK.active) {
                                                            // Xóa form nếu tab cũ có active trip
                                                            document.getElementById('pickup-input').value = "";
                                                            document.getElementById('dropoff-input').value = "";
                                                        }

                                                        // Chuyển nút về trạng thái Hủy nếu đang tìm kiếm ON_DEMAND
                                                        const btnSubmit = document.getElementById('btn-submit-search');
                                                        if (btnSubmit) {
                                                            if (isSearchingOnDemand) {
                                                                btnSubmit.type = 'button';
                                                                btnSubmit.innerHTML = 'Hủy tìm kiếm <span class="material-symbols-outlined text-[20px]">cancel</span>';
                                                                btnSubmit.className = 'w-full bg-red-500 hover:bg-red-600 text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                                                btnSubmit.disabled = false;
                                                                btnSubmit.onclick = cancelTripSearch;

                                                                document.getElementById('empty-search-state').classList.add('hidden');
                                                                document.getElementById('empty-search-state').classList.remove('flex');
                                                                document.getElementById('loading-search-state').classList.remove('hidden');
                                                                if (document.getElementById('matched-driver-state')) {
                                                                    document.getElementById('matched-driver-state').classList.add('hidden');
                                                                    document.getElementById('matched-driver-state').classList.remove('flex');
                                                                }
                                                                document.getElementById('loading-search-state').classList.add('flex');
                                                            } else {
                                                                btnSubmit.type = 'submit';
                                                                btnSubmit.innerHTML = 'Tìm chuyến <span class="material-symbols-outlined text-[20px]">arrow_forward</span>';
                                                                btnSubmit.className = 'w-full bg-slate-900 hover:bg-black text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                                                btnSubmit.onclick = null;
                                                                btnSubmit.disabled = false;

                                                                document.getElementById('loading-search-state').classList.add('hidden');
                                                                document.getElementById('loading-search-state').classList.remove('flex');
                                                                document.getElementById('empty-search-state').classList.remove('hidden');
                                                                if (document.getElementById('matched-driver-state')) {
                                                                    document.getElementById('matched-driver-state').classList.add('hidden');
                                                                    document.getElementById('matched-driver-state').classList.remove('flex');
                                                                }
                                                                document.getElementById('empty-search-state').classList.add('flex');
                                                            }

                                                            toggleFormInputs(tripData.ON_DEMAND.active);
                                                        }

                                                    } else if (type === 'PRE_BOOK') {
                                                        // Set Toggle UI
                                                        bg.style.transform = 'translateX(100%)';
                                                        btnPreBook.classList.remove('text-slate-500');
                                                        btnPreBook.classList.add('text-[#FF6D00]');
                                                        btnOnDemand.classList.remove('text-[#6200EE]');
                                                        btnOnDemand.classList.add('text-slate-500');

                                                        // Show Date/Time fields smoothly and add 'required'
                                                        datetimeContainer.classList.remove('hidden');
                                                        datetimeContainer.classList.add('flex');
                                                        setTimeout(() => {
                                                            datetimeContainer.classList.remove('opacity-0', '-translate-y-2');
                                                        }, 10); // Small delay to allow display change to take effect

                                                        tripDate.setAttribute('required', 'required');
                                                        tripTime.setAttribute('required', 'required');

                                                        // Điền form nếu có dữ liệu chuyến đặt trước
                                                        if (tripData.PRE_BOOK.active) {
                                                            document.getElementById('pickup-input').value = tripData.PRE_BOOK.pickup;
                                                            document.getElementById('dropoff-input').value = tripData.PRE_BOOK.dropoff;
                                                            document.getElementById('trip-date').value = tripData.PRE_BOOK.date;
                                                            document.getElementById('trip-time').value = tripData.PRE_BOOK.time;
                                                        } else if (tripData.ON_DEMAND.active) {
                                                            // Xóa form nếu tab cũ có active trip
                                                            document.getElementById('pickup-input').value = "";
                                                            document.getElementById('dropoff-input').value = "";
                                                            document.getElementById('trip-date').value = "";
                                                            document.getElementById('trip-time').value = "";
                                                        }

                                                        // Phục hồi nút Submit mặc định để đăng ký chuyến xe trước, hoặc Đổi sang hủy nếu đã có chuyến
                                                        const btnSubmit = document.getElementById('btn-submit-search');
                                                        if (btnSubmit) {
                                                            if (hasPreBookTrip) {
                                                                btnSubmit.type = 'button';
                                                                btnSubmit.innerHTML = 'Hủy đặt lịch <span class="material-symbols-outlined text-[20px]">cancel</span>';
                                                                btnSubmit.className = 'w-full bg-[#FF6D00] hover:bg-orange-600 text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                                                btnSubmit.disabled = false;
                                                                btnSubmit.onclick = cancelPreBookTrip;

                                                                document.getElementById('empty-search-state').classList.add('hidden');
                                                                document.getElementById('empty-search-state').classList.remove('flex');
                                                                document.getElementById('loading-search-state').classList.remove('hidden');
                                                                if (document.getElementById('matched-driver-state')) {
                                                                    document.getElementById('matched-driver-state').classList.add('hidden');
                                                                    document.getElementById('matched-driver-state').classList.remove('flex');
                                                                }
                                                                document.getElementById('loading-search-state').classList.add('flex');
                                                            } else {
                                                                btnSubmit.type = 'submit';
                                                                btnSubmit.innerHTML = 'Tìm chuyến <span class="material-symbols-outlined text-[20px]">arrow_forward</span>';
                                                                btnSubmit.className = 'w-full bg-slate-900 hover:bg-black text-white font-bold py-3.5 rounded-full transition-all shadow-[0_8px_20px_rgba(0,0,0,0.15)] hover:shadow-[0_12px_24px_rgba(0,0,0,0.25)] flex items-center justify-center gap-2 text-lg mt-auto';
                                                                btnSubmit.onclick = null;
                                                                btnSubmit.disabled = false;

                                                                document.getElementById('loading-search-state').classList.add('hidden');
                                                                document.getElementById('loading-search-state').classList.remove('flex');
                                                                document.getElementById('empty-search-state').classList.remove('hidden');
                                                                if (document.getElementById('matched-driver-state')) {
                                                                    document.getElementById('matched-driver-state').classList.add('hidden');
                                                                    document.getElementById('matched-driver-state').classList.remove('flex');
                                                                }
                                                                document.getElementById('empty-search-state').classList.add('flex');
                                                            }
                                                        }

                                                        toggleFormInputs(tripData.PRE_BOOK.active);
                                                    }
                                                };

                                                // Mapbox Location Autocomplete
                                                function setupAutocomplete(inputId, suggestionsId) {
                                                    const input = document.getElementById(inputId);
                                                    const suggestionsContainer = document.getElementById(suggestionsId);
                                                    let debounceTimer;

                                                    if (!input || !suggestionsContainer) return;

                                                    input.addEventListener('input', function () {
                                                        clearTimeout(debounceTimer);
                                                        const query = this.value;

                                                        // Clear hidden coordinates when user types
                                                        if (inputId === 'pickup-input') {
                                                            document.getElementById('pickup-lat').value = '';
                                                            document.getElementById('pickup-lng').value = '';
                                                        } else if (inputId === 'dropoff-input') {
                                                            document.getElementById('dropoff-lat').value = '';
                                                            document.getElementById('dropoff-lng').value = '';
                                                        }

                                                        if (!query || query.length < 2) {
                                                            suggestionsContainer.innerHTML = '';
                                                            suggestionsContainer.classList.add('hidden');
                                                            return;
                                                        }

                                                        debounceTimer = setTimeout(() => {
                                                            // Gọi API Search của Vietmap
                                                            const url = `https://maps.vietmap.vn/api/search/v3?apikey=\${vietmapSearchApiKey}&text=\${encodeURIComponent(query)}`;

                                                            fetch(url)
                                                                .then(response => response.json())
                                                                .then(data => {
                                                                    suggestionsContainer.innerHTML = '';
                                                                    if (data && data.length > 0) {
                                                                        data.slice(0, 8).forEach(feature => {
                                                                            const mainText = feature.name || '';
                                                                            let fullAddress = feature.display || feature.address || '';

                                                                            const secondaryText = fullAddress !== mainText ? fullAddress : '';

                                                                            const div = document.createElement('div');
                                                                            div.className = 'px-4 py-2 hover:bg-slate-100 cursor-pointer text-sm text-slate-700 border-b border-slate-100 last:border-0';

                                                                            // Viết tách HTML, cần dùng backslash để tránh JSP EL
                                                                            let suggestionHtml = `<strong>\${mainText}</strong>`;
                                                                            if (secondaryText) {
                                                                                suggestionHtml += `<br><span class="text-xs text-slate-500">\${secondaryText}</span>`;
                                                                            }
                                                                            div.innerHTML = suggestionHtml;

                                                                            div.onclick = () => {
                                                                                input.value = fullAddress;
                                                                                suggestionsContainer.innerHTML = '';
                                                                                suggestionsContainer.classList.add('hidden');

                                                                                // Gọi Place API để lấy toạ độ chính xác từ ref_id
                                                                                if (feature.ref_id) {
                                                                                    const placeUrl = `https://maps.vietmap.vn/api/place/v3?apikey=\${vietmapSearchApiKey}&refid=\${feature.ref_id}`;
                                                                                    fetch(placeUrl)
                                                                                        .then(res => res.json())
                                                                                        .then(placeData => {
                                                                                            const lat = placeData.lat;
                                                                                            const lng = placeData.lng;

                                                                                            if (lat && lng) {
                                                                                                // Lưu coordinates vào hidden fields
                                                                                                if (inputId === 'pickup-input') {
                                                                                                    document.getElementById('pickup-lat').value = lat;
                                                                                                    document.getElementById('pickup-lng').value = lng;
                                                                                                } else if (inputId === 'dropoff-input') {
                                                                                                    document.getElementById('dropoff-lat').value = lat;
                                                                                                    document.getElementById('dropoff-lng').value = lng;
                                                                                                }

                                                                                                // Bay đến vị trí
                                                                                                map.flyTo({
                                                                                                    center: [lng, lat],
                                                                                                    zoom: 15,
                                                                                                    essential: true
                                                                                                });

                                                                                                // Xóa marker cũ nếu có
                                                                                                const isPrebook = document.getElementById('tripType') ? document.getElementById('tripType').value === 'PRE_BOOK' : false;
                                                                                                if (isPrebook && window.markerPreBook) {
                                                                                                    window.markerPreBook.remove();
                                                                                                } else if (!isPrebook && window.markerOnDemand) {
                                                                                                    window.markerOnDemand.remove();
                                                                                                }

                                                                                                // Màu sắc động theo loại
                                                                                                const color1 = isPrebook ? 'bg-orange-500/30' : 'bg-purple-500/30';
                                                                                                const color2 = isPrebook ? 'bg-orange-500/40' : 'bg-purple-500/40';
                                                                                                const grad = isPrebook ? 'from-orange-400 to-orange-600' : 'from-purple-500 to-purple-700';
                                                                                                const shad = isPrebook ? 'shadow-[0_4px_15px_rgba(249,115,22,0.5)]' : 'shadow-[0_4px_15px_rgba(98,0,238,0.5)]';
                                                                                                const btm = isPrebook ? 'bg-orange-600' : 'bg-purple-700';

                                                                                                // Tạo Custom Marker
                                                                                                const searchMarkerEl = document.createElement('div');
                                                                                                searchMarkerEl.className = 'relative flex items-center justify-center';
                                                                                                searchMarkerEl.innerHTML = `
                                                                                <div class="absolute w-24 h-24 \${color1} rounded-full animate-ping"></div>
                                                                                <div class="absolute w-12 h-12 \${color2} rounded-full animate-pulse"></div>
                                                                                <div class="relative flex flex-col items-center">
                                                                                    <div class="w-8 h-8 bg-gradient-to-br \${grad} border-[3px] border-white rounded-full \${shad} z-10 flex items-center justify-center">
                                                                                        <div class="w-2 h-2 bg-white rounded-full shadow-inner"></div>
                                                                                    </div>
                                                                                    <div class="w-1 h-3 \${btm} -mt-1 rounded-b-full"></div>
                                                                                </div>
                                                                            `;

                                                                                                const marker = new vietmapgl.Marker({ element: searchMarkerEl, offset: [0, -15] })
                                                                                                    .setLngLat([lng, lat])
                                                                                                    .addTo(map);

                                                                                                if (isPrebook) window.markerPreBook = marker;
                                                                                                else window.markerOnDemand = marker;

                                                                                                // Nếu cả 2 điểm đã được chọn, gọi hàm tính giá
                                                                                                calculateRouteAndPrice();
                                                                                            }
                                                                                        })
                                                                                        .catch(err => console.error("Place API error:", err));
                                                                                }
                                                                            };
                                                                            suggestionsContainer.appendChild(div);
                                                                        });
                                                                        suggestionsContainer.classList.remove('hidden');
                                                                    } else {
                                                                        suggestionsContainer.classList.add('hidden');
                                                                    }
                                                                })
                                                                .catch(err => console.error("Geocoding error:", err));
                                                        }, 300);
                                                    });

                                                    // Hide suggestions when clicking outside
                                                    document.addEventListener('click', function (e) {
                                                        if (e.target !== input && !suggestionsContainer.contains(e.target)) {
                                                            suggestionsContainer.classList.add('hidden');
                                                        }
                                                    });
                                                }

                                                function calculateRouteAndPrice() {
                                                    const pLat = document.getElementById('pickup-lat').value;
                                                    const pLng = document.getElementById('pickup-lng').value;
                                                    const dLat = document.getElementById('dropoff-lat').value;
                                                    const dLng = document.getElementById('dropoff-lng').value;

                                                    if (pLat && pLng && dLat && dLng) {
                                                        const priceBox = document.getElementById('price-estimation-box');
                                                        priceBox.classList.remove('hidden');
                                                        document.getElementById('price-value').textContent = "Đang tính...";
                                                        document.getElementById('distance-value').textContent = "Đang quét tuyến đường...";
                                                        document.getElementById('duration-value').textContent = "";

                                                        const contextPath = (window.TransCakeConfig.contextPath + '');
                                                        const vehicleType = document.querySelector('input[name="vehicleType"]:checked').value;
                                                        const routeUrl = `\${contextPath}/api/price-estimate?pLat=\${pLat}&pLng=\${pLng}&dLat=\${dLat}&dLng=\${dLng}&vehicleType=\${vehicleType}`;

                                                        fetch(routeUrl)
                                                            .then(res => res.json())
                                                            .then(data => {
                                                                if (data.success) {
                                                                    const distanceKm = data.distanceKm;
                                                                    const durationMins = data.durationMins;
                                                                    const totalPrice = data.totalPrice;

                                                                    // Hiển thị
                                                                    document.getElementById('distance-value').textContent = `Quãng đường: \${distanceKm} km`;
                                                                    document.getElementById('duration-value').textContent = `Thời gian: ~\${durationMins} phút`;
                                                                    document.getElementById('price-value').textContent = totalPrice.toLocaleString('vi-VN') + " đ";

                                                                    // Lưu vào hidden input
                                                                    document.getElementById('trip-price').value = totalPrice;
                                                                    document.getElementById('trip-distance').value = distanceKm;

                                                                    // Vẽ đường đi trên bản đồ
                                                                    const isPrebook = document.getElementById('tripType') ? document.getElementById('tripType').value === 'PRE_BOOK' : false;
                                                                    const routeId = isPrebook ? 'route-pre-book' : 'route-on-demand';
                                                                    const routeColor = isPrebook ? '#FF6D00' : '#6200EE';

                                                                    if (data.points) {
                                                                        if (map.getSource(routeId)) {
                                                                            map.getSource(routeId).setData(data.points);
                                                                        } else {
                                                                            map.addSource(routeId, {
                                                                                'type': 'geojson',
                                                                                'data': data.points
                                                                            });
                                                                            map.addLayer({
                                                                                'id': routeId,
                                                                                'type': 'line',
                                                                                'source': routeId,
                                                                                'layout': {
                                                                                    'line-join': 'round',
                                                                                    'line-cap': 'round'
                                                                                },
                                                                                'paint': {
                                                                                    'line-color': routeColor,
                                                                                    'line-width': 6,
                                                                                    'line-opacity': 0.8
                                                                                }
                                                                            });
                                                                        }

                                                                        // Căn chỉnh bản đồ để vừa vặn với đường đi
                                                                        if (data.bbox) {
                                                                            map.fitBounds([
                                                                                [data.bbox[0], data.bbox[1]], // [minLng, minLat]
                                                                                [data.bbox[2], data.bbox[3]]  // [maxLng, maxLat]
                                                                            ], {
                                                                                padding: { top: 50, bottom: 50, left: 50, right: 400 }, // Padding right để né cái panel
                                                                                duration: 1000
                                                                            });
                                                                        }
                                                                    }
                                                                } else {
                                                                    document.getElementById('distance-value').textContent = data.error || "Không tìm thấy đường đi";
                                                                    document.getElementById('price-value').textContent = "Chưa rõ";
                                                                }
                                                            })
                                                            .catch(err => {
                                                                console.error("Routing error:", err);
                                                                document.getElementById('distance-value').textContent = "Lỗi tính toán quãng đường";
                                                            });
                                                    }
                                                }

                                                document.addEventListener('DOMContentLoaded', function () {
                                                    setupAutocomplete('pickup-input', 'pickup-suggestions');
                                                    setupAutocomplete('dropoff-input', 'dropoff-suggestions');
                                                });
