@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

cls
echo.
echo ====================================================
echo        Flutter‑Web Gallery 自动上传工具
echo ====================================================
echo.

set PROJECT_DIR=project
set LIST_FILE=%PROJECT_DIR%\.folder-list.txt

if not exist "%PROJECT_DIR%\" (
    echo [错误] 找不到 project 工作文件夹！
    echo.
    pause
    exit /b 1
)

if not exist "%LIST_FILE%" (
    echo [提示] 不存在 .folder‑list.txt，自动创建
    type nul > "%LIST_FILE%"
)

type nul > "%LIST_FILE%"
echo [1/3] 正在扫描 project 下一级项目文件夹
echo.

set count=0
for /d %%d in (%PROJECT_DIR%\*) do (
    set /a count+=1
    set "foldername=%%~nxd"
    echo  ‣ !foldername!

    if not exist "%%d\description.txt" (
        echo    ⚠️ 警告：缺少 description.txt
    )

    echo !foldername! >> "%LIST_FILE%"
)

echo.
if !count! equ 0 (
    echo [警告] project 内没有找到任何子文件夹！
) else (
    echo [成功] 共扫描到 !count! 个项目文件夹
)

echo.
echo [2/3] Git 提交变更并推送到 GitHub
echo.

git add .
git commit -m "auto update gallery list"
if !errorlevel! neq 0 (
    echo [提示] 没有文件变更，无需提交
) else (
    git push -u origin main
    if !errorlevel! neq 0 (
        echo [错误] Git推送失败，请检查网络/权限！
        echo.
        pause
        exit /b 1
    )
)

echo.
echo [3/3] 执行完成
echo.
echo ✅ 操作全部完成
echo.
echo 线上访问地址：https://drustan14.github.io/show/
echo 提示：GitHub Pages 需要 1‑3 分钟生效，浏览器 Ctrl+F5 强制刷新
echo.
echo ====================================================
pause