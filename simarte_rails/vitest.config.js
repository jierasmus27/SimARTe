import { defineConfig } from "vitest/config"

export default defineConfig({
  test: {
    environment: "jsdom",
    include: ["test/javascript/**/*.test.js"],
    // threads pool avoids fork teardown issues in some CI/sandbox environments
    pool: "threads"
  }
})
