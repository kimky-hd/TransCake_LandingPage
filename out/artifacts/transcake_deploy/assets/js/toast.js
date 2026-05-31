/**
 * Global Toast Notification Utility
 * Provides a reusable function to display toast messages.
 */
window.showToast = function(message, type = 'info') {
    // 1. Get or create the container
    let container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        // Positioned at top-right, fixed, above all overlays (z-[9999])
        container.className = 'fixed top-5 right-5 z-[9999] flex flex-col gap-3 pointer-events-none';
        document.body.appendChild(container);
    }

    // 2. Create the toast element
    const toast = document.createElement('div');
    
    // Configuration based on type
    let typeClasses = '';
    let iconSvg = '';

    if (type === 'success') {
        typeClasses = 'bg-white border-l-4 border-green-500 text-slate-800';
        iconSvg = `<svg class="w-6 h-6 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"></path></svg>`;
    } else if (type === 'error') {
        typeClasses = 'bg-white border-l-4 border-red-500 text-slate-800';
        iconSvg = `<svg class="w-6 h-6 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M6 18L18 6M6 6l12 12"></path></svg>`;
    } else if (type === 'warning') {
        typeClasses = 'bg-white border-l-4 border-orange-500 text-slate-800';
        iconSvg = `<svg class="w-6 h-6 text-orange-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg>`;
    } else {
        // Default info style using primary brand color
        typeClasses = 'bg-white border-l-4 border-[#6d28d9] text-slate-800';
        iconSvg = `<svg class="w-6 h-6 text-[#6d28d9]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>`;
    }

    // Initial state: translated out of view (translate-x-[120%]) and transparent
    toast.className = `flex items-center gap-3.5 min-w-[320px] max-w-sm px-5 py-4 rounded-xl shadow-[0_10px_40px_-10px_rgba(0,0,0,0.15)] transform transition-all duration-300 translate-x-[120%] opacity-0 pointer-events-auto ${typeClasses}`;
    
    toast.innerHTML = `
        <div class="flex-shrink-0">${iconSvg}</div>
        <div class="text-[14px] font-semibold flex-1 leading-snug">${message}</div>
        <button class="flex-shrink-0 text-slate-400 hover:text-slate-600 transition-colors ml-2" onclick="this.parentElement.remove()">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
        </button>
    `;

    container.appendChild(toast);

    // 3. Animate in (slide in from right)
    // Small delay ensures DOM is updated before animation starts
    setTimeout(() => {
        toast.classList.remove('translate-x-[120%]', 'opacity-0');
        toast.classList.add('translate-x-0', 'opacity-100');
    }, 10);

    // 4. Auto-remove after 4 seconds
    setTimeout(() => {
        // Only animate out if it wasn't manually closed already
        if (toast.parentElement) {
            toast.classList.remove('translate-x-0', 'opacity-100');
            toast.classList.add('translate-x-[120%]', 'opacity-0');
            
            // Wait for animation to finish before removing from DOM
            setTimeout(() => {
                if (toast.parentElement) {
                    toast.remove();
                }
            }, 300);
        }
    }, 4000);
};

/**
 * Global Confirm Modal Utility
 * Displays a custom styled confirmation dialog
 */
window.showConfirmModal = function(title, message, onConfirmCallback) {
    // 1. Create overlay
    const overlay = document.createElement('div');
    overlay.className = 'fixed inset-0 z-[10000] flex items-center justify-center bg-slate-900/40 backdrop-blur-sm opacity-0 transition-opacity duration-300';
    
    // 2. Create modal box
    const modal = document.createElement('div');
    modal.className = 'bg-white rounded-2xl p-6 max-w-sm w-[90%] shadow-[0_20px_60px_-15px_rgba(0,0,0,0.3)] transform scale-95 opacity-0 transition-all duration-300 text-center';
    
    modal.innerHTML = `
        <div class="mx-auto w-12 h-12 bg-orange-100 rounded-full flex items-center justify-center mb-4">
            <svg class="w-6 h-6 text-orange-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
            </svg>
        </div>
        <h3 class="text-lg font-bold text-slate-800 mb-2">${title}</h3>
        <p class="text-sm text-slate-500 mb-6">${message}</p>
        <div class="flex gap-3 justify-center">
            <button id="btn-confirm-cancel" class="flex-1 py-2.5 px-4 rounded-full border border-slate-200 text-slate-600 font-semibold text-sm hover:bg-slate-50 transition-colors">
                Hủy bỏ
            </button>
            <button id="btn-confirm-ok" class="flex-1 py-2.5 px-4 rounded-full bg-red-500 text-white font-semibold text-sm hover:bg-red-600 transition-colors shadow-md shadow-red-500/20">
                Đồng ý
            </button>
        </div>
    `;
    
    overlay.appendChild(modal);
    document.body.appendChild(overlay);
    
    // Function to close modal
    const closeModal = () => {
        overlay.classList.remove('opacity-100');
        modal.classList.remove('scale-100', 'opacity-100');
        setTimeout(() => overlay.remove(), 300);
    };
    
    // Bind events
    modal.querySelector('#btn-confirm-cancel').onclick = closeModal;
    modal.querySelector('#btn-confirm-ok').onclick = () => {
        closeModal();
        if (typeof onConfirmCallback === 'function') {
            onConfirmCallback();
        }
    };
    
    // Animate in
    setTimeout(() => {
        overlay.classList.add('opacity-100');
        modal.classList.add('scale-100', 'opacity-100');
    }, 10);
};
