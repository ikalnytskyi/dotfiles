--
-- Author: Ihor Kalnytskyi <ihor@kalnytskyi.com>
-- Source: https://git.io/JYNmy
--

--
-- // BOOTSTRAP //
--

-- Since this init.lua uses 'vim-plug' to manage plugins, the first step that
-- needs to be done is to install 'vim-plug' and invoke it to install all
-- required dependencies.
(function()
   local vim_plug = vim.fn.stdpath("data") .. "/site/autoload/plug.vim"
   local vim_plug_http = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

   if vim.fn.filereadable(vim_plug) == 0 then
      vim.cmd(string.format("!curl -fLo %s --create-dirs %s", vim_plug, vim_plug_http))
      vim.cmd("autocmd VimEnter * silent! PlugInstall --sync")
   end
end)();

-- In order to use Python plugins, one need 'pynvim' package to be installed.
-- So let's create a Python venv with 'pynvim', and use its interpreter to run
-- Python plugins in order to avoid polluting system namespace.
(function()
   local runtime_py3 = vim.fn.stdpath("cache") .. "/runtime/py3"
   local runtime_py3_bin = runtime_py3 .. "/bin/python3"

   if vim.fn.isdirectory(runtime_py3) == 0 then
      local bootstrap = vim.fn.confirm("Bootstrap python3 provider?", "&Yes\n&No", 0, "Question")
      if bootstrap == 1 then
         vim.cmd(string.format("!python3 -m venv '%s'", runtime_py3))
         vim.cmd(string.format("!%s -m pip install pynvim", runtime_py3_bin))
      elseif bootstrap == 2 then
         -- Create an empty directory in order to stop asking a user about
         -- boostrapping python3 provider on start.
         vim.fn.mkdir(runtime_py3, "p")
      end
   end

   if vim.fn.filereadable(runtime_py3_bin) == 1 then
      vim.g.python3_host_prog = runtime_py3_bin
   end
end)();


--
-- // HELPERS //
--
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
   Constructor      = "",
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
   Constructor      = "",
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

local function set_keymap(mode, lhs, rhs, opts)
   opts = vim.tbl_extend("force", {noremap=true, silent=true}, opts or {})
   return vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

local function set_vim_plug(path, plugins, setup)
   _PLUG_SETUP_FUNCTIONS = setup
   local start = {}
   vim.fn["plug#begin"](path)
   plugins(function(repo, opts)
      opts = opts or vim.empty_dict()
      if setup[repo] and (opts["on"] or opts["for"]) then
         local name = opts.as or vim.fn.fnamemodify(repo, ":t:s?.git$??")
         vim.cmd(string.format("autocmd! User %s lua _PLUG_SETUP_FUNCTIONS['%s']()", name, repo))
      elseif setup[repo] then
         table.insert(start, repo)
      end
      vim.fn["plug#"](repo, opts)
   end)
   vim.fn["plug#end"]()
   for _, repo in ipairs(start) do pcall(setup[repo]) end
end

local function lsp_progress_status()
   local messages = vim.lsp.util.get_progress_messages()
   local function isempty(value) return value == nil or value == "" end

   -- In order to avoid cluttering we're showing only the last message since
   -- the last one probably contains most actual information.
   for _, msg in pairs(messages) do
      if msg.progress then
         local status = {}

         if not isempty(msg.title) then
            table.insert(status, msg.title)
         end

         if not isempty(msg.message) then
            table.insert(status, msg.message)
         end

         if not isempty(msg.percentage) then
            table.insert(status, string.format("(%.0f%%%%)", msg.percentage))
         end

         if not vim.tbl_isempty(status) then
            return vim.trim(table.concat(status, " - "))
         end
      end
   end
end


--
-- // OPTIONS //
--

vim.opt.termguicolors = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = "n"
vim.opt.showmode = false
vim.opt.timeout = false
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
      border = "single",
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

vim.api.nvim_exec([[
   augroup NVIM_DIAGNOSTIC
      autocmd!
      autocmd CursorHold * lua vim.diagnostic.open_float(0, {scope="cursor"})
   augroup END
]], false)


--
-- // KEYBINDINGS //
--

set_keymap("n", "<leader>3", "<cmd>set spell!<cr>")
set_keymap("n", "<leader>i", "<cmd>lua vim.diagnostic.setqflist()<CR>")

set_keymap("", "<leader>y", '"+y')
set_keymap("", "<leader>p", '"+p')
set_keymap("", "<leader>Y", '"*y')
set_keymap("", "<leader>P", '"*p')


