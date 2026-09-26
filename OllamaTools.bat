::Happy工具箱的Ollama组件
@echo off
setlocal EnableExtensions EnableDelayedExpansion

:main
::主界面
cls
title Ollama组件
echo ============================================
echo                Ollama组件
echo ============================================
echo.
echo     [1]  快速启动菜单     [2]  Ollama操作
echo     [3]  安装Ollama      [0]  退出本组件
echo.
echo ============================================
choice /C 1230 /N /M "请选择操作 [1-3,0]: "
:: CHOICE 返回的是按 /C 中字符排列的位置；这里 0 是第 4 个选项。
if errorlevel 4 exit /b 0
if errorlevel 3 goto install_ollama
if errorlevel 2 goto ollama_operations
if errorlevel 1 goto quick_start_menu

goto main

:quick_start_menu
::快速启动菜单
cls
title 快速启动菜单
echo ============================================
echo                快速启动菜单
echo ============================================
echo.
echo    [1]运行Gemma4
echo    [2]运行DeepSeek-R1
echo    [3]运行Qwen3.5:0.8b  (非低配机器不建议使用)
echo    [4]运行GPT-OSS  (高配机器适合)
echo    [5]运行GPT-OSS-Safeguard(貌似更安全？)
echo    [6]运行自定义模型
echo    [7]配置自定义模型
echo    [0]返回上级菜单
echo.
echo ============================================
choice /C 12345670 /N /M "请选择操作 [1-7,0]: "
:: /C 中的 0 是第 8 个选项，必须先检查最高返回值。
if errorlevel 8 goto main
if errorlevel 7 goto configure_custom_model
if errorlevel 6 goto run_custom_model
if errorlevel 5 goto run_gpt_oss_safeguard
if errorlevel 4 goto run_gpt_oss
if errorlevel 3 goto run_qwen35_08b
if errorlevel 2 goto run_deepseek_r1
if errorlevel 1 goto run_gemma4

goto quick_start_menu

:ensure_ollama
where ollama >nul 2>&1
if errorlevel 1 (
    echo 未检测到 Ollama 命令，请先安装 Ollama。
    echo [1] 立即安装 [2] 返回主菜单
    choice /C 12 /N /M "请选择操作 [1-2]: "
    if errorlevel 2 goto main
    if errorlevel 1 goto install_ollama
    goto main
)
exit /b 0

:run_gemma4
call :ensure_ollama
cls
title 运行Gemma4
echo 运行Gemma4
echo 正在启动 gemma4...
ollama run gemma4
echo 已结束。
timeout /t 3 /nobreak >nul
goto quick_start_menu

:run_deepseek_r1
call :ensure_ollama
cls
title 运行DeepSeek-R1
echo 运行DeepSeek-R1
echo 正在启动 deepseek-r1...
ollama run deepseek-r1
echo 已结束。
timeout /t 3 /nobreak >nul
goto quick_start_menu

:run_qwen35_08b
call :ensure_ollama
cls
title 运行Qwen3.5:0.8b
echo 运行Qwen3.5:0.8b
echo 正在启动 qwen3.5:0.8b...
ollama run qwen3.5:0.8b
echo 已结束。
timeout /t 3 /nobreak >nul
goto quick_start_menu

:run_gpt_oss
call :ensure_ollama
cls
title 运行GPT-OSS
echo 运行GPT-OSS
echo 正在启动 gpt-oss...
ollama run gpt-oss
echo 已结束。
timeout /t 3 /nobreak >nul
goto quick_start_menu

:run_gpt_oss_safeguard
call :ensure_ollama
cls
title 运行GPT-OSS-Safeguard
echo 运行GPT-OSS-Safeguard
echo 正在启动 gpt-oss-safeguard...
ollama run gpt-oss-safeguard
echo 已结束。
timeout /t 3 /nobreak >nul
goto quick_start_menu

