local M = {}
function M.themeColor(value)
    local theme = value or "koda-dark"
    if pcall(vim.cmd.colorscheme, theme) then
        return
    end

    vim.notify("colorscheme '" .. theme .. "' not found, using habamax", vim.log.levels.WARN)
    vim.cmd.colorscheme("habamax")
end


vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("ThemeOverrides", { clear = true }),
    callback = function()
        vim.api.nvim_set_hl(0, "Visual", { bg = "#4a4f5c" })
        vim.api.nvim_set_hl(0, "CursorLine", { bg = "#383b45" })
    end,
})

M.themeColor("edge")
