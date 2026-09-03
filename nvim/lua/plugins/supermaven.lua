return {
    {
      "supermaven-inc/supermaven-nvim",
      event = "InsertEnter",
      config = function()
        require("supermaven-nvim").setup({
          keymaps = {
            accept_suggestion = "<C-l>",
            clear_suggestion = "<C-]>",
            accept_word = "<C-j>",
          },
          -- log_level = "info" ghi log moi request/response theo tung keystroke.
          log_level = "off",
          ignore_filetypes = {
            gitcommit = true,
            gitrebase = true,
            ["dap-repl"] = true,
            TelescopePrompt = true,
            NvimTree = true,
          },
          -- condition tra ve true = TAT suggestion. Buffer rat lon thi moi lan
          -- go lai gui lai context len server, khong dang.
          condition = function()
            local buf = vim.api.nvim_get_current_buf()

            if vim.api.nvim_buf_line_count(buf) > 4000 then
              return true
            end

            local name = vim.api.nvim_buf_get_name(buf)
            local stat = name ~= "" and vim.uv.fs_stat(name)

            return stat ~= nil and stat.size > 512 * 1024
          end,
        })
      end,
    },
}
