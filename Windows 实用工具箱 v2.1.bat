@echo off
setlocal enabledelayedexpansion
title Windowsʵ�ù����� v2.1

:: ��ɫ���� - ������ɫ�����ְ�ɫ
color 1F

:: ������ԱȨ��
fltmc >nul 2>&1 || (
    echo ���棺�˹����䲿�ֹ�����Ҫ����ԱȨ�ޡ�
    echo ���Ҽ�ѡ��"�Թ���Ա�������"�Ի���������ܡ�
    echo.
    pause
)

:main_menu
cls
echo =================================================
echo           Windows ʵ�ù����� v2.1
echo =================================================
echo.
echo   [1] ϵͳ�Ż�����       [2] ������Ϲ���
echo   [3] �ļ�������       [4] ��ȫά������
echo   [5] ���̹�����       [6] ϵͳ��Ϣ����
echo   [7] ������ù���       [8] ���ڹ�����
echo   [9] ����ʵ�ù���       [0] �˳�������
echo.
echo GitHub�ֿ⣺https://github.com/ClarkCheng3/happytoolbox
echo =================================================
echo  ��ʾ�����ֹ�����Ҫ����ԱȨ�޲����������С�
echo =================================================
echo.

choice /C 1234567890 /N /M "��ѡ���� [1-9,0]: "

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

:: ϵͳ�Ż�����
:system_optimize
cls
echo =================================================
echo               ϵͳ�Ż�����
echo =================================================
echo.
echo   [1] ������ʱ�ļ�       [2] ������Ƭ����
echo   [3] ����ϵͳ����       [4] ϵͳ�����Ż�
echo   [5] ϵͳ�����Ż�       [6] �ָ�Ĭ������
echo   [7] �������˵�
echo.
echo =================================================
echo.

choice /C 1234567 /N /M "��ѡ���Ż����� [1-7]: "

if errorlevel 7 goto main_menu
if errorlevel 6 goto restore_defaults
if errorlevel 5 goto service_optimize
if errorlevel 4 goto performance_optimize
if errorlevel 3 goto disable_hibernation
if errorlevel 2 goto defrag_disk
if errorlevel 1 goto clean_temp_files

:clean_temp_files
cls
echo ��������ϵͳ��ʱ�ļ�...
echo.
rd /S /Q "%temp%" 2>nul
del /F /S /Q "%windir%\temp\*.*" 2>nul
del /F /S /Q "%windir%\prefetch\*.*" 2>nul
echo.
echo ϵͳ��ʱ�ļ�������ɣ�
echo.
pause
goto system_optimize

:defrag_disk
cls
echo =================================================
echo             ������Ƭ������
echo =================================================
echo.
echo ��ǰϵͳ������Ϣ��
wmic logicaldisk where drivetype=3 get deviceid, volumename, freespace, size
echo.
set /p drive="������Ҫ������������� (���� C): "
echo.
echo ���ڶ� %drive%: ������Ƭ����... �������Ҫһ��ʱ�䡣
echo.
defrag %drive%: /U /V
echo.
echo ������Ƭ������ɣ�
echo.
pause
goto system_optimize

:disable_hibernation
cls
echo ���ڼ��ϵͳ����״̬...
powercfg /a | find "����" >nul
if %errorlevel%==0 (
    echo ϵͳ���������ã����ڽ���...
    powercfg /h off
    echo.
    echo ϵͳ�����ѽ��ã�
) else (
    echo ϵͳ�����ѽ��ã�
)
echo.
pause
goto system_optimize

:performance_optimize
cls
echo =================================================
echo             ϵͳ�����Ż�
echo =================================================
echo.
echo ���ڵ���ϵͳ��������������ٶ�...
echo.
:: ��������ѡ��Ϊ"����Ϊ�������"
systempropertiesperformance.exe /p /d
echo.
echo ϵͳ�����������Ż���
echo.
pause
goto system_optimize

