-- Hien loi/canh bao ngay tren dong code (virtual text) + sign o cot ben trai.
vim.diagnostic.config({
    -- doi text loi ngay cuoi dong
    virtual_text = {
        spacing = 2,
        prefix = "●",
        source = "if_many",
    },
    -- virtual_lines hien loi tren dong rieng ben duoi; bat bang <leader>lv
    virtual_lines = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },
    underline = true,
    -- khong update khi dang go, tranh nhay lien tuc
    update_in_insert = false,
    -- loi nghiem trong hien truoc khi nhieu diagnostic tren cung mot dong
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
    },
})

-- Toggle giua virtual_text (gon) va virtual_lines (day du, nhieu dong)
vim.keymap.set("n", "<leader>lv", function()
    local cfg = vim.diagnostic.config()
    local lines_on = cfg.virtual_lines ~= false and cfg.virtual_lines ~= nil
    vim.diagnostic.config({
        virtual_lines = not lines_on,
        virtual_text = lines_on and { spacing = 2, prefix = "●", source = "if_many" } or false,
    })
end, { desc = "Toggle diagnostic virtual lines" })
