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
   Class            = "ﴯ",
   Interface        = "",
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
   Struct           = "ﳤ",
   Event            = "",
   Operator         = "",
   TypeParameter    = "",
}

-- Nerd Font icons for LSP symbol item kinds.
local LSP_SYMBOL_KIND_ICONS = {
   File             = "",
   Module           = "",
   Namespace        = ":",
   Package          = "",
   Class            = "ﴯ",
   Method           = "",
   Property         = "ﰠ",
   Field            = "ﰠ",
   Constructor      = "⌘",
   Enum             = "",
   Interface        = "",
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
   Struct           = "ﳤ",
   Event            = "",
   Operator         = "",
   TypeParameter    = "",
}

local LSP_CAPABILITIES = vim.lsp.protocol.make_client_capabilities()
local LSP_ON_ATTACH_FUNCTIONS = {}


--
-- // OPTIONS //
--

vim.opt.termguicolors = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = "n"
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
vim.opt.showbreak = "﬌ "
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

vim.g.netrw_keepdir = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 15


--
-- // LSP FRAMEWORK //
--

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

vim.keymap.set("n", "<Leader>3", function() vim.wo.spell = not vim.wo.spell end)
vim.keymap.set("n", "<Leader>i", vim.diagnostic.setloclist)


--
-- // PLUGINS //
--

