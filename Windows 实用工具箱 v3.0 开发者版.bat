@echo off
setlocal enabledelayedexpansion
title Windows 实用工具箱 v3.0（开发者版）

color 0F

fltmc >nul 2>&1 || (
    echo [警告] 部分功能需要管理员权限。
    echo        建议右键选择"以管理员身份运行"。
    echo.
    pause
)

:main_menu
cls
echo ================================================================
echo             Windows 实用工具箱 v3.0（开发者版）
echo ================================================================
echo.
echo    [1] 系统优化工具      [2] 网络诊断工具
echo    [3] 文件处理工具      [4] 安全维护工具
echo    [5] 磁盘管理工具      [6] 系统信息查看
echo    [7] 系统设置工具      [8] AI 对话
echo    [9] 开发者工具        [0] 退出工具箱
echo.
echo ================================================================
echo    提示：部分功能需要管理员权限才能正常运行。
echo ================================================================
echo.

choice /C 1234567890 /N /M "请选择操作 [1-9,0]: "

if errorlevel 10 goto exit
if errorlevel 9 goto dev_tools
if errorlevel 8 goto ai_chat
if errorlevel 7 goto settings_menu
if errorlevel 6 goto system_info
if errorlevel 5 goto disk_tools
if errorlevel 4 goto security_tools
if errorlevel 3 goto file_tools
if errorlevel 2 goto network_tools
if errorlevel 1 goto system_optimize

:system_optimize
cls
echo ================================================================
echo                系统优化工具
echo ================================================================
echo.
echo    [1] 清理临时文件      [2] 磁盘碎片整理
echo    [3] 关闭系统休眠      [4] 系统性能优化
echo    [5] 系统服务优化      [6] 恢复默认设置
echo    [7] 返回主菜单
echo.
echo ================================================================
echo.

choice /C 1234567 /N /M "请选择优化项目 [1-7]: "

if errorlevel 7 goto main_menu
if errorlevel 6 goto restore_defaults
if errorlevel 5 goto service_optimize
if errorlevel 4 goto performance_optimize
if errorlevel 3 goto disable_hibernation
if errorlevel 2 goto defrag_disk
if errorlevel 1 goto clean_temp_files

:clean_temp_files
cls
echo ================================================================
echo                清理临时文件
echo ================================================================
echo.
echo 将清理以下位置（仅限临时目录，不会删除个人文件）：
echo   - 当前用户临时目录 %%TEMP%%
echo   - 系统临时目录 %%windir%%\temp
echo.
echo 说明：不会清理 Prefetch 预取缓存（该操作反而可能拖慢程序启动）。
echo.
choice /C YN /N /M "是否开始清理? [Y/N]: "
if errorlevel 2 goto system_optimize
echo.
echo 正在清理系统临时文件...
echo.
rd /S /Q "%temp%" 2>nul
del /F /S /Q "%windir%\temp\*.*" 2>nul
echo.
echo 系统临时文件清理完成！
echo.
pause
goto system_optimize

:defrag_disk
cls
echo ================================================================
echo              磁盘碎片整理工具
echo ================================================================
echo.
echo 当前系统磁盘信息：
wmic logicaldisk where drivetype=3 get deviceid, volumename, freespace, size
echo.
set /p drive="请输入需要整理的磁盘盘符 (例如 C): "
echo.
echo 正在对 %drive%: 进行磁盘碎片整理... 这需要一段时间。
echo.
defrag %drive%: /U /V
echo.
echo 磁盘碎片整理完成！
echo.
pause
goto system_optimize

:disable_hibernation
cls
echo 正在检查系统休眠状态...
powercfg /a | find "休眠" >nul
if %errorlevel%==0 (
    echo 系统休眠已启用，正在关闭...
    powercfg /h off
    echo.
    echo 系统休眠已关闭！
) else (
    echo 系统休眠已关闭！
)
echo.
pause
goto system_optimize

:performance_optimize
cls
echo ================================================================
echo              系统性能优化
echo ================================================================
echo.
echo 正在调整系统设置以提升运行速度...
echo.
systempropertiesperformance.exe /p /d
echo.
echo 系统性能设置已优化！
echo.
pause
goto system_optimize

:service_optimize
cls
echo ================================================================
echo              系统服务优化
echo ================================================================
echo.
echo 注意：禁用不必要的服务可能会影响某些功能。
echo 建议先备份系统或创建还原点。
echo.
choice /C YN /N /M "是否继续? [Y/N]: "
if errorlevel 2 goto system_optimize
if errorlevel 1 (
    echo.
    echo 正在优化系统服务...
    echo.
    sc config wuauserv start= disabled >nul 2>&1
    sc config Superfetch start= disabled >nul 2>&1
    sc config HomeGroupListener start= disabled >nul 2>&1
    sc config HomeGroupProvider start= disabled >nul 2>&1
    sc config XboxLiveAuthManager start= disabled >nul 2>&1
    sc config XboxNetApiSvc start= disabled >nul 2>&1
    echo.
    echo 系统服务优化完成！
)
echo.
pause
goto system_optimize

:restore_defaults
cls
echo ================================================================
echo            恢复系统默认设置
echo ================================================================
echo.
echo 警告：此操作将恢复上述优化项目为默认值。
echo.
choice /C YN /N /M "是否继续? [Y/N]: "
if errorlevel 2 goto system_optimize
if errorlevel 1 (
    echo.
    echo 正在恢复系统默认设置...
    echo.
    sc config wuauserv start= auto >nul 2>&1
    sc config Superfetch start= auto >nul 2>&1
    powercfg /h on >nul 2>&1
    echo.
    echo 系统设置已恢复为默认值！
)
echo.
pause
goto system_optimize

:network_tools
cls
echo ================================================================
echo                网络诊断工具
echo ================================================================
echo.
echo    [1] 网络连接测试      [2] IP地址信息
echo    [3] DNS刷新工具      [4] 端口扫描工具
echo    [5] 路由追踪工具      [6] WiFi密码查看
echo    [7] 查询公网IP        [8] 返回主菜单
echo.
echo ================================================================
echo.

choice /C 12345678 /N /M "请选择网络工具 [1-8]: "

if errorlevel 8 goto main_menu
if errorlevel 7 goto public_ip
if errorlevel 6 goto wifi_passwords
if errorlevel 5 goto trace_route
if errorlevel 4 goto port_scan
if errorlevel 3 goto flush_dns
if errorlevel 2 goto ip_config
if errorlevel 1 goto network_test

:network_test
cls
echo ================================================================
echo               网络连接测试
echo ================================================================
echo.
echo 正在测试外网连接，请稍候...
echo.
ping www.baidu.com -n 4 >nul
if %errorlevel%==0 (
    echo 恭喜！外网连接正常。
) else (
    echo 外网连接测试失败，请检查网络配置。
)
echo.
echo 正在测试本地回环...
ping 127.0.0.1 -n 4 >nul
if %errorlevel%==0 (
    echo 本地回环网络正常。
) else (
    echo 本地回环测试失败，可能存在网络驱动问题。
)
echo.
pause
goto network_tools

:ip_config
cls
echo ================================================================
echo                IP地址信息
echo ================================================================
echo.
ipconfig /all
echo.
pause
goto network_tools

:flush_dns
cls
echo ================================================================
echo                 DNS刷新工具
echo ================================================================
echo.
echo 正在刷新DNS缓存...
ipconfig /flushdns
echo.
echo DNS缓存已刷新！
echo.
pause
goto network_tools

