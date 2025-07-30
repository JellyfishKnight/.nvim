-- ==================== 插件配置模块 ====================
-- 这个文件定义了所有要安装和配置的插件
-- lazy.nvim 会根据这个配置自动下载、安装和加载插件

require("lazy").setup({
    
    -- ==================== 主题插件配置 ====================
    {
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
    },

    -- ==================== 文件图标插件 ====================
    {
        -- 提供文件类型图标的插件
        -- 这些图标会在文件管理器、状态栏、标签页等地方显示
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
                    -- 可以添加更多自定义图标
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

    -- ==================== 自动补全插件系统 ====================
    {
        -- 核心自动补全引擎
        "hrsh7th/nvim-cmp",
        
        -- 补全插件的依赖项
        dependencies = {
            "hrsh7th/cmp-buffer",        -- 从当前缓冲区内容补全
            "hrsh7th/cmp-path",          -- 文件路径补全
            "hrsh7th/cmp-nvim-lsp",      -- 从LSP服务器获取补全
            "hrsh7th/cmp-cmdline",       -- 命令行模式补全
            "L3MON4D3/LuaSnip",          -- 代码片段引擎
            "saadparwaiz1/cmp_luasnip",  -- LuaSnip与cmp的集成
            "rafamadriz/friendly-snippets", -- 预制代码片段库
        },
        
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            
            -- 加载VS Code风格的代码片段
            -- 这会从friendly-snippets插件加载各种语言的代码片段
            require("luasnip.loaders.from_vscode").lazy_load()
            
            -- 配置自动补全行为
            cmp.setup({
                -- ========== 代码片段配置 ==========
                snippet = {
                    -- 定义如何展开代码片段
                    expand = function(args)
                        -- 使用LuaSnip引擎展开代码片段
                        luasnip.lsp_expand(args.body)
                    end,
                },
                
                -- ========== 补全窗口样式 ==========
                window = {
                    -- 补全列表窗口：添加圆角边框
                    completion = cmp.config.window.bordered(),
                    -- 文档预览窗口：添加圆角边框
                    documentation = cmp.config.window.bordered(),
                },
                
                -- ========== 按键映射配置 ==========
                mapping = cmp.mapping.preset.insert({
                    -- 上下选择补全项
                    ["<C-k>"] = cmp.mapping.select_prev_item(),  -- Ctrl+k：上一个
                    ["<C-j>"] = cmp.mapping.select_next_item(),  -- Ctrl+j：下一个
                    
                    -- 滚动文档预览
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),     -- Ctrl+b：文档向上滚动
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),      -- Ctrl+f：文档向下滚动
                    
                    -- 补全控制
                    ["<C-Space>"] = cmp.mapping.complete(),      -- Ctrl+空格：手动触发补全
                    ["<C-e>"] = cmp.mapping.abort(),             -- Ctrl+e：取消补全
                    
                    -- 确认补全
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,  -- 替换现有文本
                        select = false,                          -- 不自动选择第一项
                    }),
                    
                    -- Tab键智能行为
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            -- 如果补全菜单可见，选择下一项
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            -- 如果可以展开代码片段或跳转到下一个占位符
                            luasnip.expand_or_jump()
                        else
                            -- 否则执行默认Tab行为（插入制表符或空格）
                            fallback()
                        end
                    end, { "i", "s" }),  -- 在insert和select模式下生效
                    
                    -- Shift+Tab反向操作
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            -- 选择上一个补全项
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            -- 跳转到上一个代码片段占位符
                            luasnip.jump(-1)
                        else
                            -- 默认行为
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                
                -- ========== 补全来源配置 ==========
                -- 按优先级排序，上面的优先级更高
                sources = cmp.config.sources({
                    -- 第一优先级组
                    { name = "nvim_lsp" },    -- LSP服务器补全（函数、变量、类型等）
                    { name = "luasnip" },     -- 代码片段补全
                }, {
                    -- 第二优先级组（当第一组没有结果时才使用）
                    { name = "buffer" },      -- 当前文件内容补全
                    { name = "path" },        -- 文件路径补全
                }),
                
                -- ========== 补全项格式化 ==========
                formatting = {
                    format = function(entry, vim_item)
                        -- 为每个补全项添加来源标签
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",      -- 来自语言服务器
                            luasnip = "[Snippet]",   -- 来自代码片段
                            buffer = "[Buffer]",     -- 来自当前文件
                            path = "[Path]",         -- 来自文件路径
                        })[entry.source.name]
                        
                        return vim_item
                    end,
                },
                
                -- ========== 实验性功能 ==========
                experimental = {
                    ghost_text = true,  -- 禁用幽灵文本（预览补全结果）
                },
            })
            
            -- ========== 命令行补全配置 ==========
            -- 搜索模式补全（/ 和 ? 命令）
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),  -- 使用命令行预设按键
                sources = {
                    { name = "buffer" }  -- 从当前缓冲区补全搜索词
                }
            })
            
            -- 命令模式补全（: 命令）
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" }     -- 文件路径补全
                }, {
                    { name = "cmdline" }  -- Vim命令补全
                })
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

    -- ==================== LSP配置系统 ====================
    {
        -- Neovim内置LSP客户端的配置插件
        "neovim/nvim-lspconfig",
        
        -- 懒加载：只有在读取或创建文件时才加载
        event = { "BufReadPre", "BufNewFile" },
        
        -- LSP相关依赖
        dependencies = {
            "williamboman/mason.nvim",              -- LSP服务器管理器
            "williamboman/mason-lspconfig.nvim",    -- Mason与lspconfig的桥梁
            "hrsh7th/cmp-nvim-lsp",                 -- LSP与补全系统的集成
        },
        
        config = function() 
            -- 导入必需的模块
            local lspconfig = require("lspconfig")
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")
            
            -- ========== Mason LSP管理器配置 ==========
            mason.setup({
                ui = {
                    border = "rounded",               -- 界面使用圆角边框
                    icons = {
                        package_installed = "✓",     -- 已安装图标
                        package_pending = "➜",       -- 安装中图标
                        package_uninstalled = "✗"    -- 未安装图标
                    },
                },
            })
            
            -- ========== 自动安装LSP服务器 ==========
            mason_lspconfig.setup({
                -- 确保安装以下LSP服务器
                ensure_installed = {
                    "rust_analyzer",    -- Rust语言服务器
                    "lua_ls",          -- Lua语言服务器（用于Neovim配置）
                    "pyright",         -- Python语言服务器
                    "tsserver",        -- TypeScript/JavaScript语言服务器
                },
                automatic_installation = true,  -- 自动安装缺失的服务器
            })

            -- ========== LSP快捷键配置函数 ==========
            -- 当LSP服务器附加到缓冲区时执行的函数
            local on_attach = function(client, bufnr)
                -- 设置快捷键选项：只在当前缓冲区生效，静默执行
                local opts = { buffer = bufnr, silent = true }
                
                -- === 代码导航快捷键 ===
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                -- gd = go to definition：跳转到定义位置
                
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                -- gD = go to declaration：跳转到声明位置
                
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                -- gi = go to implementation：跳转到实现位置
                
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                -- gr = go to references：查找所有引用位置
                
                -- === 文档和帮助 ===
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                -- K = 显示悬浮文档（查看函数/变量详细信息）
                
                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
                -- Ctrl+k = 显示函数签名帮助
                
                -- === 代码编辑操作 ===
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                -- 空格+rn = rename：智能重命名变量/函数
                
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                -- 空格+ca = code action：显示可用的代码操作（修复、重构等）
                
                vim.keymap.set("n", "<leader>f", function()
                    vim.lsp.buf.format({ async = true })
                end, opts)
                -- 空格+f = format：格式化当前文件代码
                
                -- === 诊断信息导航 ===
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                -- [d = 跳转到上一个诊断信息（错误/警告）
                
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                -- ]d = 跳转到下一个诊断信息
                
                vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
                -- 空格+q = 在位置列表中显示所有诊断信息
            end

            -- ========== 诊断信息显示配置 ==========
            vim.diagnostic.config({
                -- 虚拟文本配置（行尾显示的错误信息）
                virtual_text = {
                    prefix = "●",           -- 诊断信息前缀符号
                },
                signs = true,               -- 在标志列显示诊断符号
                underline = true,           -- 在问题代码下显示下划线
                update_in_insert = false,   -- 插入模式下不更新诊断（避免干扰）
                severity_sort = true,       -- 按严重程度排序
            })

            -- ========== 诊断符号配置 ==========
            -- 自定义诊断级别的显示符号
            local signs = { 
                Error = " ",    -- 错误符号
                Warn = " ",     -- 警告符号
                Hint = " ",     -- 提示符号
                Info = " "      -- 信息符号
            }
            
            -- 注册诊断符号到Neovim
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { 
                    text = icon,        -- 显示的符号
                    texthl = hl,        -- 高亮组
                    numhl = ""          -- 行号高亮
                })
            end

            -- ========== LSP服务器能力配置 ==========
            -- 获取补全系统提供的LSP能力
            -- 这告诉LSP服务器我们的客户端支持哪些功能
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- ========== Rust Analyzer配置 ==========
            lspconfig.rust_analyzer.setup({
                capabilities = capabilities,    -- 使用增强的LSP能力
                on_attach = on_attach,         -- 附加快捷键配置
                settings = {
                    ["rust-analyzer"] = {
                        -- Cargo配置
                        cargo = {
                            allFeatures = true,             -- 启用所有Cargo特性
                            loadOutDirsFromCheck = true,    -- 从check加载输出目录
                            runBuildScripts = true,         -- 运行构建脚本
                        },
                        -- 保存时检查配置
                        checkOnSave = {
                            allFeatures = true,             -- 检查所有特性
                            command = "clippy",             -- 使用clippy而不是check
                            extraArgs = { "--no-deps" }     -- 不检查依赖项
                        },
                        -- 过程宏配置
                        procMacro = {
                            enable = true,                  -- 启用过程宏支持
                            ignored = {
                                -- 忽略特定宏（避免误报）
                                leptos_macro = {
                                    "component",
                                    "server",
                                },
                            },
                        },
                    },
                },
            })

            -- ========== Lua语言服务器配置 ==========
            -- 主要用于编辑Neovim配置文件
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        runtime = { 
                            version = "LuaJIT"              -- 使用LuaJIT版本
                        },
                        diagnostics = {
                            globals = { "vim" },            -- 识别vim全局变量
                        },
                        workspace = {
                            -- 让服务器知道Neovim运行时文件
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        telemetry = { 
                            enable = false                  -- 禁用遥测数据收集
                        }
                    },
                },
            })
            
            -- ========== Python语言服务器配置 ==========
            lspconfig.pyright.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,         -- 自动搜索Python路径
                            diagnosticMode = "workspace",   -- 工作区诊断模式
                            useLibraryCodeForTypes = true   -- 使用库代码进行类型推断
                        }
                    }
                }
            })
            
            -- ========== TypeScript/JavaScript服务器配置 ==========
            lspconfig.tsserver.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                -- TypeScript服务器通常使用默认设置即可
            })
        end
    },

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
