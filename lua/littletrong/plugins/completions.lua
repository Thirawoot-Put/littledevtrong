return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-path",             -- source for file system paths
    "L3MON4D3/LuaSnip",             -- snippet engine
    "saadparwaiz1/cmp_luasnip",     -- for autocompletion
    "rafamadriz/friendly-snippets", -- useful snippets
    "VonHeikemen/lsp-zero.nvim",
  },
  config = function()
    local cmp = require("cmp")
    local cmp_format = require("lsp-zero").cmp_format({ details = true })
    local cmp_action = require("lsp-zero").cmp_action()
    local luasnip = require("luasnip")

    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          if not luasnip then
            return
          end
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        -- ["<S-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        -- ["<S-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp_action.luasnip_jump_forward(),
        ["<C-f>"] = cmp_action.luasnip_jump_backward(),
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(),        -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp_action.luasnip_supertab(),
        ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "luasnip" }, -- snippets
        { name = "buffer" },  -- text within current buffer
        { name = "path" },    -- file system paths
      }),
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = cmp_format,
    })

    -- `:` cmdline setup.
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })

    -- ******* use this for separate normal sql file and dadbod ********
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "sql", "mysql", "plsql" },
      callback = function()
        local is_dadbod_session = vim.fn.exists(":DB") == 2 -- Detect if `vim-dadbod` is in use
        if is_dadbod_session then
          cmp.setup.buffer({
            sources = {
              { name = "vim-dadbod-completion" }, -- Use Dadbod completion only in DB sessions
            },
          })
        else
          -- Normal SQL completion for non-Dadbod files
          cmp.setup.buffer({
            sources = cmp.config.sources({
              { name = "buffer" },
              { name = "path" },
              { name = "nvim_lsp" }, -- Use LSP if available
            }),
          })
        end
      end,
    })
  end,
}
