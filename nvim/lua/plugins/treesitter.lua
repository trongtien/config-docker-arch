local utils = require("utils.module_utils")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		opts_extend = { "ensure_installed" },
		opts = {
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
				"gitignore",
			},
		},
		config = function(_, opts)
			utils.prefer_real_tree_sitter()
			utils.prefer_mingw_cc()

			local ts = require("nvim-treesitter")
			ts.setup({})

			vim.api.nvim_create_autocmd("FileType", {
				desc = "Bat treesitter highlight khi filetype co parser",
				callback = function(ev)
					local lang = vim.treesitter.language.get_lang(ev.match) or ev.match

					if vim.treesitter.language.add(lang) then
						vim.treesitter.start(ev.buf, lang)
					end
				end,
			})

			local installed = require("nvim-treesitter.config").get_installed("parsers")
			local missing = vim.tbl_filter(function(lang)
				return not vim.tbl_contains(installed, lang)
			end, opts.ensure_installed)

			if #missing == 0 then
				return
			end

			if not utils.tree_sitter_ready() then
				vim.notify(
					string.format(
						"tree-sitter CLI khong chay duoc (exepath: %s), bo qua %d parser: %s -- cai bang: scoop install tree-sitter",
						vim.fn.exepath("tree-sitter") ~= "" and vim.fn.exepath("tree-sitter") or "khong tim thay",
						#missing,
						table.concat(missing, ", ")
					),
					vim.log.levels.WARN
				)
				return
			end

			ts.install(missing)
		end,
	},
}
