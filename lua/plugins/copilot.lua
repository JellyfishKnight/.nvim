-- GitHub Copilot 代码补全插件配置
return {
    {
        -- GitHub 官方 Copilot 插件
        "github/copilot.vim",
        
        config = function()
            -- ========== 基础设置 ==========
            -- 启用 Copilot
            vim.g.copilot_enabled = true
            
            -- 设置 Copilot 的文件类型支持
            vim.g.copilot_filetypes = {
                ["*"] = true,          -- 默认所有文件类型都启用
                ["gitcommit"] = false, -- Git 提交信息中禁用
                ["gitrebase"] = false, -- Git rebase 中禁用
                ["hgcommit"] = false,  -- Mercurial 提交中禁用
                ["svn"] = false,       -- SVN 中禁用
                ["cvs"] = false,       -- CVS 中禁用
                ["."] = false,         -- dotfiles 中禁用
            }
            
            -- ========== 快捷键映射 ==========
            local keymap = vim.keymap.set
            
            -- Copilot 基础操作
            keymap("i", "<C-g>", 'copilot#Accept("\\<CR>")', {
                expr = true,
                replace_keycodes = false,
                desc = "接受 Copilot 建议"
            })
            
            keymap("i", "<C-]>", "<Plug>(copilot-dismiss)", { desc = "拒绝 Copilot 建议" })
            keymap("i", "<M-[>", "<Plug>(copilot-previous)", { desc = "上一个 Copilot 建议" })
            keymap("i", "<C-'>", "<Plug>(copilot-next)", { desc = "下一个 Copilot 建议" })
            
            -- Copilot 面板操作（普通模式）
            keymap("n", "<leader>cp", ":Copilot panel<CR>", { desc = "打开 Copilot 面板" })
            keymap("n", "<leader>cs", ":Copilot status<CR>", { desc = "查看 Copilot 状态" })
            keymap("n", "<leader>ce", ":Copilot enable<CR>", { desc = "启用 Copilot" })
            keymap("n", "<leader>cd", ":Copilot disable<CR>", { desc = "禁用 Copilot" })
            
            -- 切换 Copilot 功能
            keymap("n", "<leader>ct", function()
                if vim.g.copilot_enabled then
                    vim.cmd("Copilot disable")
                    vim.notify("Copilot 已禁用", vim.log.levels.INFO)
                else
                    vim.cmd("Copilot enable")
                    vim.notify("Copilot 已启用", vim.log.levels.INFO)
                end
            end, { desc = "切换 Copilot 开关" })
            
            -- ========== 自动命令 ==========
            -- 在某些文件类型中自动启用/禁用 Copilot
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {"rust", "python", "javascript", "typescript", "lua", "go", "java", "c", "cpp"},
                callback = function()
                    vim.b.copilot_enabled = true
                end,
                desc = "在编程语言文件中启用 Copilot"
            })
            
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {"markdown", "text", "plaintext"},
                callback = function()
                    vim.b.copilot_enabled = false
                end,
                desc = "在文档文件中禁用 Copilot"
            })
        end,
    },
}