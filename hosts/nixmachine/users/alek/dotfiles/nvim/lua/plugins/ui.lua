return {
  -- 1. Color scheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000, -- download the theme first
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- 2. Icon set (requires Nerd fonts in the terminal)
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- 3. Side File tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
      -- Shortcut: Ctrl+B to open/close the file tree
      vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>', { desc = 'Переключить дерево файлов' })
    end,
  },

  -- 4. Status bar at the bottom of the screen
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = 'tokyonight' }
      })
    end,
  }
}
