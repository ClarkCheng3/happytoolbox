@echo off
setlocal enabledelayedexpansion
title Windows实用工具箱 v2.1

:: 颜色设置 - 背景蓝色，文字白色
color 1F

:: 检查管理员权限
fltmc >nul 2>&1 || (
    echo 警告：此工具箱部分功能需要管理员权限。
    echo 请右键选择"以管理员身份运行"以获得完整功能。
    echo.
    pause
)

:main_menu
cls
echo =================================================
echo           Windows 实用工具箱 v2.1
echo =================================================
echo.
echo   [1] 系统优化工具       [2] 网络诊断工具
echo   [3] 文件管理工具       [4] 安全维护工具
echo   [5] 磁盘管理工具       [6] 系统信息工具
echo   [7] 快捷设置工具       [8] 关于工具箱
echo   [9] 其他实用工具       [0] 退出工具箱
echo.
echo GitHub仓库：https://github.com/ClarkCheng3/happytoolbox
echo =================================================
echo  提示：部分功能需要管理员权限才能正常运行。
echo =================================================
echo.

choice /C 1234567890 /N /M "请选择功能 [1-9,0]: "

if errorlevel 10 goto exit
if errorlevel 9 goto other_tools
if errorlevel 8 goto toolbox_info
if errorlevel 7 goto settings_menu
if errorlevel 6 goto system_info
if errorlevel 5 goto disk_tools
if errorlevel 4 goto security_tools
if errorlevel 3 goto file_tools
if errorlevel 2 goto network_tools
if errorlevel 1 goto system_optimize

:: 系统优化工具
:system_optimize
cls
echo =================================================
echo               系统优化工具
echo =================================================
echo.
echo   [1] 清理临时文件       [2] 磁盘碎片整理
echo   [3] 禁用系统休眠       [4] 系统性能优化
echo   [5] 系统服务优化       [6] 恢复默认设置
echo   [7] 返回主菜单
echo.
echo =================================================
echo.

choice /C 1234567 /N /M "请选择优化功能 [1-7]: "

if errorlevel 7 goto main_menu
if errorlevel 6 goto restore_defaults
if errorlevel 5 goto service_optimize
if errorlevel 4 goto performance_optimize
if errorlevel 3 goto disable_hibernation
if errorlevel 2 goto defrag_disk
if errorlevel 1 goto clean_temp_files

:clean_temp_files
cls
echo 正在清理系统临时文件...
echo.
rd /S /Q "%temp%" 2>nul
del /F /S /Q "%windir%\temp\*.*" 2>nul
del /F /S /Q "%windir%\prefetch\*.*" 2>nul
echo.
echo 系统临时文件清理完成！
echo.
pause
goto system_optimize

:defrag_disk
cls
echo =================================================
echo             磁盘碎片整理工具
echo =================================================
echo.
echo 当前系统磁盘信息：
wmic logicaldisk where drivetype=3 get deviceid, volumename, freespace, size
echo.
set /p drive="请输入要整理的驱动器号 (例如 C): "
echo.
echo 正在对 %drive%: 进行碎片整理... 这可能需要一段时间。
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
    echo 系统休眠已启用，正在禁用...
    powercfg /h off
    echo.
    echo 系统休眠已禁用！
) else (
    echo 系统休眠已禁用！
)
echo.
pause
goto system_optimize

:performance_optimize
cls
echo =================================================
echo             系统性能优化
echo =================================================
echo.
echo 正在调整系统性能设置以提高速度...
echo.
:: 设置性能选项为"调整为最佳性能"
systempropertiesperformance.exe /p /d
echo.
echo 系统性能设置已优化！
echo.
pause
goto system_optimize

