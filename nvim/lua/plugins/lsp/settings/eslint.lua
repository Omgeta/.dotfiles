return {
  root_markers = {
    {
      "eslint.config.js",
      "eslint.config.cjs",
      "eslint.config.mjs",
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".eslintrc.json",
      ".eslintrc.yaml",
      ".eslintrc.yml",
      ".eslintrc",
    },
    {
      "package.json",
      ".git",
    },
  },

  settings = {
    validate = "on",
    packageManager = "npm",
    format = false,
  },
}
