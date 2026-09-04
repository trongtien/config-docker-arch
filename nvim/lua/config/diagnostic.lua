vim.diagnostic.config({
	virtual_text = {
		spacing = 2,
		prefix = "●",
		source = "if_many",
	},
	virtual_lines = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
	},
})

vim.keymap.set("n", "<leader>lv", function()
	local cfg = vim.diagnostic.config()
	local lines_on = cfg.virtual_lines ~= false and cfg.virtual_lines ~= nil
	vim.diagnostic.config({
		virtual_lines = not lines_on,
		virtual_text = lines_on and { spacing = 2, prefix = "●", source = "if_many" } or false,
	})
end, { desc = "Toggle diagnostic virtual lines" })
