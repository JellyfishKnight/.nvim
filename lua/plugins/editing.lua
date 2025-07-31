-- lua/plugins/editing.lua (新建文件)
return {
    -- 代码注释
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup({
                -- ========== 基础配置 ==========
                -- 自动检测文件类型并使用对应的注释符号
                opleader = {
                    line = 'gc',      -- 行注释操作符
                    block = 'gb',     -- 块注释操作符
                },
                
                -- 快捷键映射
                mappings = {
                    basic = true,     -- 启用基础映射 (gcc, gbc, gc[count]{motion})
                    extra = true,     -- 启用额外映射 (gco, gcO, gcA)
                },
                
                -- ========== 切换器配置 ==========
                toggler = {
                    line = 'gcc',     -- 切换行注释
                    block = 'gbc',    -- 切换块注释
                },
                
                -- ========== 操作器配置 ==========
                opleader = {
                    line = 'gc',      -- 行注释操作符
                    block = 'gb',     -- 块注释操作符
                },
                
                -- ========== 额外映射 ==========
                extra = {
                    above = 'gcO',    -- 在上方添加注释
                    below = 'gco',    -- 在下方添加注释
                    eol = 'gcA',      -- 在行尾添加注释
                },
                
                -- ========== 钩子函数 ==========
                pre_hook = nil,   -- 注释前执行的函数
                post_hook = nil,  -- 注释后执行的函数
            })
            
            -- ========== 自定义快捷键映射 ==========
            -- 添加 Ctrl+/ 快捷键支持
            local keymap = vim.keymap.set
            
            -- 普通模式下的 Ctrl+/（注释当前行）
            keymap("n", "<C-_>", function()
                require("Comment.api").toggle.linewise.current()
            end, { desc = "切换当前行注释" })
            
            -- 可视模式下的 Ctrl+/（注释选中的所有行）
            keymap("v", "<C-_>", "<ESC><CMD>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "切换选中行的注释" })
            
            -- Note: 在终端中，Ctrl+/ 通常被识别为 Ctrl+_
            -- 如果你的终端不支持，也可以使用以下映射：
            keymap("n", "<C-/>", function()
                require("Comment.api").toggle.linewise.current()
            end, { desc = "切换当前行注释（备用）" })
            
            keymap("v", "<C-/>", "<ESC><CMD>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "切换选中行的注释（备用）" })
        end,
    },

    -- 包围操作 (添加/删除/修改引号、括号等)
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup()
        end,
    },

    -- 自动配对括号
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup()
        end,
    },

    -- 多光标编辑
    {
        "mg979/vim-visual-multi",
        branch = "master",
    },

    -- 代码缩进线
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("ibl").setup()
        end,
    },

    -- 彩虹括号
    {
        "HiPhish/rainbow-delimiters.nvim",
        config = function()
            require("rainbow-delimiters.setup")
        end,
    },
}
