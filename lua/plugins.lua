-- ==================== 插件列表配置 ====================
-- 只定义插件的基本信息，具体配置在各自的文件中

require("lazy").setup({
    -- 主题相关
    require("plugins.colorscheme"),
    
    -- UI相关插件
    require("plugins.ui"),
    
    -- 自动补全系统
    require("plugins.completion"),
    
    -- LSP配置
    require("plugins.lsp"),
    
}, {
    -- ==================== Lazy.nvim 全局配置 ====================
    ui = {
        border = "rounded",     -- 插件管理界面使用圆角边框
    },
    rocks = {
        enabled = false,        -- 禁用luarocks支持（避免警告）
    },
    performance = {
        rtp = {
            -- 禁用不需要的内置插件，提高启动速度
            disabled_plugins = {
                "gzip",             -- gzip文件支持
                "matchit",          -- 括号匹配增强
                "matchparen",       -- 括号高亮
                "netrwPlugin",      -- 内置文件管理器
                "tarPlugin",        -- tar文件支持
                "tohtml",           -- 转换为HTML
                "tutor",            -- Vim教程
                "zipPlugin",        -- zip文件支持
            },
        },
    },
})
