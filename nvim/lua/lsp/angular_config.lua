-- Angular: nvim chi doan htmlangular qua noi dung file (@if, *ngIf, ng-template...),
-- map thang theo ten file de angularls va parser angular luon nhan dung.
vim.filetype.add({
	pattern = {
		[".*%.component%.html"] = "htmlangular",
		[".*%.container%.html"] = "htmlangular",
		[".*%.ng%.html"] = "htmlangular",
	},
})

vim.lsp.config["angularls"] = {
	-- Nap metadata cua angular-three (neu project co cai) truoc request initialize
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
		-- Server nho client doc noi dung cac file trong dataPaths
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
		-- HACK: tat rename cua angularls, ts_ls cung co rename nen popup bi lap
		client.server_capabilities.renameProvider = false
	end,
}

local function angular_plugin_path()
	local exe = vim.fn.exepath("ngserver")

	if exe == "" then
		return nil
	end

	local bin = vim.fs.dirname(vim.fs.normalize(exe))
	local candidates = {
		-- Windows: shim <prefix>/ngserver.cmd, package o <prefix>/node_modules/...
		vim.fs.joinpath(bin, "node_modules/@angular/language-server"),
		-- Unix: <prefix>/bin/ngserver -> <prefix>/lib/node_modules/...
		vim.fs.joinpath(bin, "../lib/node_modules/@angular/language-server"),
	}

	for _, dir in ipairs(candidates) do
		if vim.uv.fs_stat(vim.fs.joinpath(dir, "package.json")) then
			return vim.fs.normalize(dir)
		end
	end
end

local angular_plugin = angular_plugin_path()

if angular_plugin then
	-- init_options duoc deep-merge, hostInfo cua lspconfig van giu nguyen
	vim.lsp.config["ts_ls"] = {
		init_options = {
			plugins = {
				{
					name = "@angular/language-server",
					location = angular_plugin,
					languages = { "typescript", "html", "htmlangular" },
				},
			},
		},
	}
end
