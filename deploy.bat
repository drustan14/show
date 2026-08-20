@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ==============================================
echo 自动遍历project子文件夹，更新列表并上传Github
echo ==============================================

set PROJECT_DIR=project
set LIST_FILE=%PROJECT_DIR%\.folder-list.txt

if not exist "%PROJECT_DIR%\" (
    echo ❌错误 project文件夹不存在
    pause
    exit /b 1
)

if not exist "%LIST_FILE%" (
    echo 创建 %LIST_FILE%
    type nul > "%LIST_FILE%"
)

:: 先清空旧列表
type nul > "%LIST_FILE%"

echo [1] 遍历 project 下一级子文件夹
for /d %%d in (%PROJECT_DIR%\*) do (
    set "foldername=%%~nxd"
    echo 发现文件夹: !foldername!

    :: 警告检查是否有description.txt
    if not exist "%%d\description.txt" (
        echo    ⚠️警告 !foldername! 缺少 description.txt
    )

    echo !foldername! >> "%LIST_FILE%"
)

echo.
echo [2] Git提交推送
git add .
git commit -m "auto update project folder list"
git push -u origin main

echo.
echo ✅完成
echo 访问地址：https://drustan14.github.io/show/
echo Pages 1‑3分钟生效，Ctrl+F5强制刷新
pause