--
-- // PLUGINS //
--

set_vim_plug(
   vim.fn.stdpath("data") .. "/plugins",
   function(plug)
      -- Fast asynchronous completion manager that works with omnicomplete,
      -- word completion and built-in LSP.
      plug("hrsh7th/nvim-cmp")
      plug("hrsh7th/cmp-buffer")
      plug("hrsh7th/cmp-nvim-lsp")
      plug("hrsh7th/cmp-nvim-lua")
      plug("hrsh7th/vim-vsnip")

      -- Telescope is general fuzzy finder over lists that could be used to
      -- find files, grep projects, show LSP symbols, etc. One generic
      -- interface for lot of things.
      plug("nvim-lua/plenary.nvim")
      plug("nvim-lua/popup.nvim")
      plug("nvim-telescope/telescope.nvim")
      plug("nvim-telescope/telescope-fzy-native.nvim")

      -- LSP and its goodies.
      plug("neovim/nvim-lspconfig")
      plug("ray-x/lsp_signature.nvim")
      plug("simrat39/rust-tools.nvim")
      plug("kosayoda/nvim-lightbulb")

      -- Tree-sitter is a parser generator tool and an incremental parsing
      -- library. NeoVim can leverage its functionality in various ways:
      -- semantic syntax highlighting, indentation, navigation, etc.
      plug("nvim-treesitter/nvim-treesitter", {["do"] = ":TSUpdate"})
      plug("nvim-treesitter/playground")
      plug("p00f/nvim-ts-rainbow")

      plug("arcticicestudio/nord-vim", {branch = "develop"})
      plug("folke/tokyonight.nvim")

      plug("nvim-lualine/lualine.nvim")
      plug("ahmedkhalf/project.nvim")
      plug("tpope/vim-sleuth")
      plug("mg979/vim-visual-multi")
      plug("stevearc/aerial.nvim")
      plug("tpope/vim-fugitive")
      plug("lewis6991/gitsigns.nvim")
      plug("Valloric/ListToggle")
      plug("norcalli/nvim-colorizer.lua")
      plug("ryanoasis/vim-devicons")
      plug("kyazdani42/nvim-web-devicons")

      -- Extra syntaxes support, since they aren't supported by Treesitter.
      plug("iloginow/vim-stylus", {["for"] = {"stylus"}})
      plug("Glench/Vim-Jinja2-Syntax", {["for"] = {"jinja"}})
      plug("chrisbra/csv.vim", {["for"] = {"csv"}})
   end,
   {
      ["hrsh7th/nvim-cmp"] = function()
         local cmp = require("cmp")
         cmp.setup({
            completion = {
               completeopt = vim.o.completeopt,
            },

            documentation = {
               border = FLOAT_BORDER,
               winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
            },

            snippet = {
               expand = function(args)
                  vim.fn["vsnip#anonymous"](args.body)
               end
            },

            preselect = cmp.PreselectMode.None,

            mapping = {
               ["<C-p>"] = cmp.mapping.select_prev_item(),
               ["<C-n>"] = cmp.mapping.select_next_item(),
               ["<C-d>"] = cmp.mapping.scroll_docs(-4),
               ["<C-f>"] = cmp.mapping.scroll_docs(4),
               ["<C-Space>"] = cmp.mapping.complete(),
               ["<C-e>"] = cmp.mapping.close(),
               ["<C-y>"] = cmp.mapping.confirm(),
               ["<CR>"] = cmp.mapping.confirm(),
            },

            formatting = {
               format = function(_, vim_item)
                  vim_item.kind = string.format(
                     "%s %s",
                     LSP_COMPLETION_ITEM_KIND_ICONS[vim_item.kind],
                     vim_item.kind
                  )
                  return vim_item
               end
            },

            sources = {
               { name = "nvim_lsp" },
               { name = "nvim_lua" },
               { name = "buffer" , keyword_length = 3 },
            },
         })
      end,

      ["hrsh7th/cmp-nvim-lsp"] = function()
         require("cmp_nvim_lsp").update_capabilities(LSP_CAPABILITIES)
      end,

      ["nvim-telescope/telescope.nvim"] = function()
         local telescope = require("telescope")
         local telescope_actions = require("telescope.actions")
         local telescope_builtin = require("telescope.builtin")

         telescope.setup({
            defaults = {
               mappings = {
                  i = {
                     -- I don't need Vim modes in Telescope, so anytime Esc is
                     -- pressed I want to close Telescope instead of entering
                     -- Normal mode.
                     ["<esc>"] = telescope_actions.close,
                  },
               },
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
            }
         })
         telescope.load_extension("fzy_native")
         telescope.load_extension("projects")

         function _G.telescope_file_browser_current_file()
            local cwd = vim.fn.expand("%:p:h")
            return telescope_builtin.file_browser({cwd = cwd})
         end

         set_keymap("n", "<leader>1", "<cmd>call v:lua.telescope_file_browser_current_file()<cr>")
         set_keymap("n", "<c-p>", "<cmd>Telescope git_files<cr>")
         set_keymap("n", "<leader>g", "<cmd>Telescope live_grep<cr>")
         set_keymap("n", "<leader>G", "<cmd>Telescope grep_string<cr>")
         set_keymap("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>")
         set_keymap("n", "<leader>?", "<cmd>Telescope resume<cr>")
         set_keymap("n", "<leader>i", "<cmd>Telescope diagnostics bufnr=0<cr>")

         table.insert(LSP_ON_ATTACH_FUNCTIONS, function(client, bufnr)
            local function buf_set_keymap(mode, lhs, rhs)
               return vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, {noremap=true, silent=true})
            end

            -- These are Telescope overwrites to provide a better UI than
            -- standard NeoVim does.
            buf_set_keymap("n", "<leader>d", "<cmd>Telescope lsp_definitions<CR>")
            buf_set_keymap("n", "<leader>t", "<cmd>Telescope lsp_document_symbols<CR>")
            buf_set_keymap("n", "<leader>T", "<cmd>Telescope lsp_workspace_symbols<CR>")
            buf_set_keymap("n", "<leader>r", "<cmd>Telescope lsp_references<CR>")
            buf_set_keymap("n", "<leader>A", "<cmd>Telescope lsp_code_actions<CR>")
         end)
      end,

      ["neovim/nvim-lspconfig"] = function()
         local lspconfig = require("lspconfig")
         local config = lspconfig.util.default_config

         config.capabilities = LSP_CAPABILITIES
         config.on_attach = function(client, bufnr)
            vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

            local function buf_set_keymap(mode, lhs, rhs)
               return vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, {noremap=true, silent=true})
            end

            buf_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.declaration()<CR>")
            buf_set_keymap("n", "<leader>d", "<cmd>lua vim.lsp.buf.definition()<CR>")
            buf_set_keymap("n", "<leader>h", "<cmd>lua vim.lsp.buf.hover()<CR>")
            buf_set_keymap("n", "<leader>t", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
            buf_set_keymap("n", "<leader>T", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
            buf_set_keymap("n", "<leader>r", "<cmd>lua vim.lsp.buf.references()<CR>")
            buf_set_keymap("n", "<leader>A", "<cmd>lua vim.lsp.buf.code_action()<CR>")
            buf_set_keymap("n", "<leader>R", "<cmd>lua vim.lsp.buf.rename()<CR>")

            if client.resolved_capabilities.document_formatting then
               buf_set_keymap("n", "<leader>F", "<cmd>lua vim.lsp.buf.formatting()<CR>")
            elseif client.resolved_capabilities.document_range_formatting then
               buf_set_keymap("n", "<leader>F", "<cmd>lua vim.lsp.buf.range_formatting()<CR>")
            end

            if client.resolved_capabilities.document_highlight then
               vim.api.nvim_exec([[
                  augroup NVIM_LSP_HIGHLIGHT_REFERENCES
                     autocmd! * <buffer>
                     autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                     autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                  augroup END
               ]], false)
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
                  analysis = {
                     autoImportCompletions = false,
                  },
               },
            },
         })
         -- lspconfig.pylsp.setup({
         --    settings = {
         --       pylsp = {
         --          configurationSources = {"flake8"},
         --          plugins = {
         --             jedi_completion = {
         --                include_params = true
         --             },
         --          },
         --       },
         --    },
         -- })
         lspconfig.clangd.setup({})
         lspconfig.bashls.setup({})
         lspconfig.denols.setup({})
         lspconfig.tsserver.setup({})
         lspconfig.yamlls.setup({})
         lspconfig.cssls.setup({cmd = {"vscode-css-languageserver", "--stdio"}})
         lspconfig.html.setup({cmd = {"vscode-html-languageserver", "--stdio"}})
         lspconfig.jsonls.setup({cmd = {"vscode-json-languageserver", "--stdio"}})
      end,

      ["ray-x/lsp_signature.nvim"] = function()
         require("lsp_signature").setup({
            bind = true,
            handler_opts = {
               border = FLOAT_BORDER,
            },
            doc_lines = 0,
            fix_pos = true,
            hint_enable = false,
         })
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
         vim.cmd("autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()")
         vim.fn.sign_define("LightBulbSign", {text = ""})
      end,

      ["nvim-treesitter/nvim-treesitter"] = function()
         require("nvim-treesitter.configs").setup({
            highlight = {enable = true},
            playground = {enable = true},
            rainbow = {enable = true},
         })
      end,

      ["arcticicestudio/nord-vim"] = function()
         vim.g.nord_bold_vertical_split_line = 1
         vim.g.nord_cursor_line_number_background = 1

         function _G.colorscheme_nord_enhancements()
            local patches = {
               "hi! default link TabLineSel lualine_a_normal",

               -- Use NeoVim 0.6+ diagnostic names.
               "hi! default link DiagnosticHint LspDiagnosticsDefaultHint",
               "hi! default link DiagnosticInfo LspDiagnosticsDefaultInformation",
               "hi! default link DiagnosticWarn LspDiagnosticsDefaultWarning",
               "hi! default link DiagnosticError LspDiagnosticsDefaultError",
               "hi! default link DiagnosticUnderlineHint LspDiagnosticsUnderlineHint",
               "hi! default link DiagnosticUnderlineInfo LspDiagnosticsUnderlineInformation",
               "hi! default link DiagnosticUnderlineWarn LspDiagnosticsUnderlineWarning",
               "hi! default link DiagnosticUnderlineError LspDiagnosticsUnderlineError",

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
         end

         vim.api.nvim_exec([[
            augroup COLORSCHEME_NORD_ENHANCEMENTS
               autocmd!
               autocmd ColorScheme nord call v:lua.colorscheme_nord_enhancements()
            augroup END
         ]], false)

         vim.api.nvim_command("colorscheme nord")
      end,


      ["folke/tokyonight.nvim"] = function()
         vim.g.tokyonight_italic_keywords = false
      end,

      ["nvim-lualine/lualine.nvim"] = function()
         local breadcrump_sep = " ⟩ "

         require("lualine").setup({
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
               lualine_x = {
                  {
                     function() return lsp_progress_status() or "" end,
                     icon = "",
                  },
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

      ["ahmedkhalf/project.nvim"] = function ()
         require("project_nvim").setup()
      end,

      ["stevearc/aerial.nvim"] = function()
         vim.g.aerial = {
            manage_folds = false,
            min_width = 35,
            max_width = 35,
            highlight_on_jump = 0,
            close_on_select = true,
            icons = LSP_SYMBOL_KIND_ICONS,
         }
         table.insert(LSP_ON_ATTACH_FUNCTIONS, require("aerial").on_attach)
         set_keymap("n", "<leader>2", "<cmd>AerialToggle<cr>")
      end,

      ["lewis6991/gitsigns.nvim"] = function()
         require("gitsigns").setup({
            preview_config = {
               border = FLOAT_BORDER,
               focusable = false,
            },
         })
      end,

      ["Valloric/ListToggle"] = function()
         vim.g.lt_location_list_toggle_map = "<leader>l"
         vim.g.lt_quickfix_list_toggle_map = "<leader>q"
      end,

      ["norcalli/nvim-colorizer.lua"] = function()
         require("colorizer").setup({
            css = { css = true },
            stylus = { css = true },
         })
      end,
   }
)


vim.api.nvim_exec([[
   augroup HIGHLIGHT_YANKED_TEXT
      autocmd!
      autocmd TextYankPost * silent! lua require("vim.highlight").on_yank()
   augroup END
]], false)


--
-- // LANGUAGES //
--

vim.api.nvim_exec([[
   augroup FILETYPES
      autocmd!
      autocmd BufReadPost .babelrc setlocal filetype=json
      autocmd BufReadPost .eslintrc setlocal filetype=json
      autocmd BufReadPost *.fish setlocal filetype=fish
      autocmd BufReadPost *.rasi setlocal filetype=css
   augroup END

   augroup PYTHON
      autocmd!
      autocmd FileType python setlocal comments+=b:#:    " sphinx (#:) comments
   augroup END
]], false)


--
-- // SOURCE EXTRA CONFIGURATIONS //
--

for _, name in ipairs({vim.fn.hostname(), "local"}) do
   local path = string.format("%s/init.%s.lua", vim.fn.stdpath("config"), name)

   if vim.fn.filereadable(path) == 1 then
      vim.cmd(string.format("source %s", path))
   end
end
