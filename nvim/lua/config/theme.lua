local M = {}
function M.themeColor(value)
    local theme = value or "koda-dark"
    if pcall(vim.cmd.colorscheme, theme) then
        return
    end

    vim.notify("colorscheme '" .. theme .. "' not found, using habamax", vim.log.levels.WARN)
    vim.cmd.colorscheme("habamax")
end

M.themeColor("edge")