:port_scan
cls
echo ================================================================
echo                端口扫描工具
echo ================================================================
echo.
echo 说明：测试目标主机指定端口是否开放（无需 telnet）。
echo.
set /p target="请输入目标IP或域名 (例 192.168.1.1 或 baidu.com): "
set /p ports="请输入端口号，多个用逗号分隔 (例 80,443,3306,8080): "
echo.
echo 正在扫描 %target% 的端口...
echo.
echo 端口扫描结果：
echo --------------------------------
powershell -NoProfile -Command "$h='%target%'; $ps='%ports%' -split ','; foreach($p in $ps){ if($p -eq ''){continue}; $r = Test-NetConnection -ComputerName $h -Port ([int]$p) -WarningAction SilentlyContinue; if($r.TcpTestSucceeded){ Write-Host ('  [开放] {0}:{1}' -f $h,$p) -ForegroundColor Green } else { Write-Host ('  [关闭] {0}:{1}' -f $h,$p) -ForegroundColor Red } }"
echo --------------------------------
echo.
echo 端口扫描完成！
echo.
pause
goto network_tools

:trace_route
cls
echo ================================================================
echo                路由追踪工具
echo ================================================================
echo.
set /p target="请输入目标网站或IP地址: "
echo.
echo 正在追踪到 %target% 的路由，请稍候...
echo.
tracert %target%
echo.
pause
goto network_tools

:wifi_passwords
cls
echo ================================================================
echo              WiFi密码查看工具
echo ================================================================
echo.
echo 正在获取已保存的WiFi配置信息...
echo.
netsh wlan show profiles
echo.
set /p wifi_name="请输入需要查看密码的WiFi名称: "
echo.
netsh wlan show profile name="%wifi_name%" key=clear | findstr "关键内容"
echo.
pause
goto network_tools

:public_ip
cls
echo ================================================================
echo                查询公网IP
echo ================================================================
echo.
echo 正在查询本机公网IP...
echo.
echo 公网IP (IPv4): 
curl -s --max-time 10 https://api.ipify.org
echo.
echo.
echo 地理位置信息:
curl -s --max-time 10 https://ipinfo.io/json
echo.
echo.
pause
goto network_tools

:file_tools
cls
echo ================================================================
echo                文件处理工具
echo ================================================================
echo.
echo    [1] 文件搜索工具      [2] 文件批量重命名
echo    [3] 文件加密工具      [4] 文件哈希校验
echo    [5] 大文件查找工具    [6] 文件压缩工具
echo    [7] 返回主菜单
echo.
echo ================================================================
echo.

choice /C 1234567 /N /M "请选择文件工具 [1-7]: "

if errorlevel 7 goto main_menu
if errorlevel 6 goto file_zip
if errorlevel 5 goto find_large_files
if errorlevel 4 goto file_hash
if errorlevel 3 goto file_encrypt
if errorlevel 2 goto batch_rename
if errorlevel 1 goto file_search

:file_search
cls
echo ================================================================
echo                文件搜索工具
echo ================================================================
echo.
set /p search_dir="请输入搜索目录 (例 C:\Users): "
set /p search_text="请输入需要查找的文件名关键字: "
echo.
echo 正在搜索相关文件，请稍候...
echo.
dir /s /b "%search_dir%\*%search_text%*"
echo.
echo 文件搜索完成！
echo.
pause
goto file_tools

:batch_rename
cls
echo ================================================================
echo              文件批量重命名工具
echo ================================================================
echo.
set /p rename_dir="请输入需要重命名的文件夹目录: "
set /p old_text="请输入需要替换的文本: "
set /p new_text="请输入替换后的新文本: "
echo.
echo 以下文件将被重命名（预览）：
echo --------------------------------
for %%f in ("%rename_dir%\*%old_text%*") do echo   %%~nxf
echo --------------------------------
echo.
choice /C YN /N /M "确认执行重命名? [Y/N]: "
if errorlevel 2 goto file_tools
echo.
echo 正在批量重命名文件...
echo.
cd /d "%rename_dir%"
for %%f in (*%old_text%*) do (
    set "filename=%%f"
    setlocal enabledelayedexpansion
    set "newname=!filename:%old_text%=%new_text%!"
    ren "!filename!" "!newname!"
    endlocal
)
echo.
echo 文件批量重命名完成！
echo.
pause
goto file_tools

:file_encrypt
cls
echo ================================================================
echo                文件加密工具
echo ================================================================
echo.
echo 说明：使用 Base64 编码对文件做简单混淆，适合非机密数据。
echo       加密后会保留原文件，并生成 .enc 副本（更安全）。
echo.
set /p encrypt_file="请输入需要加密的文件路径: "
echo.
echo 正在生成加密副本...
certutil -encode "%encrypt_file%" "%encrypt_file%.enc" >nul
echo.
echo 加密副本已生成: %encrypt_file%.enc
echo 原文件已保留，请确认无误后可自行删除原文件。
echo.
pause
goto file_tools

:file_hash
cls
echo ================================================================
echo                文件哈希校验
echo ================================================================
echo.
set /p hash_file="请输入需要校验的文件路径: "
echo.
echo 正在计算文件哈希值，请稍候...
echo.
echo 文件 MD5 哈希:
certutil -hashfile "%hash_file%" MD5
echo.
echo 文件 SHA1 哈希:
certutil -hashfile "%hash_file%" SHA1
echo.
echo 文件 SHA256 哈希:
certutil -hashfile "%hash_file%" SHA256
echo.
pause
goto file_tools

:find_large_files
cls
echo ================================================================
echo              大文件查找工具
echo ================================================================
echo.
set /p large_dir="请输入需要扫描的目录 (例 C:\): "
set /p size_limit="请输入文件大小阈值 (MB): "
echo.
echo 正在查找大于 %size_limit%MB 的文件，请稍候...
echo.
forfiles /p "%large_dir%" /s /m * /c "cmd /c if @fsize GTR %size_limit%000000 echo @path - @fsize bytes"
echo.
echo 大文件查找完成！
echo.
pause
goto file_tools

:file_zip
cls
echo ================================================================
echo                文件压缩工具
echo ================================================================
echo.
set /p zip_dir="请输入需要压缩的文件或目录: "
set /p zip_file="请输入压缩后的文件名 (例 archive.zip): "
echo.
echo 正在压缩文件，请稍候...
echo.
powershell -command "Compress-Archive -Path '%zip_dir%' -DestinationPath '%zip_file%' -Force"
echo.
echo 文件压缩完成！
echo.
pause
goto file_tools

:security_tools
cls
echo ================================================================
echo                安全维护工具
echo ================================================================
echo.
echo    [1] 系统病毒扫描      [2] 恶意软件查杀
echo    [3] 防火墙设置        [4] 账户密码修改
echo    [5] 系统还原点        [6] UAC设置
echo    [7] 返回主菜单
echo.
echo ================================================================
echo.

choice /C 1234567 /N /M "请选择安全工具 [1-7]: "

if errorlevel 7 goto main_menu
if errorlevel 6 goto uac_settings
if errorlevel 5 goto system_restore
if errorlevel 4 goto change_password
if errorlevel 3 goto firewall_settings
if errorlevel 2 goto malware_scan
if errorlevel 1 goto virus_scan

