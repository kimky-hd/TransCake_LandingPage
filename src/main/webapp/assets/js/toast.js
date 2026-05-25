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
