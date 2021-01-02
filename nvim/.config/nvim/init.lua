--
-- Author: Ihor Kalnytskyi <ihor@kalnytskyi.com>
-- Source: https://git.io/JYNmy
--

--
-- // CONSTANTS //
--

local IS_REMOTE_HOST = os.getenv("SSH_TTY")            -- ssh
    or vim.loop.fs_stat("/run/host/container-manager") -- systemd-nspawn
    or vim.loop.fs_stat("/.dockerenv")                 -- docker


--
-- // OPTIONS //
--

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmode = false
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 3
vim.opt.shortmess:append({ a = true, s = true, c = true })
vim.opt.title = true
vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }
vim.opt.updatetime = 300
vim.opt.colorcolumn = { 81, 101 }
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = {
   tab      = "--⇥",
   lead     = "·",
   trail    = "·",
   nbsp     = "␣",
   extends  = "⟩",
   precedes = "⟨",
}
vim.opt.showbreak = "➥ "
vim.opt.foldenable = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.wrap = false
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.expandtab = true
vim.opt.formatoptions:append({ r = true, n = true, t = false })
vim.opt.swapfile = false
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.spelllang = { "en", "uk" }
vim.opt.tabstop = 4
vim.opt.undofile = true
vim.opt.clipboard = "unnamedplus"
vim.opt.pumheight = 20
vim.opt.mousemodel = "extend"
vim.opt.mousescroll = "ver:3,hor:0"
vim.opt.winborder = "rounded"

vim.g.mapleader = " "

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

vim.g.netrw_keepdir = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 15


--
-- // KEYMAPS //
--

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "<Leader>F", function() vim.lsp.buf.format() end, { desc = "Format" })


--
-- // CLIPBOARD //
--

-- When running NeoVim over SSH or in a Linux container, system clipboard
-- integration usually fails due to the lack of X11 or Wayland sockets. Using
-- OSC 52 escape codes can improve clipboard integration if supported by the
-- terminal emulator.
if IS_REMOTE_HOST then
   local osc52 = require("vim.ui.clipboard.osc52")
   vim.g.clipboard = {
      name = "OSC 52",
      copy = {
         ["+"] = osc52.copy("+"),
         ["*"] = osc52.copy("*"),
      },
      paste = {
         ["+"] = osc52.paste("+"),
         ["*"] = osc52.paste("*"),
      },
   }
end


--
-- // HOOKS //
--

vim.api.nvim_create_autocmd("TextYankPost", {
   group = vim.api.nvim_create_augroup("MyTextYank", {}),
   callback = function() vim.hl.on_yank() end,
})


--
-- // LANGUAGES //
--

vim.filetype.add({
   extension = {
      ["rasi"] = "rasi",
   },
   pattern = {
      [".*/sway/config%.d/.*"] = "swayconfig",
      [".*/sway/config%..*"] = "swayconfig",
   },
})

vim.api.nvim_create_augroup("MyFiletypeOptions", {})
vim.api.nvim_create_autocmd("FileType", {
   group = "MyFiletypeOptions",
   pattern = "python",
   callback = function()
      vim.opt_local.comments:append("b:#:") -- '#:' sphinx docstring comments
   end
})
vim.api.nvim_create_autocmd("FileType", {
   group = "MyFiletypeOptions",
   pattern = "dosini",
   callback = function()
      vim.opt_local.comments:append("b:#") -- '#' common ini dialect
   end
})


--
-- // LSP FRAMEWORK //
--

vim.api.nvim_create_augroup("MyLspAttach", {})
vim.api.nvim_create_autocmd("LspAttach", {
   group = "MyLspAttach",
   callback = function(ev)
      local lsp_client = vim.lsp.get_client_by_id(ev.data.client_id)

      if lsp_client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
         vim.api.nvim_create_autocmd("CursorHold", {
            group = "MyLspAttach",
            callback = function()
               vim.lsp.buf.document_highlight()
            end,
            buffer = ev.buf,
         })
         vim.api.nvim_create_autocmd("CursorMoved", {
            group = "MyLspAttach",
            callback = function()
               vim.lsp.buf.clear_references()
            end,
            buffer = ev.buf,
         })
      end
   end,
})
vim.lsp.config("clangd", {
   -- Header insertions are nasty and rarely work for me. Since clangd 21, they
   -- can be disabled via clangd’s own configuration file. Until it's available
   -- in Arch Linux, I have no choice but to maintain this setting here.
   cmd = { "clangd", "--header-insertion=never" },
})

