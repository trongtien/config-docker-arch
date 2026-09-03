vim.lsp.config["html"] = {
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
	-- Feed angular-three's custom element metadata to the server, when the
	-- project has it installed. Runs before the initialize request so the
	-- paths reach the server in initializationOptions.
	before_init = function(params, config)
		local root_dir = config.root_dir or vim.fn.getcwd()
		local metadata_path = vim.fs.normalize(root_dir .. "/node_modules/angular-three/metadata.json")

		if vim.fn.filereadable(metadata_path) == 0 then
			return
		end

		local init_options = params.initializationOptions or {}
		init_options.dataPaths = init_options.dataPaths or {}
		table.insert(init_options.dataPaths, metadata_path)
		params.initializationOptions = init_options
	end,
	handlers = {
		-- Server asks us to read the custom data files listed in dataPaths.
		["html/customDataContent"] = function(_, result)
			local path = result and result[1]

			if type(path) ~= "string" or not vim.uv.fs_stat(path) then
				return ""
			end

			local ok, content = pcall(vim.fn.readfile, path)
			return ok and table.concat(content, "\n") or ""
		end,
	},
}
