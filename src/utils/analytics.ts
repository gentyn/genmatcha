// Type declarations for Umami
declare global {
  interface Window {
    umami?: {
      track: (eventName: string, eventData?: Record<string, any>) => void;
    };
  }
}

// Umami Analytics utility functions
export function trackEvent(eventName: string, eventData: Record<string, any> = {}) {
  if (typeof window !== 'undefined' && typeof window.umami !== 'undefined') {
    window.umami.track(eventName, eventData);
    console.log('Tracked event:', eventName, eventData);
  } else {
    console.log('Umami not loaded yet, event queued:', eventName, eventData);
  }
}

// Track page views
export function trackPageView() {
  if (typeof window === 'undefined') return;
  
  const currentPath = window.location.pathname;
  const currentTheme = document.documentElement.classList.contains('dark') ? 'dark' : 'light';
  trackEvent('page_view', {
    path: currentPath,
    theme: currentTheme,
    referrer: document.referrer || 'direct'
  });
}

// Track project interactions
export function trackProjectView(projectId: string, projectTitle: string) {
  trackEvent('project_view', {
    project_id: projectId,
    project_title: projectTitle,
    path: typeof window !== 'undefined' ? window.location.pathname : ''
  });
}

export function trackProjectModalOpen(projectId: string, projectTitle: string) {
  trackEvent('project_modal_open', {
    project_id: projectId,
    project_title: projectTitle
  });
}

export function trackProjectModalClose(projectId: string, projectTitle: string) {
  trackEvent('project_modal_close', {
    project_id: projectId,
    project_title: projectTitle
  });
}

// Track image interactions
export function trackImageClick(imageSrc: string, context: string) {
  trackEvent('image_click', {
    image_src: imageSrc,
    context: context
  });
}

export function trackImageLoad(imageSrc: string, context: string) {
  trackEvent('image_load', {
    image_src: imageSrc,
    context: context
  });
}

export function trackImageError(imageSrc: string, context: string) {
  trackEvent('image_error', {
    image_src: imageSrc,
    context: context
  });
}

// Track gallery interactions
export function trackGalleryView(galleryName: string) {
  trackEvent('gallery_view', {
    gallery_name: galleryName
  });
}

export function trackGalleryImageClick(galleryName: string, imageIndex: number) {
  trackEvent('gallery_image_click', {
    gallery_name: galleryName,
    image_index: imageIndex
  });
}

// Track theme changes
export function trackThemeChange(theme: 'light' | 'dark') {
  trackEvent('theme_changed', { theme });
}

// Track navigation
export function trackNavigationClick(link: string, linkText: string) {
  trackEvent('navigation_click', {
    link,
    text: linkText,
    current_path: typeof window !== 'undefined' ? window.location.pathname : ''
  });
}

// Track external links
export function trackExternalLinkClick(url: string, linkText: string) {
  trackEvent('external_link_click', {
    url,
    text: linkText
  });
}

// Track scroll depth
export function trackScrollDepth(depth: number) {
  trackEvent('scroll_depth', { depth });
}

// Track time on page
export function trackTimeOnPage(seconds: number) {
  trackEvent('time_on_page', { seconds });
}

// Track accessibility features
export function trackSkipLinkUsed() {
  trackEvent('accessibility_skip_link_used');
}

// Track form interactions (if you add forms later)
export function trackFormSubmit(formName: string) {
  trackEvent('form_submit', { form_name: formName });
}

export function trackFormError(formName: string, errorType: string) {
  trackEvent('form_error', { 
    form_name: formName, 
    error_type: errorType 
  });
} 