require("lazy").setup({
    -- 主题插件
    {
        "catppuccin/nvim",              -- 插件的 GitHub 地址
        name = "catppuccin",            -- 给插件起个名字
        priority = 1000,                -- 优先级：1000 表示最先加载
        config = function()
            -- 这个函数在插件安装后自动执行
            vim.cmd.colorscheme("catppuccin-mocha")  -- 应用主题
        end,
    },
    -- 文件图标
    {
        "nvim-tree/nvim-web-devicons",  -- 文件图标插件
        config = function()
            require("nvim-web-devicons").setup()  -- 初始化插件
        end,
    },

})
