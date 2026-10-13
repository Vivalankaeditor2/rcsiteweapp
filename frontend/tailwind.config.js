/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        // Palette derived from the legacy brand CSS (rcsiteweb/ROOT/css/styles.css)
        // and the VivaLanka wordmark: #0066cc / #1e90ff accent, #07056a navy.
        brand: {
          DEFAULT: "#0066cc",
          dark: "#004a99",
          light: "#1e90ff",
          50: "#eef6ff",
          100: "#d9ecff",
        },
        navy: "#07056a",
        ink: {
          DEFAULT: "#16181d",
          soft: "#454a54",
          mute: "#6b7280",
        },
        line: "#e5e7eb",
        canvas: "#f6f7f9",
      },
      fontFamily: {
        sans: [
          "system-ui",
          "-apple-system",
          "Segoe UI",
          "Roboto",
          "Helvetica Neue",
          "Arial",
          "sans-serif",
        ],
        serif: ["Georgia", "Cambria", "Times New Roman", "serif"],
      },
      maxWidth: {
        page: "1200px",
      },
    },
  },
  plugins: [],
};
