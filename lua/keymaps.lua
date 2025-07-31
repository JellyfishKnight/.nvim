-- ==================== 快捷键配置模块 ====================
-- 创建 vim.keymap.set 的局部引用，简化后续代码
-- keymap 函数用于设置键盘映射：keymap(模式, 按键, 命令, 选项)
local keymap = vim.keymap.set

-- ==================== 基础移动改进 ====================
-- 改进 j/k 键的行为，让它们按显示行而不是实际行移动
-- 当一行很长被折行显示时，j/k 会在同一逻辑行内移动
-- gj/gk 则按显示行移动，这在编辑长段落时更符合直觉

keymap("n", "j", "gj", { desc = "向下移动（按显示行）" })
-- "n" = 普通模式，"j" = 触发键，"gj" = 实际执行的命令
-- desc = 描述，会在 which-key 等插件中显示

keymap("n", "k", "gk", { desc = "向上移动（按显示行）" })

-- ==================== 窗口导航快捷键 ====================
-- 使用 Ctrl+hjkl 在窗口间快速切换，比默认的 Ctrl+w h 更方便
-- 这些快捷键在分屏工作时非常有用

keymap("n", "<C-h>", "<C-w>h", { desc = "切换到左侧窗口" })
-- <C-h> = Ctrl+h，<C-w>h = Ctrl+w 然后 h（Vim 原生窗口切换命令）

keymap("n", "<C-j>", "<C-w>j", { desc = "切换到下方窗口" })
keymap("n", "<C-k>", "<C-w>k", { desc = "切换到上方窗口" })
keymap("n", "<C-l>", "<C-w>l", { desc = "切换到右侧窗口" })

-- ==================== 窗口大小调整 ====================
-- 使用 Ctrl+方向键快速调整窗口大小
-- 在分屏时可以方便地调整各个窗口的尺寸

keymap("n", "<C-Up>", ":resize +2<CR>", { desc = "增加窗口高度" })
-- :resize +2 = 增加2行高度，<CR> = 回车键执行命令

keymap("n", "<C-Down>", ":resize -2<CR>", { desc = "减少窗口高度" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "减少窗口宽度" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "增加窗口宽度" })
-- ==================== 缓冲区（文件）导航 ====================
-- 使用 Shift+h/l 在打开的文件间切换
-- 比使用 :bnext 和 :bprevious 命令更快捷

keymap("n", "<S-l>", ":bnext<CR>", { desc = "切换到下一个缓冲区" })
-- <S-l> = Shift+l，:bnext = 下一个缓冲区

keymap("n", "<S-h>", ":bprevious<CR>", { desc = "切换到上一个缓冲区" })

-- ==================== 可视模式缩进增强 ====================
-- 在可视模式下缩进后保持选择状态，方便多次缩进操作
-- 默认情况下，缩进后会退出可视模式，需要重新选择

keymap("v", "<", "<gv", { desc = "向左缩进并保持选择" })
-- "v" = 可视模式，"<" = 向左缩进，"gv" = 重新选择上次的可视选择

keymap("v", ">", ">gv", { desc = "向右缩进并保持选择" })

-- ==================== Tab键缩进功能 ====================
-- 使用Tab和Shift+Tab进行缩进操作，更符合IDE使用习惯

-- 可视模式下使用Tab进行缩进（针对选中的所有行）
keymap("v", "<Tab>", ">gv", { desc = "Tab键对选中行向右缩进并保持选择" })
keymap("v", "<S-Tab>", "<gv", { desc = "Shift+Tab对选中行向左缩进并保持选择" })

-- 插入模式下的Tab行为（保持默认Tab功能，但添加Shift+Tab反缩进）
keymap("i", "<S-Tab>", "<C-d>", { desc = "插入模式下Shift+Tab反缩进" })

-- 普通模式下的Tab缩进（针对当前行）
keymap("n", "<Tab>", ">>", { desc = "普通模式Tab向右缩进当前行" })
keymap("n", "<S-Tab>", "<<", { desc = "普通模式Shift+Tab向左缩进当前行" })

-- ==================== 移动选中文本 ====================
-- 在可视模式下移动整个选中的文本块
-- 这在重新组织代码时非常有用

keymap("v", "J", ":move '>+1<CR>gv-gv", { desc = "向下移动选中文本" })
-- :move '>+1 = 移动到选择区域末尾的下一行
-- gv-gv = 重新选择并调整选择区域

keymap("v", "K", ":move '<-2<CR>gv-gv", { desc = "向上移动选中文本" })

-- ==================== 文件操作快捷键 ====================
-- 使用 leader 键组合快速执行常用文件操作

keymap("n", "<leader>w", ":w<CR>", { desc = "保存当前文件" })
-- <leader>w = 空格+w，:w = 保存文件

keymap("n", "<leader>W", ":wa<CR>", { desc = "保存所有文件" })
-- :wa = 保存所有已修改的文件

