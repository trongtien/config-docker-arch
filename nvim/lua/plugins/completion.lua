return {
    {
        "saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",
		opts = {
			keymap = {
				preset = "default",
				-- Enter de accept item dang chon, khong co menu thi xuong dong binh thuong
				["<CR>"] = { "accept", "fallback" },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
    }
}
