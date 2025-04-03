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
vim.opt.shortmess:append("c")
vim.opt.title = true
vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }
vim.opt.updatetime = 300
vim.opt.colorcolumn = { 81, 101 }
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = {
   tab      = "⇥-",
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
vim.opt.formatoptions:append("r")
vim.opt.formatoptions:append("n")
vim.opt.formatoptions:remove("t")
vim.opt.swapfile = false
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.spelllang = { "en", "uk" }
vim.opt.tabstop = 4
vim.opt.undofile = true
vim.opt.clipboard = "unnamedplus"
vim.opt.pumheight = 20
vim.opt.mousemodel = "extend"
vim.opt.winborder = "single"

vim.g.mapleader = " "

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

vim.g.netrw_keepdir = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 15


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
   callback = function() require("vim.hl").on_yank() end,
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
   command = "setlocal comments+=b:#:", -- '#:' sphinx docstrings comments
})
vim.api.nvim_create_autocmd("FileType", {
   group = "MyFiletypeOptions",
   pattern = "dosini",
   command = "setlocal comments+=b:#", -- '#' common ini dialect
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
            callback = vim.lsp.buf.document_highlight,
            buffer = ev.buf,
         })
         vim.api.nvim_create_autocmd("CursorMoved", {
            group = "MyLspAttach",
            callback = vim.lsp.buf.clear_references,
            buffer = ev.buf,
         })
      end
   end,
})