:virus_scan
cls
echo ================================================================
echo                系统病毒扫描
echo ================================================================
echo.
echo 警告：此操作将调用Windows Defender进行全系统扫描。
echo 这可能需要较长时间，取决于系统大小和性能。
echo.
choice /C YN /N /M "是否继续? [Y/N]: "
if errorlevel 2 goto security_tools
if errorlevel 1 (
    echo.
    echo 正在启动系统病毒扫描...
    echo.
    powershell -NoProfile -Command "Start-MpScan -ScanType FullScan"
    echo.
    echo 系统病毒扫描已启动。
    echo 请在Windows安全中心查看扫描结果。
)
echo.
pause
goto security_tools

:malware_scan
cls
echo ================================================================
echo              恶意软件查杀工具
echo ================================================================
echo.
echo 正在检查系统是否装有Microsoft Safety Scanner...
echo.
where mssacli.exe >nul 2>&1
if %errorlevel%==0 (
    echo 已安装Microsoft Safety Scanner，正在启动扫描...
    mssacli.exe /scan /full
) else (
    echo 未安装Microsoft Safety Scanner，正在打开下载页面。
    echo 请下载安装后再运行此工具。
    start https://www.microsoft.com/security/scanner
)
echo.
pause
goto security_tools

:firewall_settings
cls
echo ================================================================
echo                防火墙设置
echo ================================================================
echo.
echo    [1] 启用防火墙        [2] 禁用防火墙
echo    [3] 查看防火墙状态    [4] 返回上一级
echo.
echo ================================================================
echo.

choice /C 1234 /N /M "请选择操作 [1-4]: "

if errorlevel 4 goto security_tools
if errorlevel 3 goto firewall_status
if errorlevel 2 goto disable_firewall
if errorlevel 1 goto enable_firewall

:enable_firewall
cls
echo 正在启用Windows Defender防火墙...
netsh advfirewall set allprofiles state on
echo.
echo Windows Defender防火墙已启用！
echo.
pause
goto firewall_settings

:disable_firewall
cls
echo 警告：禁用防火墙将使系统面临安全风险！
echo.
choice /C YN /N /M "是否继续? [Y/N]: "
if errorlevel 2 goto firewall_settings
if errorlevel 1 (
    echo.
    echo 正在禁用Windows Defender防火墙...
    netsh advfirewall set allprofiles state off
    echo.
    echo Windows Defender防火墙已禁用！
)
echo.
pause
goto firewall_settings

:firewall_status
cls
echo ================================================================
echo             Windows Defender防火墙状态
echo ================================================================
echo.
netsh advfirewall show allprofiles
echo.
pause
goto firewall_settings

:change_password
cls
echo ================================================================
echo                账户密码修改
echo ================================================================
echo.
net user
echo.
set /p username="请输入需要修改密码的用户名: "
echo.
echo 请输入新密码（密码不会显示在屏幕上）：
echo.
net user %username% *
echo.
echo 密码修改完成！
echo.
pause
goto security_tools

:system_restore
cls
echo ================================================================
echo                系统还原点
echo ================================================================
echo.
echo    [1] 创建还原点        [2] 查看还原点
echo    [3] 系统还原          [4] 返回上一级
echo.
echo ================================================================
echo.

choice /C 1234 /N /M "请选择操作 [1-4]: "

if errorlevel 4 goto security_tools
if errorlevel 3 goto restore_system
if errorlevel 2 goto view_restore_points
if errorlevel 1 goto create_restore_point

:create_restore_point
cls
echo ================================================================
echo              创建系统还原点
echo ================================================================
echo.
set /p description="请输入还原点描述: "
echo.
echo 正在创建系统还原点，请稍候...
powershell -command "Checkpoint-Computer -Description '%description%' -RestorePointType 'MODIFY_SETTINGS'"
echo.
echo 系统还原点创建完成！
echo.
pause
goto system_restore

:view_restore_points
cls
echo ================================================================
echo              查看系统还原点
echo ================================================================
echo.
powershell -command "Get-ComputerRestorePoint"
echo.
pause
goto system_restore

:restore_system
cls
echo ================================================================
echo                系统还原
echo ================================================================
echo.
echo 警告：系统还原会将系统恢复到还原点之前的状态。
echo 之后安装的程序和更改的文件可能会被删除，某些设置可能会丢失。
echo.
choice /C YN /N /M "是否继续? [Y/N]: "
if errorlevel 2 goto system_restore
if errorlevel 1 (
    echo.
    echo 正在启动系统还原...
    rstrui.exe
    echo.
    echo 系统还原向导已启动。
)
echo.
pause
goto system_restore

:uac_settings
cls
echo ================================================================
echo                UAC设置
echo ================================================================
echo.
echo    [1] 高 (始终通知)        [2] 中 (默认级别)
echo    [3] 低 (仅在程序更改系统时通知)
echo    [4] 关闭UAC (不推荐)     [5] 返回上一级
echo.
echo ================================================================
echo.

choice /C 12345 /N /M "请选择UAC级别 [1-5]: "

if errorlevel 5 goto security_tools
if errorlevel 4 goto uac_off
if errorlevel 3 goto uac_low
if errorlevel 2 goto uac_medium
if errorlevel 1 goto uac_high

:uac_high
cls
echo 正在设置UAC为高级别 (始终通知)...
powershell -command "Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 2"
echo.
echo UAC级别已更新！
echo 更改将在下次登录时生效。
echo.
pause
goto uac_settings

:uac_medium
cls
echo 正在设置UAC为中级别 (默认级别)...
powershell -command "Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 5"
echo.
echo UAC级别已更新！
echo 更改将在下次登录时生效。
echo.
pause
goto uac_settings

:uac_low
cls
echo 正在设置UAC为低级别 (仅在程序更改系统时通知)...
powershell -command "Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 1"
echo.
echo UAC级别已更新！
echo 更改将在下次登录时生效。
echo.
pause
goto uac_settings

:uac_off
cls
echo 警告：关闭UAC将使系统面临安全风险！
echo.
choice /C YN /N /M "是否继续? [Y/N]: "
if errorlevel 2 goto uac_settings
if errorlevel 1 (
    echo.
    echo 正在关闭UAC...
    powershell -command "Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0"
    echo.
    echo UAC已关闭！
    echo 更改将在下次登录时生效。
)
echo.
pause
goto uac_settings

:disk_tools
cls
echo ================================================================
echo                磁盘管理工具
echo ================================================================
echo.
echo    [1] 磁盘检查工具      [2] 磁盘清理工具
echo    [3] 磁盘空间分析      [4] 磁盘分区管理
echo    [5] 磁盘格式化工具    [6] 返回主菜单
echo.
echo ================================================================
echo.

choice /C 123456 /N /M "请选择磁盘工具 [1-6]: "

if errorlevel 6 goto main_menu
if errorlevel 5 goto format_disk
if errorlevel 4 goto partition_manager
if errorlevel 3 goto disk_analyzer
if errorlevel 2 goto disk_cleanup
if errorlevel 1 goto disk_check

:disk_check
cls
echo ================================================================
echo                磁盘检查工具
echo ================================================================
echo.
echo 当前系统磁盘信息：
wmic logicaldisk where drivetype=3 get deviceid, volumename, freespace, size
echo.
set /p drive="请输入需要检查的磁盘盘符 (例如 C): "
echo.
echo 警告：磁盘检查可能会修复错误，但可能会删除一些文件。
echo.
choice /C YN /N /M "是否继续? [Y/N]: "
if errorlevel 2 goto disk_tools
if errorlevel 1 (
    echo.
    echo 正在检查 %drive%: 磁盘，请稍候...
    chkdsk %drive%: /f /r
    echo.
    echo 磁盘检查完成！
)
echo.
pause
goto disk_tools

