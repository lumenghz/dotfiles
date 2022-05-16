--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
vim.opt.relativenumber = true

lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "tokyodark"
lvim.transparent_window = true

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<C-n>"] = ":NvimTreeToggle<cr>"
lvim.keys.normal_mode["<M-h>"] = ":BufferLineCyclePrev<cr>"
lvim.keys.normal_mode["<M-l>"] = ":BufferLineCycleNext<cr>"
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = false
-- edit a default keymapping
lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
-- }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 1

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "java",
  "yaml",
}
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- copilot
local cmp = require("cmp")
lvim.builtin.cmp.mapping["<C-e>"] = function(fallback)
  cmp.mapping.abort()
  local copilot_keys = vim.fn["copilot#Accept"]()
  if copilot_keys ~= "" then
    vim.api.nvim_feedkeys(copilot_keys, "i", true)
  else
    fallback()
  end
end

-- generic LSP settings
lvim.lsp.automatic_servers_installation = false

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    name = "eslint_d",
    args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
    filetypes = { "typescript", "vue" },
  }
}

-- -- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  {
    name = "eslint",
    filetypes = { "typescript", "typescriptreact", "vue", "javascriptreact" }
  },
}

-- Additional Plugins
lvim.plugins = {
  -- General
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require("neoscroll").setup({
        mappings = {
          '<C-u>',
          '<C-d>',
          'zz',
        },
        hide_cursor = true,
        stop_eof = true,
        use_local_scrolloff = false,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = nil,
        pre_hook = nil,
        post_hook = nil,
      })
    end
  },
  {
    -- inline hex color
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "*" }, {
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        rbg_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
      })
    end
  },
  {
    -- show indent dot
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    config = function()
      -- vim.opt.list = true
      -- vim.opt.listchars:append("space:⋅")
      require("indent_blankline").setup({
        char = "⋅",
        show_end_of_line = true,
      })
    end
  },
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
    end
  },
  {
    -- git inline blame
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      vim.g.gitblame_enabled = 1
    end
  },
  {
    -- inline hint
    "ray-x/lsp_signature.nvim",
    config = function()
      require("lsp_signature").setup({
        floating_window = true,
      })
    end
  },
  {
    -- nvim-treesitter mods: generate method docs
    "nvim-treesitter/nvim-tree-docs",
    config = function()
      require("nvim-treesitter.configs").setup({
        tree_docs = {
          enable = true,
        }
      })
    end
  },
  -- Colorscheme
  {
    "tiagovla/tokyodark.nvim",
    config = function()
      vim.g.tokyodark_transparent_background = true
    end
  },
}
