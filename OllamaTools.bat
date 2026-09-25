::Happy工具箱的Ollama组件
::务必使用ANSI编码
@echo off
:main
::主界面
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
if errorlevel 3 goto install_ollama
if errorlevel 2 goto ollama_operations
if errorlevel 1 goto quick_start_menu
if errorlevel 0 exit

:quick_start_menu
：：快速启动菜单
clear
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
echo    [8]运行自定义模型
echo    [9]配置自定义模型
echo    [0]返回上级菜单
echo.
echo ============================================
choice /C 12345890 /N /M "请选择操作 [1-5,8-9,0]: "
if errorlevel 1 goto run_gemma4
if errorlevel 2 goto run_deepseek_r1
if errorlevel 3 goto run_qwen35_08b
if errorlevel 4 goto run_gpt_oss
if errorlevel 5 goto run_gpt_oss_safeguard
if errorlevel 8 goto run_custom_model
if errorlevel 9 goto configure_custom_model
if errorlevel 0 goto main

::下面是跑模型的命令
::感谢VSCode，AI确实能在重复性的工作上十分出色，期待未来的表现
:run_gemma4
clear
title 运行Gemma4
echo 运行Gemma4
ollama run gemma4
echo 已结束。
timeout /t 3 /nobreak >nul
goto quick_start_menu

:run_deepseek_r1
clear
title 运行DeepSeek-R1
echo 运行DeepSeek-R1
ollama run deepseek-r1
echo 已结束。
timeout /t 3 /nobreak >nul
goto quick_start_menu

:run_qwen35_08b
clear
title 运行Qwen3.5:0.8b
echo 运行Qwen3.5:0.8b
ollama run qwen3.5:0.8b
echo 已结束。
timeout /t 3 /nobreak >nul
goto quick_start_menu

:run_gpt_oss
clear
title 运行GPT-OSS
echo 运行GPT-OSS
ollama run gpt-oss
echo 已结束。
timeout /t 3 /nobreak >nul
goto quick_start_menu

:run_gpt_oss_safeguard
clear
title 运行GPT-OSS-Safeguard
echo 运行GPT-OSS-Safeguard
ollama run gpt-oss-safeguard
echo 已结束。
timeout /t 3 /nobreak >nul
goto quick_start_menu

::环境变量还不太熟练，不知道行不行的通

:run_custom_model
clear
title 运行自定义模型
echo 运行自定义模型
ollama run %OllamaTools_CustomModel%
echo 已结束。
timeout /t 3 /nobreak >nul
goto quick_start_menu

:configure_custom_model
clear
title 配置自定义模型
echo 配置自定义模型
setx /p OllamaTools_CustomModel=请输入自定义模型名称(例如：deepseek-r1):
echo 已配置自定义模型为：%OllamaTools_CustomModel%
echo 即将重启组件以生效
timeout /t 3 /nobreak >nul
start %0
exit

:ollama_operations
clear
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
if errorlevel 2 goto delete_model
if errorlevel 1 goto list_models
if errorlevel 0 goto main

:list_models
clear
title 列出已有的模型
echo 列出已有的模型
ollama list
pause
goto ollama_operations

:delete_model
clear
title 删除模型
set /p del_model_name=请输入要删除的模型名称:
echo.
::应该没人误删了吧。。
echo 确认要删除吗？(1)是  (2)否
choice /C 12 /N /M "请选择操作 [1-2]: "
if errorlevel 2 goto ollama_operations
if errorlevel 1 echo 正在删除模型：%del_model_name%
ollama rm %del_model_name%
echo 已删除模型：%del_model_name%
timeout /t 5 /nobreak >nul
goto ollama_operations

:install_ollama
::感谢脚本，确实有用:)
clear
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
choice /C 120 /N /M "请选择操作 [1-3,0]: "
if errorlevel 2 goto install_ollama_script
if errorlevel 1 start https://ollama.com/download
if errorlevel 0 goto main

:install_ollama_script
clear
title 使用官方脚本自动安装Ollama
echo 正在使用官方脚本自动安装Ollama...
powershell irm https://ollama.com/install.ps1 | iex
echo 已结束。
pause
goto main
::写完了！！解脱了！！！