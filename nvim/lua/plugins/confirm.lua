return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = {
                    "ruff_fix",
                    "ruff_format",
                    "ruff_organize_imports",
                },
                c = { "clang-format" },
                cpp = { "clang-format" },
                go = { "gofmt" },
                odin = { "odinfmt" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                json = { "prettier" },
                html = { "prettier" },
                htmlangular = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                elixir = { "mix" },
            },
            formatters = {
                prettier = {
                    -- template Angular can parser rieng cho @if / @for / *ngIf
                    prepend_args = function(_, ctx)
                        if vim.bo[ctx.buf].filetype == "htmlangular" then
                            return { "--parser", "angular" }
                        end
                        return {}
                    end,
                },
                ruff_format = {
                    command = "ruff",
                    args = { "format", "--stdin-filename", "$FILENAME", "-" },
                    stdin = true,
                },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_format = "fallback",
            },
        })
    end,
}
