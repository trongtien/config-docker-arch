return {
    "nvim-telescope/telescope.nvim",

    branch = "0.1.x",

    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
    },

    config = function()
        local telescope = require('telescope')
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                file_ignore_patterns = {
                    "node_modules",
                    "vendor",
                    "build",
                    "%.git",
                },
                path_display = { "smart" },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        ["<C-t>"] = require("trouble.sources.telescope").open,
                    },
                },
            },
        })

        pcall(telescope.load_extension, "fzf")

        local preview_utils = require("telescope.previewers.utils")
        preview_utils.ts_highlighter = function(bufnr, ft)
            local lang = vim.treesitter.language.get_lang(ft) or ft
            if not lang or lang == "" then
                return false
            end

            return pcall(vim.treesitter.start, bufnr, lang)
        end
    end
}