:run_custom_model
call :ensure_ollama
if not defined OllamaTools_CustomModel (
    echo 未配置自定义模型，请先执行“配置自定义模型”。
    timeout /t 3 /nobreak >nul
    goto quick_start_menu
)
cls
title 运行自定义模型
echo 运行自定义模型
echo 正在启动 %OllamaTools_CustomModel%...
ollama run "%OllamaTools_CustomModel%"
echo 已结束。
timeout /t 3 /nobreak >nul
goto quick_start_menu

:configure_custom_model
cls
title 配置自定义模型
echo 配置自定义模型
set /p "custom_model_name=请输入自定义模型名称(例如：deepseek-r1): "
if not defined custom_model_name (
    echo 未输入模型名称，已取消配置。
    timeout /t 2 /nobreak >nul
    goto quick_start_menu
)
set "OllamaTools_CustomModel=%custom_model_name%"
setx OllamaTools_CustomModel "%OllamaTools_CustomModel%" >nul
echo 已配置自定义模型为：%OllamaTools_CustomModel%
echo 即将返回菜单...
timeout /t 2 /nobreak >nul
goto quick_start_menu

:ollama_operations
call :ensure_ollama
cls
title Ollama操作
echo ============================================
echo               Ollama操作
echo ============================================
echo.
echo   [1]列出已有的模型
echo   [2]删除模型
echo   [0]返回上级菜单
echo.
echo ============================================
choice /C 120 /N /M "请选择操作 [1-2,0]: "
:: /C 中的 0 是第 3 个选项。
if errorlevel 3 goto main
if errorlevel 2 goto delete_model
if errorlevel 1 goto list_models

goto ollama_operations

:list_models
cls
title 列出已有的模型
echo 列出已有的模型
ollama list
pause
goto ollama_operations

:delete_model
cls
title 删除模型
set /p "del_model_name=请输入要删除的模型名称: "
if not defined del_model_name (
    echo 未输入模型名称，已取消删除。
    timeout /t 2 /nobreak >nul
    goto ollama_operations
)
if /I "%del_model_name%"=="all" (
    echo 为了安全，拒绝删除 "all" 关键词，已取消。
    timeout /t 2 /nobreak >nul
    goto ollama_operations
)
echo.
echo 确认要删除模型 "%del_model_name%" 吗？(1)是  (2)否
choice /C 12 /N /M "请选择操作 [1-2]: "
if errorlevel 2 goto ollama_operations
if not errorlevel 1 goto ollama_operations
echo 正在删除模型：%del_model_name%
ollama rm "%del_model_name%"
if errorlevel 1 (
    echo 删除失败，可能模型不存在或服务未运行。
) else (
    echo 已删除模型：%del_model_name%
)
timeout /t 5 /nobreak >nul
goto ollama_operations

:install_ollama
cls
title 安装Ollama
echo ============================================
echo               安装Ollama
echo ============================================
echo.
echo     [1]打开Ollama官网
echo     [2]使用官方脚本自动安装
echo     [0]返回上级菜单
echo.
echo ============================================
choice /C 120 /N /M "请选择操作 [1-2,0]: "
:: /C 中的 0 是第 3 个选项。
if errorlevel 3 goto main
if errorlevel 2 goto install_ollama_script
if errorlevel 1 (
    start "" "https://ollama.com/download"
    goto main
)

goto install_ollama

:install_ollama_script
cls
title 使用官方脚本自动安装Ollama
echo 正在使用官方脚本自动安装Ollama...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; irm https://ollama.com/install.ps1 | iex"
if errorlevel 1 (
    echo 安装脚本执行失败，可能是 PowerShell/网络问题或权限不足。
    pause
    goto main
)
where ollama >nul 2>&1
if errorlevel 1 (
    echo 安装已结束，但未检测到 ollama 命令，建议重启终端或检查安装状态。
) else (
    echo 安装成功，当前 Ollama 版本：
    ollama --version
)
pause
goto main
