return {
    "tjdevries/express_line.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- express_line is unmaintained (this commit is upstream tip) and still calls
    -- two APIs Neovim has deprecated: `vim.tbl_flatten` on every statusline
    -- redraw (removed in 0.13) and `vim.validate{<table>}` in its setup
    -- (removed in 1.0). Shim both so :checkhealth stays clean and the statusline
    -- keeps working once they are gone for good.
    init = function()
        -- express_line goi tbl_flatten moi lan build statusline (tuc la moi
        -- keystroke, vi generator co builtin.column). `vim.iter():flatten()`
        -- cap phat mot chuoi iterator moi lan goi, nen dung de quy thuan tay.
        vim.tbl_flatten = function(t)
            local result = {}
            local function flatten(list)
                for _, v in ipairs(list) do
                    if type(v) == "table" then
                        flatten(v)
                    else
                        result[#result + 1] = v
                    end
                end
            end
            flatten(t)
            return result
        end

        local type_aliases =
            { b = "boolean", c = "callable", f = "function", n = "number", s = "string", t = "table" }
        local function unalias(validator)
            if type(validator) == "string" then
                return type_aliases[validator] or validator
            elseif type(validator) == "table" then
                return vim.tbl_map(function(t)
                    return type_aliases[t] or t
                end, validator)
            end
            return validator
        end

        local validate = vim.validate
        vim.validate = function(name, ...)
            -- Only the deprecated single-table form is translated; the modern
            -- `vim.validate(name, value, validator, ...)` form passes straight through.
            if select("#", ...) > 0 or type(name) ~= "table" then
                return validate(name, ...)
            end
            for param, spec in pairs(name) do
                local ok, err = pcall(validate, param, spec[1], unalias(spec[2]), spec[3])
                if not ok then
                    error(err, 0)
                end
            end
        end
    end,
    config = function()
        local builtin = require("el.builtin")
        local extensions = require("el.extensions")
        local subscribe = require("el.subscribe")

        local SPACE = " "

        -- Cac mau nay la hang so, dinh nghia MOT lan. Truoc day chung nam trong
        -- callback statusline: `nvim_set_hl` invalidate highlight cache nen moi
        -- lan goi la mot lan redraw ca man hinh -- diagnostics doi lien tuc luc
        -- dang go => redraw storm. ColorScheme autocmd de mau khong bi
        -- colorscheme (load sau plugin nay) ghi de.
        local function define_highlights()
            vim.api.nvim_set_hl(0, "StatusLineLsp", { fg = "#ffacf0", bg = "#1e1e1e", bold = true })
            vim.api.nvim_set_hl(0, "StatusLineDiagErr", { fg = "#ffffff", bg = "#fa1000", bold = true })
            vim.api.nvim_set_hl(0, "StatusLineDiagWarn", { fg = "#773300", bg = "#ffac00", bold = true })
            vim.api.nvim_set_hl(0, "StatusLineDiagInfo", { fg = "#111133", bg = "#0facf0", bold = true })
            vim.api.nvim_set_hl(0, "StatusLineDiagHint", { fg = "#ffffff", bg = "#00b070", bold = true })
            vim.api.nvim_set_hl(0, "StatusLineModeNormal", { fg = "#1e1e2e", bg = "#89b4fa", bold = true })
            vim.api.nvim_set_hl(0, "StatusLineModeInsert", { fg = "#1e1e2e", bg = "#a6e3a1", bold = true })
            vim.api.nvim_set_hl(0, "StatusLineModeVisual", { fg = "#1e1e2e", bg = "#f9e2af", bold = true })
        end

        define_highlights()

        vim.api.nvim_create_autocmd("ColorScheme", {
            desc = "Dinh nghia lai highlight statusline sau khi doi colorscheme",
            callback = define_highlights,
        })

        local lsp_server = function(_, buffer)
            local clients = vim.lsp.get_clients({ bufnr = buffer.bufnr })
            if next(clients) == nil then
                return ""
            end
            local server_name = clients[1].name
            local hl = "StatusLineLsp"
            local post = "%#StatusLine#"
            return string.format("%%#Normal# [%%#%s#%s%s]", hl, server_name, post)
        end

        local diagnostics = function(_, buffer)
            local counts = vim.diagnostic.count(buffer.bufnr)

            local severity_map = {
                { count = counts[vim.diagnostic.severity.ERROR] or 0, hl = "StatusLineDiagErr" },
                { count = counts[vim.diagnostic.severity.WARN] or 0, hl = "TroubleWarning" },
                { count = counts[vim.diagnostic.severity.INFO] or 0, hl = "TroubleInformation" },
                { count = counts[vim.diagnostic.severity.HINT] or 0, hl = "TroubleHint" },
            }

            local display = {}
            for _, item in ipairs(severity_map) do
                if item.count > 0 then
                    table.insert(display, string.format("%%#%s#%d%%*", item.hl, item.count))
                end
            end

            if #display > 0 then
                return " " .. table.concat(display, " ")
            end
            return ""
        end

        local git_branch_name = function(window, buffer)
            local branch = extensions.git_branch(window, buffer)
            return branch and (" " .. branch) or ""
        end

        local file_icon = function(_, buffer)
            local icon = extensions.file_icon(_, buffer)
            return icon or ""
        end

        local function mode_segment_highlighted()
            local mode_map = {
                ["n"] = "N",
                ["no"] = "N·OPERATOR",
                ["v"] = "V",
                ["V"] = "V·LINE",
                ["\22"] = "V·BLOCK",
                ["s"] = "S",
                ["S"] = "S·LINE",
                ["\19"] = "S·BLOCK",
                ["i"] = "I",
                ["R"] = "R",
                ["Rv"] = "V·REPLACE",
                ["c"] = "C",
                ["cv"] = "VIM·EX",
                ["ce"] = "EX",
                ["r"] = "PROMPT",
                ["rm"] = "MORE",
                ["r?"] = "CF",
                ["!"] = "S",
                ["t"] = "T",
            }

            return function()
                local mode_code = vim.api.nvim_get_mode().mode
                local mode_name = mode_map[mode_code] or mode_code
                local hl = "StatusLineModeNormal" -- Default
                local post = "%#StatusLine#"
                if mode_code:lower():find("v") or mode_code == "\22" then
                    hl = "StatusLineModeVisual"
                elseif mode_code == "i" then
                    hl = "StatusLineModeInsert"
                end
                return string.format("%%#%s# %s %%* %s", hl, mode_name, post)
            end
        end

        local generator = function()
            return {
                -- Left Side
                mode_segment_highlighted(),
                SPACE,
                builtin.file_relative,
                builtin.modified_flag,

                -- Spacer
                "%=",

                -- Right Side
                subscribe.buf_autocmd("el_git_branch", "BufEnter", git_branch_name),
                SPACE,
                builtin.line_number,
                ":",
                builtin.column,
                SPACE,

                subscribe.buf_autocmd("el_file_icon", "BufRead", file_icon),
                subscribe.buf_autocmd("el_buf_lsp_name", "LspAttach", lsp_server),
                subscribe.buf_autocmd("el_buf_diagnostic", "DiagnosticChanged", diagnostics),
            }
        end

        require("el").setup({ generator = generator })

    end
}

