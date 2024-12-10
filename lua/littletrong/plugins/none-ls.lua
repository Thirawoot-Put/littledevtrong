return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    'jay-babu/mason-null-ls.nvim'
  },
  config = function()
    local nls = require("null-ls")
    local mason_nls = require("mason-null-ls")
    mason_nls.setup({
      ensure_installed = { "prettier" },
    })

    nls.setup({
      sources = {
        require("none-ls.diagnostics.eslint_d").with({                      --js/ts linter
          condition = function(utils)
            return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs" }) -- only enable if root has .eslintrc.js or .eslintrc.cjs
          end,
        }),
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.sql_formatter,
        nls.builtins.formatting.prettier.with({
          condition = function(utils)
            return utils.root_has_file({
              ".prettierrc",
              ".prettierrc.js",
              ".prettierrc.json",
              ".prettierrc.yml",
              ".prettierrc.yaml",
              "prettier.config.js",
            })
          end
        }),
        -- nls.builtins.diagnostics.erb_lint,
        -- nls.builtins.diagnostics.rubocop,
        -- nls.builtins.formatting.rubocop,
      },
    })

    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Get format" })
  end,
}