:service_optimize
cls
echo =================================================
echo             ϵͳ�����Ż�
echo =================================================
echo.
echo ע�⣺���ò���Ҫ�ķ�����ܻ�Ӱ��ĳЩ���ܡ�
echo �����ȱ���ϵͳ�򴴽���ԭ�㡣
echo.
choice /C YN /N /M "�Ƿ����? [Y/N]: "
if errorlevel 2 goto system_optimize
if errorlevel 1 (
    echo.
    echo �����Ż�ϵͳ����...
    echo.
    :: ����һЩ�����ķǹؼ�����
    sc config wuauserv start= disabled >nul 2>&1  :: Windows Update
    sc config Superfetch start= disabled >nul 2>&1  :: Ԥȡ
    sc config HomeGroupListener start= disabled >nul 2>&1  :: ��ͥ��
    sc config HomeGroupProvider start= disabled >nul 2>&1  :: ��ͥ��
    sc config XboxLiveAuthManager start= disabled >nul 2>&1  :: Xbox����
    sc config XboxNetApiSvc start= disabled >nul 2>&1  :: Xbox�������
    echo.
    echo ϵͳ�����Ż���ɣ�
)
echo.
pause
goto system_optimize

:restore_defaults
cls
echo =================================================
echo           �ָ�ϵͳĬ������
echo =================================================
echo.
echo ���棺�˲������ָ������Ż�����ΪĬ��ֵ��
echo.
choice /C YN /N /M "�Ƿ����? [Y/N]: "
if errorlevel 2 goto system_optimize
if errorlevel 1 (
    echo.
    echo ���ڻָ�ϵͳĬ������...
    echo.
    :: �ָ�һЩ�Ż�����ΪĬ��ֵ
    sc config wuauserv start= auto >nul 2>&1  :: Windows Update
    sc config Superfetch start= auto >nul 2>&1  :: Ԥȡ
    powercfg /h on >nul 2>&1  :: ��������
    echo.
    echo ϵͳ�����ѻָ�ΪĬ��ֵ��
)
echo.
pause
goto system_optimize

:: ������Ϲ���
:network_tools
cls
echo =================================================
echo               ������Ϲ���
echo =================================================
echo.
echo   [1] �������Ӳ���       [2] IP������Ϣ
echo   [3] DNSˢ�¹���       [4] �˿�ɨ�蹤��
echo   [5] ·��׷�ٹ���       [6] WiFi����鿴
echo   [7] �������˵�
echo.
echo =================================================
echo.

choice /C 1234567 /N /M "��ѡ�����繤�� [1-7]: "

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
echo              �������Ӳ���
echo =================================================
echo.
echo ���ڲ����������ӣ����Ժ�...
echo.
ping www.baidu.com -n 4 >nul
if %errorlevel%==0 (
    echo ��ϲ��������������������
) else (
    echo �������Ӳ���ʧ�ܣ����������������á�
)
echo.
echo ���ڲ��Ա�������...
ping 127.0.0.1 -n 4 >nul
if %errorlevel%==0 (
    echo ���ػػ�����������
) else (
    echo ���ػػ�����ʧ�ܣ��������������������⡣
)
echo.
pause
goto network_tools

:ip_config
cls
echo =================================================
echo              IP������Ϣ
echo =================================================
echo.
ipconfig /all
echo.
pause
goto network_tools

:flush_dns
cls
echo =================================================
echo               DNSˢ�¹���
echo =================================================
echo.
echo ����ˢ��DNS����...
ipconfig /flushdns
echo.
echo DNS������ˢ�£�
echo.
pause
goto network_tools

:port_scan
cls
echo =================================================
echo               �˿�ɨ�蹤��
echo =================================================
echo.
set /p target="������Ҫɨ���Ŀ��IP��ַ (���� 192.168.1.1): "
echo.
echo ����ɨ�� %target% �ĳ��ö˿�...
echo.
echo �˿�ɨ����:
echo ------------------------
for /L %%p in (20,1,1024) do (
    start /b /wait cmd /c "(echo open %target% %%p) | (telnet.exe) >nul 2>&1 && echo �˿� %%p �ǿ��ŵ�"
)
echo ------------------------
echo.
echo �˿�ɨ����ɣ�
echo.
pause
goto network_tools

:trace_route
cls
echo =================================================
echo               ·��׷�ٹ���
echo =================================================
echo.
set /p target="������Ŀ����վ��IP��ַ: "
echo.
echo ����׷�ٵ� %target% ��·�ɣ����Ժ�...
echo.
tracert %target%
echo.
pause
goto network_tools

:wifi_passwords
cls
echo =================================================
echo             WiFi����鿴����
echo =================================================
echo.
echo ���ڻ�ȡ�ѱ����WiFi������Ϣ...
echo.
netsh wlan show profiles
echo.
set /p wifi_name="������Ҫ�鿴�����WiFi����: "
echo.
netsh wlan show profile name="%wifi_name%" key=clear | findstr "�ؼ�����"
echo.
pause
goto network_tools

