return {
  "michaelb/sniprun",
  branch = "master",

  build = "sh install.sh",
  -- do 'sh install.sh 1' if you want to force compile locally
  -- (instead of fetching a binary from the github release). Requires Rust >= 1.65

  config = function()
    require("sniprun").setup({
      -- your options
    })

    local keymap = vim.keymap

    keymap.set("n", "<leader>xf", ":SnipRun<CR>", { desc = "Execute file with SnipRun" })
    keymap.set("v", "X", ":'<,'>SnipRun<CR>", { desc = "Execute hover with SnipRun" })
  end,
}
