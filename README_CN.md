[中文](.\README_CN.md) | [English](.\README.md)

# 📜 Add-VSCodeToContextMenu.bat

一键把 **“使用 VS Code 打开”** 添加到 Windows 资源管理器右键菜单，支持  
• 任意文件 • 任意文件夹 • 目录空白处 • Windows 10/11 库窗口背景

---

## ✨ 功能特点

- ✅ 自动检测 VS Code 安装路径  
- ✅ 仅对当前用户生效，无需管理员权限  
- ✅ 一键卸载，随时还原  
- ✅ 可手动指定 VS Code 启动路径  
- ✅ 支持管理员模式，实现系统级右键菜单（所有用户）

---

## 🚀 快速上手

1. 克隆或下载本仓库  
2. **双击** `Add-VSCodeToContextMenuCN.bat`  
   - 输入 `I` → 安装  
   - 输入 `U` → 卸载  
3. 脚本会自动重启资源管理器，右键菜单立即生效  
4. 若脚本未找到 VS Code，请手动设置路径，详见 [自定义 VS Code 路径](#?-自定义-vs-code-路径)

---

## 📂 默认搜索路径（优先级由高到低）

| 优先级 | 路径                                                                 |
| ------ | -------------------------------------------------------------------- |
| 1️⃣    | **脚本同目录**<br>`%SCRIPT_DIR%\Code.exe`                            |
| 2️⃣    | **用户安装目录**<br>`%LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe` |
| 3️⃣    | **64 位系统级安装**<br>`%ProgramFiles%\Microsoft VS Code\Code.exe`   |
| 4️⃣    | **32 位系统级安装**<br>`%ProgramFiles(x86)%\Microsoft VS Code\Code.exe` |

若以上路径均未找到 `Code.exe`，脚本会提示您手动指定路径后重试。

## ⚙️ 自定义 VS Code 路径

当 VS Code 不在默认位置时，打开脚本并在第 15 行填写完整路径：

```bat
set "CodePath=C:\你的\路径\Code.exe"
```

## 🌐 全局安装（所有用户）

1. 把第 55 行
   ```bat
   set "ROOT=HKCU\Software\Classes"
   ```
   修改为
   ```bat
   set "ROOT=HKCR"
   ```
2. 以**管理员身份**运行脚本

## 📄 写入的注册表位置

| 右键场景      | 注册表键路径                                  |
| --------- | --------------------------------------- |
| 任意文件      | `*\shell\VSCode`                        |
| 文件夹       | `Directory\shell\VSCode`                |
| 目录空白处/磁盘根 | `Directory\Background\shell\VSCode`     |
| 库窗口背景     | `LibraryFolder\Background\shell\VSCode` |

## 🔧 常见问题

| 问题               | 解决方法                                     |
| ---------------- | ---------------------------------------- |
| **找不到 VS Code？** | 编辑脚本内的 `CodePath` 或把 `Code.exe` 放到脚本同目录。 |
| **菜单未出现？**       | 重新运行脚本输入 `I` 或手动重启资源管理器。                 |
| **需要管理员权限？**     | 仅在改为 `ROOT=HKCR` 为所有用户安装时才需要管理员权限。       |