:disk_cleanup
cls
echo ================================================================
echo                磁盘清理工具
echo ================================================================
echo.
echo 当前系统磁盘信息：
wmic logicaldisk where drivetype=3 get deviceid, volumename, freespace, size
echo.
set /p drive="请输入需要清理的磁盘盘符 (例如 C): "
echo.
echo 正在启动磁盘清理工具...
cleanmgr /sageset:99
cleanmgr /sagerun:99
echo.
echo 磁盘清理完成！
echo.
pause
goto disk_tools

:disk_analyzer
cls
echo ================================================================
echo                磁盘空间分析
echo ================================================================
echo.
echo 正在检查系统是否装有WinDirStat...
echo.
where wds.exe >nul 2>&1
if %errorlevel%==0 (
    echo 已安装WinDirStat，正在启动...
    wds.exe
) else (
    echo 未安装WinDirStat，正在打开下载页面。
    echo 请下载安装后再运行此工具。
    start https://windirstat.net/
)
echo.
pause
goto disk_tools

:partition_manager
cls
echo ================================================================
echo                磁盘分区管理
echo ================================================================
echo.
echo 警告：此操作将打开磁盘管理控制台。
echo 错误的操作可能会导致数据丢失。
echo.
choice /C YN /N /M "是否继续? [Y/N]: "
if errorlevel 2 goto disk_tools
if errorlevel 1 (
    echo.
    echo 正在打开磁盘管理控制台...
    diskmgmt.msc
    echo.
    echo 磁盘管理控制台已打开。
)
echo.
pause
goto disk_tools

:format_disk
cls
echo ================================================================
echo                磁盘格式化工具
echo ================================================================
echo.
echo 警告：格式化将删除磁盘上的所有数据！
echo 请确认已备份重要数据。
echo.
echo 当前系统磁盘信息：
wmic logicaldisk where drivetype=3 get deviceid, volumename, freespace, size
echo.
set /p drive="请输入需要格式化的磁盘盘符 (例如 D): "
echo.
choice /C YN /N /M "确认要格式化 %drive%: 吗? [Y/N]: "
if errorlevel 2 goto disk_tools
if errorlevel 1 (
    echo.
    echo 请选择文件系统:
    echo    [1] NTFS   [2] FAT32   [3] exFAT
    echo.
    choice /C 123 /N /M "请选择 [1-3]: "
    if errorlevel 3 set fs=exFAT
    if errorlevel 2 set fs=FAT32
    if errorlevel 1 set fs=NTFS
    
    echo.
    echo 正在格式化 %drive%: 为 %fs% 文件系统...
    format %drive%: /FS:%fs% /Q /Y
    echo.
    echo 磁盘格式化完成！
)
echo.
pause
goto disk_tools

:system_info
cls
echo ================================================================
echo                系统信息查看
echo ================================================================
echo.
echo    [1] 基本系统信息      [2] 硬件信息
echo    [3] 网络信息          [4] 软件信息
echo    [5] 系统日志          [6] 返回主菜单
echo.
echo ================================================================
echo.

choice /C 123456 /N /M "请选择信息类别 [1-6]: "

if errorlevel 6 goto main_menu
if errorlevel 5 goto system_logs
if errorlevel 4 goto software_info
if errorlevel 3 goto network_info
if errorlevel 2 goto hardware_info
if errorlevel 1 goto basic_info

:basic_info
cls
echo ================================================================
echo                基本系统信息
echo ================================================================
echo.
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type" /C:"Total Physical Memory"
echo.
echo 计算机名称: %COMPUTERNAME%
echo 当前用户:   %USERNAME%
echo 当前日期:   %DATE%
echo 当前时间:   %TIME%
echo.
echo CPU 信息:
wmic cpu get name
echo.
echo 磁盘空间:
wmic logicaldisk where drivetype=3 get deviceid, freespace, size
echo.
pause
goto system_info

:hardware_info
cls
echo ================================================================
echo                硬件信息
echo ================================================================
echo.
echo    [1] CPU信息           [2] 内存信息
echo    [3] 硬盘信息          [4] 显卡信息
echo    [5] 主板信息          [6] 返回上一级
echo.
echo ================================================================
echo.

choice /C 123456 /N /M "请选择硬件类别 [1-6]: "

if errorlevel 6 goto system_info
if errorlevel 5 goto motherboard_info
if errorlevel 4 goto graphics_info
if errorlevel 3 goto disk_info
if errorlevel 2 goto memory_info
if errorlevel 1 goto cpu_info

:cpu_info
cls
echo ================================================================
echo                  CPU 信息
echo ================================================================
echo.
wmic cpu get name, numberofcores, maxclockspeed, status
echo.
pause
goto hardware_info

:memory_info
cls
echo ================================================================
echo                 内存信息
echo ================================================================
echo.
echo 物理内存:
systeminfo | findstr /C:"Total Physical Memory"
echo.
echo 内存条信息:
wmic memorychip get banklabel, capacity, speed
echo.
pause
goto hardware_info

:disk_info
cls
echo ================================================================
echo                 硬盘信息
echo ================================================================
echo.
wmic diskdrive get model, size, status
echo.
echo 磁盘分区信息:
wmic partition get deviceid, diskindex, size, type
echo.
pause
goto hardware_info

:graphics_info
cls
echo ================================================================
echo                 显卡信息
echo ================================================================
echo.
wmic path win32_videocontroller get name, adapterram, driverversion
echo.
pause
goto hardware_info

:motherboard_info
cls
echo ================================================================
echo                 主板信息
echo ================================================================
echo.
wmic baseboard get product, manufacturer, version
echo.
wmic bios get manufacturer, version, releasedate
echo.
pause
goto hardware_info

:network_info
cls
echo ================================================================
echo                 网络信息
echo ================================================================
echo.
ipconfig /all
echo.
echo 网络连接状态:
netstat -an | findstr /C:"ESTABLISHED"
echo.
pause
goto system_info

:software_info
cls
echo ================================================================
echo                 软件信息
echo ================================================================
echo.
echo    [1] 已安装程序        [2] 服务信息
echo    [3] 启动项信息        [4] 返回上一级
echo.
echo ================================================================
echo.

choice /C 1234 /N /M "请选择软件类别 [1-4]: "

if errorlevel 4 goto system_info
if errorlevel 3 goto startup_info
if errorlevel 2 goto service_info
if errorlevel 1 goto installed_software

:installed_software
cls
echo ================================================================
echo                 已安装程序
echo ================================================================
echo.
wmic product get name, version, vendor
echo.
pause
goto software_info

:service_info
cls
echo ================================================================
echo                 服务信息
echo ================================================================
echo.
echo    [1] 所有服务          [2] 正在运行的服务
echo    [3] 已停止的服务      [4] 返回上一级
echo.
echo ================================================================
echo.

choice /C 1234 /N /M "请选择服务类别 [1-4]: "

if errorlevel 4 goto software_info
if errorlevel 3 goto stopped_services
if errorlevel 2 goto running_services
if errorlevel 1 goto all_services

:all_services
cls
echo ================================================================
echo                 所有服务
echo ================================================================
echo.
sc query
echo.
pause
goto service_info

:running_services
cls
echo ================================================================
echo               正在运行的服务
echo ================================================================
echo.
sc query state= running
echo.
pause
goto service_info

:stopped_services
cls
echo ================================================================
echo               已停止的服务
echo ================================================================
echo.
sc query state= stopped
echo.
pause
goto service_info

:startup_info
cls
echo ================================================================
echo                 启动项信息
echo ================================================================
echo.
echo 注册表启动项:
reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
echo.
echo 计划任务启动项:
schtasks /query /fo LIST /v | findstr /C:"TaskName" /C:"Next Run Time" /C:"Status"
echo.
pause
goto software_info