keymap("n", "<leader>q", ":q<CR>", { desc = "退出当前窗口" })
-- :q = 退出当前窗口

keymap("n", "<leader>Q", ":qa!<CR>", { desc = "强制退出所有窗口" })
-- :qa! = 强制退出所有窗口，不保存更改

-- ==================== 搜索和显示控制 ====================
-- 清除搜索高亮，当你不再需要看到搜索结果的高亮时使用

keymap("n", "<leader>h", ":nohlsearch<CR>", { desc = "清除搜索高亮" })
-- :nohlsearch = 清除当前的搜索高亮

-- ==================== 插入模式下的移动 ====================
-- 在插入模式下不用切换到普通模式就能移动光标
-- 对于小幅度的光标调整很有用

keymap("i", "<C-h>", "<Left>", { desc = "插入模式：光标左移" })
keymap("i", "<C-j>", "<Down>", { desc = "插入模式：光标下移" })
keymap("i", "<C-k>", "<Up>", { desc = "插入模式：光标上移" })
keymap("i", "<C-l>", "<Right>", { desc = "插入模式：光标右移" })

-- ==================== 快速编辑配置文件 ====================
-- 快速打开和重新加载 Neovim 配置文件

keymap("n", "<leader>ev", ":edit $MYVIMRC<CR>", { desc = "编辑 Neovim 配置" })
-- $MYVIMRC = Neovim 配置文件路径的环境变量

keymap("n", "<leader>sv", ":source $MYVIMRC<CR>", { desc = "重新加载配置" })
-- :source = 重新加载配置文件

-- ==================== 更好的粘贴体验 ====================
-- 在可视模式下粘贴时不会把被替换的内容放入剪贴板
-- 这样可以连续粘贴同一内容到多个位置

keymap("x", "<leader>p", [["_dP]], { desc = "粘贴但不影响剪贴板" })
-- "x" = 可视块模式，"_d = 删除到黑洞寄存器，P = 粘贴到光标前

-- ==================== 分屏操作快捷键 ====================
-- 快速分屏操作，提高多文件编辑效率

keymap("n", "<leader>sv", ":vsplit<CR>", { desc = "垂直分屏" })
-- 垂直分屏：左右分割窗口

keymap("n", "<leader>sh", ":split<CR>", { desc = "水平分屏" })
-- 水平分屏：上下分割窗口

keymap("n", "<leader>se", "<C-w>=", { desc = "平衡分屏大小" })
-- 让所有分屏窗口大小相等

keymap("n", "<leader>sx", ":close<CR>", { desc = "关闭当前分屏" })
-- 关闭当前分屏窗口

-- ==================== Cargo 操作快捷键 ====================
-- Rust项目常用的cargo命令快捷键

keymap("n", "cargobuild", ":!cargo build<CR>", { desc = "Cargo 构建项目" })
-- 编译当前Rust项目

keymap("n", "crgorun", ":!cargo run<CR>", { desc = "Cargo 运行项目" })
-- 运行当前Rust项目

keymap("n", "cargotest", ":!cargo test<CR>", { desc = "Cargo 运行测试" })
-- 运行项目测试

keymap("n", "cargocheck", ":!cargo check<CR>", { desc = "Cargo 检查代码" })
-- 快速检查代码，不生成可执行文件

keymap("n", "cargofmt", ":!cargo fmt<CR>", { desc = "Cargo 格式化代码" })
-- 格式化Rust代码

keymap("n", "cargoclippy", ":!cargo clippy<CR>", { desc = "Cargo 代码检查" })
-- 使用clippy进行代码质量检查

keymap("n", "cargoupdate", ":!cargo update<CR>", { desc = "Cargo 更新依赖" })
-- 更新项目依赖

keymap("n", "cargodoc", ":!cargo doc --open<CR>", { desc = "Cargo 生成并打开文档" })
-- 生成文档并在浏览器中打开

-- ==================== 行操作快捷键 ====================
-- 快速操作整行

keymap("n", "<leader>d", "dd", { desc = "删除当前行" })
keymap("n", "<leader>D", "VD", { desc = "删除当前行（可视模式）" })

-- 在当前行上方/下方插入空行
keymap("n", "<leader>o", "o<Esc>", { desc = "在下方插入空行" })
keymap("n", "<leader>O", "O<Esc>", { desc = "在上方插入空行" })

-- ==================== 注释说明 ====================
-- 以上快捷键的设计原则：
-- 1. 使用熟悉的 Vim 动作键（hjkl）
-- 2. leader 键用于不常用但有用的功能
-- 3. Ctrl 键用于快速导航和窗口操作
-- 4. Shift 键用于变体操作（如 Shift+h/l 切换缓冲区）
-- 5. 保持与 Vim 原生快捷键的一致性
-- 6. 每个映射都有描述，方便记忆和调试