:service_optimize
cls
echo =================================================
echo             系统服务优化
echo =================================================
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
    :: 禁用一些常见的非关键服务
    sc config wuauserv start= disabled >nul 2>&1  :: Windows Update
    sc config Superfetch start= disabled >nul 2>&1  :: 预取
    sc config HomeGroupListener start= disabled >nul 2>&1  :: 家庭组
    sc config HomeGroupProvider start= disabled >nul 2>&1  :: 家庭组
    sc config XboxLiveAuthManager start= disabled >nul 2>&1  :: Xbox服务
    sc config XboxNetApiSvc start= disabled >nul 2>&1  :: Xbox网络服务
    echo.
    echo 系统服务优化完成！
)
echo.
pause
goto system_optimize

:restore_defaults
cls
echo =================================================
echo           恢复系统默认设置
echo =================================================
echo.
echo 警告：此操作将恢复所有优化设置为默认值！
echo.
choice /C YN /N /M "是否继续? [Y/N]: "
if errorlevel 2 goto system_optimize
if errorlevel 1 (
    echo.
    echo 正在恢复系统默认设置...
    echo.
    :: 恢复一些优化设置为默认值
    sc config wuauserv start= auto >nul 2>&1  :: Windows Update
    sc config Superfetch start= auto >nul 2>&1  :: 预取
    powercfg /h on >nul 2>&1  :: 启用休眠
    echo.
    echo 系统设置已恢复为默认值！
)
echo.
pause
goto system_optimize

:: 网络诊断工具
:network_tools
cls
echo =================================================
echo               网络诊断工具
echo =================================================
echo.
echo   [1] 网络连接测试       [2] IP配置信息
echo   [3] DNS刷新工具       [4] 端口扫描工具
echo   [5] 路由追踪工具       [6] WiFi密码查看
echo   [7] 返回主菜单
echo.
echo =================================================
echo.

choice /C 1234567 /N /M "请选择网络工具 [1-7]: "

if errorlevel 7 goto main_menu
if errorlevel 6 goto wifi_passwords
if errorlevel 5 goto trace_route
if errorlevel 4 goto port_scan
if errorlevel 3 goto flush_dns
if errorlevel 2 goto ip_config
if errorlevel 1 goto network_test

:network_test
cls
echo =================================================
echo              网络连接测试
echo =================================================
echo.
echo 正在测试网络连接，请稍候...
echo.
ping www.baidu.com -n 4 >nul
if %errorlevel%==0 (
    echo 恭喜！您的网络连接正常。
) else (
    echo 网络连接测试失败！请检查您的网络设置。
)
echo.
echo 正在测试本地连接...
ping 127.0.0.1 -n 4 >nul
if %errorlevel%==0 (
    echo 本地回环测试正常。
) else (
    echo 本地回环测试失败！网络适配器可能有问题。
)
echo.
pause
goto network_tools

:ip_config
cls
echo =================================================
echo              IP配置信息
echo =================================================
echo.
ipconfig /all
echo.
pause
goto network_tools

:flush_dns
cls
echo =================================================
echo               DNS刷新工具
echo =================================================
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
echo =================================================
echo               端口扫描工具
echo =================================================
echo.
set /p target="请输入要扫描的目标IP地址 (例如 192.168.1.1): "
echo.
echo 正在扫描 %target% 的常用端口...
echo.
echo 端口扫描结果:
echo ------------------------
for /L %%p in (20,1,1024) do (
    start /b /wait cmd /c "(echo open %target% %%p) | (telnet.exe) >nul 2>&1 && echo 端口 %%p 是开放的"
)
echo ------------------------
echo.
echo 端口扫描完成！
echo.
pause
goto network_tools

:trace_route
cls
echo =================================================
echo               路由追踪工具
echo =================================================
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
echo =================================================
echo             WiFi密码查看工具
echo =================================================
echo.
echo 正在获取已保存的WiFi网络信息...
echo.
netsh wlan show profiles
echo.
set /p wifi_name="请输入要查看密码的WiFi名称: "
echo.
netsh wlan show profile name="%wifi_name%" key=clear | findstr "关键内容"
echo.
pause
goto network_tools

