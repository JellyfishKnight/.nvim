-- ==================== 主题插件配置 ====================

return {
    -- GitHub 仓库地址：用户名/仓库名
    "catppuccin/nvim",
    
    -- 插件别名，可以用这个名字引用插件
    name = "catppuccin",
    
    -- 加载优先级，数值越大越先加载
    -- 主题插件必须最先加载，这样其他插件才能正确应用主题色彩
    priority = 1000,
    
    -- 插件配置函数，在插件安装后自动执行
    config = function()
        -- 调用插件的设置函数
        require("catppuccin").setup({
            -- 选择主题风格：latte(浅色), frappe(中色), macchiato(深色), mocha(最深)
            flavour = "mocha",
            
            -- 不同模式下的默认主题
            background = {
                light = "latte",    -- 当系统设置为浅色模式时使用
                dark = "mocha",     -- 当系统设置为深色模式时使用
            },
            
            -- 背景透明度设置
            transparent_background = false,  -- false=使用主题背景色, true=透明背景
            
            -- 是否显示文件末尾的波浪线标记
            show_end_of_buffer = false,
            
            -- 是否为终端设置颜色
            term_colors = false,
            
            -- 非活动窗口淡化设置
            dim_inactive = {
                enabled = false,        -- 是否启用窗口淡化效果
                shade = "dark",         -- 淡化方向：dark或light
                percentage = 0.15,      -- 淡化程度：0.0-1.0
            },
            
            -- 语法高亮样式自定义
            styles = {
                comments = { "italic" },        -- 注释：斜体
                conditionals = { "italic" },    -- 条件语句：斜体
                loops = {},                     -- 循环：默认样式
                functions = {},                 -- 函数：默认样式
                keywords = {},                  -- 关键字：默认样式
                strings = {},                   -- 字符串：默认样式
                variables = {},                 -- 变量：默认样式
                numbers = {},                   -- 数字：默认样式
                booleans = {},                  -- 布尔值：默认样式
                properties = {},                -- 属性：默认样式
                types = {},                     -- 类型：默认样式
                operators = {},                 -- 操作符：默认样式
            },
            
            -- 与其他插件的集成配置
            integrations = {
                cmp = true,         -- nvim-cmp 自动补全插件
                gitsigns = true,    -- gitsigns Git状态插件
                nvimtree = true,    -- nvim-tree 文件树插件
                telescope = true,   -- telescope 模糊搜索插件
                notify = false,     -- 通知插件（暂不启用）
                mini = false,       -- mini.nvim 插件集（暂不启用）
            }
        })
        
        -- 应用主题：立即切换到配置好的catppuccin主题
        vim.cmd.colorscheme("catppuccin")
    end,
}
