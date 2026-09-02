return {
    {
        "oskarnurm/koda.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme(vim.g.colorscheme or "koda-dark")
        end,
    },
}