:: �ļ�������
:file_tools
cls
echo =================================================
echo               �ļ�������
echo =================================================
echo.
echo   [1] �ļ���������       [2] �ļ�����������
echo   [3] �ļ����ܹ���       [4] �ļ���ϣУ��
echo   [5] ���ļ����ҹ���     [6] �ļ�ѹ������
echo   [7] �������˵�
echo.
echo =================================================
echo.

choice /C 1234567 /N /M "��ѡ���ļ����� [1-7]: "

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
echo               �ļ���������
echo =================================================
echo.
set /p search_dir="����������Ŀ¼ (���� C:\Users): "
set /p search_text="������Ҫ�������ļ���������: "
echo.
echo ���������ļ������Ժ�...
echo.
dir /s /b "%search_dir%\*%search_text%*"
echo.
echo �ļ�������ɣ�
echo.
pause
goto file_tools

:batch_rename
cls
echo =================================================
echo             �ļ���������������
echo =================================================
echo.
set /p rename_dir="������Ҫ�������ļ���Ŀ¼: "
set /p old_text="������Ҫ�滻���ı�: "
set /p new_text="�������滻����ı�: "
echo.
echo ���������������ļ�...
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
echo �ļ�������������ɣ�
echo.
pause
goto file_tools

:file_encrypt
cls
echo =================================================
echo               �ļ����ܹ���
echo =================================================
echo.
echo ���棺�˹���ʹ�ü򵥵ļ��ܷ��������ʺϸ߶��������ݣ�
echo.
set /p encrypt_file="������Ҫ���ܵ��ļ�·��: "
set /p password="�������������: "
echo.
echo ���ڼ����ļ�...
certutil -encode "%encrypt_file%" "%encrypt_file%.enc" >nul
del /F "%encrypt_file%"
echo.
echo �ļ��Ѽ���Ϊ: %encrypt_file%.enc
echo.
pause
goto file_tools

:file_hash
cls
echo =================================================
echo               �ļ���ϣУ��
echo =================================================
echo.
set /p hash_file="������ҪУ����ļ�·��: "
echo.
echo ���ڼ����ļ���ϣֵ�����Ժ�...
echo.
echo �ļ� MD5 ��ϣ:
certutil -hashfile "%hash_file%" MD5
echo.
echo �ļ� SHA1 ��ϣ:
certutil -hashfile "%hash_file%" SHA1
echo.
echo �ļ� SHA256 ��ϣ:
certutil -hashfile "%hash_file%" SHA256
echo.
pause
goto file_tools

:find_large_files
cls
echo =================================================
echo             ���ļ����ҹ���
echo =================================================
echo.
set /p large_dir="������Ҫ������Ŀ¼ (���� C:\): "
set /p size_limit="�������ļ���С���� (MB): "
echo.
echo ���ڲ��Ҵ��� %size_limit%MB ���ļ������Ժ�...
echo.
forfiles /p "%large_dir%" /s /m * /c "cmd /c if @fsize GTR %size_limit%000000 echo @path - @fsize bytes"
echo.
echo ���ļ�������ɣ�
echo.
pause
goto file_tools

:file_zip
cls
echo =================================================
echo               �ļ�ѹ������
echo =================================================
echo.
set /p zip_dir="������Ҫѹ�����ļ���Ŀ¼: "
set /p zip_file="������ѹ���ļ��� (���� archive.zip): "
echo.
echo ����ѹ���ļ������Ժ�...
echo.
powershell -command "Compress-Archive -Path '%zip_dir%' -DestinationPath '%zip_file%' -Force"
echo.
echo �ļ�ѹ����ɣ�
echo.
pause
goto file_tools

:: ��ȫά������
:security_tools
cls
echo =================================================
echo               ��ȫά������
echo =================================================
echo.
echo   [1] ϵͳ����ɨ��       [2] ����������
echo   [3] ����ǽ����         [4] �˻������޸�
echo   [5] ϵͳ��ԭ��         [6] UAC����
echo   [7] �������˵�
echo.
echo =================================================
echo.

