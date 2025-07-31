-- ==================== LSP配置系统 ====================

return {
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
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                },
            },
        })
        
        -- ========== 自动安装LSP服务器 ==========
        mason_lspconfig.setup({
            ensure_installed = {
                "rust_analyzer",    -- Rust语言服务器
                "lua_ls",          -- Lua语言服务器
                "pyright",         -- Python语言服务器
                "ts_ls",        -- TypeScript/JavaScript语言服务器
            },
            automatic_installation = true,
        })

        -- ========== LSP快捷键配置函数 ==========
        local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, silent = true }
            
            -- 代码导航快捷键
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            
            -- 文档和帮助
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
            
            -- 代码编辑操作
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "<leader>f", function()
                vim.lsp.buf.format({ async = true })
            end, opts)
            
            -- 快速修复功能 (类似VSCode)
            vim.keymap.set("n", "<leader>qf", function()
                vim.lsp.buf.code_action({
                    filter = function(action)
                        return action.kind and (
                            action.kind:match("quickfix") or 
                            action.kind:match("source.fixAll") or
                            action.kind:match("refactor.rewrite")
                        )
                    end,
                    apply = true,
                })
            end, opts)
            
            -- 自动修复当前行的问题
            vim.keymap.set("n", "<leader>af", function()
                local line = vim.api.nvim_win_get_cursor(0)[1]
                local diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })
                if #diagnostics > 0 then
                    vim.lsp.buf.code_action({
                        context = { diagnostics = diagnostics },
                        filter = function(action)
                            return action.kind and action.kind:match("quickfix")
                        end,
                        apply = true,
                    })
                else
                    vim.notify("当前行没有可修复的问题", vim.log.levels.INFO)
                end
            end, opts)
            
            -- 修复所有可自动修复的问题
            vim.keymap.set("n", "<leader>fa", function()
                vim.lsp.buf.code_action({
                    context = { only = { "source.fixAll" } },
                    apply = true,
                })
            end, opts)
            
            -- 诊断信息导航和快速修复
            vim.keymap.set("n", "[d", function()
                vim.diagnostic.goto_prev()
                -- 自动显示诊断信息
                vim.defer_fn(function()
                    vim.diagnostic.open_float(nil, { focus = false })
                end, 100)
            end, opts)
            
            vim.keymap.set("n", "]d", function()
                vim.diagnostic.goto_next()
                -- 自动显示诊断信息
                vim.defer_fn(function()
                    vim.diagnostic.open_float(nil, { focus = false })
                end, 100)
            end, opts)
            
            vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
            vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
        end

        -- ========== 诊断信息显示配置 ==========
        vim.diagnostic.config({
            virtual_text = {
                prefix = "●",
                spacing = 4,
                severity = { min = vim.diagnostic.severity.HINT },
            },
            signs = {
                active = true,
                values = {
                    { name = "DiagnosticSignError", text = "" },
                    { name = "DiagnosticSignWarn", text = "" },
                    { name = "DiagnosticSignHint", text = "" },
                    { name = "DiagnosticSignInfo", text = "" },
                }
            },
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                focusable = true,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
                format = function(diagnostic)
                    local code = diagnostic.code or diagnostic.user_data and diagnostic.user_data.lsp.code
                    if code then
                        return string.format("%s [%s]", diagnostic.message, code)
                    end
                    return diagnostic.message
                end,
            },
        })

        -- ========== 诊断符号配置 ==========
        local signs = { 
            Error = " ",
            Warn = " ",
            Hint = " ",
            Info = " "
        }
        
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { 
                text = icon,
                texthl = hl,
                numhl = ""
            })
        end

        -- ========== LSP服务器能力配置 ==========
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        
        -- ========== 自动修复功能设置 ==========
        -- 为 rust-analyzer 添加特殊的自动修复功能
        vim.api.nvim_create_autocmd("CursorHold", {
            pattern = "*.rs",
            callback = function()
                -- 显示诊断信息的浮动窗口
                for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
                    if vim.api.nvim_win_get_config(winid).zindex then
                        return
                    end
                end
                vim.diagnostic.open_float(nil, {
                    focusable = false,
                    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                    border = 'rounded',
                    source = 'always',
                    prefix = ' ',
                    scope = 'cursor',
                })
            end
        })
        
        -- 保存时自动应用可用的修复
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.rs",
            callback = function()
                -- 应用所有可用的修复
                vim.lsp.buf.code_action({
                    context = { only = { "source.fixAll" } },
                    apply = true,
                })
            end
        })

        -- ========== 各语言服务器配置 ==========
        
        -- Rust Analyzer配置
        lspconfig.rust_analyzer.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                ["rust-analyzer"] = {
                    cargo = {
                        allFeatures = true,
                        loadOutDirsFromCheck = true,
                        runBuildScripts = true,
                    },
                    checkOnSave = true,
                    check = {
                        command = "clippy",
                        extraArgs = { "--no-deps" },
                        allFeatures = true,
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
                    -- 自动导入配置
                    imports = {
                        granularity = {
                            group = "module",
                        },
                        prefix = "self",
                    },
                    -- 补全配置
                    completion = {
                        addCallArgumentSnippets = true,
                        addCallParenthesis = true,
                        postfix = {
                            enable = true,
                        },
                        autoimport = {
                            enable = true,
                        },
                    },
                },
            },
        })

        -- Lua语言服务器配置
        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                Lua = {
                    runtime = { 
                        version = "LuaJIT"
                    },
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                    telemetry = { 
                        enable = false
                    }
                },
            },
        })
        
        -- Python语言服务器配置
        lspconfig.pyright.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        diagnosticMode = "workspace",
                        useLibraryCodeForTypes = true
                    }
                }
            }
        })
        
        -- TypeScript/JavaScript服务器配置
        lspconfig.ts_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })
    end
}
