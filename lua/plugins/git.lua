-- lua/plugins/git.lua (新建文件)
return {
    -- Git状态显示和行级操作
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = '│' },
                    change       = { text = '│' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked    = { text = '┆' },
                },
                signcolumn = true,
                numhl      = false,
                linehl     = false,
                word_diff  = false,
                watch_gitdir = {
                    follow_files = true
                },
                attach_to_untracked = true,
                current_line_blame = false,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol',
                    delay = 1000,
                    ignore_whitespace = false,
                },
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil,
                max_file_length = 40000,
                preview_config = {
                    border = 'single',
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1
                },
            })
            
            -- Gitsigns 快捷键（行级Git操作）
            vim.keymap.set("n", "<leader>hp", ":Gitsigns preview_hunk<CR>", { desc = "预览Git变更" })
            vim.keymap.set("n", "<leader>hb", ":Gitsigns toggle_current_line_blame<CR>", { desc = "切换Git blame" })
            vim.keymap.set("n", "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "暂存当前hunk" })
            vim.keymap.set("n", "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "重置当前hunk" })
            vim.keymap.set("n", "<leader>hu", ":Gitsigns undo_stage_hunk<CR>", { desc = "撤销暂存hunk" })
            vim.keymap.set("v", "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "暂存选中区域" })
            vim.keymap.set("v", "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "重置选中区域" })
            
            -- 导航Git变更
            vim.keymap.set("n", "]h", ":Gitsigns next_hunk<CR>", { desc = "下一个Git变更" })
            vim.keymap.set("n", "[h", ":Gitsigns prev_hunk<CR>", { desc = "上一个Git变更" })
        end,
    },

    -- Git命令行集成
    {
        "tpope/vim-fugitive",
        config = function()
            -- 基本Git操作
            vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Git状态" })
            vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit<CR>", { desc = "Git diff" })
            vim.keymap.set("n", "<leader>gl", ":Git log --oneline<CR>", { desc = "Git log" })
            
            -- Git工作流快捷键
            vim.keymap.set("n", "<leader>ga", ":Git add .<CR>", { desc = "Git add 所有文件" })
            vim.keymap.set("n", "<leader>gA", ":Git add %<CR>", { desc = "Git add 当前文件" })
            vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git commit" })
            vim.keymap.set("n", "<leader>gC", ":Git commit -m '", { desc = "Git commit -m" })
            vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Git push" })
            vim.keymap.set("n", "<leader>gP", ":Git pull<CR>", { desc = "Git pull" })
            vim.keymap.set("n", "<leader>gf", ":Git fetch<CR>", { desc = "Git fetch" })
            
            -- 分支操作
            vim.keymap.set("n", "<leader>gb", ":Git branch<CR>", { desc = "查看分支" })
            vim.keymap.set("n", "<leader>gB", ":Git checkout -b ", { desc = "创建新分支" })
            vim.keymap.set("n", "<leader>go", ":Git checkout ", { desc = "切换分支" })
            
            -- 撤销操作
            vim.keymap.set("n", "<leader>gr", ":Git reset<CR>", { desc = "Git reset" })
            vim.keymap.set("n", "<leader>gR", ":Git reset --hard<CR>", { desc = "Git reset --hard" })
        end,
    },

    -- Git UI - 更现代的Git界面
    {
        "kdheepak/lazygit.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "打开LazyGit" })
        end,
    },

    -- Git差异对比增强
    {
        "sindrets/diffview.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            require("diffview").setup({
                diff_binaries = false,
                enhanced_diff_hl = false,
                git_cmd = { "git" },
                use_icons = true,
            })
            
            vim.keymap.set("n", "<leader>gv", ":DiffviewOpen<CR>", { desc = "打开Diff视图" })
            vim.keymap.set("n", "<leader>gV", ":DiffviewClose<CR>", { desc = "关闭Diff视图" })
            vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory<CR>", { desc = "文件Git历史" })
            vim.keymap.set("n", "<leader>gH", ":DiffviewFileHistory %<CR>", { desc = "当前文件Git历史" })
        end,
    },

    -- Git冲突解决助手
    {
        "akinsho/git-conflict.nvim",
        version = "*",
        config = function()
            require("git-conflict").setup({
                default_mappings = true,
                default_commands = true,
                disable_diagnostics = false,
                highlights = {
                    incoming = "DiffText",
                    current = "DiffAdd",
                }
            })
            
            -- 冲突解决快捷键
            vim.keymap.set("n", "<leader>co", "<Plug>(git-conflict-ours)", { desc = "选择我们的更改" })
            vim.keymap.set("n", "<leader>ct", "<Plug>(git-conflict-theirs)", { desc = "选择他们的更改" })
            vim.keymap.set("n", "<leader>cb", "<Plug>(git-conflict-both)", { desc = "保留双方更改" })
            vim.keymap.set("n", "<leader>c0", "<Plug>(git-conflict-none)", { desc = "删除双方更改" })
            vim.keymap.set("n", "]x", "<Plug>(git-conflict-next-conflict)", { desc = "下一个冲突" })
            vim.keymap.set("n", "[x", "<Plug>(git-conflict-prev-conflict)", { desc = "上一个冲突" })
        end,
    },
}