:: 文件管理工具
:file_tools
cls
echo =================================================
echo               文件管理工具
echo =================================================
echo.
echo   [1] 文件搜索工具       [2] 文件批量重命名
echo   [3] 文件加密工具       [4] 文件哈希校验
echo   [5] 大文件查找工具     [6] 文件压缩工具
echo   [7] 返回主菜单
echo.
echo =================================================
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
echo =================================================
echo               文件搜索工具
echo =================================================
echo.
set /p search_dir="请输入搜索目录 (例如 C:\Users): "
set /p search_text="请输入要搜索的文件名或内容: "
echo.
echo 正在搜索文件，请稍候...
echo.
dir /s /b "%search_dir%\*%search_text%*"
echo.
echo 文件搜索完成！
echo.
pause
goto file_tools

:batch_rename
cls
echo =================================================
echo             文件批量重命名工具
echo =================================================
echo.
set /p rename_dir="请输入要重命名文件的目录: "
set /p old_text="请输入要替换的文本: "
set /p new_text="请输入替换后的文本: "
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
echo =================================================
echo               文件加密工具
echo =================================================
echo.
echo 警告：此工具使用简单的加密方法，不适合高度敏感数据！
echo.
set /p encrypt_file="请输入要加密的文件路径: "
set /p password="请输入加密密码: "
echo.
echo 正在加密文件...
certutil -encode "%encrypt_file%" "%encrypt_file%.enc" >nul
del /F "%encrypt_file%"
echo.
echo 文件已加密为: %encrypt_file%.enc
echo.
pause
goto file_tools

:file_hash
cls
echo =================================================
echo               文件哈希校验
echo =================================================
echo.
set /p hash_file="请输入要校验的文件路径: "
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
echo =================================================
echo             大文件查找工具
echo =================================================
echo.
set /p large_dir="请输入要搜索的目录 (例如 C:\): "
set /p size_limit="请输入文件大小限制 (MB): "
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
echo =================================================
echo               文件压缩工具
echo =================================================
echo.
set /p zip_dir="请输入要压缩的文件或目录: "
set /p zip_file="请输入压缩文件名 (例如 archive.zip): "
echo.
echo 正在压缩文件，请稍候...
echo.
powershell -command "Compress-Archive -Path '%zip_dir%' -DestinationPath '%zip_file%' -Force"
echo.
echo 文件压缩完成！
echo.
pause
goto file_tools

:: 安全维护工具
:security_tools
cls
echo =================================================
echo               安全维护工具
echo =================================================
echo.
echo   [1] 系统病毒扫描       [2] 恶意软件清除
echo   [3] 防火墙设置         [4] 账户密码修改
echo   [5] 系统还原点         [6] UAC设置
echo   [7] 返回主菜单
echo.
echo =================================================
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
echo =================================================
echo               系统病毒扫描
echo =================================================
echo.
echo 警告：此操作将调用Windows Defender进行系统扫描。
echo 这可能需要较长时间，取决于系统大小和性能。
echo.
choice /C YN /N /M "是否继续? [Y/N]: "
if errorlevel 2 goto security_tools
if errorlevel 1 (
    echo.
    echo 正在启动系统病毒扫描...
    echo.
    Start-MpScan -ScanType FullScan
    echo.
    echo 系统病毒扫描已启动！
    echo 您可以在Windows安全中心查看扫描进度。
)
echo.
pause
goto security_tools

:malware_scan
cls
echo =================================================
echo             恶意软件清除工具
echo =================================================
echo.
echo 正在检查系统是否安装了Microsoft Safety Scanner...
echo.
where mssacli.exe >nul 2>&1
if %errorlevel%==0 (
    echo 已安装Microsoft Safety Scanner，正在启动扫描...
    mssacli.exe /scan /full
) else (
    echo 未安装Microsoft Safety Scanner，将打开下载页面。
    echo 请下载并安装后再运行此工具。
    start https://www.microsoft.com/security/scanner
)
echo.
pause
goto security_tools

