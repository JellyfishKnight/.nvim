-- lua/plugins/editing.lua (新建文件)
return {
    -- 代码注释
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },

    -- 包围操作 (添加/删除/修改引号、括号等)
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup()
        end,
    },

    -- 自动配对括号
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup()
        end,
    },

    -- 多光标编辑
    {
        "mg979/vim-visual-multi",
        branch = "master",
    },

    -- 代码缩进线
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("ibl").setup()
        end,
    },

    -- 彩虹括号
    {
        "HiPhish/rainbow-delimiters.nvim",
        config = function()
            require("rainbow-delimiters.setup")
        end,
    },
}
