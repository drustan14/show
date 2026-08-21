@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 颜色定义
set "GREEN=[92m"
set "RED=[91m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "RESET=[0m"

cls
echo.
echo %BLUE%====================================================%RESET%
echo %BLUE%        Flutter‑Web Gallery 自动上传工具               %RESET%
echo %BLUE%====================================================%RESET%
echo.

set PROJECT_DIR=project
set LIST_FILE=%PROJECT_DIR%\.folder-list.txt

:: 校验project文件夹是否存在
if not exist "%PROJECT_DIR%\" (
    echo %RED%[错误] 找不到 project 工作文件夹！%RESET%
    echo.
    pause
    exit /b 1
)

:: 不存在则创建列表文件
if not exist "%LIST_FILE%" (
    echo %YELLOW%[提示] 不存在 .folder‑list.txt，自动创建%RESET%
    type nul > "%LIST_FILE%"
)

:: 清空旧列表
type nul > "%LIST_FILE%"
echo %BLUE%[1/3] 正在扫描 project 下一级项目文件夹%RESET%
echo.

set count=0
for /d %%d in (%PROJECT_DIR%\*) do (
    set /a count+=1
    set "foldername=%%~nxd"
    echo  ‣ !foldername!

    if not exist "%%d\description.txt" (
        echo    %YELLOW%⚠️ 警告：缺少 description.txt%RESET%
    )

    echo !foldername! >> "%LIST_FILE%"
)

echo.
if !count! equ 0 (
    echo %RED%[警告] project 内没有找到任何子文件夹！%RESET%
) else (
    echo %GREEN%[成功] 共扫描到 !count! 个项目文件夹%RESET%
)

echo.
echo %BLUE%[2/3] Git 提交变更并推送到 GitHub%RESET%
echo.

git add .
git commit -m "auto update gallery list"
if !errorlevel! neq 0 (
    echo %YELLOW%[提示] 没有文件变更，无需提交%RESET%
) else (
    git push -u origin main
    if !errorlevel! neq 0 (
        echo %RED%[错误] Git推送失败，请检查网络/权限！%RESET%
        echo.
        pause
        exit /b 1
    )
)

echo.
echo %BLUE%[3/3] 执行完成%RESET%
echo.
echo %GREEN%✅ 操作全部完成%RESET%
echo.
echo 线上访问地址：https://drustan14.github.io/show/
echo %YELLOW%提示：GitHub Pages 需要 1‑3 分钟生效，浏览器 Ctrl+F5 强制刷新%RESET%
echo.
echo %BLUE%====================================================%RESET%
pause