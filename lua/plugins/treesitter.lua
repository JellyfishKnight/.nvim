-- ==================== Treesitter 语法解析器配置 ====================

return {
    -- Neovim Treesitter 核心插件
    "nvim-treesitter/nvim-treesitter",
    
    -- 构建时编译解析器
    build = ":TSUpdate",
    
    -- 在文件读取或创建时加载
    event = { "BufReadPre", "BufNewFile" },
    
    -- 依赖插件
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",  -- 文本对象支持
    },
    
    config = function()
        require("nvim-treesitter.configs").setup({
            -- ========== 自动安装语言解析器 ==========
            ensure_installed = {
                -- 常用语言
                "lua",          -- Lua
                "vim",          -- Vim script
                "vimdoc",       -- Vim 文档
                
                -- 系统编程语言
                "c",            -- C
                "cpp",          -- C++
                "rust",         -- Rust
                
                -- 构建工具
                "cmake",        -- CMake
                "make",         -- Makefile
                
                -- 脚本语言
                "python",       -- Python
                "javascript",   -- JavaScript
                "typescript",   -- TypeScript
                "bash",         -- Bash
                
                -- 数据格式
                "json",         -- JSON
                "yaml",         -- YAML
                "toml",         -- TOML
                "xml",          -- XML
                
                -- 标记语言
                "markdown",     -- Markdown
                "markdown_inline", -- Markdown 内联语法
                
                -- 其他
                "regex",        -- 正则表达式
                "gitignore",    -- Git ignore 文件
                "diff",         -- Diff 文件
                "dockerfile",   -- Dockerfile
            },
            
            -- 自动安装缺失的解析器
            auto_install = true,
            
            -- ========== 语法高亮配置 ==========
            highlight = {
                enable = true,
                
                -- 禁用某些文件类型的高亮（如果出现性能问题）
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
                
                -- 启用额外的 vim regex 高亮（用于某些复杂语法）
                additional_vim_regex_highlighting = false,
            },
            
            -- ========== 代码缩进配置 ==========
            indent = {
                enable = true,
                -- C/C++ 缩进可能有问题，可以禁用
                disable = { "c", "cpp" },
            },
            
            -- ========== 增量选择配置 ==========
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",      -- 初始化选择
                    node_incremental = "<C-space>",    -- 扩展选择到下一个节点
                    scope_incremental = "<C-s>",       -- 扩展选择到更大的作用域
                    node_decremental = "<C-backspace>", -- 缩小选择
                },
            },
            
            -- ========== 文本对象配置 ==========
            textobjects = {
                select = {
                    enable = true,
                    
                    -- 自动跳转到文本对象
                    lookahead = true,
                    
                    keymaps = {
                        -- 函数相关
                        ["af"] = "@function.outer",     -- 选择整个函数
                        ["if"] = "@function.inner",     -- 选择函数内部
                        
                        -- 类相关
                        ["ac"] = "@class.outer",        -- 选择整个类
                        ["ic"] = "@class.inner",        -- 选择类内部
                        
                        -- 条件语句
                        ["ai"] = "@conditional.outer",  -- 选择整个条件语句
                        ["ii"] = "@conditional.inner",  -- 选择条件内部
                        
                        -- 循环
                        ["al"] = "@loop.outer",         -- 选择整个循环
                        ["il"] = "@loop.inner",         -- 选择循环内部
                        
                        -- 参数
                        ["aa"] = "@parameter.outer",    -- 选择整个参数
                        ["ia"] = "@parameter.inner",    -- 选择参数内部
                        
                        -- 注释
                        ["aC"] = "@comment.outer",      -- 选择整个注释
                    },
                    
                    -- 选择模式
                    selection_modes = {
                        ['@parameter.outer'] = 'v',  -- 参数用字符模式选择
                        ['@function.outer'] = 'V',   -- 函数用行模式选择
                        ['@class.outer'] = 'V',      -- 类用行模式选择
                    },
                },
                
                -- 移动快捷键
                move = {
                    enable = true,
                    set_jumps = true, -- 在跳转列表中设置跳转点
                    goto_next_start = {
                        ["]f"] = "@function.outer",     -- 跳转到下一个函数开始
                        ["]c"] = "@class.outer",        -- 跳转到下一个类开始
                        ["]a"] = "@parameter.inner",    -- 跳转到下一个参数
                    },
                    goto_next_end = {
                        ["]F"] = "@function.outer",     -- 跳转到下一个函数结束
                        ["]C"] = "@class.outer",        -- 跳转到下一个类结束
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",     -- 跳转到上一个函数开始
                        ["[c"] = "@class.outer",        -- 跳转到上一个类开始
                        ["[a"] = "@parameter.inner",    -- 跳转到上一个参数
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",     -- 跳转到上一个函数结束
                        ["[C"] = "@class.outer",        -- 跳转到上一个类结束
                    },
                },
                
                -- 交换文本对象
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>sa"] = "@parameter.inner", -- 与下一个参数交换
                        ["<leader>sf"] = "@function.outer",  -- 与下一个函数交换
                    },
                    swap_previous = {
                        ["<leader>sA"] = "@parameter.inner", -- 与上一个参数交换
                        ["<leader>sF"] = "@function.outer",  -- 与上一个函数交换
                    },
                },
            },
        })
        
        -- ========== C/C++ 特定配置 ==========
        -- 设置 C/C++ 文件的折叠方法为 treesitter
        vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
            pattern = {"*.c", "*.cpp", "*.h", "*.hpp", "*.cc", "*.cxx"},
            callback = function()
                vim.opt_local.foldmethod = "expr"
                vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
                vim.opt_local.foldenable = false  -- 默认不折叠
            end,
        })
        
        -- ========== CMake 特定配置 ==========
        vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
            pattern = {"CMakeLists.txt", "*.cmake"},
            callback = function()
                vim.opt_local.foldmethod = "expr"
                vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
                vim.opt_local.foldenable = false
            end,
        })
    end,
}