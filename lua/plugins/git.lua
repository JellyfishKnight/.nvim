-- lua/plugins/git.lua (新建文件)
return {
    -- Git状态显示
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
            
            -- Git快捷键
            vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "预览Git变更" })
            vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", { desc = "切换Git blame" })
        end,
    },

    -- Git集成
    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Git状态" })
            vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git commit" })
        end,
    },
}
