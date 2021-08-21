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

local LSP_KIND_SIGNS = {
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

local function set_keymap(mode, lhs, rhs, opts)
   opts = vim.tbl_extend("force", {noremap=true, silent=true}, opts or {})
   return vim.api.nvim_set_keymap(mode, lhs , rhs, opts)
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


--
-- // GENERAL //
--

if vim.env.COLORTERM == "truecolor" or vim.env.COLORTERM == "24bit" then
   vim.opt.termguicolors = true
end

vim.opt.autochdir = true                           -- change cwd to the directory containing the file
vim.opt.ignorecase = true                          -- do case insensitive search
vim.opt.smartcase = true                           -- match uppercase in the search string
vim.opt.mouse = "a"                                -- enable mouse support in all Vim modes
vim.opt.showmode = false                           -- do not show Vim mode, lualine shows it
vim.opt.timeout = false                            -- no timeout on keybindings (aka mappings)
vim.opt.scrolloff = 3                              -- start scrolling 3 lines before the border
vim.opt.sidescrolloff = 3                          -- start scrolling 3 columns before the border
vim.opt.shortmess:append("c")                      -- supress 'match X of Y' message
vim.opt.visualbell = true                          -- flash screen instead of beep
vim.opt.title = true                               -- show useful info in window's title
vim.opt.completeopt = {
   "menu",                                         -- use popup menu to show completions
   "menuone",                                      -- use popup menu even for a single completion
   "noselect",                                     -- do not auto select completions
   "noinsert",                                     -- do not auto insert completions
}
vim.opt.updatetime = 300                           -- time (ms) to wait for CursorHold event
vim.opt.colorcolumn = {"80", "100"}                -- set ruler at 80 & 100 characters
vim.opt.cursorline = true                          -- highlight the line with the cursor
vim.opt.list = true                                -- show unprintable characters
vim.opt.listchars = {                              -- set unprintable characters
   tab      = " ",                                -- tab character
   lead     = "·",                                 -- leading whitespaces
   trail    = "·",                                 -- trailing whitespaces
   nbsp     = "⎵",                                 -- non breakable whitespaces
   extends  = "⟩",                                 -- invisible characters on the right (scrolling)
   precedes = "⟨",                                 -- invisible characters on the left (scrolling)
}
vim.opt.showbreak = "﬌ "                           -- character to mark wrapped line
vim.opt.foldenable = false                         -- no code folding, I hate it
vim.opt.wrap = false                               -- do not wrap lines visually
vim.opt.number = true                              -- show line numbers
vim.opt.signcolumn = "yes"                         -- always show sign column
vim.opt.expandtab = true                           -- insert spaces instead of tabs
vim.opt.formatoptions:append("r")                  -- auto insert comment leader on <enter>
vim.opt.formatoptions:remove("o")                  -- do not auto insert comment leader on o/O
vim.opt.swapfile = false                           -- do not create swap files
vim.opt.shiftwidth = 4                             -- indent lines by X spaces
vim.opt.softtabstop = 4                            -- insert X spaces instead of a tab character
vim.opt.spelllang = {"en", "ru"}                   -- languages to spellcheck
vim.opt.tabstop = 8                                -- use X characters indentation for tabs
vim.opt.undofile = true                            -- persistent undo (survives Vim restart)


--
-- // KEYBINDINGS //
--

set_keymap("n", "<leader>3", "<cmd>set spell!<cr>")

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
      plug("hrsh7th/cmp-path")
      plug("hrsh7th/vim-vsnip")
      plug("hrsh7th/vim-vsnip-integ")

      -- Telescope is general fuzzy finder over lists that could be used to
      -- find files, grep projects, show LSP symbols, etc. One generic
      -- interface for lot of things.
      plug("nvim-lua/plenary.nvim")
      plug("nvim-lua/popup.nvim")
      plug("nvim-telescope/telescope.nvim")
      plug("nvim-telescope/telescope-fzy-native.nvim")

      -- LSP and its goodies.
      plug("neovim/nvim-lspconfig")
      plug("nvim-lua/lsp-status.nvim")
      plug("nvim-lua/lsp_extensions.nvim")
      plug("ray-x/lsp_signature.nvim")

      -- Tree-sitter is a parser generator tool and an incremental parsing
      -- library. NeoVim can leverage its functionality in various ways:
      -- semantic syntax highlighting, indentation or navigation.
      plug("nvim-treesitter/nvim-treesitter", {["do"] = ":TSUpdate"})
      plug("nvim-treesitter/playground")
      plug("p00f/nvim-ts-rainbow")

      plug("arcticicestudio/nord-vim", {branch = "develop"})
      plug("morhetz/gruvbox")

      plug("hoob3rt/lualine.nvim")
      plug("tpope/vim-sleuth")
      plug("preservim/nerdtree")
      plug("mg979/vim-visual-multi")
      plug("simrat39/symbols-outline.nvim")
      plug("tpope/vim-fugitive")
      plug("mhinz/vim-signify")
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

            snippet = {
               expand = function(args)
                  vim.fn["vsnip#anonymous"](args.body)
               end
            },

            confirmation = {
               default_behavior = cmp.ConfirmBehavior.Insert,
            },

            mapping = {
               ["<C-p>"] = cmp.mapping.prev_item(),
               ["<C-n>"] = cmp.mapping.next_item(),
               ["<C-e>"] = cmp.mapping.close(),
               ["<C-y>"] = cmp.mapping.confirm(),
               ["<CR>"] = cmp.mapping.confirm(),
            },

            formatting = {
               format = function(entry, vim_item)
                  vim_item.kind = string.format("%s %s", LSP_KIND_SIGNS[vim_item.kind], vim_item.kind)
                  return vim_item
               end
            },

            sources = {
               { name = "nvim_lsp" },
               { name = "buffer" },
               { name = "path" },
            },
         })
      end,

      ["hrsh7th/cmp-nvim-lsp"] = function()
         require("cmp_nvim_lsp").setup({})
      end,

      ["nvim-telescope/telescope.nvim"] = function()
         local telescope = require("telescope")
         local telescope_actions = require("telescope.actions")
         local telescope_utils = require("telescope.utils")
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
            }
         })
         telescope.load_extension("fzy_native")

         -- This opens telescope's grepper but with CWD pointing to a git root.
         -- The idea is to ensure no matter which directory I'm in, the grep
         -- will search throughout the whole project.
         function _G.telescope_git_grep()
            local cwd = vim.loop.cwd()
            local root, exitcode, _ = telescope_utils.get_os_command_output(
               {"git", "rev-parse", "--show-toplevel"}, cwd
            )
            if exitcode == 0 then cwd = root[1] end
            return telescope_builtin.live_grep({cwd = cwd})
         end

         set_keymap("n", "<c-p>", "<cmd>Telescope git_files<cr>")
         set_keymap("n", "<leader>g", "<cmd>call v:lua.telescope_git_grep()<cr>")
      end,

      ["neovim/nvim-lspconfig"] = function()
         vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
               virtual_text = false,
               underline = true,
               signs = true,
            }
         )
         vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
            vim.lsp.handlers.hover, {
               border = "single",
            }
         )
         vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
            vim.lsp.handlers.signature_help, {
               border = "single",
            }
         )
         vim.fn.sign_define("LspDiagnosticsSignError", {text = ""})
         vim.fn.sign_define("LspDiagnosticsSignWarning", {text = ""})
         vim.fn.sign_define("LspDiagnosticsSignInformation", {text = ""})
         vim.fn.sign_define("LspDiagnosticsSignHint", {text = ""})

         local lspconfig = require("lspconfig")
         local lsp_status = {
            on_attach = function(...) end,
            capabilities = vim.lsp.protocol.make_client_capabilities(),
         }

         if pcall(require, "lsp-status") then
            lsp_status = require("lsp-status")
         end

         local capabilities = lsp_status.capabilities
         if pcall(require, "cmp_nvim_lsp") then
            capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown" }
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities.textDocument.completion.completionItem.preselectSupport = true
            capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
            capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
            capabilities.textDocument.completion.completionItem.deprecatedSupport = true
            capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
            capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
            capabilities.textDocument.completion.completionItem.resolveSupport = {
              properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
              }
            }
         end

         local on_attach = function(client, bufnr)
            local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
            local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
            local opts = {noremap=true, silent=true}

            buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

            buf_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
            buf_set_keymap("n", "<leader>d", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
            buf_set_keymap("n", "<leader>h", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
            buf_set_keymap("n", "<leader>t", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
            buf_set_keymap("n", "<leader>T", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", opts)
            buf_set_keymap("n", "<leader>r", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
            buf_set_keymap("n", "<leader>k", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
            buf_set_keymap("n", "<leader>i", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
            buf_set_keymap("n", "<leader>I", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = 'single' })<CR>", opts)
            buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev({ popup_opts = { border = 'single' }})<CR>", opts)
            buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next({ popup_opts = { border = 'single' }})<CR>", opts)
            buf_set_keymap("n", "<leader>A", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
            buf_set_keymap("n", "<leader>R", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

            if client.resolved_capabilities.document_formatting then
               buf_set_keymap("n", "<leader>F", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
            elseif client.resolved_capabilities.document_range_formatting then
               buf_set_keymap("n", "<leader>F", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
            end

            -- These are Telescope overwrites to provide a better UI than
            -- standard NeoVim does.
            buf_set_keymap("n", "<leader>d", "<cmd>Telescope lsp_definitions<CR>", opts)
            buf_set_keymap("n", "<leader>t", "<cmd>Telescope lsp_document_symbols<CR>", opts)
            buf_set_keymap("n", "<leader>T", "<cmd>Telescope lsp_workspace_symbols<CR>", opts)
            buf_set_keymap("n", "<leader>r", "<cmd>Telescope lsp_references<CR>", opts)
            buf_set_keymap("n", "<leader>i", "<cmd>Telescope lsp_document_diagnostics<CR>", opts)
            buf_set_keymap("n", "<leader>A", "<cmd>Telescope lsp_code_actions<CR>", opts)

            if client.resolved_capabilities.document_highlight then
               vim.api.nvim_exec([[
                  hi LspReferenceRead  guibg=#3b4252
                  hi LspReferenceText  guibg=#3b4252
                  hi LspReferenceWrite guibg=#3b4252

                  augroup NVIM_LSP_HIGHLIGHT_REFERENCES
                     autocmd! * <buffer>
                     autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                     autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                  augroup END
               ]], false)
            end

            lsp_status.on_attach(client, bufnr)
         end

         lspconfig.pyright.setup({
            on_attach = on_attach,
            capabilities = capabilities,
         })

         lspconfig.pylsp.setup({
            settings = {
               pylsp = {
                  configurationSources = {"flake8", "pycodestyle"},
               },
            },
            on_attach = on_attach,
            capabilities = capabilities,
         })

         lspconfig.rust_analyzer.setup({
            on_attach = function(client, bufnr)
               on_attach(client, bufnr)

               if pcall(require, "lsp_extensions") then
                  -- rust_analyzer support an awesome extension that evaluates types and
                  -- show them using virtual text overlay. I want to invoke that
                  -- behaviour every time the cursor is hold on the line.
                  vim.api.nvim_exec([[
                     augroup NVIM_LSP_EXTENSIONS_INLAY_HINTS
                        autocmd! * <buffer>
                        autocmd CursorHold <buffer> call v:lua.inlay_hints_show()
                        autocmd CursorMovedI <buffer> call v:lua.inlay_hints_clear()
                     augroup END
                  ]], false)
               end
            end,
            capabilities = capabilities,
         })

         lspconfig.clangd.setup({
            init_options = {
               clangdFileStatus = true,
            },
            handlers = lsp_status.extensions.clangd.setup(),
            on_attach = on_attach,
            capabilities = capabilities,
         })

         lspconfig.bashls.setup({on_attach = on_attach, capabilities = capabilities})
         lspconfig.denols.setup({on_attach = on_attach, capabilities = capabilities})
         lspconfig.tsserver.setup({on_attach = on_attach, capabilities = capabilities})
      end,

      ["nvim-lua/lsp-status.nvim"] = function()
         local lsp_status = require("lsp-status")

         lsp_status.config({
            kind_labels = LSP_KIND_SIGNS,
            status_symbol = "",
            diagnostics = false,
         })
         lsp_status.register_progress()
      end,

      ["nvim-lua/lsp_extensions.nvim"] = function()
         function _G.inlay_hints_show()
            require("lsp_extensions").inlay_hints({
               highlight = "Folded",
               prefix = "  ",
               enabled = {"TypeHint", "ChainingHint", "ParameterHint"},
            })
         end

         function _G.inlay_hints_clear()
            require("lsp_extensions").inlay_hints({enabled = {}})
         end
      end,

      ["ray-x/lsp_signature.nvim"] = function()
         -- The only reason this plugin is used is probably because it shows
         -- currently active parameter in signature. Should not be needed once
         -- https://github.com/neovim/neovim/issues/14444 is closed.
         require("lsp_signature").on_attach({
            bind = true,
            handler_opts = {border = "single"},
            hint_enable = false,
         })
      end,


      ["nvim-treesitter/nvim-treesitter"] = function()
         require("nvim-treesitter.configs").setup({
            highlight = {enable = true, disable = {"rust"}},
            indent = {enable = true, disable = {"yaml", "python"}},
            playground = {enable = true},
         })

         -- nvim-treesitter/queries/python/injections.scm, with docstring
         -- injections removed
         local py_injections = [[
            ((call
              function: (attribute object: (identifier) @_re)
              arguments: (argument_list (string) @regex))
             (#eq? @_re "re")
             (#match? @regex "^r.*"))

            (comment) @comment
         ]]
         vim.treesitter.set_query("python", "injections", py_injections)
      end,

      ["p00f/nvim-ts-rainbow"] = function()
         function _G.nvim_ts_rainbow_setup()
            require("nvim-treesitter.configs").setup({
               rainbow = {
                  enable = true,
                  colors = {
                     vim.g.terminal_color_9,
                     vim.g.terminal_color_10,
                     vim.g.terminal_color_11,
                     vim.g.terminal_color_12,
                     vim.g.terminal_color_13,
                     vim.g.terminal_color_14,
                  },
               },
            })
         end

         -- Since the setup function pipes in colors from a colorscheme, it has
         -- to be reevaluated every time a colorscheme changed.
         vim.api.nvim_exec([[
            augroup NVIM_TREESITTER_RAINBOW
               autocmd!
               autocmd ColorScheme * call v:lua.nvim_ts_rainbow_setup()
            augroup END
         ]], false)
      end,

      ["arcticicestudio/nord-vim"] = function()
         vim.g.nord_bold_vertical_split_line = 1
         vim.g.nord_cursor_line_number_background = 1

         function _G.colorscheme_nord_enhancements()
            local patches = {
               -- Treesitter gaps.
               "hi default link rstTSTitle markdownH1",
               "hi default link rstTSPunctSpecial markdownH1",
               "hi default link rstTSFuncBuiltin Type",
               "hi default link yamlTSField Keyword",

               -- Emphasize matched parts.
               "hi TelescopeMatching guifg=#88c0d0 guibg=#4c566a guisp=none",

               -- Use custom background for floating windows.
               "hi NormalFloat guibg=#4c566a",

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

      ["hoob3rt/lualine.nvim"] = function()
         require("lualine").setup({
            options = {
               theme = vim.g.colors_name,
            },
            sections = {
               lualine_x = {
                  function()
                     return vim.trim(require("lsp-status").status_progress())
                  end,
                  {"vim.b.lsp_current_function"},
                  {"diagnostics", sources = {"nvim_lsp"}},
                  {"filetype"},
                  {
                     -- Nowadays UTF-8 is the most widespread text encoding.
                     -- Since this is something most users are dealing with
                     -- 99.9% of the time, there's no need to show unless it's
                     -- different.
                     "encoding", condition = function()
                        local fenc = vim.opt.fenc:get()
                        return string.len(fenc) > 0 and string.lower(fenc) ~= "utf-8"
                     end,
                  },
                  {"fileformat"},
               },
            },
         })
      end,

      ["preservim/nerdtree"] = function()
         vim.g.NERDTreeQuitOnOpen = 1
         vim.g.NERDTreeShowHidden = 1
         vim.g.NERDTreeMinimalUI = 1

         vim.api.nvim_exec([[
            function! MyNERDTreeToggleVCS()
               let path = expand('%:p')

               execute ':NERDTreeToggleVCS'

               " Find and show currently open file in the file explorer. It's the primary
               " reason why this home grown function exists in the first place.
               if exists('g:NERDTree') && g:NERDTree.IsOpen() && filereadable(path)
                  execute ':NERDTreeFind' . path
               endif
            endfunction

            command! -n=? -complete=dir -bar MyNERDTreeToggleVCS :call MyNERDTreeToggleVCS()
         ]], false)

         set_keymap("n", "<leader>1", "<cmd>MyNERDTreeToggleVCS<cr>")
      end,

      ["simrat39/symbols-outline.nvim"] = function()
         set_keymap("n", "<leader>2", "<cmd>SymbolsOutline<cr>")
      end,

      ["mhinz/vim-signify"] = function()
         vim.g.signify_sign_add = "│"
         vim.g.signify_sign_change = "│"
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
   augroup END

   augroup PYTHON
      autocmd!
      autocmd FileType python setlocal comments+=b:#:    " sphinx (#:) comments
   augroup END
]], false)
