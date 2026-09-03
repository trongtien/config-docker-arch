vim.lsp.config["html"] = {
	filetypes = { "html", "htmlangular" },
	root_markers = { "package.json", "tsconfig.json", ".git" },
	settings = {
		html = {
			suggest = { -- completion
				enable = true,
				autoimport = true,
			},
			validate = { -- validation
				scripts = true,
				styles = true,
			},
		},
		emmet = { -- emmet
			includeLanguages = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			},
		},
	},
}
