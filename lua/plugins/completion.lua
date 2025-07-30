-- ==================== 自动补全插件系统 ====================

return {
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
        require("luasnip.loaders.from_vscode").lazy_load()
        
        -- 配置自动补全行为
        cmp.setup({
            -- ========== 代码片段配置 ==========
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            
            -- ========== 补全窗口样式 ==========
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            
            -- ========== 按键映射配置 ==========
            mapping = cmp.mapping.preset.insert({
                -- 上下选择补全项
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-j>"] = cmp.mapping.select_next_item(),
                
                -- 滚动文档预览
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                
                -- 补全控制
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                
                -- 确认补全
                ["<CR>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                }),
                
                -- Tab键智能行为
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                
                -- Shift+Tab反向操作
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            
            -- ========== 补全来源配置 ==========
            sources = cmp.config.sources({
                { name = "nvim_lsp" },    -- LSP服务器补全
                { name = "luasnip" },     -- 代码片段补全
            }, {
                { name = "buffer" },      -- 当前文件内容补全
                { name = "path" },        -- 文件路径补全
            }),
            
            -- ========== 补全项格式化 ==========
            formatting = {
                format = function(entry, vim_item)
                    vim_item.menu = ({
                        nvim_lsp = "[LSP]",
                        luasnip = "[Snippet]",
                        buffer = "[Buffer]",
                        path = "[Path]",
                    })[entry.source.name]
                    
                    return vim_item
                end,
            },
            
            -- ========== 实验性功能 ==========
            experimental = {
                ghost_text = true,
            },
        })
        
        -- ========== 命令行补全配置 ==========
        -- 搜索模式补全
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" }
            }
        })
        
        -- 命令模式补全
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" }
            }, {
                { name = "cmdline" }
            })
        })
    end,
}
