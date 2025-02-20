local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { 'folke/tokyonight.nvim', lazy = false, priority = 1000, config = function()
      vim.cmd.colorscheme('tokyonight')
    end,
  },
  { "folke/which-key.nvim", event = "VeryLazy" },
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }, config = function()
      require('lualine').setup({ options = { theme = 'auto' } })
    end,
  },
  { "jghauser/mkdir.nvim", event = "BufWritePre" },
  { 'williamboman/mason.nvim', dependencies = {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'jayp0521/mason-null-ls.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      require('mason').setup({})
      require('mason-tool-installer').setup({ ensure_installed = { 'intelephense' }, auto_update = true })
      require('lspconfig').intelephense.setup({ settings = { intelephense = { files = { maxSize = 5000000 } } } })
    end,
  },
  { "github/copilot.vim", lazy=false },
  { 'stevearc/aerial.nvim', dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-lspconfig' }, config = function()
      require('aerial').setup({
        backends = { "lsp", "treesitter", "markdown" },
        layout = { default_direction = "right" },
        attach_mode = "global",
        show_guides = true,
      })
      vim.keymap.set('n', '<Leader>a', '<cmd>AerialToggle!<CR>', { desc = 'Toggle Aerial' })
    end,
    lazy = true,
    keys = { '<Leader>a' },
  }
})

vim.opt.mouse = ""
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<Tab>", 'copilot#Accept("<Tab>")', { expr = true, silent = true, noremap = true })

local diagnostics_visible = true

function ToggleDiagnostics()
  diagnostics_visible = not diagnostics_visible
  if diagnostics_visible then
    vim.diagnostic.show()
    print("LSP Diagnostics: ON")
  else
    vim.diagnostic.hide()
    print("LSP Diagnostics: OFF")
  end
end

vim.api.nvim_create_user_command("ToggleDiagnostics", ToggleDiagnostics, {})
vim.keymap.set("n", "<leader>d", ":ToggleDiagnostics<CR>", { noremap = true, silent = true })
