-- lua/plugins/terminal.lua (新建文件)
return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                -- ========== 基础设置 ==========
                size = function(term)
                    if term.direction == "horizontal" then
                        return 15  -- 水平终端高度（行数）
                    elseif term.direction == "vertical" then
                        return vim.o.columns * 0.4  -- 垂直终端宽度（40%屏幕宽度）
                    end
                end,
                
                -- ========== 快捷键设置 ==========
                open_mapping = [[<c-\>]], -- Ctrl+\ 切换终端
                hide_numbers = true,      -- 隐藏行号
                
                -- ========== 外观设置 ==========
                shade_filetypes = {},
                shade_terminals = true,   -- 终端背景着色
                shading_factor = 1,       -- 着色程度（1-3，越高越暗）
                
                -- ========== 行为设置 ==========
                start_in_insert = true,   -- 打开终端时进入插入模式
                insert_mappings = true,   -- 插入模式下也可用快捷键
                terminal_mappings = true, -- 终端模式下可用快捷键
                persist_size = true,      -- 记住终端大小
                persist_mode = true,      -- 记住终端模式
                
                -- ========== 方向设置 ==========
                direction = "horizontal", -- 水平分屏（底部）
                -- 可选值：
                -- "vertical"   - 垂直分屏（右侧）
                -- "horizontal" - 水平分屏（底部）  
                -- "tab"        - 新标签页
                -- "float"      - 浮动窗口
                
                -- ========== 其他设置 ==========
                close_on_exit = true,     -- 进程退出时关闭终端
                shell = vim.o.shell,      -- 使用系统默认shell
                auto_scroll = true,       -- 自动滚动到底部
            })
            
            -- ========== 自定义快捷键 ==========
            local keymap = vim.keymap.set
            
            -- 基础终端操作
            keymap("n", "<leader>t", ":ToggleTerm<CR>", { desc = "切换水平终端" })
            keymap("n", "<leader>tv", ":ToggleTerm direction=vertical<CR>", { desc = "切换垂直终端" })
            keymap("n", "<leader>th", ":ToggleTerm direction=horizontal<CR>", { desc = "切换水平终端" })
            keymap("n", "<leader>tf", ":ToggleTerm direction=float<CR>", { desc = "切换浮动终端" })
            
            -- 多终端管理
            keymap("n", "<leader>t1", ":1ToggleTerm<CR>", { desc = "切换终端1" })
            keymap("n", "<leader>t2", ":2ToggleTerm<CR>", { desc = "切换终端2" })
            keymap("n", "<leader>t3", ":3ToggleTerm<CR>", { desc = "切换终端3" })
            
            -- 终端模式下的快捷键
            function _G.set_terminal_keymaps()
                local opts = {buffer = 0}
                -- 在终端模式下用 Esc 退出到普通模式
                keymap('t', '<esc>', [[<C-\><C-n>]], opts)
                -- 在终端模式下也可以用 Ctrl+hjkl 切换窗口
                keymap('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
                keymap('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
                keymap('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
                keymap('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
            end
            
            -- 自动应用终端快捷键
            vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
        end,
    },
}
