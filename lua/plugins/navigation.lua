-- lua/plugins/navigation.lua (新建文件)
return {
    -- 文件树管理器
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("nvim-tree").setup({
                sort_by = "case_sensitive",
                view = {
                    width = 30,
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = true,
                },
                on_attach = function(bufnr)
                    local api = require("nvim-tree.api")
                    local function opts(desc)
                        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                    end
                    -- 默认映射
                    api.config.mappings.default_on_attach(bufnr)
                    -- 自定义映射
                    vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
                end,
            })
            
            -- 快捷键
            vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "切换文件树" })
        end,
    },

    -- 模糊搜索神器
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-h>"] = "which_key"
                        }
                    }
                }
            })
            
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "查找文件" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "全文搜索" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "搜索缓冲区" })
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "搜索帮助" })
        end,
    },

    -- 快速跳转
    {
        "phaazon/hop.nvim",
        branch = "v2",
        config = function()
            require("hop").setup()
            vim.keymap.set("n", "<leader>j", ":HopWord<CR>", { desc = "跳转到单词" })
            vim.keymap.set("n", "<leader>l", ":HopLine<CR>", { desc = "跳转到行" })
        end,
    },
}
