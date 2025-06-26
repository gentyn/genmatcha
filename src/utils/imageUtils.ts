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

/**
 * Get image dimensions from URL or element
 * @param src - Image source URL
 * @returns Promise with image dimensions
 */
export function getImageDimensions(src: string): Promise<{ width: number; height: number }> {
  return new Promise((resolve, reject) => {
    const img = new Image();
    img.onload = () => {
      resolve({ width: img.naturalWidth, height: img.naturalHeight });
    };
    img.onerror = reject;
    img.src = src;
  });
} 