:firewall_settings
cls
echo =================================================
echo               防火墙设置
echo =================================================
echo.
echo   [1] 启用防火墙         [2] 禁用防火墙
echo   [3] 查看防火墙状态     [4] 返回上一级
echo.
echo =================================================
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
echo 警告：禁用防火墙会使系统面临安全风险！
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
echo =================================================
echo             Windows Defender防火墙状态
echo =================================================
echo.
netsh advfirewall show allprofiles
echo.
pause
goto firewall_settings

:change_password
cls
echo =================================================
echo               账户密码修改
echo =================================================
echo.
net user
echo.
set /p username="请输入要修改密码的用户名: "
echo.
echo 请输入新密码（不会显示在屏幕上）。
echo.
net user %username% *
echo.
echo 密码修改完成！
echo.
pause
goto security_tools

:system_restore
cls
echo =================================================
echo               系统还原点
echo =================================================
echo.
echo   [1] 创建还原点         [2] 查看还原点
echo   [3] 系统还原           [4] 返回上一级
echo.
echo =================================================
echo.

choice /C 1234 /N /M "请选择操作 [1-4]: "

if errorlevel 4 goto security_tools
if errorlevel 3 goto restore_system
if errorlevel 2 goto view_restore_points
if errorlevel 1 goto create_restore_point

:create_restore_point
cls
echo =================================================
echo             创建系统还原点
echo =================================================
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
echo =================================================
echo             查看系统还原点
echo =================================================
echo.
powershell -command "Get-ComputerRestorePoint"
echo.
pause
goto system_restore

:restore_system
cls
echo =================================================
echo               系统还原
echo =================================================
echo.
echo 警告：系统还原将把您的计算机还原到以前的状态。
echo 您安装的程序和个人文件不会被删除，但某些设置可能会更改。
echo.
choice /C YN /N /M "是否继续? [Y/N]: "
if errorlevel 2 goto system_restore
if errorlevel 1 (
    echo.
    echo 正在启动系统还原向导...
    rstrui.exe
    echo.
    echo 系统还原向导已启动！
)
echo.
pause
goto system_restore

:uac_settings
cls
echo =================================================
echo               UAC设置
echo =================================================
echo.
echo   [1] 高 (始终通知)      [2] 中 (默认设置)
echo   [3] 低 (仅在程序尝试更改系统时通知)
echo   [4] 关闭UAC (不推荐)   [5] 返回上一级
echo.
echo =================================================
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
echo UAC设置已更新！
echo 更改将在下次登录时生效。
echo.
pause
goto uac_settings

:uac_medium
cls
echo 正在设置UAC为中级别 (默认设置)...
powershell -command "Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 5"
echo.
echo UAC设置已更新！
echo 更改将在下次登录时生效。
echo.
pause
goto uac_settings

:uac_low
cls
echo 正在设置UAC为低级别 (仅在程序尝试更改系统时通知)...
powershell -command "Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 1"
echo.
echo UAC设置已更新！
echo 更改将在下次登录时生效。
echo.
pause
goto uac_settings

:uac_off
cls
echo 警告：关闭UAC会使系统面临安全风险！
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

:: 磁盘管理工具
:disk_tools
cls
echo =================================================
echo               磁盘管理工具
echo =================================================
echo.
echo   [1] 磁盘检查工具       [2] 磁盘清理工具
echo   [3] 磁盘空间分析       [4] 分区管理工具
echo   [5] 磁盘格式化工具     [6] 返回主菜单
echo.
echo =================================================
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
echo =================================================
echo               磁盘检查工具
echo =================================================
echo.
echo 当前系统磁盘信息：
wmic logicaldisk where drivetype=3 get deviceid, volumename, freespace, size
echo.
set /p drive="请输入要检查的驱动器号 (例如 C): "
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
echo =================================================
echo               磁盘清理工具
echo =================================================
echo.
echo 当前系统磁盘信息：
wmic logicaldisk where drivetype=3 get deviceid, volumename, freespace, size
echo.
set /p drive="请输入要清理的驱动器号 (例如 C): "
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
echo =================================================
echo               磁盘空间分析
echo =================================================
echo.
echo 正在检查系统是否安装了WinDirStat...
echo.
where wds.exe >nul 2>&1
if %errorlevel%==0 (
    echo 已安装WinDirStat，正在启动...
    wds.exe
) else (
    echo 未安装WinDirStat，将打开下载页面。
    echo 请下载并安装后再运行此工具。
    start https://windirstat.net/
)
echo.
pause
goto disk_tools

