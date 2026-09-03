local utils = require("utils.module_utils")

if not utils.is_angular_project() then
	return {}
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = {
			ensure_installed = { "angular", "scss" },
		},
		init = function()
			vim.filetype.add({
				pattern = {
					[".*%.component%.html"] = "htmlangular",
					[".*%.container%.html"] = "htmlangular",
					[".*%.ng%.html"] = "htmlangular",
				},
			})
		end,
	},
}