:system_logs
cls
echo ================================================================
echo                 系统日志
echo ================================================================
echo.
echo    [1] 系统日志          [2] 应用程序日志
echo    [3] 安全日志          [4] 安装日志
echo    [5] 返回上一级
echo.
echo ================================================================
echo.

choice /C 12345 /N /M "请选择日志类别 [1-5]: "

if errorlevel 5 goto system_info
if errorlevel 4 goto setup_logs
if errorlevel 3 goto security_logs
if errorlevel 2 goto application_logs
if errorlevel 1 goto system_event_logs

:system_event_logs
cls
echo ================================================================
echo                 系统日志
echo ================================================================
echo.
echo 正在打开系统事件日志查看器...
eventvwr.msc /c:System
echo.
pause
goto system_logs

:application_logs
cls
echo ================================================================
echo               应用程序日志
echo ================================================================
echo.
echo 正在打开应用程序事件日志查看器...
eventvwr.msc /c:Application
echo.
pause
goto system_logs

:security_logs
cls
echo ================================================================
echo                 安全日志
echo ================================================================
echo.
echo 正在打开安全事件日志查看器...
eventvwr.msc /c:Security
echo.
pause
goto system_logs

:setup_logs
cls
echo ================================================================
echo                 安装日志
echo ================================================================
echo.
echo 正在打开安装事件日志查看器...
eventvwr.msc /c:Setup
echo.
pause
goto system_logs

:settings_menu
cls
echo ================================================================
echo                系统设置工具
echo ================================================================
echo.
echo    [1] 显示设置          [2] 声音设置
echo    [3] 电源设置          [4] 网络设置
echo    [5] 时间和日期        [6] 用户账户管理
echo    [7] 返回主菜单
echo.
echo ================================================================
echo.

choice /C 1234567 /N /M "请选择设置项目 [1-7]: "

if errorlevel 7 goto main_menu
if errorlevel 6 goto user_accounts
if errorlevel 5 goto time_date
if errorlevel 4 goto network_settings
if errorlevel 3 goto power_settings
if errorlevel 2 goto sound_settings
if errorlevel 1 goto display_settings

:display_settings
cls
echo ================================================================
echo                 显示设置
echo ================================================================
echo.
echo 正在打开显示设置...
control display
echo.
pause
goto settings_menu

:sound_settings
cls
echo ================================================================
echo                 声音设置
echo ================================================================
echo.
echo 正在打开声音设置...
control mmsys.cpl sounds
echo.
pause
goto settings_menu

:power_settings
cls
echo ================================================================
echo                 电源设置
echo ================================================================
echo.
echo    [1] 查看电源计划      [2] 修改电源计划
echo    [3] 创建电源计划      [4] 高级电源设置
echo    [5] 返回上一级
echo.
echo ================================================================
echo.

choice /C 12345 /N /M "请选择操作 [1-5]: "

if errorlevel 5 goto settings_menu
if errorlevel 4 goto advanced_power
if errorlevel 3 goto create_power_plan
if errorlevel 2 goto change_power_plan
if errorlevel 1 goto view_power_plans

:view_power_plans
cls
echo ================================================================
echo                 电源计划
echo ================================================================
echo.
powercfg /list
echo.
pause
goto power_settings

:change_power_plan
cls
echo ================================================================
echo               修改电源计划
echo ================================================================
echo.
echo 当前电源计划:
powercfg /list
echo.
set /p plan_guid="请输入需要使用的电源计划GUID: "
echo.
powercfg /setactive %plan_guid%
echo.
echo 电源计划已修改！
echo.
pause
goto power_settings

:create_power_plan
cls
echo ================================================================
echo               创建电源计划
echo ================================================================
echo.
set /p plan_name="请输入新的电源计划名称: "
set /p base_plan="请输入基准电源计划GUID (留空使用平衡计划): "
echo.
if "%base_plan%"=="" (
    powercfg /duplicateplan balanced %plan_name%
) else (
    powercfg /duplicateplan %base_plan% %plan_name%
)
echo.
echo 电源计划已创建！
echo.
pause
goto power_settings

:advanced_power
cls
echo ================================================================
echo             高级电源设置
echo ================================================================
echo.
echo 正在打开高级电源设置...
powercfg.cpl
echo.
pause
goto power_settings

:network_settings
cls
echo ================================================================
echo                 网络设置
echo ================================================================
echo.
echo 正在打开网络连接设置...
control ncpa.cpl
echo.
pause
goto settings_menu

:time_date
cls
echo ================================================================
echo               时间和日期设置
echo ================================================================
echo.
echo 正在打开时间和日期设置...
control timedate.cpl
echo.
pause
goto settings_menu

:user_accounts
cls
echo ================================================================
echo               用户账户管理
echo ================================================================
echo.
echo 正在打开用户账户管理...
control userpasswords2
echo.
pause
goto settings_menu

:ai_chat
cls
echo ================================================================
echo                AI 对话   API连接
echo ================================================================
echo.
echo    请选择大模型厂商：
echo.
echo    [1] DeepSeek         [2] 智谱GLM
echo    [3] 返回主菜单
echo.
echo ================================================================
echo.

choice /C 123 /N /M "请选择 [1-3]: "

if errorlevel 3 goto main_menu
if errorlevel 2 goto ai_glm
if errorlevel 1 goto ai_deepseek

:ai_deepseek
cls
echo ================================================================
echo           DeepSeek 模型选择
echo ================================================================
echo.
echo    请选择模型：
echo.
echo    [1] deepseek-chat        (通用对话)
echo    [2] deepseek-reasoner    (深度推理 R1)
echo    [3] 自定义模型名称
echo    [4] 返回上一级
echo.
echo ================================================================
echo.

choice /C 1234 /N /M "请选择 [1-4]: "

if errorlevel 4 goto ai_chat
if errorlevel 3 goto ai_ds_custom
if errorlevel 2 goto ai_ds_r1
if errorlevel 1 goto ai_ds_chat

:ai_ds_custom
set "ai_model="
set /p ai_model="请输入 DeepSeek 模型名称: "
goto ai_ds_key

:ai_ds_r1
set ai_model=deepseek-reasoner
goto ai_ds_key

:ai_ds_chat
set ai_model=deepseek-chat
goto ai_ds_key

:ai_ds_key
cls
echo ================================================================
echo           DeepSeek API 密钥配置
echo ================================================================
echo.
echo  提示：密钥仅用于本次会话，不会保存到磁盘。
echo  获取密钥：https://platform.deepseek.com/api_keys
echo.
set "ai_key="
set /p ai_key="请输入 DeepSeek API Key: "
if "%ai_key%"=="" goto ai_ds_err
set ai_provider=DeepSeek
set ai_base=https://api.deepseek.com/v1
goto ai_connect

:ai_ds_err
echo.
echo [错误] API Key 不能为空！
pause
goto ai_deepseek

:ai_glm
cls
echo ================================================================
echo           智谱GLM 模型选择
echo ================================================================
echo.
echo    请选择模型：
echo.
echo    [1] glm-4-plus          (通用大模型)
echo    [2] glm-4-air           (轻量高效)
echo    [3] glm-4-flash         (免费极速)
echo    [4] glm-4-long          (长文本)
echo    [5] glm-4               (标准版)
echo    [6] 自定义模型名称
echo    [7] 返回上一级
echo.
echo ================================================================
echo.

choice /C 1234567 /N /M "请选择 [1-7]: "