choice /C 1234567 /N /M "��ѡ��ȫ���� [1-7]: "

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
echo               ϵͳ����ɨ��
echo =================================================
echo.
echo ���棺�˲���������Windows Defender����ϵͳɨ�衣
echo �������Ҫ�ϳ�ʱ�䣬ȡ����ϵͳ��С�����ܡ�
echo.
choice /C YN /N /M "�Ƿ����? [Y/N]: "
if errorlevel 2 goto security_tools
if errorlevel 1 (
    echo.
    echo ��������ϵͳ����ɨ��...
    echo.
    Start-MpScan -ScanType FullScan
    echo.
    echo ϵͳ����ɨ����������
    echo ��������Windows��ȫ���Ĳ鿴ɨ����ȡ�
)
echo.
pause
goto security_tools

:malware_scan
cls
echo =================================================
echo             ��������������
echo =================================================
echo.
echo ���ڼ��ϵͳ�Ƿ�װ��Microsoft Safety Scanner...
echo.
where mssacli.exe >nul 2>&1
if %errorlevel%==0 (
    echo �Ѱ�װMicrosoft Safety Scanner����������ɨ��...
    mssacli.exe /scan /full
) else (
    echo δ��װMicrosoft Safety Scanner����������ҳ�档
    echo �����ز���װ�������д˹��ߡ�
    start https://www.microsoft.com/security/scanner
)
echo.
pause
goto security_tools

:firewall_settings
cls
echo =================================================
echo               ����ǽ����
echo =================================================
echo.
echo   [1] ���÷���ǽ         [2] ���÷���ǽ
echo   [3] �鿴����ǽ״̬     [4] ������һ��
echo.
echo =================================================
echo.

choice /C 1234 /N /M "��ѡ����� [1-4]: "

if errorlevel 4 goto security_tools
if errorlevel 3 goto firewall_status
if errorlevel 2 goto disable_firewall
if errorlevel 1 goto enable_firewall

:enable_firewall
cls
echo ��������Windows Defender����ǽ...
netsh advfirewall set allprofiles state on
echo.
echo Windows Defender����ǽ�����ã�
echo.
pause
goto firewall_settings

:disable_firewall
cls
echo ���棺���÷���ǽ��ʹϵͳ���ٰ�ȫ���գ�
echo.
choice /C YN /N /M "�Ƿ����? [Y/N]: "
if errorlevel 2 goto firewall_settings
if errorlevel 1 (
    echo.
    echo ���ڽ���Windows Defender����ǽ...
    netsh advfirewall set allprofiles state off
    echo.
    echo Windows Defender����ǽ�ѽ��ã�
)
echo.
pause
goto firewall_settings

:firewall_status
cls
echo =================================================
echo             Windows Defender����ǽ״̬
echo =================================================
echo.
netsh advfirewall show allprofiles
echo.
pause
goto firewall_settings

:change_password
cls
echo =================================================
echo               �˻������޸�
echo =================================================
echo.
net user
echo.
set /p username="������Ҫ�޸�������û���: "
echo.
echo �����������루������ʾ����Ļ�ϣ���
echo.
net user %username% *
echo.
echo �����޸���ɣ�
echo.
pause
goto security_tools

:system_restore
cls
echo =================================================
echo               ϵͳ��ԭ��
echo =================================================
echo.
echo   [1] ������ԭ��         [2] �鿴��ԭ��
echo   [3] ϵͳ��ԭ           [4] ������һ��
echo.
echo =================================================
echo.

choice /C 1234 /N /M "��ѡ����� [1-4]: "

if errorlevel 4 goto security_tools
if errorlevel 3 goto restore_system
if errorlevel 2 goto view_restore_points
if errorlevel 1 goto create_restore_point

:create_restore_point
cls
echo =================================================
echo             ����ϵͳ��ԭ��
echo =================================================
echo.
set /p description="�����뻹ԭ������: "
echo.
echo ���ڴ���ϵͳ��ԭ�㣬���Ժ�...
powershell -command "Checkpoint-Computer -Description '%description%' -RestorePointType 'MODIFY_SETTINGS'"
echo.
echo ϵͳ��ԭ�㴴����ɣ�
echo.
pause
goto system_restore

:view_restore_points
cls
echo =================================================
echo             �鿴ϵͳ��ԭ��
echo =================================================
echo.
powershell -command "Get-ComputerRestorePoint"
echo.
pause
goto system_restore

