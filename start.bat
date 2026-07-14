@echo off
title 600天纪念网页 - 本地服务器
echo.
echo   ==============================
echo     ✦ 我们的600天 ✦
echo   ==============================
echo.

where python >nul 2>nul
if %errorlevel%==0 (
    echo   ✓ 使用 Python 启动服务器...
    echo   → 打开浏览器访问: http://localhost:8080
    echo   → 按 Ctrl+C 停止服务器
    echo.
    start http://localhost:8080
    python -m http.server 8080
    pause
    exit /b
)

where node >nul 2>nul
if %errorlevel%==0 (
    echo   ✓ 使用 Node.js 启动服务器...
    echo   → 打开浏览器访问: http://localhost:3000
    echo   → 按 Ctrl+C 停止服务器
    echo.
    start http://localhost:3000
    npx --yes http-server -p 3000
    pause
    exit /b
)

echo.
echo   ✗ 未检测到 Python 或 Node.js
echo.
echo   请安装 Python (https://python.org) 后重试
echo   或使用 VS Code 的 Live Server 扩展打开
echo.
pause
