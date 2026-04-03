module.exports = {
  darkMode: "class",
  content: [
    "./app/views/**/*.html.erb",
    "./app/components/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js"
  ],
  theme: {
    extend: {
      colors: {
        "inverse-primary": "#96d3bd",
        "on-background": "#e2e6eb",
        "secondary-fixed-dim": "#b9c7df",
        "tertiary-fixed": "#d8e2ff",
        "primary-container": "#96d3bd",
        "on-error-container": "#ffdad6",
        "on-tertiary": "#002e68",
        "on-secondary-container": "#abb9d1",
        "secondary-container": "#282d31",
        "on-primary-container": "#0c0e10",
        "surface-container-high": "#1c2023",
        "on-primary-fixed": "#0c0e10",
        "error-container": "#93000a",
        "surface-variant": "#282d31",
        "on-tertiary-container": "#00285b",
        "primary-fixed": "#96d3bd",
        "on-tertiary-fixed-variant": "#96d3bd",
        "outline-variant": "#414754",
        "on-secondary": "#233144",
        "background": "#0c0e10",
        "tertiary-container": "#4a8eff",
        "surface": "#0c0e10",
        "surface-container": "#111416",
        "on-secondary-fixed": "#0d1c2e",
        "surface-bright": "#282d31",
        "tertiary": "#adc7ff",
        "surface-dim": "#0c0e10",
        "error": "#ffb4ab",
        "inverse-surface": "#e2e6eb",
        "surface-container-low": "#111416",
        "secondary-fixed": "#d5e3fc",
        "primary": "#96d3bd",
        "on-secondary-fixed-variant": "#3a485b",
        "on-surface-variant": "#e2e6eb",
        "outline": "#8b90a0",
        "on-tertiary-fixed": "#001a41",
        "on-error": "#690005",
        "on-primary-fixed-variant": "#004f58",
        "on-surface": "#e2e6eb",
        "tertiary-fixed-dim": "#adc7ff",
        "primary-fixed-dim": "#96d3bd",
        "inverse-on-surface": "#0c0e10",
        "surface-container-highest": "#282d31",
        "secondary": "#b9c7df",
        "surface-container-lowest": "#060708",
        "on-primary": "#0c0e10",
        "surface-tint": "#96d3bd"
      },
      fontFamily: {
        headline: [
          "Space Grotesk",
          "ui-sans-serif",
          "system-ui",
          "sans-serif",
        ],
        body: ["Inter", "ui-sans-serif", "system-ui", "sans-serif"],
        label: ["Inter", "ui-sans-serif", "system-ui", "sans-serif"],
      },
      borderRadius: {
        DEFAULT: "0.125rem",
        lg: "0.25rem",
        xl: "0.5rem",
        full: "0.75rem"
      }
    }
  },
  plugins: []
}
