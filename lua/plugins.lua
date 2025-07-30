require("lazy").setup({
    -- 主题插件
    {
        "catppuccin/nvim",              -- 插件的 GitHub 地址
        name = "catppuccin",            -- 给插件起个名字
        priority = 1000,                -- 优先级：1000 表示最先加载
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                backgroud = {
                    light = "latte",
                    dark = "mocha",
                },
                transparent_background = false,  -- 透明背景
                show_end_of_buffer = false,     -- 显示缓冲区结束标记
                term_colors = false,            -- 终端颜色
                dim_inactive = {
                    enabled = false,              -- 淡化非活动窗口
                    shade = "dark",
                    percentage = 0.15,
                },
                styles = {
                    comments = { "italic" },
                    conditionals = { "italic" },
                },
                integrations = {
                    cmp = true,                   -- nvim-cmp 集成,
                    gitsigns = true,              -- gitsigns 集成,
                    nvimtree = true,              -- nvim-tree 集成,
                    telescope = true,             -- telescope 集成,
                    notify = false,
                    mini = false,
                }
            })
            -- 应用主题
            vim.cmd.colorscheme("catppuccin")
        end,
    },
    -- 文件图标
    {
        "nvim-tree/nvim-web-devicons",  -- 文件图标插件
        config = function()
            require("nvim-web-devicons").setup()  -- 初始化插件
        end,
    },
    -- 状态栏
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { 
            "nvim-tree/nvim-web-devicons" -- 这个插件依赖图标插件
        },
        config = function()
            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = "catppuccin",         -- 使用 catppuccin 主题
                    component_separators = { left = "", right = ""},
                    section_separators = { left = "", right = ""},
                    disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = false,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                }
            },
            sections = {
                lualine_a = {"mode"},         -- 显示当前模式
                lualine_b = {"branch", "diff", "diagnostics"}, -- Git 分支、差异、诊断
                lualine_c = {"filename"},     -- 文件名
                lualine_x = {"encoding", "fileformat", "filetype"}, -- 编码、格式、类型
                lualine_y = {"progress"},     -- 进度
                lualine_z = {"location"}      -- 位置
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {"filename"},
                lualine_x = {"location"},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {}
        })
        end,
    },
    -- LSP配置
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",              -- LSP服务器管理器
            "williamboman/mason-lspconfig.nvim",    -- Mason和lspconfig的Bridge
            "hrsh7th/cmp-nvim-lsp",                 -- LSP和自动补全的集成
        },
        config = function() 
            local lspconfig = require("lspconfig")
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")
            -- 配置Mason(LSP管理器)
            mason.setup({
                ui = {
                    border = "rounded",   --圆角边框
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜", 
                        package_uninstalled = "✗"
                    },
                },
            })
            -- 配置要安装的LSP服务器
            mason_lspconfig.setup({
                ensure_installed = {
                    "rust_analyzer",
                    "lua_ls",
                    "pyright",
                    "tsserver",
                },
                automatic_installation = true,  -- 自动安装
            })

            -- LSP 服务器连接时的按键绑定
            local on_attach = function(client, bufnr)
            -- bufnr 是当前缓冲区编号，opts 确保快捷键只在当前缓冲区生效
                local opts = { buffer = bufnr, silent = true }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                -- gd = go to definition，跳转到定义
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                -- gD = go to declaration，跳转到声明
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                -- gi = go to implementation，跳转到实现
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                -- gr = go to references，查找所有引用
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                -- K = 显示悬浮文档（查看函数/变量信息）
                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
                -- Ctrl+k = 显示函数签名帮助
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                -- 空格+rn = rename，重命名变量/函数
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                -- 空格+ca = code action，显示可用的代码操作
                vim.keymap.set("n", "<leader>f", function()
                    vim.lsp.buf.format({ async = true })
                end, opts)
                -- 空格+f = format，格式化代码
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                -- [d = 跳转到上一个诊断信息
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                -- ]d = 跳转到下一个诊断信息
                vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
                -- 空格+q = 打开诊断列表
            end

            -- 配置诊断显示
            vim.diagnostic.config({
                virtual_text = {
                    prefix = "●"
                },
                signs = true,              -- 在标志列显示诊断标记
                underline = true,          -- 下划线标记
                update_in_insert = false,  -- 插入模式下不更新诊断     
                severity_sort = true,
            })

            -- 配置诊断标记符号
            local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            -- LSP 服务器的通用配置
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            -- 这行告诉 LSP 服务器我们支持哪些补全功能
            -- 配置 Rust Analyzer
            lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,      -- 启用所有 Cargo features
                            loadOutDirsFromCheck = true,    -- 从 check 加载输出目录
                            runBuildScripts = true,  -- 运行构建脚本
                        },
                        checkOnSave = {
                            allFeatures = true,
                            command = "clippy",
                            extraArgs = { "--no-deps" }
                        },
                        procMacro = {
                            enable = true,
                            ignored = {
                                leptos_macro = {
                                    "component",
                                    "server",
                                },
                            },
                        },
                    },
                },
            })

            -- 配置 Lua 语言服务器（用于 Neovim 配置）
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = {
                            global = { "vim" }, -- 识别 vim 全局变量
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        telemetry = { enable = false }
                    },
                },
            })
        end
    },
}, {
    ui = {
        border = "rounded",
    },
    rocks = {
        enabled = false,
    },
})
