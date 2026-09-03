local M = {}

function M.is_angular_project()
	local cwd = vim.fn.getcwd()

	if vim.fs.root(cwd, { "angular.json", "nx.json" }) then
		return true
	end

	local root = vim.fs.root(cwd, { "package.json" })

	if not root then
		return false
	end

	local ok, lines = pcall(vim.fn.readfile, vim.fs.joinpath(root, "package.json"))

	if not ok then
		return false
	end

	local decoded, json = pcall(vim.json.decode, table.concat(lines, "\n"))

	if not decoded or type(json) ~= "table" then
		return false
	end

	local deps = vim.tbl_extend("keep", json.dependencies or {}, json.devDependencies or {})

	return deps["@angular/core"] ~= nil
end


function M.prefer_real_tree_sitter()
	if vim.fn.has("win32") == 0 then
		return
	end

	if vim.fn.exepath("tree-sitter"):lower():match("%.exe$") then
		return 
	end

	local dirs = {}

	for _, near in ipairs({ vim.fn.exepath("tree-sitter"), vim.fn.exepath("node") }) do
		if near ~= "" then
			table.insert(dirs, vim.fs.joinpath(vim.fs.dirname(vim.fs.normalize(near)), "node_modules/tree-sitter-cli"))
		end
	end

	local exe = vim.fn.exepath("tree-sitter.exe")

	if exe ~= "" then
		table.insert(dirs, vim.fs.dirname(vim.fs.normalize(exe)))
	end

	for _, dir in ipairs(dirs) do
		if vim.uv.fs_stat(vim.fs.joinpath(dir, "tree-sitter.exe")) then
			vim.env.PATH = dir .. ";" .. vim.env.PATH
			return
		end
	end
end


function M.prefer_mingw_cc()
	if vim.fn.has("win32") == 0 or vim.env.CC then
		return
	end

	-- co MSVC thi de CLI tu dung cl.exe
	if vim.fn.executable("cl") == 1 then
		return
	end

	local gcc = vim.fn.exepath("gcc")

	if vim.fn.executable("clang") == 0 or gcc == "" then
		return
	end

	local sysroot = vim.fs.dirname(vim.fs.dirname(vim.fs.normalize(gcc)))

	vim.env.CC = "clang"
	vim.env.CFLAGS = string.format("--target=x86_64-w64-mingw32 --sysroot=%s", sysroot)
end

function M.tree_sitter_ready()
	local ok, res = pcall(function()
		return vim.system({ "tree-sitter", "--version" }, { text = true }):wait(10000)
	end)

	return ok and res.code == 0
end

return M