if errorlevel 7 goto ai_chat
if errorlevel 6 goto ai_glm_custom
if errorlevel 5 goto ai_glm_4
if errorlevel 4 goto ai_glm_long
if errorlevel 3 goto ai_glm_flash
if errorlevel 2 goto ai_glm_air
if errorlevel 1 goto ai_glm_plus

:ai_glm_custom
set "ai_model="
set /p ai_model="请输入智谱GLM模型名称: "
goto ai_glm_key

:ai_glm_4
set ai_model=glm-4
goto ai_glm_key

:ai_glm_long
set ai_model=glm-4-long
goto ai_glm_key

:ai_glm_flash
set ai_model=glm-4-flash
goto ai_glm_key

:ai_glm_air
set ai_model=glm-4-air
goto ai_glm_key

:ai_glm_plus
set ai_model=glm-4-plus
goto ai_glm_key

:ai_glm_key
cls
echo ================================================================
echo           智谱GLM API 密钥配置
echo ================================================================
echo.
echo  提示：密钥仅用于本次会话，不会保存到磁盘。
echo  获取密钥：https://open.bigmodel.cn/usercenter/apikeys
echo.
set "ai_key="
set /p ai_key="请输入智谱GLM API Key: "
if "%ai_key%"=="" goto ai_glm_err
set ai_provider=智谱GLM
set ai_base=https://open.bigmodel.cn/api/paas/v4
goto ai_connect

:ai_glm_err
echo.
echo [错误] API Key 不能为空！
pause
goto ai_glm

:ai_connect
cls
echo ================================================================
echo           AI 对话助手 - 正在连接...
echo ================================================================
echo.
echo  厂商: %ai_provider%
echo  模型: %ai_model%
echo  接口: %ai_base%
echo.
echo  正在测试连接...

set AI_BASE=%ai_base%
set AI_KEY=%ai_key%
set AI_ACTION=connect

if exist "%TEMP%\ai_conn_result.txt" del "%TEMP%\ai_conn_result.txt" >nul 2>&1

start /wait "" pythonw "%~dp0ai_expand.exe"

if not exist "%TEMP%\ai_conn_result.txt" goto ai_conn_fail

findstr /B "OK" "%TEMP%\ai_conn_result.txt" >nul 2>&1
if errorlevel 1 goto ai_conn_error

echo.
echo  [连接成功]
echo  可用模型列表：
echo.
for /f "skip=1 tokens=*" %%M in ('type "%TEMP%\ai_conn_result.txt"') do echo    - %%M
echo.
echo  当前使用模型: %ai_model%
echo.
del "%TEMP%\ai_conn_result.txt" >nul 2>&1
pause
goto ai_chat_start

:ai_conn_fail
echo.
echo  [连接失败] 无法运行，请检查 Python 是否已安装。
echo.
if exist "%TEMP%\ai_conn_result.txt" del "%TEMP%\ai_conn_result.txt" >nul 2>&1
pause
goto ai_chat

:ai_conn_error
echo.
echo  [连接失败] API 返回错误：
echo.
for /f "skip=1 tokens=*" %%E in ('type "%TEMP%\ai_conn_result.txt"') do echo    %%E
echo.
echo  请检查 API Key 是否正确、账户是否有余额。
echo.
del "%TEMP%\ai_conn_result.txt" >nul 2>&1
pause
goto ai_chat

:ai_chat_start
echo.
echo  AI 对话助手 - %ai_provider% / %ai_model%
echo  命令: /quit=/返回  /exit=/退出  /clear=/清空历史  /model=/切换模型
echo.

echo []> "%TEMP%\ai_history.json"

:ai_chat_input
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set "ai_input="
set /p ai_input="用户: "
if "%ai_input%"=="" goto ai_chat_input

if /I "%ai_input%"=="/quit" goto ai_cmd_quit
if /I "%ai_input%"=="/exit" goto ai_cmd_exit
if /I "%ai_input%"=="/clear" goto ai_cmd_clear
if /I "%ai_input%"=="/model" goto ai_cmd_model

<nul set /p dummy=%ai_input%> "%TEMP%\ai_user_input.txt"

echo.
echo  AI 正在思考...

set AI_BASE=%ai_base%
set AI_MODEL=%ai_model%
set AI_KEY=%ai_key%
set AI_ACTION=chat

if exist "%TEMP%\ai_reply.txt" del "%TEMP%\ai_reply.txt" >nul 2>&1

start /wait "" pythonw "%~dp0ai_expand.py"

if not exist "%TEMP%\ai_reply.txt" goto ai_no_reply

echo.
echo AI:
powershell -NoProfile -Command "Get-Content -Path '%TEMP%\ai_reply.txt' -Encoding UTF8 -Raw" 2>nul
if errorlevel 1 type "%TEMP%\ai_reply.txt"
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
del "%TEMP%\ai_reply.txt" >nul 2>&1

goto ai_chat_input

:ai_no_reply
echo.
echo  [错误] 未收到回复，请检查网络或 API Key。
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
goto ai_chat_input

:ai_cmd_quit
del "%TEMP%\ai_history.json" >nul 2>&1
del "%TEMP%\ai_user_input.txt" >nul 2>&1
del "%TEMP%\ai_reply.txt" >nul 2>&1
goto ai_chat

:ai_cmd_exit
del "%TEMP%\ai_history.json" >nul 2>&1
del "%TEMP%\ai_user_input.txt" >nul 2>&1
del "%TEMP%\ai_reply.txt" >nul 2>&1
goto exit

:ai_cmd_clear
echo []> "%TEMP%\ai_history.json"
echo.
echo  [对话历史已清空]
goto ai_chat_input

:ai_cmd_model
del "%TEMP%\ai_history.json" >nul 2>&1
del "%TEMP%\ai_user_input.txt" >nul 2>&1
del "%TEMP%\ai_reply.txt" >nul 2>&1
if "%ai_provider%"=="DeepSeek" goto ai_deepseek
if "%ai_provider%"=="智谱GLM" goto ai_glm
goto ai_chat

:dev_tools
cls
echo ================================================================
echo                开发者工具
echo ================================================================
echo.
echo    [1] 开发环境检测      [2] 端口与进程管理
echo    [3] Git 快捷操作      [4] HTTP 请求测试
echo    [5] 环境变量管理      [6] hosts 文件管理
echo    [7] 文本处理工具      [8] 快捷启动开发工具
echo    [9] 返回主菜单
echo.
echo ================================================================
echo.

choice /C 123456789 /N /M "请选择开发者工具 [1-9]: "

if errorlevel 9 goto main_menu
if errorlevel 8 goto dev_quick_launch
if errorlevel 7 goto text_tools
if errorlevel 6 goto hosts_manager
if errorlevel 5 goto env_var_manager
if errorlevel 4 goto http_test
if errorlevel 3 goto git_tools
if errorlevel 2 goto port_process
if errorlevel 1 goto dev_env_check

:dev_env_check
cls
echo ================================================================
echo                开发环境检测
echo ================================================================
echo.
echo 正在检测常用开发工具，请稍候...
echo.
echo  [运行时 / 语言]
call :check_tool node -v
call :check_tool npm -v
call :check_tool yarn -v
call :check_tool pnpm -v
call :check_tool python --version
call :check_tool pip --version
call :check_tool java -version
call :check_tool go version
call :check_tool dotnet --version
call :check_tool rustc --version
call :check_tool gcc --version
call :check_tool g++ --version
echo.
echo  [版本控制 / 容器 / 构建]
call :check_tool git --version
call :check_tool docker --version
call :check_tool kubectl version --client
call :check_tool make --version
call :check_tool cmake --version
echo.
echo  [编辑器 / 包管理]
call :check_tool code --version
call :check_tool nvim --version
call :check_tool vim --version
echo.
echo ================================================================
echo 检测完成！ [已安装] 以显示版本号与路径
echo ================================================================
echo.
pause
goto dev_tools