:restore_system
cls
echo =================================================
echo               ϵͳ��ԭ
echo =================================================
echo.
echo ���棺ϵͳ��ԭ�������ļ������ԭ����ǰ��״̬��
echo ����װ�ĳ���͸����ļ����ᱻɾ������ĳЩ���ÿ��ܻ���ġ�
echo.
choice /C YN /N /M "�Ƿ����? [Y/N]: "
if errorlevel 2 goto system_restore
if errorlevel 1 (
    echo.
    echo ��������ϵͳ��ԭ��...
    rstrui.exe
    echo.
    echo ϵͳ��ԭ����������
)
echo.
pause
goto system_restore

:uac_settings
cls
echo =================================================
echo               UAC����
echo =================================================
echo.
echo   [1] �� (ʼ��֪ͨ)      [2] �� (Ĭ������)
echo   [3] �� (���ڳ����Ը���ϵͳʱ֪ͨ)
echo   [4] �ر�UAC (���Ƽ�)   [5] ������һ��
echo.
echo =================================================
echo.

choice /C 12345 /N /M "��ѡ��UAC���� [1-5]: "

if errorlevel 5 goto security_tools
if errorlevel 4 goto uac_off
if errorlevel 3 goto uac_low
if errorlevel 2 goto uac_medium
if errorlevel 1 goto uac_high

:uac_high
cls
echo ��������UACΪ�߼��� (ʼ��֪ͨ)...
powershell -command "Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 2"
echo.
echo UAC�����Ѹ��£�
echo ���Ľ����´ε�¼ʱ��Ч��
echo.
pause
goto uac_settings

:uac_medium
cls
echo ��������UACΪ�м��� (Ĭ������)...
powershell -command "Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 5"
echo.
echo UAC�����Ѹ��£�
echo ���Ľ����´ε�¼ʱ��Ч��
echo.
pause
goto uac_settings

:uac_low
cls
echo ��������UACΪ�ͼ��� (���ڳ����Ը���ϵͳʱ֪ͨ)...
powershell -command "Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 1"
echo.
echo UAC�����Ѹ��£�
echo ���Ľ����´ε�¼ʱ��Ч��
echo.
pause
goto uac_settings

:uac_off
cls
echo ���棺�ر�UAC��ʹϵͳ���ٰ�ȫ���գ�
echo.
choice /C YN /N /M "�Ƿ����? [Y/N]: "
if errorlevel 2 goto uac_settings
if errorlevel 1 (
    echo.
    echo ���ڹر�UAC...
    powershell -command "Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0"
    echo.
    echo UAC�ѹرգ�
    echo ���Ľ����´ε�¼ʱ��Ч��
)
echo.
pause
goto uac_settings

:: ���̹�����
:disk_tools
cls
echo =================================================
echo               ���̹�����
echo =================================================
echo.
echo   [1] ���̼�鹤��       [2] ����������
echo   [3] ���̿ռ����       [4] ����������
echo   [5] ���̸�ʽ������     [6] �������˵�
echo.
echo =================================================
echo.

choice /C 123456 /N /M "��ѡ����̹��� [1-6]: "

if errorlevel 6 goto main_menu
if errorlevel 5 goto format_disk
if errorlevel 4 goto partition_manager
if errorlevel 3 goto disk_analyzer
if errorlevel 2 goto disk_cleanup
if errorlevel 1 goto disk_check

:disk_check
cls
echo =================================================
echo               ���̼�鹤��
echo =================================================
echo.
echo ��ǰϵͳ������Ϣ��
wmic logicaldisk where drivetype=3 get deviceid, volumename, freespace, size
echo.
set /p drive="������Ҫ������������ (���� C): "
echo.
echo ���棺���̼����ܻ��޸����󣬵����ܻ�ɾ��һЩ�ļ���
echo.
choice /C YN /N /M "�Ƿ����? [Y/N]: "
if errorlevel 2 goto disk_tools
if errorlevel 1 (
    echo.
    echo ���ڼ�� %drive%: ���̣����Ժ�...
    chkdsk %drive%: /f /r
    echo.
    echo ���̼����ɣ�
)
echo.
pause
goto disk_tools

:disk_cleanup
cls
echo =================================================
echo               ����������
echo =================================================
echo.
echo ��ǰϵͳ������Ϣ��
wmic logicaldisk where drivetype=3 get deviceid, volumename, freespace, size
echo.
set /p drive="������Ҫ������������� (���� C): "
echo.
echo ������������������...
cleanmgr /sageset:99
cleanmgr /sagerun:99
echo.
echo ����������ɣ�
echo.
pause
goto disk_tools

