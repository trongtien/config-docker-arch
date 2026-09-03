
local servers = {
	"clangd",
	"rust_analyzer",
	"ts_ls",
	"yamlls",
	"jsonls",
	"gopls",
	"salt_ls",
	"dockerls",
	"bashls",
	"awk_ls",
	"ocamllsp",
	"elixirls",
	"basedpyright",
	"html",
	"angularls",
}

for _, server in ipairs(servers) do
	vim.lsp.enable(server)
end

require("lsp.angular_config")
require("lsp.ocaml_config")
require("lsp.html_config")
