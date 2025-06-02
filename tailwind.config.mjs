/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    extend: {
      colors: {
        'matcha': {
          50: '#f0f9f1',
          100: '#dcf1de',
          200: '#bae3bf',
          300: '#8dce96',
          400: '#5ab36a',
          500: '#3a9a4b',
          600: '#2c7b3b',
          700: '#256231',
          800: '#214f2a',
          900: '#1d4224',
          950: '#0f2413',
        },
      },
    },
  },
  plugins: [],
} 