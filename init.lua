vim.g.mapleader = " "  -- 设置leader为空格
vim.g.maplocalleader = " "  -- 设置本地leader为空格


require("options")
require("keymaps")

-- 自动安装 lazy.nvim 插件管理器
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- vim.fn.stdpath("data") 获取 Neovim 数据目录路径
-- 完整路径类似：~/.local/share/nvim/lazy/lazy.nvim

if not vim.loop.fs_stat(lazy_path) then 
    -- 如果 lazy.nvim 不存在，就自动下载安装
    print("正在安装 lazy.nvim...")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",          -- 只克隆必要的文件，加快速度
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",             -- 使用稳定版本
        lazypath,
    })
    print("lazy.nvim 安装完成！")
end

-- 将 lazy.nvim 添加到运行时路径
vim.opt.rtp:prepend(lazy_path)
-- rtp 是 runtimepath 的缩写，告诉 Neovim 在哪里找插件

print("配置加载完成，lazy.nvim 已就绪！")

-- Plugins需要在Lazy之后加载不然会找不到Lazy
require("plugins")