--
-- // DIAGNOSTIC FRAMEWORK //
--

vim.diagnostic.config({
   severity_sort = true,
   float = {
      focusable = false,
   },
   signs = {
      text = {
         [vim.diagnostic.severity.ERROR] = "",
         [vim.diagnostic.severity.WARN] = "",
         [vim.diagnostic.severity.INFO] = "",
         [vim.diagnostic.severity.HINT] = "",
      }
   }
})


--
-- // PLUGINS //
--

-- Bootstrap the plugin manager, i.e. download the latest version from GitHub
-- if it's not yet downloaded.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
   vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--single-branch",
      "https://github.com/folke/lazy.nvim.git",
      lazypath,
   })
end
vim.opt.runtimepath:prepend(lazypath)


require("lazy").setup({
   -- Fast asynchronous completion manager that works with omnicomplete, word
   -- completion and built-in LSP. The priority must be higher than of lspconfig
   -- plugin, because its config updates LSP client capabilities.
   {
      "saghen/blink.cmp",
      priority = 100,
      version = "1.*",
      opts = {
         cmdline = { enabled = false },
         completion = {
            accept = { auto_brackets = { enabled = false } },
            documentation = { auto_show = true },
            list = { selection = { preselect = false, auto_insert = false } },
            menu = {
               draw = {
                  columns = {
                     { "kind_icon", "label", "label_description", gap = 1 },
                     { "kind" },
                     -- { "label",     "label_description", gap = 1 },
                     -- { "kind_icon", "kind",              gap = 1 },
                  },
                  components = {
                     kind_icon = {
                        text = function(ctx)
                           local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                           return kind_icon
                        end,
                     },
                  },
               },
            },
         },
         keymap = {
            preset = "default",
            ["<Cr>"] = { "accept", "fallback" },
         },
         signature = { enabled = true },
         sources = { min_keyword_length = 3 },
      },
   },

   -- A collection of small quality-of-life plugins for Neovim, including
   -- general fuzzy finders for files/symbols/etc., a file explorer,
   -- indentation guides and much more.
   {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = {
         gitbrowse = {
            open = function(url)
               if IS_REMOTE_HOST then
                  vim.fn.setreg("+", url)
               else
                  vim.ui.open(url)
               end
            end
         },
         indent = {
            scope = { enabled = false },
         },
         picker = {
            sources = {
               explorer = {
                  auto_close = true,
                  diagnostics = false,
                  win = {
                     list = {
                        keys = {
                           ["<C-t>"] = { "tab", mode = { "n", "i" } },
                        }
                     }
                  },
               },
            },
            win = {
               input = {
                  keys = {
                     ["<Esc>"] = { "close", mode = { "n", "i" } },
                  }
               },
               preview = {
                  wo = {
                     number = false,
                  }
               }
            }
         },
      },
      keys = {
         { "<Leader>e", function() Snacks.explorer() end,                      desc = "Open file explorer" },
         { "<Leader>G", function() Snacks.gitbrowse() end,                     desc = "Open git browser",                  mode = { "n", "v" } },
         { "'",         function() Snacks.picker.marks() end,                  desc = "Open marks picker" },
         { "<Leader>f", function() Snacks.picker.git_files() end,              desc = "Open file picker" },
         { "<Leader>/", function() Snacks.picker.grep() end,                   desc = "Open search in workspace directory" },
         { "<Leader>b", function() Snacks.picker.buffers() end,                desc = "Open buffer picker" },
         { "<Leader>.", function() Snacks.picker.grep_word() end,              desc = "Open search of selection",          mode = { "n", "x" } },
         { "<Leader>'", function() Snacks.picker.resume() end,                 desc = "Open last picker" },
         { "<Leader>?", function() Snacks.picker.commands() end,               desc = "Open command palette" },
         { "<Leader>d", function() Snacks.picker.diagnostics_buffer() end,     desc = "Open diagnostic picker" },
         { "<Leader>g", function() Snacks.picker.git_status() end,             desc = "Open changed file picker" },
         { "<Leader>H", function() Snacks.toggle.inlay_hints():toggle() end,   desc = "Toggle inlay hints" },
         { "<Leader>3", function() Snacks.toggle.option("spell"):toggle() end, desc = "Toggle spelling" },
         { "gd",        function() Snacks.picker.lsp_definitions() end,        desc = "Goto definition" },
         { "gD",        function() Snacks.picker.lsp_declarations() end,       desc = "Goto declarations" },
         { "grr",       function() Snacks.picker.lsp_references() end,         desc = "Goto references" },
         { "gi",        function() Snacks.picker.lsp_implementations() end,    desc = "Goto implementation" },
         { "gy",        function() Snacks.picker.lsp_type_definitions() end,   desc = "Goto type definition" },
         { "<Leader>s", function() Snacks.picker.lsp_symbols() end,            desc = "Open symbol picker" },
         { "<Leader>S", function() Snacks.picker.lsp_workspace_symbols() end,  desc = "Open workspace symbol picker" },
         { "<Leader>q", function() Snacks.picker.treesitter() end,             desc = "Open symbol picker" },
      },
   },

   -- Lets you navigate your code with search labels, enhanced character
   -- motions, and Treesitter integration.
   {
      "folke/flash.nvim",
      event = "VeryLazy",
      opts = {
         modes = { char = { enabled = false } },
         prompt = { enabled = false },
      },
      keys = {
         { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
         { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      },
   },

   -- LSP and its goodies.
   {
      "neovim/nvim-lspconfig",
      dependencies = { "b0o/SchemaStore.nvim" },
      config = function()
         local servers = {
            "bashls",
            "clangd",
            "cssls",
            "dotls",
            "gopls",
            "html",
            "jsonls",
            "lua_ls",
            "marksman",
            "pyright",
            "ruff",
            "rust_analyzer",
            "sourcekit",
            "taplo",
            "ts_ls",
            "typos_lsp",
            "yamlls",
         }

         for _, server_name in ipairs(servers) do
            vim.lsp.enable(server_name)
         end

         vim.lsp.config("pyright", {
            settings = {
               pyright = {
                  disableOrganizeImports = true,
               },
               python = {
                  analysis = {
                     autoImportCompletions = false,
                  },
               },
            },
         })
         vim.lsp.config("ts_ls", {
            settings = {
               typescript = {
                  inlayHints = {
                     includeInlayParameterNameHints = "all",
                     includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                     includeInlayFunctionParameterTypeHints = true,
                     includeInlayVariableTypeHints = true,
                     includeInlayPropertyDeclarationTypeHints = true,
                     includeInlayFunctionLikeReturnTypeHints = true,
                     includeInlayEnumMemberValueHints = true,
                  },
               },
               javascript = {
                  inlayHints = {
                     includeInlayParameterNameHints = "all",
                     includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                     includeInlayFunctionParameterTypeHints = true,
                     includeInlayVariableTypeHints = true,
                     includeInlayPropertyDeclarationTypeHints = true,
                     includeInlayFunctionLikeReturnTypeHints = true,
                     includeInlayEnumMemberValueHints = true,
                  },
               },
            },
         })
         vim.lsp.config("lua_ls", {
            settings = {
               Lua = {
                  hint = {
                     enable = true,
                  },
               },
            },
         })
         vim.lsp.config("jsonls", {
            settings = {
               json = {
                  schemas = require("schemastore").json.schemas(),
                  validate = { enable = true },
               },
            },
         })
      end,
   },

   -- Tree-sitter is a parser generator tool and an incremental parsing
   -- library. NeoVim can leverage its functionality in various ways: semantic
   -- syntax highlighting, indentation, navigation, etc.
   {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      main = "nvim-treesitter.configs",
      opts = {
         highlight = { enable = true },
         incremental_selection = {
            enable = true,
            keymaps = {
               init_selection = "<C-Space>",
               scope_incremental = "<C-Space>",
            },
         },
      },
   },

   -- Non default colorschemes and their configurations.
   {
      "gbprod/nord.nvim",
      priority = 200,
      opts = {
         diff = { mode = "fg" },
         styles = {
            comments = { italic = false },
         }
      },
      config = function(_, opts)
         require("nord").setup(opts)
         vim.cmd.colorscheme("nord")
      end,
   },

   {
      "nvim-lualine/lualine.nvim",
      dependencies = { "stevearc/aerial.nvim" },
      config = function()
         local breadcrump_sep = " ⟩ "
         local format_hl = require("lualine.highlight").component_format_highlight

         require("lualine").setup({
            options = {
               globalstatus = true,
            },
            sections = {
               lualine_a = { "mode" },
               lualine_b = {
                  {
                     "filename",
                     path = 1,
                     separator = false,
                     fmt = function(str, ctx)
                        local path_separator = package.config:sub(1, 1)
                        local colorized_sep = ""
                            .. "%" .. format_hl({ name = "lualine_b_aerial_LLNonText" })
                            .. breadcrump_sep
                            .. "%" .. ctx.default_hl;
                        return str:gsub(path_separator, colorized_sep);
                     end
                  },
                  {
                     "aerial",
                     sep = breadcrump_sep,
                     sep_prefix = true,
                     padding = { left = 0, right = 1 },
                  },
               },
               lualine_c = {},
               lualine_x = {
                  { "vim.lsp.status():gsub('%%', '%%%%')", icon = "" },
               },
               lualine_y = {
                  "diagnostics",
                  {
                     "encoding",
                     cond = function()
                        -- UTF-8 is the de-facto standard encoding and is what
                        -- most users expect by default. There's no need to
                        -- show encoding unless it's something else.
                        local fenc = vim.opt_local.fenc:get()
                        return string.len(fenc) > 0 and string.lower(fenc) ~= "utf-8"
                     end,
                  },
                  "filetype",
                  "fileformat",
                  "progress",
               },
               lualine_z = { "location" },
            },
         })
      end,
   },
   {
      "stevearc/aerial.nvim",
      opts = {
         layout = {
            min_width = 40,
            max_width = 40,
         },
         highlight_on_jump = false,
         close_on_select = true,
         show_guides = true,
      },
      keys = {
         { "<Leader>2", "<Cmd>AerialToggle!<Cr>", desc = "Toggle code outline" },
      },
      lazy = false,
   },
   {
      "folke/which-key.nvim",
      opts = {
         preset = "modern",
         filter = function(mapping)
            -- Do not show key mappings w/o description, since it won't be
            -- useful anyway.
            return mapping.desc and mapping.desc ~= ""
         end,
         spec = {
            { "<Leader>h", group = "Git [H]unk" }
         }
      },
   },
   {
      "lewis6991/gitsigns.nvim",
      opts = {
         preview_config = {
            focusable = false,
         },
         on_attach = function(buffer)
            local gitsigns = require("gitsigns")

            -- There's no need for next/prev hunk keymaps for diff buffers
            -- since they support them natively.
            if not vim.wo.diff then
               vim.keymap.set("n", "]c", gitsigns.next_hunk, { buffer = buffer, desc = "Goto next change" })
               vim.keymap.set("n", "[c", gitsigns.prev_hunk, { buffer = buffer, desc = "Goto previous change" })
            end

            vim.keymap.set("n", "<Leader>hs", function()
               gitsigns.stage_hunk()
            end, { buffer = buffer, desc = "Stage hunk under cursor" })

            vim.keymap.set("v", "<Leader>hs", function()
               gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, { buffer = buffer, desc = "Stage selected hunk" })

            vim.keymap.set("n", "<Leader>hr", function()
               gitsigns.reset_hunk()
            end, { buffer = buffer, desc = "Revert hunk under cursor" })

            vim.keymap.set("v", "<Leader>hr", function()
               gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end, { buffer = buffer, desc = "Revert selected hunk" })

            vim.keymap.set("n", "<Leader>hp", function()
               gitsigns.preview_hunk()
            end, { buffer = buffer, desc = "Show current hunk" })

            vim.keymap.set("n", "<Leader>hb", function()
               gitsigns.blame_line({ full = true })
            end, { buffer = buffer, desc = "Blame current line" })
         end,
      },
   },

   -- Nerd icons for everything we need.
   {
      "echasnovski/mini.icons",
      opts = {
         lsp = {
            ["function"] = { glyph = "󰊕" },
         },
      },
      config = function(_, opts)
         require("mini.icons").setup(opts)
         MiniIcons.mock_nvim_web_devicons()
      end,
   },

   { "brenoprata10/nvim-highlight-colors", opts = {} },
   { "tpope/vim-sleuth" },
   -- {
   --    "mg979/vim-visual-multi",
   --    init=function ()
   --    end,
   -- },
   {
      "williamboman/mason.nvim",
      opts = {},
      cond = (vim.fn.hostname() == "jakku"),
   },
}, {
   lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
   install = { colorscheme = { "nord" } },
   ui = { border = vim.o.winborder },
})


--
-- // SOURCE EXTRA CONFIGURATIONS //
--

for _, name in ipairs({ vim.fn.hostname(), "local" }) do
   local path = string.format("%s/init.%s.lua", vim.fn.stdpath("config"), name)

   if vim.fn.filereadable(path) == 1 then
      vim.cmd.source(path)
   end
end
