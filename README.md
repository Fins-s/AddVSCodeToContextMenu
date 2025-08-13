
[中文](./README_CN.md) | [English](./README.md)

# 📜 Add-VSCodeToContextMenu.bat

A tiny Windows batch script that adds **"Open with VS Code"** to the right-click context menu for  
• any file • any folder • directory background • library background

---

## ✨ Features

- ✅ Auto-detects VS Code installation
- ✅ Per-user scope (no system-folder write, no admin prompt)
- ✅ One-click uninstall
- ✅ Manual VS Code path override
- ✅ Administrator mode switch for all users

---

## 🚀 Quick Start

1. Clone this repositories
2. **Double-click** "Add-VSCodeToContextMenu.bat"
   - Type `I` → install  
   - Type `U` → uninstall  
3. Windows Explorer will restart automatically; the menu appears immediately.
4. If auto find "Code.exe" failed you need set `CodePath` Manually, see [Custom VS Code Path](#️-custom-vs-code-path)

---

## 📂 Default Search Paths

| Priority | Location                                                                           |
| -------- | ---------------------------------------------------------------------------------- |
| 1️⃣      | **Same directory as this script**<br>`%SCRIPT_DIR%\Code.exe`                       |
| 2️⃣      | **User-install location**<br>`%LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe`  |
| 3️⃣      | **64-bit system-wide install**<br>`%ProgramFiles%\Microsoft VS Code\Code.exe`      |
| 4️⃣      | **32-bit system-wide install**<br>`%ProgramFiles(x86)%\Microsoft VS Code\Code.exe` |

If none of the above locations contain Code.exe, the script prompts you to manually set the correct path before retrying.

## ⚙️ Custom VS Code Path

If VS Code is **not** in one of the default locations, open the script and set the exact path on **line 15**:

```bat
set "CodePath=C:\Your\Path\To\Code.exe"
```

## 🌐 All Users Mode (System-Wide)

1. Run the script as Administrator
2. Change line 55 from
    ```bat
    set "ROOT=HKCU\Software\Classes"
    ```
    to
    ```bat
    set "ROOT=HKCR"
    ```

## 📄 Registry Locations Created

| Target Area        | Registry Key                            |
| ------------------ | --------------------------------------- |
| Any file           | `*\shell\VSCode`                        |
| Folder             | `Directory\shell\VSCode`                |
| Directory blank    | `Directory\Background\shell\VSCode`     |
| Library background | `LibraryFolder\Background\shell\VSCode` |

The uninstall routine deletes these keys.

## 🔧 FAQ

| Question               | Answer                                                    |
| ---------------------- | --------------------------------------------------------- |
| **VS Code not found?** | Edit `CodePath` or place `Code.exe` next to the script.   |
| **Menu not showing?**  | Re-run the script with `I`, or restart Explorer manually. |
| **Need admin rights?** | Only if you switch to `ROOT=HKCR` for all users.          |
