-- ==================== 全局设置 ====================
-- 设置 leader 键为空格键
-- leader 键是一个前缀键，用于触发自定义快捷键组合
-- 例如：<leader>w 实际上就是 空格+w
vim.g.mapleader = " "  

-- 设置本地 leader 键为空格键  
-- 本地 leader 用于特定文件类型的快捷键
vim.g.maplocalleader = " "  

-- ==================== 加载配置模块 ====================
-- 加载基础选项配置文件 lua/options.lua
-- 这会设置行号、缩进、搜索等基础 Neovim 选项
require("options")

-- 加载快捷键配置文件 lua/keymaps.lua  
-- 这会设置所有的键盘映射和快捷键
require("keymaps")

-- ==================== 插件管理器安装 ====================
-- 获取 lazy.nvim 插件管理器的安装路径
-- stdpath("data") 返回 Neovim 的数据目录，通常是：
-- Linux/macOS: ~/.local/share/nvim
-- Windows: ~/AppData/Local/nvim-data
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 检查 lazy.nvim 是否已经安装
-- vim.loop.fs_stat() 检查文件/目录是否存在
if not vim.loop.fs_stat(lazy_path) then 
    -- 如果不存在，开始自动安装过程
    print("检测到 lazy.nvim 未安装，正在自动安装...")
    
    -- 使用 Git 克隆 lazy.nvim 仓库
    vim.fn.system({
        "git",                    -- 使用 git 命令
        "clone",                  -- 克隆操作
        "--filter=blob:none",     -- 只下载必要文件，减少下载量，提高速度
        "https://github.com/folke/lazy.nvim.git",  -- 源仓库地址
        "--branch=stable",        -- 使用稳定分支，避免开发版本的不稳定问题
        lazy_path,                -- 克隆到的目标路径 ✅ 修复：使用正确的变量名
    })
    print("lazy.nvim 安装完成！准备加载插件...")
end

-- ==================== 运行时路径配置 ====================
-- 将 lazy.nvim 添加到 Neovim 的运行时路径
-- rtp = runtimepath，告诉 Neovim 在哪些目录中寻找插件和脚本
-- prepend() 将路径添加到列表开头，确保优先级最高
vim.opt.rtp:prepend(lazy_path)

print("插件管理器配置完成，开始加载插件配置...")

-- ==================== 加载插件配置 ====================
-- 加载插件配置文件 lua/plugins.lua
-- 注意：这必须在 lazy.nvim 安装和路径配置之后
-- 因为 plugins.lua 中会调用 require("lazy")
require("plugins")

print("所有配置加载完成！Neovim 已就绪")