:partition_manager
cls
echo =================================================
echo               分区管理工具
echo =================================================
echo.
echo 警告：此操作将打开磁盘管理控制台。
echo 不正确的操作可能导致数据丢失！
echo.
choice /C YN /N /M "是否继续? [Y/N]: "
if errorlevel 2 goto disk_tools
if errorlevel 1 (
    echo.
    echo 正在启动磁盘管理控制台...
    diskmgmt.msc
    echo.
    echo 磁盘管理控制台已启动！
)
echo.
pause
goto disk_tools

:format_disk
cls
echo =================================================
echo               磁盘格式化工具
echo =================================================
echo.
echo 警告：格式化会删除磁盘上的所有数据！
echo 请确保您已备份重要数据。
echo.
echo 当前系统磁盘信息：
wmic logicaldisk where drivetype=3 get deviceid, volumename, freespace, size
echo.
set /p drive="请输入要格式化的驱动器号 (例如 D): "
echo.
choice /C YN /N /M "确定要格式化 %drive%: 吗? [Y/N]: "
if errorlevel 2 goto disk_tools
if errorlevel 1 (
    echo.
    echo 请选择文件系统:
    echo   [1] NTFS   [2] FAT32   [3] exFAT
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

:: 系统信息工具
:system_info
cls
echo =================================================
echo               系统信息工具
echo =================================================
echo.
echo   [1] 系统信息      
echo   [2] 系统日志              [3] 返回主菜单
echo.
echo =================================================
echo.

choice /C 123 /N /M "请选择 [1-3]: "

if errorlevel 3 goto main_menu
if errorlevel 2 goto system_logs
if errorlevel 1 goto basic_info

:basic_info
cls
echo =================================================
echo               基本系统信息
echo =================================================
echo.
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type" /C:"Total Physical Memory"
echo.
echo 计算机名称: %COMPUTERNAME%
echo 当前用户: %USERNAME%
echo 当前日期: %DATE%
echo 当前时间: %TIME%
echo.
pause
goto system_info

echo =================================================
echo               系统日志
echo =================================================
echo.
echo   [1] 系统日志           [2] 应用程序日志
echo   [3] 安全日志           [4] 安装日志
echo   [5] 返回上一级
echo.
echo =================================================
echo.

choice /C 12345 /N /M "请选择日志类别 [1-5]: "

if errorlevel 5 goto system_info
if errorlevel 4 goto setup_logs
if errorlevel 3 goto security_logs
if errorlevel 2 goto application_logs
if errorlevel 1 goto system_event_logs

:system_event_logs
cls
echo =================================================
echo               系统日志
echo =================================================
echo.
echo 正在启动系统事件日志查看器...
eventvwr.msc /c:System
echo.
pause
goto system_logs

:application_logs
cls
echo =================================================
echo             应用程序日志
echo =================================================
echo.
echo 正在启动应用程序事件日志查看器...
eventvwr.msc /c:Application
echo.
pause
goto system_logs

:security_logs
cls
echo =================================================
echo               安全日志
echo =================================================
echo.
echo 正在启动安全事件日志查看器...
eventvwr.msc /c:Security
echo.
pause
goto system_logs

:setup_logs
cls
echo =================================================
echo               安装日志
echo =================================================
echo.
echo 正在启动安装事件日志查看器...
eventvwr.msc /c:Setup
echo.
pause
goto system_logs

:: 快捷设置工具
:settings_menu
cls
echo =================================================
echo               快捷设置工具
echo =================================================
echo.
echo   [1] 显示设置           [2] 声音设置
echo   [3] 网络设置           [4] 时间和日期
echo   [5] 用户账户设置     [6] 返回主菜单
echo.
echo =================================================
echo.

choice /C 123456 /N /M "请选择设置类别 [1-6]: "

if errorlevel 6 goto main_menu
if errorlevel 5 goto user_accounts
if errorlevel 4 goto time_date
if errorlevel 3 goto network_settings
if errorlevel 2 goto sound_settings
if errorlevel 1 goto display_settings

:display_settings
cls
echo =================================================
echo               显示设置
echo =================================================
echo.
echo 正在打开显示设置...
control display
echo.
pause
goto settings_menu

:sound_settings
cls
echo =================================================
echo               声音设置
echo =================================================
echo.
echo 正在打开声音设置...
control mmsys.cpl sounds
echo.
pause
goto settings_menu

:network_settings
cls
echo =================================================
echo               网络设置
echo =================================================
echo.
echo 正在打开网络连接设置...
control ncpa.cpl
echo.
pause
goto settings_menu

:time_date
cls
echo =================================================
echo             时间和日期设置
echo =================================================
echo.
echo 正在打开时间和日期设置...
control timedate.cpl
echo.
pause
goto settings_menu

:user_accounts
cls
echo =================================================
echo             用户账户设置
echo =================================================
echo.
echo 正在打开用户账户设置...
control userpasswords2
echo.
pause
goto settings_menu
:: 其他实用工具

::工具箱信息
:toolbox_info
cls
echo =================================================
echo               工具箱信息
echo =================================================
echo.
echo 这是一个基于批处理（batch）开发的超实用微工具箱。
echo.
echo 这个工具箱由两个学生共同开发，通过上千行代码，致力于打造一个完美的实用工具箱。
echo 本工具箱面向于有经验的人士进行系统维护（小白其实也行）。
echo 欢迎各位提出宝贵的建议哦
echo.
echo QQ交流群：932691274
echo GitHub仓库：https://github.com/ClarkCheng3/happytoolbox
echo.
echo 如果您支持我们用上千行代码打造的工具箱，并希望我们继续更新升级，请赞助我们
echo.
echo.
echo [1] 打开Github仓库    [2]返回主菜单
choice /C 12 /N /M "请选择操作 [1-2]: "

if errorlevel 2 goto main_menu
if errorlevel 1 goto start_github

::打开仓库
:start_github
cls
echo 正在打开仓库...
start https://github.com/ClarkCheng3/happytoolbox
echo 已打开仓库
goto toolbox_info

:other_tools
cls
echo =================================================
echo               其他实用工具
echo =================================================
echo.
echo   [1] 命令提示符         [2] PowerShell
echo   [3] 返回主菜单
echo.
echo =================================================
echo.

choice /C 123 /N /M "请选择工具 [1-3,0]: "

if errorlevel 3 goto main_menu
if errorlevel 2 goto powershell
if errorlevel 1 goto cmd_prompt

:cmd_prompt
cls
echo =================================================
echo             命令提示符
echo =================================================
echo.
echo 正在启动命令提示符...
start cmd.exe
echo.
echo 命令提示符已启动
echo.
pause
goto other_tools

:powershell
cls
echo =================================================
echo             PowerShell
echo =================================================
echo.
echo 正在启动PowerShell...
start powershell.exe
echo.
echo PowerShell已启动
echo.
pause
goto other_tools

:exit
cls
echo =================================================
echo           感谢使用Windows实用工具箱！
echo =================================================
echo.
echo 工具箱已准备好退出...
timeout /t 2 >nul
exit /b 0