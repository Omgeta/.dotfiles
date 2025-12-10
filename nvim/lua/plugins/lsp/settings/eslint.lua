local ok, util = pcall(require, "lspconfig.util")
if not ok then
  return {}
end

return {
  settings = {
    root_dir = util.root_pattern(
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".eslintrc.json",
      ".eslintrc.yaml",
      ".eslintrc.yml",
      ".eslintrc",

      -- flat config
      "eslint.config.js",
      "eslint.config.cjs",
      "eslint.config.mjs"
    ),
    validate = "on",
    packageManager = "npm",
    workingDirectories = { mode = "auto" },
    format = false,
  },
}
