--
-- Author: Ihor Kalnytskyi <ihor@kalnytskyi.com>
-- Source: https://git.io/JYNmy
--

--
-- // HELPERS //
--

-- These symbols essentially represent "single" border style. Once Telescope
-- supports built-in borders, we can probably replace them with just "single"
-- string.
local FLOAT_BORDER = {"┌", "─", "┐", "│", "┘", "─", "└", "│"}

-- Nerd Font icons for LSP completion item kinds.
local LSP_COMPLETION_ITEM_KIND_ICONS = {
   Text             = "",
   Method           = "",
   Function         = "",
   Constructor      = "⌘",
   Field            = "ﰠ",
   Variable         = "",
   Class            = "",
   Interface        = "",
   Module           = "",
   Property         = "ﰠ",
   Unit             = "",
   Value            = "",
   Enum             = "",
   Keyword          = "",
   Snippet          = "",
   Color            = "",
   File             = "",
   Reference        = "",
   Folder           = "",
   EnumMember       = "",
   Constant         = "",
   Struct           = "",
   Event            = "",
   Operator         = "",
   TypeParameter    = "",
}

-- Nerd Font icons for LSP symbol item kinds.
local LSP_SYMBOL_KIND_ICONS = {
   File             = "",
   Module           = "",
   Namespace        = ":",
   Package          = "",
   Class            = "",
   Method           = "",
   Property         = "ﰠ",
   Field            = "ﰠ",
   Constructor      = "⌘",
   Enum             = "",
   Interface        = "",
   Function         = "",
   Variable         = "",
   Constant         = "",
   String           = "",
   Number           = "#",
   Boolean          = "",
   Array            = "",
   Object           = "",
   Key              = "",
   Null             = "␀",
   EnumMember       = "",
   Struct           = "",
   Event            = "",
   Operator         = "",
   TypeParameter    = "",
}

local LSP_CAPABILITIES = vim.lsp.protocol.make_client_capabilities()


--
-- // OPTIONS //
--

vim.opt.termguicolors = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmode = false
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 3
vim.opt.shortmess:append("c")
vim.opt.title = true
vim.opt.completeopt = {"menu", "menuone", "noselect", "noinsert"}
vim.opt.updatetime = 300
vim.opt.colorcolumn = {"81", "101"}
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = {
   tab      = " ",
   lead     = "·",
   trail    = "·",
   nbsp     = "⎵",
   extends  = "⟩",
   precedes = "⟨",
}
vim.opt.showbreak = "➥ "
vim.opt.foldenable = false
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
vim.opt.spelllang = {"en", "uk"}
vim.opt.tabstop = 4
vim.opt.undofile = true
vim.opt.clipboard = "unnamedplus"
vim.opt.pumheight = 20

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

vim.g.netrw_keepdir = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 15


--
-- // HOOKS //
--