:disk_analyzer
cls
echo =================================================
echo               ���̿ռ����
echo =================================================
echo.
echo ���ڼ��ϵͳ�Ƿ�װ��WinDirStat...
echo.
where wds.exe >nul 2>&1
if %errorlevel%==0 (
    echo �Ѱ�װWinDirStat����������...
    wds.exe
) else (
    echo δ��װWinDirStat����������ҳ�档
    echo �����ز���װ�������д˹��ߡ�
    start https://windirstat.net/
)
echo.
pause
goto disk_tools

:partition_manager
cls
echo =================================================
echo               ����������
echo =================================================
echo.
echo ���棺�˲������򿪴��̹������̨��
echo ����ȷ�Ĳ������ܵ������ݶ�ʧ��
echo.
choice /C YN /N /M "�Ƿ����? [Y/N]: "
if errorlevel 2 goto disk_tools
if errorlevel 1 (
    echo.
    echo �����������̹������̨...
    diskmgmt.msc
    echo.
    echo ���̹������̨��������
)
echo.
pause
goto disk_tools

:format_disk
cls
echo =================================================
echo               ���̸�ʽ������
echo =================================================
echo.
echo ���棺��ʽ����ɾ�������ϵ��������ݣ�
echo ��ȷ�����ѱ�����Ҫ���ݡ�
echo.
echo ��ǰϵͳ������Ϣ��
wmic logicaldisk where drivetype=3 get deviceid, volumename, freespace, size
echo.
set /p drive="������Ҫ��ʽ������������ (���� D): "
echo.
choice /C YN /N /M "ȷ��Ҫ��ʽ�� %drive%: ��? [Y/N]: "
if errorlevel 2 goto disk_tools
if errorlevel 1 (
    echo.
    echo ��ѡ���ļ�ϵͳ:
    echo   [1] NTFS   [2] FAT32   [3] exFAT
    echo.
    choice /C 123 /N /M "��ѡ�� [1-3]: "
    if errorlevel 3 set fs=exFAT
    if errorlevel 2 set fs=FAT32
    if errorlevel 1 set fs=NTFS
    
    echo.
    echo ���ڸ�ʽ�� %drive%: Ϊ %fs% �ļ�ϵͳ...
    format %drive%: /FS:%fs% /Q /Y
    echo.
    echo ���̸�ʽ����ɣ�
)
echo.
pause
goto disk_tools

:: ϵͳ��Ϣ����
:system_info
cls
echo =================================================
echo               ϵͳ��Ϣ����
echo =================================================
echo.
echo   [1] ϵͳ��Ϣ      
echo   [2] ϵͳ��־              [3] �������˵�
echo.
echo =================================================
echo.

choice /C 123 /N /M "��ѡ�� [1-3]: "

if errorlevel 3 goto main_menu
if errorlevel 2 goto system_logs
if errorlevel 1 goto basic_info

:basic_info
cls
echo =================================================
echo               ����ϵͳ��Ϣ
echo =================================================
echo.
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type" /C:"Total Physical Memory"
echo.
echo ���������: %COMPUTERNAME%
echo ��ǰ�û�: %USERNAME%
echo ��ǰ����: %DATE%
echo ��ǰʱ��: %TIME%
echo.
pause
goto system_info

echo =================================================
echo               ϵͳ��־
echo =================================================
echo.
echo   [1] ϵͳ��־           [2] Ӧ�ó�����־
echo   [3] ��ȫ��־           [4] ��װ��־
echo   [5] ������һ��
echo.
echo =================================================
echo.

choice /C 12345 /N /M "��ѡ����־��� [1-5]: "

if errorlevel 5 goto system_info
if errorlevel 4 goto setup_logs
if errorlevel 3 goto security_logs
if errorlevel 2 goto application_logs
if errorlevel 1 goto system_event_logs

:system_event_logs
cls
echo =================================================
echo               ϵͳ��־
echo =================================================
echo.
echo ��������ϵͳ�¼���־�鿴��...
eventvwr.msc /c:System
echo.
pause
goto system_logs

:application_logs
cls
echo =================================================
echo             Ӧ�ó�����־
echo =================================================
echo.
echo ��������Ӧ�ó����¼���־�鿴��...
eventvwr.msc /c:Application
echo.
pause
goto system_logs

