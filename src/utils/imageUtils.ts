/**
 * Image utility functions for progressive loading
 */

/**
 * Generate a low-quality placeholder URL for an image
 * This can be used with services like Cloudinary, ImageKit, or similar
 * @param originalSrc - The original image source URL
 * @param width - Desired width for placeholder (default: 20)
 * @param quality - Quality percentage (default: 10)
 * @returns Placeholder URL or empty string if not supported
 */
export function generatePlaceholderUrl(originalSrc: string, width: number = 20, quality: number = 10): string {
  // If using Cloudinary
  if (originalSrc.includes('cloudinary.com')) {
    return originalSrc.replace('/upload/', `/upload/w_${width},q_${quality},blur_1000/`);
  }
  
  // If using ImageKit
  if (originalSrc.includes('imagekit.io')) {
    return `${originalSrc}?tr=w-${width},q-${quality},bl-1000`;
  }
  
  // If using a custom image service, add your logic here
  // For now, return empty string to use skeleton loading
  return '';
}

/**
 * Check if an image URL supports placeholder generation
 * @param src - Image source URL
 * @returns boolean indicating if placeholder generation is supported
 */
export function supportsPlaceholderGeneration(src: string): boolean {
  return src.includes('cloudinary.com') || src.includes('imagekit.io');
}

/**
 * Generate thumbnail URL for different contexts
 * @param originalSrc - The original image source URL
 * @param context - The context where the thumbnail will be used
 * @returns Thumbnail URL with appropriate dimensions
 */
export function generateThumbnailUrl(originalSrc: string, context: 'card' | 'gallery' | 'modal_thumbnail' | 'headshot' = 'card'): string {
  // For now, we'll use the original src since Astro's image optimization
  // will handle the resizing at build time. In a production environment,
  // you might want to use a CDN or image service for dynamic resizing.
  
  // Add a query parameter to indicate the intended use
  // This can be used by image optimization services or CDNs
  const separator = originalSrc.includes('?') ? '&' : '?';
  
  switch (context) {
    case 'card':
      return `${originalSrc}${separator}w=400&h=256&fit=crop`;
    case 'gallery':
      return `${originalSrc}${separator}w=300&h=200&fit=crop`;
    case 'modal_thumbnail':
      return `${originalSrc}${separator}w=200&h=128&fit=crop`;
    case 'headshot':
      return `${originalSrc}${separator}w=192&h=192&fit=crop`;
    default:
      return originalSrc;
  }
}

/**
 * Get optimal image dimensions for different contexts
 * @param context - The context where the image will be used
 * @returns Object with width and height
 */
export function getImageDimensions(context: 'card' | 'gallery' | 'modal_thumbnail' | 'headshot' | 'modal_main'): { width: number; height: number } {
  switch (context) {
    case 'card':
      return { width: 400, height: 256 };
    case 'gallery':
      return { width: 300, height: 200 };
    case 'modal_thumbnail':
      return { width: 200, height: 128 };
    case 'headshot':
      return { width: 192, height: 192 };
    case 'modal_main':
      return { width: 1200, height: 800 };
    default:
      return { width: 400, height: 256 };
  }
}

/**
 * Generate a data URL for a simple colored placeholder
 * @param width - Width in pixels
 * @param height - Height in pixels
 * @param color - Background color (default: #f0f0f0)
 * @returns Data URL for the placeholder
 */
export function generateDataUrlPlaceholder(width: number, height: number, color: string = '#f0f0f0'): string {
  const canvas = document.createElement('canvas');
  canvas.width = width;
  canvas.height = height;
  const ctx = canvas.getContext('2d');
  
  if (ctx) {
    ctx.fillStyle = color;
    ctx.fillRect(0, 0, width, height);
  }
  
  return canvas.toDataURL();
}

/**
 * Preload an image and return a promise
 * @param src - Image source URL
 * @returns Promise that resolves when image is loaded
 */
export function preloadImage(src: string): Promise<HTMLImageElement> {
  return new Promise((resolve, reject) => {
    const img = new Image();
    img.onload = () => resolve(img);
    img.onerror = reject;
    img.src = src;
  });
} 