vim.api.nvim_create_augroup("NvimTextYank", {})
vim.api.nvim_create_autocmd("TextYankPost", {
   group = "NvimTextYank",
   callback = function()
      require("vim.highlight").on_yank()
   end,
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

vim.api.nvim_create_augroup("NvimFiletypeOptions", {})
vim.api.nvim_create_autocmd("FileType", {
   group = "NvimFiletypeOptions",
   pattern = "python",
   command = "setlocal comments+=b:#:",   -- '#:' sphinx docstrings comments
})


--
-- // LSP FRAMEWORK //
--

vim.api.nvim_create_augroup("NvimLspAttach", {})
vim.api.nvim_create_autocmd("LspAttach", {
   group = "NvimLspAttach",
   callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local keymap_opts = { buffer = args.buf }

      vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, keymap_opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, keymap_opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
      vim.keymap.set("n", "<Space>k", vim.lsp.buf.hover, keymap_opts)
      vim.keymap.set("n", "<Space>s", vim.lsp.buf.document_symbol, keymap_opts)
      vim.keymap.set("n", "<Space>S", vim.lsp.buf.workspace_symbol, keymap_opts)
      vim.keymap.set({"n", "v"}, "<Space>a", vim.lsp.buf.code_action, keymap_opts)
      vim.keymap.set("n", "<Space>r", vim.lsp.buf.rename, keymap_opts)

      if client.server_capabilities.documentHighlightProvider then
         vim.api.nvim_create_augroup("NvimLspHighlightReferences", {})
         vim.api.nvim_create_autocmd("CursorHold", {
            group = "NvimLspHighlightReferences",
            callback = vim.lsp.buf.document_highlight,
            buffer = args.buf,
         })
         vim.api.nvim_create_autocmd("CursorMoved", {
            group = "NvimLspHighlightReferences",
            callback = vim.lsp.buf.clear_references,
            buffer = args.buf,
         })
      end
   end,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
   vim.lsp.handlers.hover, {
      border = FLOAT_BORDER,
      focusable = false,
   }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
   vim.lsp.handlers.signature_help, {
      border = FLOAT_BORDER,
      focusable = false,
   }
)


--
-- // DIAGNOSTIC FRAMEWORK //
--

vim.diagnostic.config({
   virtual_text = false,
   severity_sort = true,
   float = {
      border = FLOAT_BORDER,
      focusable = false,
   },
})

vim.fn.sign_define({
   -- Set custom icons for diagnostics. Unfortunately these signs aren't
   -- defined until diagnostics are shown for the first time, that's why
   -- specifying `texthl` in addition to `text` is required; otherwise proper
   -- highlight groups won't be applied.
   {name = "DiagnosticSignError", text = "", texthl = "DiagnosticSignError"},
   {name = "DiagnosticSignWarn",  text = "", texthl = "DiagnosticSignWarn"},
   {name = "DiagnosticSignInfo",  text = "", texthl = "DiagnosticSignInfo"},
   {name = "DiagnosticSignHint",  text = "", texthl = "DiagnosticSignHint"},
})

vim.api.nvim_create_augroup("NvimDiagnostic", {})
vim.api.nvim_create_autocmd("CursorHold", {
   group = "NvimDiagnostic",
   callback = function()
      vim.diagnostic.open_float(0, {scope="cursor"})
   end
})


--
-- // KEYBINDINGS //
--

vim.keymap.set("n", "<Space>3", function() vim.wo.spell = not vim.wo.spell end)
vim.keymap.set("n", "<Space>d", vim.diagnostic.setloclist)


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
   -- completion and built-in LSP.
   {
      "hrsh7th/nvim-cmp",
      dependencies = {
         "hrsh7th/cmp-nvim-lsp",
         "hrsh7th/cmp-nvim-lsp-signature-help",
         "hrsh7th/cmp-buffer",
         "hrsh7th/cmp-nvim-lua",
         "hrsh7th/cmp-path",
         { "petertriho/cmp-git", dependencies = "nvim-lua/plenary.nvim" },
      },
      config = function()
         local cmp = require("cmp")
         cmp.setup({
            completion = {
               completeopt = vim.o.completeopt,
            },
            window = {
               documentation = cmp.config.window.bordered({
                  border = FLOAT_BORDER,
               }),
               completion = cmp.config.window.bordered({
                  border = FLOAT_BORDER,
               }),
            },
            snippet = {
               expand = function(args)
                  require("snippy").expand_snippet(args.body)
               end
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
                  vim_item.kind = LSP_COMPLETION_ITEM_KIND_ICONS[vim_item.kind]
                  return vim_item
               end
            },
            sources = cmp.config.sources({
               { name = "nvim_lsp" },
               { name = "nvim_lsp_signature_help" },
               { name = "nvim_lua" },
               { name = "buffer" , keyword_length = 3 },
               { name = "snippy" },
               { name = "path" },
            }),
         })
         cmp.setup.filetype("gitcommit", {
            sources = cmp.config.sources({
               { name = "git" },
               { name = "buffer" , keyword_length = 3 },
            }),
         })
         require("cmp_git").setup({})

         LSP_CAPABILITIES = vim.tbl_deep_extend(
            "force",
            LSP_CAPABILITIES,
            require("cmp_nvim_lsp").default_capabilities()
         )
      end,
   },

   -- The snippet engine of choice.
   {
      "dcampos/nvim-snippy",
      dependencies = {"dcampos/cmp-snippy"},
      opts = {
         mappings = {
            is = {
               ["<Tab>"] = "expand_or_advance",
               ["<S-Tab>"] = "previous",
            },
         },
      },
   },

   -- Telescope is general fuzzy finder over lists that could be used to find
   -- files, grep projects, show LSP symbols, etc. One generic interface for
   -- lot of things.
   {
      "nvim-telescope/telescope.nvim",
      dependencies = {
         "nvim-lua/plenary.nvim",
         { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
         "nvim-telescope/telescope-file-browser.nvim",
         "nvim-telescope/telescope-ui-select.nvim",
         "debugloop/telescope-undo.nvim",
      },
      config = function()
         local telescope = require("telescope")
         local telescope_actions = require("telescope.actions")
         local telescope_builtin = require("telescope.builtin")

         telescope.setup({
            defaults = {
               sorting_strategy = "ascending",
               layout_config = {
                  horizontal = {
                     height = 0.7,
                     prompt_position = "top",
                  },
               },
               -- Do not show prompt, selection, entry caret, keep UI simple.
               prompt_prefix = " ",
               selection_caret = " ",
               entry_prefix = " ",
               multi_icon = "",
               borderchars = {
                  -- Telescope doesn't support built-in borders yet :'(
                  FLOAT_BORDER[2],
                  FLOAT_BORDER[4],
                  FLOAT_BORDER[6],
                  FLOAT_BORDER[8],
                  FLOAT_BORDER[1],
                  FLOAT_BORDER[3],
                  FLOAT_BORDER[5],
                  FLOAT_BORDER[7],
               },
               results_title = false,
               prompt_title = false,
               mappings = {
                  i = {
                     -- I don't need Vim modes in Telescope, so any time Esc is
                     -- pressed I want to close Telescope instead of entering
                     -- Normal mode.
                     ["<Esc>"] = telescope_actions.close,
                     ["<C-Down>"] = telescope_actions.cycle_history_next,
                     ["<C-Up>"] = telescope_actions.cycle_history_prev,
                     ["<C-h>"] = "which_key",
                  },
               },
            },
            extensions = {
               file_browser = {
                  hidden = false,
                  hijack_netrw = true,
                  git_status = false,
                  mappings = {
                     i = {
                        -- Use the same shortcuts as telescope.nvim for
                        -- consistent experience.
                        ["<C-x>"] = telescope_actions.select_horizontal,
                        ["<C-v>"] = telescope_actions.select_vertical,
                        ["<C-t>"] = telescope_actions.select_tab,
                     },
                  },
               },
               undo = {
                  use_delta = false,
               },
            },
         })
         telescope.load_extension("fzf")
         telescope.load_extension("projects")
         telescope.load_extension("file_browser")
         telescope.load_extension("ui-select")
         telescope.load_extension("undo")

         vim.keymap.set("n", "<Space>1", function()
            telescope.extensions.file_browser.file_browser({path = "%:p:h", hidden = true})
         end)
         vim.keymap.set("n", "<Space>f", telescope_builtin.git_files)
         vim.keymap.set("n", "<Space>/", telescope_builtin.live_grep)
         vim.keymap.set("n", "<Space>.", telescope_builtin.grep_string)
         vim.keymap.set("n", "<Space>'", telescope_builtin.resume)
         vim.keymap.set("n", "<Space>d", function()
            telescope_builtin.diagnostics({bufnr = 0, no_sign = true})
         end)


         vim.api.nvim_create_augroup("NvimTelescopeLspAttach", {})
         vim.api.nvim_create_autocmd("LspAttach", {
            group = "NvimTelescopeLspAttach",
            callback = function(args)
               local client = vim.lsp.get_client_by_id(args.data.client_id)
               local keymap_opts = { buffer = args.buf }

               -- These are Telescope keymap overwrites to provide a better UI
               -- than standard NeoVim does.
               vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions, keymap_opts)
               vim.keymap.set("n", "gy", telescope_builtin.lsp_type_definitions, keymap_opts)
               vim.keymap.set("n", "gr", telescope_builtin.lsp_references, keymap_opts)
               vim.keymap.set("n", "<Space>s", telescope_builtin.lsp_document_symbols, keymap_opts)
               vim.keymap.set("n", "<Space>S", telescope_builtin.lsp_dynamic_workspace_symbols, keymap_opts)
            end
         })
      end,
   },

   -- LSP and its goodies.
   {
      "neovim/nvim-lspconfig",
      dependencies = {
         "b0o/SchemaStore.nvim",
      },
      config = function()
         local lspconfig = require("lspconfig")
         local config = lspconfig.util.default_config

         config.capabilities = LSP_CAPABILITIES
         lspconfig.rust_analyzer.setup({})
         lspconfig.pyright.setup({
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
         lspconfig.ruff_lsp.setup({})
         lspconfig.clangd.setup({})
         lspconfig.bashls.setup({})
         lspconfig.tsserver.setup({
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
               }
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
               }
             }
           }
         })
         lspconfig.lua_ls.setup({
            settings = {
               Lua = {
                  hint = {
                     enable = true,
                  }
               },
            },
         })
         lspconfig.yamlls.setup({})
         lspconfig.cssls.setup({cmd = {"vscode-css-languageserver", "--stdio"}})
         lspconfig.html.setup({cmd = {"vscode-html-languageserver", "--stdio"}})
         lspconfig.jsonls.setup({
            cmd = {"vscode-json-languageserver", "--stdio"},
            settings = {
               json = {
                  schemas = require("schemastore").json.schemas(),
                  validate = { enable = true },
               },
            },
         })
         lspconfig.taplo.setup({})
      end,
   },
   {
      "lvimuser/lsp-inlayhints.nvim",
      config = function()
         require("lsp-inlayhints").setup({
            inlay_hints = {
               parameter_hints = {
                  show = false,
               },
               type_hints = {
                  prefix = "→ ",
                  remove_colon_start = true,
               },
            },
         })

         vim.api.nvim_create_augroup("NvimInlayHintsLspAttach", {})
         vim.api.nvim_create_autocmd("LspAttach", {
            group = "NvimInlayHintsLspAttach",
            callback = function(args)
               local lspinlayhints = require("lsp-inlayhints")
               local client = vim.lsp.get_client_by_id(args.data.client_id)
               local keymap_opts = { buffer = args.buf }

               lspinlayhints.on_attach(client, args.buf)
               vim.keymap.set("n", "<Space>4", lspinlayhints.toggle, keymap_opts)
            end
         })
      end,
   },
   {
      "kosayoda/nvim-lightbulb",
      config = function()
         require("nvim-lightbulb").setup({autocmd = {enabled = true}})
         vim.fn.sign_define("LightBulbSign", {text = "", texthl = "LspDiagnosticsDefaultInformation"})
      end,
   },

   -- Tree-sitter is a parser generator tool and an incremental parsing
   -- library. NeoVim can leverage its functionality in various ways: semantic
   -- syntax highlighting, indentation, navigation, etc.
   {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      dependencies = {
         "nvim-treesitter/playground",
      },
      config = function()
         require("nvim-treesitter.configs").setup({
            highlight = {enable = true},
            incremental_selection = {
               enable = true,
               keymaps = {
                  init_selection = "<C-Space>",
                  scope_incremental = "<C-Space>",
               },
            },
            playground = {enable = true},
         })
      end,
   },

   -- Non default colorschemes and their configurations.
   {
      "gbprod/nord.nvim",
      priority = 100,
      config = function()
         vim.cmd.colorscheme("nord")
      end,
   },
   {
      "folke/tokyonight.nvim",
      priority = 100,
      opts = {
         styles = {
            comments = { italic = false },
            keywords = { italic = false },
         },
         lualine_bold = true,
      },
   },
   { "catppuccin/nvim", name = "catppuccin", opts = {flavour = "macchiato"} },
   { "rebelot/kanagawa.nvim", config = true },

   {
      "nvim-lualine/lualine.nvim",
      config = function()
         local breadcrump_sep = " ⟩ "

         require("lualine").setup({
            options = {
               globalstatus = true,
            },
            sections = {
               lualine_a = {"mode"},
               lualine_b = {
                  {
                     "filename",
                     path = 1,
                     separator = vim.trim(breadcrump_sep),
                     fmt = function(str)
                        local path_separator = package.config:sub(1, 1)
                        return str:gsub(path_separator, breadcrump_sep)
                     end
                  },
                  { "aerial", sep = breadcrump_sep, colored = false },
               },
               lualine_c = {},
               lualine_x = {"lsp_progress"},
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
               lualine_z = {"location"},
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
         icons = LSP_SYMBOL_KIND_ICONS,
         on_attach = function(buffer)
            vim.keymap.set("n", "<Space>2", "<Cmd>AerialToggle!<Cr>", {buffer = buffer})
         end,
      }
   },
   {
      "stevearc/overseer.nvim",
      config = true,
   },
   {
      "ahmedkhalf/project.nvim",
      config = function()
         require("project_nvim").setup()
      end,
   },
   {
      "folke/which-key.nvim",
      opts = {
         plugins = {
            spelling = {enabled = true},
         },
      },
   },
   {
      "lewis6991/gitsigns.nvim",
      opts = {
         preview_config = {
            border = FLOAT_BORDER,
            focusable = false,
         },
         on_attach = function(buffer)
            local gitsigns = require("gitsigns")

            -- There's no need for next/prev hunk keymaps for diff buffers
            -- since they support them natively.
            if not vim.wo.diff then
               vim.keymap.set("n", "]c", gitsigns.next_hunk, {buffer = buffer})
               vim.keymap.set("n", "[c", gitsigns.prev_hunk, {buffer = buffer})
            end

            vim.keymap.set({"n", "v"}, "<Space>hs", gitsigns.stage_hunk, {buffer = buffer})
            vim.keymap.set({"n", "v"}, "<Space>hr", gitsigns.reset_hunk, {buffer = buffer})
            vim.keymap.set("n", "<Space>hu", gitsigns.undo_stage_hunk, {buffer = buffer})
            vim.keymap.set("n", "<Space>hp", gitsigns.preview_hunk, {buffer = buffer})
            vim.keymap.set("n", "<Space>hb", function() gitsigns.blame_line{full=true} end, {buffer = buffer})
            vim.keymap.set("n", "<Space>hd", function() gitsigns.diffthis("~") end, {buffer = buffer})
         end,
      }
   },
   {
      "norcalli/nvim-colorizer.lua",
      opts = {
         css = { css = true },
         stylus = { css = true },
      },
      enabled = vim.opt.termguicolors:get(),
   },
   {"nvim-tree/nvim-web-devicons"},
   {"tpope/vim-sleuth"},
   {"mg979/vim-visual-multi"},
   {"tpope/vim-fugitive"},
   {"lukas-reineke/indent-blankline.nvim", config = true},
   {"kylechui/nvim-surround", config = true},
   {
      "ojroques/nvim-osc52",
      config = function()
         local function copy(lines, _)
           require("osc52").copy(table.concat(lines, "\n"))
         end

         local function paste()
           return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
         end

         vim.g.clipboard = {
           name = "osc52",
           copy = { ["+"] = copy, ["*"] = copy },
           paste = { ["+"] = paste, ["*"] = paste },
         }
      end,
      -- Since Neovim natively supports system clipboard there's no much sense
      -- to prefer OSC-52 over native implementation. However, native clipboard
      -- providers work only when Neovim is running in the localhost and won't
      -- work when it's flying remotely. For remote sessions we'd like to use
      -- OSC52 as it's supported by the terminal.
      cond = (vim.env.SSH_CONNECTION or vim.loop.fs_stat("/run/host/container-manager")) ~= nil,
   },
}, {
   lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
   ui = { border = FLOAT_BORDER },
})


--
-- // SOURCE EXTRA CONFIGURATIONS //
--

for _, name in ipairs({vim.fn.hostname(), "local"}) do
   local path = string.format("%s/init.%s.lua", vim.fn.stdpath("config"), name)

   if vim.fn.filereadable(path) == 1 then
      vim.cmd.source(path)
   end
end
