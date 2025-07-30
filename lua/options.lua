local opt = vim.opt

-- 开启行号显示

opt.number = true
opt.relativenumber = true

-- 缩进相关
opt.tabstop = 4    -- tab为几个空格
opt.shiftwidth = 4     -- 自动锁紧的时候的tab长度
opt.expandtab = true     -- 防止tab输入为制表符

-- 搜索
opt.ignorecase = true   -- 忽略大小写
opt.smartcase = true    -- 如果搜索词包含大小写则区分大小写

opt.mouse = "a" -- 启用鼠标