-- NeoVim only provides 'gq<motion>' and '<selection>gq' keymaps to invoke LSP
-- formatting. There's no easy way to LSP format an entire file. :(
vim.keymap.set({ "n", "v" }, "<Leader>F", function()
   vim.lsp.buf.format()
end, { desc = "Auto-format a buffer" })


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
      "hrsh7th/nvim-cmp",
      priority = 100,
      dependencies = {
         "dcampos/cmp-snippy",
         "hrsh7th/cmp-buffer",
         "hrsh7th/cmp-nvim-lsp",
         "hrsh7th/cmp-nvim-lsp-signature-help",
         "hrsh7th/cmp-nvim-lua",
         "hrsh7th/cmp-path",
      },
      config = function()
         local cmp = require("cmp")
         cmp.setup({
            completion = {
               completeopt = vim.o.completeopt,
            },
            window = {
               documentation = cmp.config.window.bordered({ border = vim.o.winborder }),
               completion = cmp.config.window.bordered({ border = vim.o.winborder }),
            },
            preselect = cmp.PreselectMode.None,
            mapping = cmp.mapping.preset.insert(
               {
                  ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                  ["<C-f>"] = cmp.mapping.scroll_docs(4),
                  ["<C-Space>"] = cmp.mapping.complete(),
                  ["<Cr>"] = cmp.mapping.confirm(),
               }
            ),
            formatting = {
               format = function(_, vim_item)
                  vim_item.menu = vim_item.kind
                  vim_item.kind = MiniIcons.get("lsp", vim_item.kind)
                  return vim_item
               end
            },
            sources = cmp.config.sources({
               { name = "nvim_lsp" },
               { name = "nvim_lsp_signature_help" },
               { name = "nvim_lua" },
               { name = "buffer",                 keyword_length = 3 },
               { name = "snippy" },
               { name = "path" },
            }),
         })
      end,
   },

   -- The snippet engine of choice.
   {
      "dcampos/nvim-snippy",
      opts = {
         mappings = {
            is = {
               ["<Tab>"] = "expand_or_advance",
               ["<S-Tab>"] = "previous",
            },
         },
      },
   },

   -- The collection of small QoL plugins for Neovim. First of all it provides
   -- various pickers with preview window.
   {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = {
         indent = { scope = { enabled = false } },
         gitbrowse = {
            open = function(url)
               if IS_REMOTE_HOST then
                  vim.fn.setreg("+", url)
               else
                  vim.ui.open(url)
               end
            end
         },
         picker = {
            sources = {
               explorer = {
                  auto_close = true,
                  diagnostics = false,
               }
            },
            win = {
               input = {
                  keys = {
                     ["<Esc>"] = { "close", mode = { "n", "i" } },
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

      },
      init = function()
         local layouts = require("snacks.picker.config.layouts")
         layouts.default.layout[1].border = vim.o.winborder
         layouts.default.layout[2].border = vim.o.winborder
         layouts.sidebar.layout[1].border = vim.o.winborder
         layouts.telescope.layout[1][1].border = vim.o.winborder
         layouts.telescope.layout[1][2].border = vim.o.winborder
         layouts.telescope.layout[2].border = vim.o.winborder
         layouts.dropdown.layout[1].border = vim.o.winborder
         layouts.dropdown.layout[2].border = vim.o.winborder
         layouts.vertical.layout.border = vim.o.winborder
         layouts.select.layout.border = vim.o.winborder
      end
   },

   -- LSP and its goodies.
   {
      "neovim/nvim-lspconfig",
      dependencies = { "hrsh7th/cmp-nvim-lsp", "b0o/SchemaStore.nvim" },
      config = function()
         local lspconfig = require("lspconfig")
         local server_settings = {
            pyright = {
               pyright = {
                  disableOrganizeImports = true,
               },
               python = {
                  analysis = {
                     autoImportCompletions = false,
                     diagnosticSeverityOverrides = {
                        -- reportIncompatibleMethodOverride = false,
                     },
                  },
               },
            },
            ts_ls = {
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
            lua_ls = {
               Lua = {
                  hint = {
                     enable = true,
                  },
               },
            },
            jsonls = {
               json = {
                  schemas = require("schemastore").json.schemas(),
                  validate = { enable = true },
               },
            },
         }
         local client_capabilities = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            require("cmp_nvim_lsp").default_capabilities()
         )

         for _, server_name in ipairs({
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
         }) do
            lspconfig[server_name].setup({
               capabilities = vim.deepcopy(client_capabilities),
               settings = server_settings[server_name] or vim.empty_dict(),
               silent = true,
            })
         end
      end,
   },

   -- Tree-sitter is a parser generator tool and an incremental parsing
   -- library. NeoVim can leverage its functionality in various ways: semantic
   -- syntax highlighting, indentation, navigation, etc.
   {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
         require("nvim-treesitter.configs").setup({
            highlight = { enable = true },
            incremental_selection = {
               enable = true,
               keymaps = {
                  init_selection = "<C-Space>",
                  scope_incremental = "<C-Space>",
               },
            },
         })
      end,
   },
   {
      "tree-sitter-grammars/tree-sitter-test",
      build = "make parser/test.so",
      ft = "test",
      init = function()
         -- toggle full-width rules for test separators
         vim.g.tstest_fullwidth_rules = false
         -- set the highlight group of the rules
         vim.g.tstest_rule_hlgroup = "FoldColumn"
      end
   },

   -- Non default colorschemes and their configurations.
   {
      "gbprod/nord.nvim",
      priority = 200,
      config = function()
         require("nord").setup({
            diff = { mode = "fg" },
            styles = {
               comments = { italic = false },
            }
         })
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
                        local fenc = vim.opt.fenc:get()
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
      config = function(self, opts)
         require("aerial").setup(opts)
         vim.keymap.set("n", "<Leader>2", "<Cmd>AerialToggle!<Cr>", { desc = "Toggle code outline" })
      end,
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

            vim.keymap.set({ "n", "v" }, "<Leader>hs", gitsigns.stage_hunk,
               { buffer = buffer, desc = "Stage current hunk" })
            vim.keymap.set({ "n", "v" }, "<Leader>hr", gitsigns.reset_hunk,
               { buffer = buffer, desc = "Revert current hunk" })
            vim.keymap.set("n", "<Leader>hu", gitsigns.undo_stage_hunk,
               { buffer = buffer, desc = "Unstage current hunk" })
            vim.keymap.set("n", "<Leader>hp", gitsigns.preview_hunk,
               { buffer = buffer, desc = "Show current hunk" })
            vim.keymap.set("n", "<Leader>hb", function() gitsigns.blame_line { full = true } end,
               { buffer = buffer, desc = "Blame current line" })
            vim.keymap.set("n", "<Leader>hd", function() gitsigns.diffthis("~") end,
               { buffer = buffer, desc = "Show current file diff" })
         end,
      }
   },
   {
      "brenoprata10/nvim-highlight-colors",
      opts = {},
   },
   {
      "echasnovski/mini.icons",
      opts = {
         lsp = {
            ["function"] = { glyph = "󰊕" },
         },
      },
      config = function(self, opts)
         require("mini.icons").setup(opts)
         MiniIcons.mock_nvim_web_devicons()
      end,
   },
   { "tpope/vim-sleuth" },
   { "mg979/vim-visual-multi" },
   {
      "williamboman/mason.nvim",
      opts = {},
      cond = (vim.fn.hostname() == "jakku"),
   },
}, {
   lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
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
