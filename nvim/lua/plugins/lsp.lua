return  {
    {
        "neovim/nvim-lspconfig"
    },
    {
        "onsails/lspkind-nvim"
    },
    {
        -- LSP diagnostics
        "folke/trouble.nvim",
        dependencies = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            })
        end,
    },
    {
        -- LSP auto refreshing docs view
        "amrbashir/nvim-docs-view",
        opt = true,
        cmd = { "DocsViewToggle" },
        config = function()
            require("docs-view").setup({
                position = "bottom",
            })
        end,
    },
    -- LSP ui element
    { 
		"j-hui/fidget.nvim",
		branch = "legacy",
	},
}
