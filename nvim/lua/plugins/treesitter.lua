return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
        auto_install = true,
        sync_install = false,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        ensure_installed = {
            "ocaml",
            "go",
            "elixir",
            "heex",
            "eex",
            "surface",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "python",
            "javascript",
            "typescript",
            "tsx",
            "html",
            "css",
            "json",
            "gitignore"
        }
	}
}

