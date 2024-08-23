require('which-key').setup()
require('nvim-web-devicons').setup()
require('colorizer').setup({})
require('diffview').setup() -- :DiffviewOpen / DiffviewClose
require('spellsitter').setup()
require('illuminate').configure()
require('hop').setup()
require('ibl').setup()
require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Use this to override mappings for specific elements
  element_mappings = {
    -- Example:
    -- stacks = {
    --   open = "<CR>",
    --   expand = "o",
    -- }
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7") == 1,
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
      -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  controls = {
    -- Requires Neovim nightly (or 0.8 when released)
    enabled = true,
    -- Display controls in this element
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "↻",
      terminate = "□",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
  }
})
require('copilot').setup({
  filetypes = {
    -- disable by default
    ['*'] = false,
  },
})
require('copilot_cmp').setup()
require('leap').create_default_mappings()

local telescope = require('telescope')
telescope.setup({
  extensions = {
    whaler = {
      directories = {
        { path = "~/code", alias = "code" },
        { path = "~/code/github", alias = "github" },
        { path = "~/code/rtl/pspdx", alias = "devx" },
        { path = "~/code/rtl/contract", alias = "contract" },
        { path = "~/code/rtl/systemssq", alias = "systems" },
      },
      file_explorer = "nvimtree",
    }
  }
})

telescope.load_extension("whaler")
vim.keymap.set("n", "<leader>p", telescope.extensions.whaler.whaler)

---hop keybindings, easymotion like
nmap("<leader>b", "<cmd>HopWordBC<CR>")
nmap("<leader>w", "<cmd>HopWordAC<CR>")
nmap("<leader>j", "<cmd>HopLineAC<CR>")
nmap("<leader>k", "<cmd>HopLineBC<CR>")

require('todo-comments').setup {
  search = {
    pattern = [[\b(KEYWORDS)\b]],
  },
  highlight = {
    pattern = [[.*<(KEYWORDS)\s*]],
  },
}

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

require('nvim-tree').setup {
  sync_root_with_cwd = true,
  git = {
    ignore = true,
  },
}

local function open_nvim_tree(data)
  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not no_name and not directory then
    return
  end

  -- change to the directory
  if directory then
    vim.cmd.cd(data.file)
  end

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

require('fzf-lua').setup {
  winopts = {
    border = 'single',
  },
  fzf_opts = {
    ['--border'] = 'none',
  },
  files = {
    cmd = 'fd --type f --hidden --follow --exclude .git --exclude .vim --exclude .cache --exclude vendor --exclude node_modules',
  },
  grep = {
    rg_opts = "--hidden --column --line-number --no-heading " ..
        "--color=always --smart-case " ..
        "-g '!{.git,node_modules,vendor}/*'",
  },
}

require('gitsigns').setup {
  signs = {
    -- source: https://en.wikipedia.org/wiki/Box-drawing_character
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '┃' },
  },
  current_line_blame = true,
}

require('nvim-treesitter.configs').setup {
  -- they are managed by nix
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
}

require('treesitter-context').setup {
  enable = false,
  throttle = true,
}

require('bufferline').setup {
  options = {
    show_close_icon = false,
    show_buffer_close_icons = false,
    separator_style = "thick",
  },
}

require('lualine').setup {
  options = {
    -- gets set automatically
    -- theme = 'tokyonight',
    -- disable powerline
    section_separators = '',
    component_separators = '',
  },
}