:check_tool
where %~1 >nul 2>&1
if errorlevel 1 (
    echo    [未安装] %~1
    exit /b 0
)
for /f "delims=" %%v in ('%~1 %~2 2^>^&1') do (
    echo    [已安装] %~1  --  %%v
    exit /b 0
)
exit /b 0

:port_process
cls
echo ================================================================
echo              端口与进程管理
echo ================================================================
echo.
echo    [1] 查看所有监听端口
echo    [2] 查看指定端口占用的进程
echo    [3] 结束占用指定端口的进程
echo    [4] 结束指定名称的进程
echo    [5] 返回上一级
echo.
echo ================================================================
echo.

choice /C 12345 /N /M "请选择操作 [1-5]: "

if errorlevel 5 goto dev_tools
if errorlevel 4 goto kill_by_name
if errorlevel 3 goto kill_by_port
if errorlevel 2 goto check_port
if errorlevel 1 goto list_ports

:list_ports
cls
echo ================================================================
echo              所有监听端口
echo ================================================================
echo.
echo 协议    本地地址           外部地址   状态      PID
netstat -ano | findstr LISTENING
echo.
pause
goto port_process

:check_port
cls
set /p chkport="请输入要查询的端口号: "
echo.
echo 占用端口 %chkport% 的连接:
echo.
netstat -ano | findstr :%chkport%
echo.
echo 进程详情:
for /f "tokens=5" %%p in ('netstat -ano ^| findstr :%chkport% ^| findstr LISTENING') do (
    tasklist /FI "PID eq %%p"
)
echo.
pause
goto port_process

:kill_by_port
cls
set /p killport="请输入要结束进程的端口号: "
echo.
echo 正在查找占用端口 %killport% 的进程...
echo.
echo 以下进程将被结束（预览）：
echo --------------------------------
for /f "tokens=5" %%p in ('netstat -ano ^| findstr :%killport% ^| findstr LISTENING') do (
    tasklist /FI "PID eq %%p" | findstr /C:".exe"
)
echo --------------------------------
echo.
choice /C YN /N /M "确认结束这些进程? [Y/N]: "
if errorlevel 2 goto port_process
echo.
for /f "tokens=5" %%p in ('netstat -ano ^| findstr :%killport% ^| findstr LISTENING') do (
    echo 正在结束 PID=%%p 的进程...
    taskkill /F /PID %%p
)
echo.
echo 操作完成！
echo.
pause
goto port_process

:kill_by_name
cls
set /p killname="请输入要结束的进程名 (例 node.exe): "
echo.
echo 以下进程将被结束（预览）：
echo --------------------------------
tasklist /FI "IMAGENAME eq %killname%" | findstr /C:".exe"
echo --------------------------------
echo.
choice /C YN /N /M "确认结束所有名为 %killname% 的进程? [Y/N]: "
if errorlevel 2 goto port_process
echo.
taskkill /F /IM %killname%
echo.
echo 操作完成！
echo.
pause
goto port_process

:git_tools
cls
echo ================================================================
echo              Git 快捷操作 (当前目录)
echo ================================================================
echo.
echo 当前目录: %cd%
echo.
echo    [1] 查看仓库状态 (git status)
echo    [2] 查看提交日志 (git log)
echo    [3] 查看当前分支 (git branch)
echo    [4] 查看远程仓库 (git remote -v)
echo    [5] 提交更改 (add + commit)
echo    [6] 推送到远程 (push)
echo    [7] 从远程拉取 (pull)
echo    [8] 查看差异 (git diff)
echo    [9] 返回上一级
echo.
echo ================================================================
echo.

choice /C 123456789 /N /M "请选择操作 [1-9]: "

if errorlevel 9 goto dev_tools
if errorlevel 8 goto git_diff
if errorlevel 7 goto git_pull
if errorlevel 6 goto git_push
if errorlevel 5 goto git_commit
if errorlevel 4 goto git_remote
if errorlevel 3 goto git_branch
if errorlevel 2 goto git_log
if errorlevel 1 goto git_status

:git_status
cls
echo ================================================================
echo             git status
echo ================================================================
echo.
git status
echo.
pause
goto git_tools

:git_log
cls
echo ================================================================
echo             git log (最近20条)
echo ================================================================
echo.
git log --oneline --graph -20
echo.
pause
goto git_tools

:git_branch
cls
echo ================================================================
echo             git branch
echo ================================================================
echo.
git branch -a
echo.
pause
goto git_tools

:git_remote
cls
echo ================================================================
echo             git remote -v
echo ================================================================
echo.
git remote -v
echo.
pause
goto git_tools

:git_commit
cls
echo ================================================================
echo             提交更改
echo ================================================================
echo.
echo 当前状态预览：
git status -s
echo.
set /p commit_msg="请输入提交信息 (commit message): "
echo.
choice /C YN /N /M "确认暂存所有更改并提交? [Y/N]: "
if errorlevel 2 goto git_tools
echo.
git add -A
git commit -m "%commit_msg%"
echo.
echo 提交完成！
echo.
pause
goto git_tools

:git_push
cls
echo ================================================================
echo             推送到远程
echo ================================================================
echo.
echo 正在推送到远程仓库...
git push
echo.
echo 推送完成！
echo.
pause
goto git_tools

:git_pull
cls
echo ================================================================
echo             从远程拉取
echo ================================================================
echo.
echo 正在从远程仓库拉取...
git pull
echo.
echo 拉取完成！
echo.
pause
goto git_tools

:git_diff
cls
echo ================================================================
echo             git diff
echo ================================================================
echo.
git diff
echo.
pause
goto git_tools

:http_test
cls
echo ================================================================
echo              HTTP 请求测试 (curl)
echo ================================================================
echo.
echo    [1] GET 请求并显示状态码/耗时
echo    [2] GET 请求显示响应内容
echo    [3] POST 请求 (JSON)
echo    [4] 查询公网IP
echo    [5] 返回上一级
echo.
echo ================================================================
echo.

choice /C 12345 /N /M "请选择操作 [1-5]: "

if errorlevel 5 goto dev_tools
if errorlevel 4 goto http_public_ip
if errorlevel 3 goto http_post
if errorlevel 2 goto http_get_body
if errorlevel 1 goto http_get_meta

:http_get_meta
cls
set /p url="请输入URL (例 http://localhost:3000/api): "
echo.
echo 请求信息:
curl -s -o NUL -w "  HTTP状态码: %%{http_code}  总耗时: %%{time_total}s  下载: %%{size_download}字节" %url%
echo.
echo.
pause
goto http_test

:http_get_body
cls
set /p url="请输入URL: "
echo.
echo 响应内容:
echo --------------------------------
curl -s %url%
echo.
echo --------------------------------
echo.
pause
goto http_test

:http_post
cls
set /p url="请输入URL: "
set /p json_data="请输入JSON数据 (例 {\"name\":\"test\"}): "
echo.
echo 正在发送POST请求...
echo --------------------------------
curl -s -X POST -H "Content-Type: application/json" -d "%json_data%" %url%
echo.
echo --------------------------------
echo.
pause
goto http_test

