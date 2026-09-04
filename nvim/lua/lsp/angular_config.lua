local utils = require("utils.module_utils")

-- ngserver chi huu dung khi cwd nam trong Angular/Nx workspace. Enable vo dieu kien
-- thi no van start o moi buffer ts/html voi probe locations rong -> client chet nhung
-- van "attached", nuot het request.
if not utils.is_angular_project() then
	return
end

vim.lsp.config["angularls"] = {
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
		["html/customDataContent"] = function(_, result)
			local path = result and result[1]

			if type(path) ~= "string" or not vim.uv.fs_stat(path) then
				return ""
			end

			local ok, content = pcall(vim.fn.readfile, path)
			return ok and table.concat(content, "\n") or ""
		end,
	},
	on_attach = function(client, _)
		client.server_capabilities.renameProvider = false
	end,
}

vim.lsp.enable("angularls")

-- Tra ve thu muc chua node_modules/@angular/language-service (= probe location cua
-- tsserver), khong phai duong dan cua chinh plugin.
local function angular_plugin_path()
	local exe = vim.fn.exepath("ngserver")

	if exe == "" then
		return nil
	end

	local bin = vim.fs.dirname(vim.fs.normalize(exe))
	local candidates = {
		vim.fs.joinpath(bin, "node_modules/@angular/language-server"),
		vim.fs.joinpath(bin, "../lib/node_modules/@angular/language-server"),
	}

	for _, dir in ipairs(candidates) do
		if vim.uv.fs_stat(vim.fs.joinpath(dir, "node_modules/@angular/language-service/package.json")) then
			return vim.fs.normalize(dir)
		end
	end
end

local angular_plugin = angular_plugin_path()
if angular_plugin then
	vim.lsp.config["ts_ls"] = {
		init_options = {
			-- Plugin cua tsserver ten la "@angular/language-service". Dat "@angular/language-server"
			-- (do la LSP binary, khong phai ts plugin) thi tsserver load nham module do, module
			-- nay doc stdin cua tsserver -> hong protocol, moi request treo im lang.
			plugins = {
				{
					name = "@angular/language-service",
					location = angular_plugin,
					languages = { "typescript", "html", "htmlangular" },
				},
			},
		},
	}
end