local PLUGINS = {
   -- Fast asynchronous completion manager that works with omnicomplete, word
   -- completion and built-in LSP.
   {"hrsh7th/nvim-cmp"},
   {"hrsh7th/cmp-buffer"},
   {"hrsh7th/cmp-nvim-lsp"},
   {"hrsh7th/cmp-nvim-lua"},
   {"hrsh7th/cmp-nvim-lsp-signature-help"},

   -- The snippet engine of choice with collection of snippets.
   {"dcampos/nvim-snippy"},

   -- Telescope is general fuzzy finder over lists that could be used to find
   -- files, grep projects, show LSP symbols, etc. One generic interface for
   -- lot of things.
   {"nvim-lua/plenary.nvim"},
   {"nvim-telescope/telescope.nvim"},
   {"nvim-telescope/telescope-fzf-native.nvim", run = "make"},
   {"nvim-telescope/telescope-file-browser.nvim"},
   {"nvim-telescope/telescope-ui-select.nvim"},

   -- LSP and its goodies.
   {"neovim/nvim-lspconfig"},
   {"simrat39/rust-tools.nvim"},
   {"kosayoda/nvim-lightbulb"},

   -- Tree-sitter is a parser generator tool and an incremental parsing
   -- library. NeoVim can leverage its functionality in various ways: semantic
   -- syntax highlighting, indentation, navigation, etc.
   {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"},
   {"nvim-treesitter/playground"},
   {"p00f/nvim-ts-rainbow"},
   {"lewis6991/spellsitter.nvim"},

   {"arcticicestudio/nord-vim", branch = "develop"},
   {"folke/tokyonight.nvim"},
   {"andersevenrud/nordic.nvim"},
   {"rmehri01/onenord.nvim"},

   {"nvim-lualine/lualine.nvim"},
   {"stevearc/aerial.nvim"},
   {"ahmedkhalf/project.nvim"},
   {"folke/which-key.nvim"},
   {"lewis6991/gitsigns.nvim"},
   {"tpope/vim-sleuth"},
   {"mg979/vim-visual-multi"},
   {"tpope/vim-fugitive"},
   {"Valloric/ListToggle"},
   {"norcalli/nvim-colorizer.lua"},
   {"kyazdani42/nvim-web-devicons"},

   -- Extra syntaxes support, since they aren't supported by Tree-sitter.
   {"iloginow/vim-stylus"},
   {"Glench/Vim-Jinja2-Syntax"},
   {"chrisbra/csv.vim"},
};

(function()
   local vim_plug = vim.fn.stdpath("data") .. "/site/autoload/plug.vim"
   local vim_plug_http = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

   if vim.fn.filereadable(vim_plug) == 0 then
      vim.cmd(string.format("!curl -fLo %s --create-dirs %s", vim_plug, vim_plug_http))
      vim.cmd("autocmd VimEnter * silent! PlugInstall --sync")
   end

   vim.fn["plug#begin"]()
   table.foreachi(PLUGINS, function(_, plugin)
      local repo = plugin[1]
      local opts = vim.deepcopy(plugin)
      opts[1] = nil
      if opts["run"] then
         opts["do"] = opts["run"]
         opts["run"] = nil
      end
      if vim.tbl_isempty(opts) then opts = vim.empty_dict() end
      vim.fn["plug#"](repo, opts)
   end)
   vim.fn["plug#end"]()
end)();


(function()
   local setup = {
      ["hrsh7th/nvim-cmp"] = function()
         local cmp = require("cmp")
         cmp.setup({
            completion = {
               completeopt = vim.o.completeopt,
            },
            window = {
               documentation = cmp.config.window.bordered({
                  border = FLOAT_BORDER,
                  winhighlight = "",
               }),
               completion = cmp.config.window.bordered({
                  border = FLOAT_BORDER,
                  winhighlight = "",
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
               { name = "nvim_lua" },
               { name = "nvim_lsp_signature_help" },
               { name = "buffer" , keyword_length = 3 },
            }),
         })
      end,

      ["hrsh7th/cmp-nvim-lsp"] = function()
         require("cmp_nvim_lsp").update_capabilities(LSP_CAPABILITIES)
      end,

      ["dcampos/nvim-snippy"] = function()
         require("snippy").setup({
            mappings = {
               is = {
                  ["<Tab>"] = "expand_or_advance",
                  ["<S-Tab>"] = "previous",
               },
            },
         })
      end,

      ["nvim-telescope/telescope.nvim"] = function()
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
            },
         })
         telescope.load_extension("fzf")
         telescope.load_extension("projects")
         telescope.load_extension("file_browser")
         telescope.load_extension("ui-select")

         vim.keymap.set("n", "<Leader>1", function()
            telescope.extensions.file_browser.file_browser({path = "%:p:h", hidden = true})
         end)
         vim.keymap.set("n", "<C-p>", telescope_builtin.git_files)
         vim.keymap.set("n", "<Leader>g", telescope_builtin.live_grep)
         vim.keymap.set("n", "<Leader>G", telescope_builtin.grep_string)
         vim.keymap.set("n", "<Leader>/", telescope_builtin.current_buffer_fuzzy_find)
         vim.keymap.set("n", "<Leader>?", telescope_builtin.resume)
         vim.keymap.set("n", "<Leader>i", function() telescope_builtin.diagnostics({bufnr = 0}) end)

         table.insert(LSP_ON_ATTACH_FUNCTIONS, function(client, bufnr)
            -- These are Telescope keymap overwrites to provide a better UI
            -- than standard NeoVim does.
            vim.keymap.set("n", "<Leader>d", telescope_builtin.lsp_definitions, {buffer = bufnr})
            vim.keymap.set("n", "<Leader>D", telescope_builtin.lsp_type_definitions, {buffer = bufnr})
            vim.keymap.set("n", "<Leader>t", telescope_builtin.lsp_document_symbols, {buffer = bufnr})
            vim.keymap.set("n", "<Leader>T", telescope_builtin.lsp_dynamic_workspace_symbols, {buffer = bufnr})
            vim.keymap.set("n", "<Leader>r", telescope_builtin.lsp_references, {buffer = bufnr})
         end)
      end,

      ["neovim/nvim-lspconfig"] = function()
         local lspconfig = require("lspconfig")
         local config = lspconfig.util.default_config

         config.capabilities = LSP_CAPABILITIES
         config.on_attach = function(client, bufnr)
            vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

            vim.keymap.set("n", "<Leader>D", vim.lsp.buf.declaration, {buffer = bufnr})
            vim.keymap.set("n", "<Leader>d", vim.lsp.buf.definition, {buffer = bufnr})
            vim.keymap.set("n", "<Leader>H", vim.lsp.buf.hover, {buffer = bufnr})
            vim.keymap.set("n", "<Leader>t", vim.lsp.buf.document_symbol, {buffer = bufnr})
            vim.keymap.set("n", "<Leader>T", vim.lsp.buf.workspace_symbol, {buffer = bufnr})
            vim.keymap.set("n", "<Leader>r", vim.lsp.buf.references, {buffer = bufnr})
            vim.keymap.set("n", "<Leader>A", vim.lsp.buf.code_action, {buffer = bufnr})
            vim.keymap.set("n", "<Leader>R", vim.lsp.buf.rename, {buffer = bufnr})

            if client.resolved_capabilities.document_formatting then
               vim.keymap.set("n", "<Leader>F", vim.lsp.buf.formatting, {buffer = bufnr})
            elseif client.resolved_capabilities.document_range_formatting then
               vim.keymap.set("n", "<Leader>F", vim.lsp.buf.range_formatting, {buffer = bufnr})
            end

            if client.resolved_capabilities.document_highlight then
               vim.api.nvim_create_augroup("NvimLspHighlightReferences", {})
               vim.api.nvim_create_autocmd("CursorHold", {
                  group = "NvimLspHighlightReferences",
                  callback = vim.lsp.buf.document_highlight,
                  buffer = bufnr,
               })
               vim.api.nvim_create_autocmd("CursorMoved", {
                  group = "NvimLspHighlightReferences",
                  callback = vim.lsp.buf.clear_references,
                  buffer = bufnr,
               })
            end

            for _, fn in ipairs(LSP_ON_ATTACH_FUNCTIONS) do
               fn(client, bufnr)
            end
         end

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
         lspconfig.clangd.setup({})
         lspconfig.bashls.setup({})
         lspconfig.denols.setup({})
         lspconfig.tsserver.setup({})
         lspconfig.yamlls.setup({})
         lspconfig.cssls.setup({cmd = {"vscode-css-languageserver", "--stdio"}})
         lspconfig.html.setup({cmd = {"vscode-html-languageserver", "--stdio"}})
         lspconfig.jsonls.setup({cmd = {"vscode-json-languageserver", "--stdio"}})
      end,

      ["simrat39/rust-tools.nvim"] = function()
         require("rust-tools").setup({
            tools = {
               autoSetHints = true,
               hover_with_actions = false,
               hover_actions = {
                  border = FLOAT_BORDER,
               },
            },
         })
      end,

      ["kosayoda/nvim-lightbulb"] = function()
         vim.api.nvim_create_augroup("Lightbulb", {})
         vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
            group = "Lightbulb",
            callback = require("nvim-lightbulb").update_lightbulb,
         })
         vim.fn.sign_define("LightBulbSign", {text = ""})
      end,

      ["nvim-treesitter/nvim-treesitter"] = function()
         require("nvim-treesitter.configs").setup({
            highlight = {enable = true},
            playground = {enable = true},
            rainbow = {enable = true},
         })
      end,

      ["lewis6991/spellsitter.nvim"] = function()
         require("spellsitter").setup()
      end,

      ["arcticicestudio/nord-vim"] = function()
         vim.g.nord_bold_vertical_split_line = 1
         vim.g.nord_cursor_line_number_background = 1

         vim.api.nvim_create_augroup("NordColorScheme", {})
         vim.api.nvim_create_autocmd("ColorScheme", {
            group = "NordColorScheme",
            pattern = "nord",
            callback = function()
               local patches = {
                  "hi! default link TabLineSel lualine_a_normal",

                  -- Enhance syntax highlighting via tree-sitter
                  "hi! default link TSConstBuiltin TSType",
                  "hi! default link TSTypeBuiltin TSFunction",
                  "hi default link TSURI TSKeyword",
                  "hi default link TSTitle TSNote",
                  "hi default link rstTSPunctSpecial TSNote",
                  "hi default link rstTSFuncBuiltin TSKeyword",
                  "hi default link rstTSConstant TSAnnotation",
                  "hi default link yamlTSField TSFunction",
                  "hi default link yamlTSType TSAnnotation",

                  -- nvim-cmp gaps
                  "hi CmpItemAbbrMatch gui=bold",
                  "hi! default link FloatBorder NormalFloat",

                  -- nvim-ts-rainbow
                  "hi rainbowcol1 guifg=#81a1c1",
                  "hi rainbowcol2 guifg=#8fbcbb",
                  "hi rainbowcol3 guifg=#d08770",
                  "hi rainbowcol4 guifg=#5e81ac",
                  "hi rainbowcol5 guifg=#ebcb8b",
                  "hi rainbowcol6 guifg=#a3be8c",
                  "hi rainbowcol7 guifg=#b48ead",

                  -- Emphasize matched parts.
                  "hi TelescopeMatching guifg=#88c0d0 guibg=#4c566a guisp=none",

                  -- https://github.com/arcticicestudio/nord-vim/pull/182
                  "hi default link mailQuoted1 helpBar",
                  "hi default link mailQuoted2 helpBar",
                  "hi default link mailQuoted3 helpBar",
                  "hi default link mailQuoted4 helpBar",
                  "hi default link mailQuoted5 helpBar",
                  "hi default link mailQuoted6 helpBar",
                  "hi default link mailURL MoreMsg",
                  "hi default link mailEmail MoreMsg",
               }

               for _, command in ipairs(patches) do
                  vim.api.nvim_command(command)
               end
            end,
         })

         vim.api.nvim_command("colorscheme nord")
      end,

      ["folke/tokyonight.nvim"] = function()
         vim.g.tokyonight_italic_keywords = false
         vim.g.tokyonight_lualine_bold = true
      end,

      ["nvim-lualine/lualine.nvim"] = function()
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
                  { "aerial", sep = breadcrump_sep },
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

      ["ahmedkhalf/project.nvim"] = function ()
         require("project_nvim").setup()
      end,

      ["stevearc/aerial.nvim"] = function()
         local aerial = require("aerial")
         aerial.setup({
            min_width = 35,
            max_width = 35,
            highlight_on_jump = 0,
            close_on_select = true,
            show_guides = true,
            icons = LSP_SYMBOL_KIND_ICONS,
         })
         table.insert(LSP_ON_ATTACH_FUNCTIONS, aerial.on_attach)
         vim.keymap.set("n", "<Leader>2", "<Cmd>AerialToggle<Cr>")
      end,

      ["folke/which-key.nvim"] = function()
         require("which-key").setup({
            plugins = {
               spelling = {enabled = true},
            },
         })
      end,

      ["lewis6991/gitsigns.nvim"] = function()
         local gitsigns = require("gitsigns")
         gitsigns.setup({
            preview_config = {
               border = FLOAT_BORDER,
               focusable = false,
            },
            on_attach = function(bufnr)
               -- There's no need for next/prev hunk keymaps for diff buffers
               -- since they support them natively.
               if not vim.wo.diff then
                  vim.keymap.set("n", "]c", gitsigns.next_hunk, {buffer = bufnr})
                  vim.keymap.set("n", "[c", gitsigns.prev_hunk, {buffer = bufnr})
               end

               vim.keymap.set({"n", "v"}, "<Leader>hs", gitsigns.stage_hunk, {buffer = bufnr})
               vim.keymap.set({"n", "v"}, "<Leader>hr", gitsigns.reset_hunk, {buffer = bufnr})
               vim.keymap.set("n", "<Leader>hu", gitsigns.undo_stage_hunk, {buffer = bufnr})
               vim.keymap.set("n", "<Leader>hp", gitsigns.preview_hunk, {buffer = bufnr})
               vim.keymap.set("n", "<Leader>hb", function() gitsigns.blame_line{full=true} end, {buffer = bufnr})
               vim.keymap.set("n", "<Leader>hd", function() gitsigns.diffthis("~") end, {buffer = bufnr})
            end,
         })
      end,

      ["Valloric/ListToggle"] = function()
         vim.g.lt_location_list_toggle_map = "<Leader>l"
         vim.g.lt_quickfix_list_toggle_map = "<Leader>q"
      end,

      ["norcalli/nvim-colorizer.lua"] = function()
         require("colorizer").setup({
            css = { css = true },
            stylus = { css = true },
         })
      end,
   }

   table.foreach(PLUGINS, function(_, plugin)
      if setup[plugin[1]] then setup[plugin[1]]() end
   end)
end)()


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

vim.api.nvim_create_augroup("NvimDetectFiletype", {})
vim.api.nvim_create_autocmd("BufReadPost", {
   group = "NvimDetectFiletype",
   pattern = "*.rasi",
   command = "setlocal filetype=rasi",
})

vim.api.nvim_create_augroup("NvimFiletypeOptions", {})
vim.api.nvim_create_autocmd("FileType", {
   group = "NvimFiletypeOptions",
   pattern = "python",
   command = "setlocal comments+=b:#:",   -- '#:' sphinx docstrings comments
})


--
-- // SOURCE EXTRA CONFIGURATIONS //
--

for _, name in ipairs({vim.fn.hostname(), "local"}) do
   local path = string.format("%s/init.%s.lua", vim.fn.stdpath("config"), name)

   if vim.fn.filereadable(path) == 1 then
      vim.cmd(string.format("source %s", path))
   end
end