:http_public_ip
cls
echo ================================================================
echo             查询公网IP
echo ================================================================
echo.
echo IPv4: 
curl -s --max-time 10 https://api.ipify.org
echo.
echo.
echo IP 详情:
curl -s --max-time 10 https://ipinfo.io/json
echo.
echo.
pause
goto http_test

:env_var_manager
cls
echo ================================================================
echo              环境变量管理
echo ================================================================
echo.
echo    [1] 查看所有环境变量
echo    [2] 查看 PATH
echo    [3] 打开系统环境变量设置 (GUI)
echo    [4] 返回上一级
echo.
echo ================================================================
echo.

choice /C 1234 /N /M "请选择操作 [1-4]: "

if errorlevel 4 goto dev_tools
if errorlevel 3 goto env_gui
if errorlevel 2 goto env_path
if errorlevel 1 goto env_all

:env_all
cls
echo ================================================================
echo              所有环境变量
echo ================================================================
echo.
set
echo.
pause
goto env_var_manager

:env_path
cls
echo ================================================================
echo              PATH 环境变量
echo ================================================================
echo.
echo 用户 PATH:
for /f "tokens=2,*" %%a in ('reg query HKCU\Environment /v Path 2^>nul') do set "userpath=%%b"
echo %userpath%
echo.
echo 系统 PATH:
for /f "tokens=2,*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul') do set "syspath=%%b"
echo %syspath%
echo.
echo ================================================================
echo PATH 按分号拆分显示:
echo ================================================================
echo.
for %%p in ("%userpath:;=" "%") do echo   %%~p
echo.
pause
goto env_var_manager

:env_gui
cls
echo 正在打开系统环境变量设置...
rundll32.exe sysdm.cpl,EditEnvironmentVariables
echo.
pause
goto env_var_manager

:hosts_manager
cls
echo ================================================================
echo              hosts 文件管理
echo ================================================================
echo.
echo hosts 文件路径: C:\Windows\System32\drivers\etc\hosts
echo.
echo    [1] 查看 hosts 文件
echo    [2] 编辑 hosts 文件 (需管理员)
echo    [3] 刷新 DNS 缓存
echo    [4] 返回上一级
echo.
echo ================================================================
echo.

choice /C 1234 /N /M "请选择操作 [1-4]: "

if errorlevel 4 goto dev_tools
if errorlevel 3 goto hosts_flush
if errorlevel 2 goto hosts_edit
if errorlevel 1 goto hosts_view

:hosts_view
cls
echo ================================================================
echo              hosts 文件内容
echo ================================================================
echo.
type C:\Windows\System32\drivers\etc\hosts
echo.
pause
goto hosts_manager

:hosts_edit
cls
echo 正在以记事本打开 hosts 文件（需要管理员权限才能保存）...
echo.
notepad C:\Windows\System32\drivers\etc\hosts
echo.
echo 提示：保存后建议刷新DNS缓存。
echo.
pause
goto hosts_manager

:hosts_flush
cls
echo 正在刷新DNS缓存...
ipconfig /flushdns
echo.
echo DNS缓存已刷新！
echo.
pause
goto hosts_manager

:text_tools
cls
echo ================================================================
echo              文本处理工具
echo ================================================================
echo.
echo    [1] JSON 格式化 (文件)
echo    [2] Base64 编码
echo    [3] Base64 解码
echo    [4] 计算文本哈希 (MD5/SHA1/SHA256)
echo    [5] 返回上一级
echo.
echo ================================================================
echo.

choice /C 12345 /N /M "请选择操作 [1-5]: "

if errorlevel 5 goto dev_tools
if errorlevel 4 goto text_hash
if errorlevel 3 goto base64_decode
if errorlevel 2 goto base64_encode
if errorlevel 1 goto json_format

:json_format
cls
set /p jsonfile="请输入JSON文件路径: "
echo.
echo 格式化结果:
echo --------------------------------
powershell -NoProfile -Command "Get-Content -Raw -Encoding UTF8 '%jsonfile%' | ConvertFrom-Json | ConvertTo-Json -Depth 20"
echo --------------------------------
echo.
pause
goto text_tools

:base64_encode
cls
set /p b64text="请输入要编码的文本: "
echo.
echo Base64 编码结果:
powershell -NoProfile -Command "[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes('%b64text%'))"
echo.
echo.
pause
goto text_tools

:base64_decode
cls
set /p b64text="请输入要解码的Base64字符串: "
echo.
echo Base64 解码结果:
powershell -NoProfile -Command "[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('%b64text%'))"
echo.
echo.
pause
goto text_tools

:text_hash
cls
set /p hashtext="请输入要计算哈希的文本: "
echo.
echo 文本哈希值:
echo   MD5:
powershell -NoProfile -Command "$i='%hashtext%'; [BitConverter]::ToString([Security.Cryptography.MD5]::Create().ComputeHash([Text.Encoding]::UTF8.GetBytes($i))).Replace('-','').ToLower()"
echo.
echo   SHA256:
powershell -NoProfile -Command "$i='%hashtext%'; [BitConverter]::ToString([Security.Cryptography.SHA256]::Create().ComputeHash([Text.Encoding]::UTF8.GetBytes($i))).Replace('-','').ToLower()"
echo.
echo.
pause
goto text_tools

:dev_quick_launch
cls
echo ================================================================
echo              快捷启动开发工具
echo ================================================================
echo.
echo    [1] VS Code            [2] Windows Terminal
echo    [3] 命令提示符         [4] PowerShell
echo    [5] 资源管理器         [6] 记事本
echo    [7] 计算器             [8] 返回上一级
echo.
echo ================================================================
echo.

choice /C 12345678 /N /M "请选择要启动的工具 [1-8]: "

if errorlevel 8 goto dev_tools
if errorlevel 7 goto launch_calc
if errorlevel 6 goto launch_notepad
if errorlevel 5 goto launch_explorer
if errorlevel 4 goto launch_powershell
if errorlevel 3 goto launch_cmd
if errorlevel 2 goto launch_wt
if errorlevel 1 goto launch_code

:launch_code
cls
echo 正在启动 VS Code...
where code >nul 2>&1
if %errorlevel%==0 (
    start "" code
    echo VS Code 已启动。
) else (
    echo 未找到 VS Code 命令行工具，请确认已安装并加入 PATH。
    echo 也可以从开始菜单手动启动。
)
echo.
pause
goto dev_quick_launch

:launch_wt
cls
echo 正在启动 Windows Terminal...
where wt >nul 2>&1
if %errorlevel%==0 (
    start "" wt
    echo Windows Terminal 已启动。
) else (
    echo 未找到 Windows Terminal，请从 Microsoft Store 安装。
)
echo.
pause
goto dev_quick_launch

:launch_cmd
cls
echo 正在启动命令提示符...
start "" cmd.exe
echo.
pause
goto dev_quick_launch

:launch_powershell
cls
echo 正在启动 PowerShell...
start "" powershell.exe
echo.
pause
goto dev_quick_launch

:launch_explorer
cls
echo 正在启动资源管理器...
start "" explorer.exe
echo.
pause
goto dev_quick_launch

:launch_notepad
cls
echo 正在启动记事本...
start "" notepad.exe
echo.
pause
goto dev_quick_launch

:launch_calc
cls
echo 正在启动计算器...
start "" calc.exe
echo.
pause
goto dev_quick_launch

:exit
cls
echo ================================================================
echo          感谢使用 Windows 工具箱 v3.0
echo ================================================================
echo.
echo 正在准备退出...
timeout /t 2 >nul
exit /b 0