:security_logs
cls
echo =================================================
echo               ��ȫ��־
echo =================================================
echo.
echo ����������ȫ�¼���־�鿴��...
eventvwr.msc /c:Security
echo.
pause
goto system_logs

:setup_logs
cls
echo =================================================
echo               ��װ��־
echo =================================================
echo.
echo ����������װ�¼���־�鿴��...
eventvwr.msc /c:Setup
echo.
pause
goto system_logs

:: ������ù���
:settings_menu
cls
echo =================================================
echo               ������ù���
echo =================================================
echo.
echo   [1] ��ʾ����           [2] ��������
echo   [3] ��������           [4] ʱ�������
echo   [5] �û��˻�����     [6] �������˵�
echo.
echo =================================================
echo.

choice /C 123456 /N /M "��ѡ��������� [1-6]: "

if errorlevel 6 goto main_menu
if errorlevel 5 goto user_accounts
if errorlevel 4 goto time_date
if errorlevel 3 goto network_settings
if errorlevel 2 goto sound_settings
if errorlevel 1 goto display_settings

:display_settings
cls
echo =================================================
echo               ��ʾ����
echo =================================================
echo.
echo ���ڴ���ʾ����...
control display
echo.
pause
goto settings_menu

:sound_settings
cls
echo =================================================
echo               ��������
echo =================================================
echo.
echo ���ڴ���������...
control mmsys.cpl sounds
echo.
pause
goto settings_menu

:network_settings
cls
echo =================================================
echo               ��������
echo =================================================
echo.
echo ���ڴ�������������...
control ncpa.cpl
echo.
pause
goto settings_menu

:time_date
cls
echo =================================================
echo             ʱ�����������
echo =================================================
echo.
echo ���ڴ�ʱ�����������...
control timedate.cpl
echo.
pause
goto settings_menu

:user_accounts
cls
echo =================================================
echo             �û��˻�����
echo =================================================
echo.
echo ���ڴ��û��˻�����...
control userpasswords2
echo.
pause
goto settings_menu
:: ����ʵ�ù���

::��������Ϣ
:toolbox_info
cls
echo =================================================
echo               ��������Ϣ
echo =================================================
echo.
echo ����һ������������batch�������ĳ�ʵ��΢�����䡣
echo.
echo ���������������ѧ����ͬ������ͨ����ǧ�д��룬�����ڴ���һ��������ʵ�ù����䡣
echo ���������������о������ʿ����ϵͳά����С����ʵҲ�У���
echo ��ӭ��λ�������Ľ���Ŷ
echo.
echo QQ����Ⱥ��932691274
echo GitHub�ֿ⣺https://github.com/ClarkCheng3/happytoolbox
echo.
echo �����֧����������ǧ�д������Ĺ����䣬��ϣ�����Ǽ�����������������������
echo.
echo.
echo [1] ��Github�ֿ�    [2]�������˵�
choice /C 12 /N /M "��ѡ����� [1-2]: "

if errorlevel 2 goto main_menu
if errorlevel 1 goto start_github

::�򿪲ֿ�
:start_github
cls
echo ���ڴ򿪲ֿ�...
start https://github.com/ClarkCheng3/happytoolbox
echo �Ѵ򿪲ֿ�
goto toolbox_info

:other_tools
cls
echo =================================================
echo               ����ʵ�ù���
echo =================================================
echo.
echo   [1] ������ʾ��         [2] PowerShell
echo   [3] �������˵�
echo.
echo =================================================
echo.

choice /C 123 /N /M "��ѡ�񹤾� [1-3,0]: "

if errorlevel 3 goto main_menu
if errorlevel 2 goto powershell
if errorlevel 1 goto cmd_prompt

:cmd_prompt
cls
echo =================================================
echo             ������ʾ��
echo =================================================
echo.
echo ��������������ʾ��...
start cmd.exe
echo.
echo ������ʾ��������
echo.
pause
goto other_tools

:powershell
cls
echo =================================================
echo             PowerShell
echo =================================================
echo.
echo ��������PowerShell...
start powershell.exe
echo.
echo PowerShell������
echo.
pause
goto other_tools

:exit
cls
echo =================================================
echo           ��лʹ��Windowsʵ�ù����䣡
echo =================================================
echo.
echo ��������׼�����˳�...
timeout /t 2 >nul
exit /b 0