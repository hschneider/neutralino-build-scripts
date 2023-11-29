@echo off
set TOOL="c:\Program Files (x86)\Resource Hacker\ResourceHacker.exe"
if exist %TOOL% (
    %TOOL% -open {APP_NAME} -save {APP_NAME} -action addskip -res {APP_ICON} -mask ICONGROUP,MAINICON,
    del {APP_ICON} 
    del install-icon.cmd
)
else (
    echo "Please install 'Resource Hacker' first."
    echo "Press any key ..."
    pause
    start "" "https://www.angusj.com/resourcehacker/"
)
