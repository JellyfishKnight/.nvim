-- ==================== UI相关插件配置 ====================

return {
    -- ==================== 文件图标插件 ====================
    {
        -- 提供文件类型图标的插件
        "nvim-tree/nvim-web-devicons",
        
        config = function()
            require("nvim-web-devicons").setup({
                -- 启用默认图标集
                default = true,
                
                -- 可以覆盖特定文件扩展名的图标
                override = {
                    -- 示例：自定义Rust文件图标
                    rs = {
                        icon = "",        -- 图标字符（需要支持的字体）
                        color = "#dea584", -- 图标颜色（十六进制）
                        name = "Rust"      -- 图标名称
                    },
                },
                
                -- 严格模式：只显示已定义的图标
                strict = true,
                
                -- 覆盖默认图标的全局设置
                override_by_filename = {
                    [".gitignore"] = {
                        icon = "",
                        color = "#f1502f",
                        name = "Gitignore"
                    }
                },
                
                -- 按文件扩展名覆盖
                override_by_extension = {
                    ["log"] = {
                        icon = "",
                        color = "#81e043",
                        name = "Log"
                    }
                },
            })
        end,
    },

    -- ==================== 状态栏插件 ====================
    {
        -- 美化的状态栏，显示各种有用信息
        "nvim-lualine/lualine.nvim",
        
        -- 依赖图标插件
        dependencies = { 
            "nvim-tree/nvim-web-devicons"
        },
        
        config = function()
            require("lualine").setup({
                -- ========== 全局选项 ==========
                options = {
                    icons_enabled = true,                        -- 启用图标
                    theme = "catppuccin",                       -- 使用catppuccin主题
                    component_separators = { left = "", right = ""},  -- 组件间分隔符
                    section_separators = { left = "", right = ""},    -- 段间分隔符
                    
                    -- 禁用状态栏的文件类型
                    disabled_filetypes = {
                        statusline = {},      -- 状态栏禁用列表
                        winbar = {},          -- 窗口栏禁用列表
                    },
                    
                    ignore_focus = {},                          -- 忽略焦点的窗口
                    always_divide_middle = true,                -- 总是在中间分割
                    globalstatus = false,                       -- 每个窗口独立状态栏
                    
                    -- 刷新频率（毫秒）
                    refresh = {
                        statusline = 1000,    -- 状态栏每秒刷新
                        tabline = 1000,       -- 标签栏每秒刷新
                        winbar = 1000,        -- 窗口栏每秒刷新
                    }
                },
                
                -- ========== 活动窗口状态栏布局 ==========
                sections = {
                    -- 最左侧：当前编辑模式
                    lualine_a = {"mode"},
                    
                    -- 左侧：Git和诊断信息
                    lualine_b = {"branch", "diff", "diagnostics"},
                    
                    -- 中央：文件名
                    lualine_c = {"filename"},
                    
                    -- 右侧：文件格式信息
                    lualine_x = {"encoding", "fileformat", "filetype"},
                    
                    -- 右侧：文件进度
                    lualine_y = {"progress"},
                    
                    -- 最右侧：光标位置
                    lualine_z = {"location"}
                },
                
                -- ========== 非活动窗口状态栏布局 ==========
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {"filename"},     -- 只显示文件名
                    lualine_x = {"location"},     -- 只显示位置
                    lualine_y = {},
                    lualine_z = {}
                },
                
                -- ========== 其他栏位 ==========
                tabline = {},           -- 标签栏配置（暂不使用）
                winbar = {},            -- 窗口栏配置（暂不使用）
                inactive_winbar = {},   -- 非活动窗口栏
                extensions = {}         -- 扩展支持
            })
        end,
    },

    -- ==================== 缓冲区标签栏插件 ====================
    {
        -- 顶部文件标签栏，类似IDE的文件标签
        "akinsho/bufferline.nvim",
        
        -- 指定版本，确保稳定性
        version = "*",
        
        -- 依赖图标插件
        dependencies = "nvim-tree/nvim-web-devicons",
        
        config = function()
            require("bufferline").setup({
                -- ========== 全局选项 ==========
                options = {
                    -- 使用Neovim内置的LSP进行诊断
                    diagnostics = "nvim_lsp",
                    
                    -- 诊断信息显示格式
                    diagnostics_indicator = function(count, level, diagnostics_dict, context)
                        local icon = level:match("error") and " " or " "
                        return " " .. icon .. count
                    end,
                    
                    -- 显示缓冲区号码
                    numbers = "ordinal",
                    
                    -- 点击行为
                    left_mouse_command = "buffer %d",      -- 左键点击切换缓冲区
                    right_mouse_command = "bdelete! %d",   -- 右键点击关闭缓冲区
                    middle_mouse_command = nil,            -- 禁用中键
                    
                    -- 分隔符样式
                    separator_style = "slant",             -- 可选: "slant", "padded_slant", "slope", "padded_slope", "thick", "thin"
                    
                    -- 始终显示缓冲区标签栏
                    always_show_bufferline = true,
                    
                    -- 显示关闭按钮
                    show_close_icon = false,               -- 全局关闭按钮
                    show_buffer_close_icons = true,        -- 每个标签的关闭按钮
                    
                    -- 显示标签图标
                    show_buffer_icons = true,
                    
                    -- 显示修改指示器
                    modified_icon = "●",
                    
                    -- 左侧偏移量（为文件管理器留空间）
                    offsets = {
                        {
                            filetype = "NvimTree",
                            text = "文件管理器",
                            text_align = "center",
                            separator = true
                        }
                    },
                    
                    -- 颜色配置
                    color_icons = true,
                    
                    -- 最大标签名长度
                    max_name_length = 18,
                    max_prefix_length = 15,
                    tab_size = 18,
                    
                    -- 强制显示选项
                    enforce_regular_tabs = false,
                    view = "multiwindow",
                    
                    -- 自定义过滤器（隐藏某些类型的缓冲区）
                    custom_filter = function(buf_number, buf_numbers)
                        -- 过滤掉临时文件和特殊缓冲区
                        if vim.bo[buf_number].filetype ~= "oil" then
                            return true
                        end
                    end,
                },
                
                -- ========== 高亮组配置 ==========
                highlights = {
                    -- 可以在此处自定义颜色，或使用主题默认颜色
                    buffer_selected = {
                        bold = true,
                        italic = false,
                    },
                },
            })
        end,
    },
}
