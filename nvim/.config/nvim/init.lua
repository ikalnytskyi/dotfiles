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
vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert", "nearest", "popup" }
vim.opt.updatetime = 300
vim.opt.colorcolumn = { 81, 101 }
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = {
    tab      = "--⇥",
    leadtab  = "--⇥",
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
vim.opt.pumborder = "rounded"

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
        [".*/sway/config%.d/.*"] = "bash",
        [".*/sway/config%..*"] = "bash",
    },
})

vim.api.nvim_create_augroup("MyFiletypeOptions", {})
vim.api.nvim_create_autocmd("FileType", {
    group = "MyFiletypeOptions",
    pattern = "*",
    callback = function(args)
        local language = vim.treesitter.language.get_lang(args.match)
        if vim.treesitter.language.add(language) then
            vim.treesitter.start(args.buf)
        end
    end,
})
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
    callback = function(args)
        local lsp_client = vim.lsp.get_client_by_id(args.data.client_id)

        -- vim.lsp.completion.enable(true, lsp_client.id, args.buf, {
        --    autotrigger = true,
        --    -- convert = function(item)
        --    --    return { abbr = item.label:gsub("%b()", "") }
        --    -- end,
        -- })

        if lsp_client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            vim.api.nvim_create_autocmd("CursorHold", {
                group = "MyLspAttach",
                callback = function()
                    if vim.lsp.client_is_stopped(vim.lsp.get_clients()) ~= true then
                        vim.lsp.buf.document_highlight()
                    end
                end,
                buffer = args.buf,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                group = "MyLspAttach",
                callback = function()
                    if vim.lsp.client_is_stopped(vim.lsp.get_clients()) ~= true then
                        vim.lsp.buf.clear_references()
                    end
                end,
                buffer = args.buf,
            })
        end
    end,
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

vim.pack.add({
    { src = "https://github.com/gbprod/nord.nvim" },
    { src = "https://github.com/nvim-mini/mini.icons" },
    { src = "https://github.com/saghen/blink.cmp",                  version = vim.version.range("1.x") },
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/folke/flash.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/b0o/SchemaStore.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter",   version = "main" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/stevearc/aerial.nvim" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/brenoprata10/nvim-highlight-colors" },
    { src = "https://github.com/tpope/vim-sleuth" },
    { src = "https://github.com/williamboman/mason.nvim" },
})


local function has_plugin(name)
    local plugin = vim.pack.get({ name }, { info = false })[1]
    return plugin ~= nil and plugin.active
end


-- Non-default colorscheme.
if has_plugin("nord.nvim") then
    require("nord").setup({
        diff = { mode = "fg" },
        styles = {
            comments = { italic = false },
        },
    })
    vim.cmd.colorscheme("nord")
end


-- Nerd icons for everything we need.
if has_plugin("mini.icons") then
    require("mini.icons").setup({
        lsp = {
            ["function"] = { glyph = "󰊕" },
        },
    })
    MiniIcons.mock_nvim_web_devicons()
end


-- Fast asynchronous completion manager that works with omnicomplete, word
-- completion and built-in LSP.
if has_plugin("blink.cmp") then
    require("blink.cmp").setup({
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
                    },
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                                return kind_icon
                            end,
                        },
                    },
                    snippet_indicator = "~",
                },
            },
        },
        keymap = { preset = "enter" },
        signature = { enabled = true },
        sources = {
            providers = {
                lsp = { fallbacks = {} },
                buffer = { score_offset = -50 },
            },
            min_keyword_length = 3,
        },
    })
end


-- A collection of small quality-of-life plugins for Neovim, including
-- general fuzzy finders for files/symbols/etc., a file explorer,
-- indentation guides and much more.
if has_plugin("snacks.nvim") then
    require("snacks").setup({
        gitbrowse = {
            open = function(url)
                if IS_REMOTE_HOST then
                    vim.fn.setreg("+", url)
                else
                    vim.ui.open(url)
                end
            end,
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
                            },
                        },
                    },
                },
                treesitter = {
                    filter = {
                        python = { "Class", "Function" },
                    },
                },
            },
            win = {
                input = {
                    keys = {
                        ["<Esc>"] = { "close", mode = { "n", "i" } },
                    },
                },
                preview = {
                    wo = {
                        number = false,
                        signcolumn = "no",
                    },
                },
            },
        },
    })

    for _, keymap in ipairs({
        { "n", "<Leader>e", function() Snacks.explorer({ cwd = vim.fn.expand("%:p:h") }) end, { desc = "Open file explorer" } },
        { "n", "<Leader>G", Snacks.gitbrowse.open,                                            { desc = "Open git browser" } },
        { "v", "<Leader>G", Snacks.gitbrowse.open,                                            { desc = "Open git browser" } },
        { "n", "'",         Snacks.picker.marks,                                              { desc = "Open marks picker" } },
        { "n", "<Leader>f", function() Snacks.picker.git_files({ untracked = true }) end,     { desc = "Open file picker" } },
        { "n", "<Leader>/", Snacks.picker.grep,                                               { desc = "Open search in workspace directory" } },
        { "n", "<Leader>b", Snacks.picker.buffers,                                            { desc = "Open buffer picker" } },
        { "n", "<Leader>.", Snacks.picker.grep_word,                                          { desc = "Open search of selection" } },
        { "x", "<Leader>.", Snacks.picker.grep_word,                                          { desc = "Open search of selection" } },
        { "n", "<Leader>'", Snacks.picker.resume,                                             { desc = "Open last picker" } },
        { "n", "<Leader>?", Snacks.picker.commands,                                           { desc = "Open command palette" } },
        { "n", "<Leader>d", Snacks.picker.diagnostics_buffer,                                 { desc = "Open diagnostic picker" } },
        { "n", "<Leader>g", Snacks.picker.git_status,                                         { desc = "Open changed file picker" } },
        { "n", "<Leader>H", function() Snacks.toggle.inlay_hints():toggle() end,              { desc = "Toggle inlay hints" } },
        { "n", "<Leader>3", function() Snacks.toggle.option("spell"):toggle() end,            { desc = "Toggle spelling" } },
        { "n", "gd",        Snacks.picker.lsp_definitions,                                    { desc = "Goto definition" } },
        { "n", "gD",        Snacks.picker.lsp_declarations,                                   { desc = "Goto declarations" } },
        { "n", "grr",       Snacks.picker.lsp_references,                                     { desc = "Goto references" } },
        { "n", "gi",        Snacks.picker.lsp_implementations,                                { desc = "Goto implementation" } },
        { "n", "gy",        Snacks.picker.lsp_type_definitions,                               { desc = "Goto type definition" } },
        { "n", "<Leader>s", Snacks.picker.lsp_symbols,                                        { desc = "Open symbol picker" } },
        { "n", "<Leader>S", Snacks.picker.lsp_workspace_symbols,                              { desc = "Open workspace symbol picker" } },
        { "n", "<Leader>q", Snacks.picker.treesitter,                                         { desc = "Open symbol picker" } },
    }) do
        vim.keymap.set(unpack(keymap))
    end
