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
            vim.keymap.set("n", "<leader>f", function()
                vim.lsp.buf.format({ async = true })
            end, opts)
            
            -- 诊断信息导航
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
            vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
        end

        -- ========== 诊断信息显示配置 ==========
        vim.diagnostic.config({
            virtual_text = {
                prefix = "●",
            },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
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
        lspconfig.tsserver.setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })
    end
}