end


-- Lets you navigate your code with search labels, enhanced character
-- motions, and Treesitter integration.
if has_plugin("flash.nvim") then
    local flash = require("flash")

    flash.setup({
        modes = { char = { enabled = false } },
        prompt = { enabled = false },
    })

    for _, keymap in ipairs({
        { { "n", "x", "o" }, "s", flash.jump,              { desc = "Flash" } },
        { { "n", "x", "o" }, "S", flash.treesitter,        { desc = "Flash Treesitter" } },
        { "o",               "r", flash.remote,            { desc = "Remote Flash" } },
        { { "o", "x" },      "R", flash.treesitter_search, { desc = "Treesitter Search" } },
    }) do
        vim.keymap.set(unpack(keymap))
    end
end


-- LSP and its goodies.
if has_plugin("nvim-lspconfig") then
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

    if has_plugin("SchemaStore.nvim") then
        vim.lsp.config("jsonls", {
            settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                    validate = { enable = true },
                },
            },
        })
    end

    for _, server_name in ipairs({
        "bashls",
        "clangd",
        "cssls",
        "dotls",
        "gopls",
        "html",
        "jsonls",
        "just",
        "lua_ls",
        "marksman",
        "pyrefly",
        "qmlls",
        "ruff",
        "rust_analyzer",
        "sourcekit",
        "taplo",
        "ts_ls",
        "typos_lsp",
        "yamlls",
    }) do
        vim.lsp.enable(server_name)
    end

    vim.keymap.set("n", "gA", "<Cmd>LspClangdSwitchSourceHeader<Cr>", { desc = "Switch between source/header" })
    vim.keymap.set("n", "gS", "<Cmd>LspClangdShowSymbolInfo<Cr>", { desc = "Show symbol info" })
end


if has_plugin("lualine.nvim") then
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
                            .. "%" .. ctx.default_hl
                        return str:gsub(path_separator, colorized_sep)
                    end,
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
end


if has_plugin("aerial.nvim") then
    require("aerial").setup({
        layout = {
            min_width = 40,
            max_width = 40,
        },
        highlight_on_jump = false,
        close_on_select = true,
        show_guides = true,
    })
end


if has_plugin("which-key.nvim") then
    require("which-key").setup({
        preset = "modern",
        filter = function(mapping)
            -- Do not show key mappings w/o description, since it won't be
            -- useful anyway.
            return mapping.desc and mapping.desc ~= ""
        end,
        spec = {
            { "<Leader>h", group = "Git [H]unk" },
        },
    })
end


if has_plugin("gitsigns.nvim") then
    require("gitsigns").setup({
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

            for _, keymap in ipairs({
                { "n", "<Leader>hs", gitsigns.stage_hunk,                                                        { buffer = buffer, desc = "Stage hunk under cursor" } },
                { "v", "<Leader>hs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { buffer = buffer, desc = "Stage selected hunk" } },
                { "n", "<Leader>hr", gitsigns.reset_hunk,                                                        { buffer = buffer, desc = "Revert hunk under cursor" } },
                { "v", "<Leader>hr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { buffer = buffer, desc = "Revert selected hunk" } },
                { "n", "<Leader>hp", gitsigns.preview_hunk,                                                      { buffer = buffer, desc = "Show current hunk" } },
                { "n", "<Leader>hb", function() gitsigns.blame_line({ full = true }) end,                        { buffer = buffer, desc = "Blame current line" } },
            }) do
                vim.keymap.set(unpack(keymap))
            end
        end,
    })
end


if has_plugin("nvim-highlight-colors") then
    require("nvim-highlight-colors").setup({})
end


if IS_REMOTE_HOST then
    require("mason").setup({})
end

--
-- // SOURCE EXTRA CONFIGURATIONS //
--

for _, name in ipairs({ vim.fn.hostname(), "local" }) do
    local path = string.format("%s/init.%s.lua", vim.fn.stdpath("config"), name)

    if vim.fn.filereadable(path) == 1 then
        vim.cmd.source(path)
    end
end
