@echo off
"c:\Program Files (x86)\Resource Hacker\ResourceHacker.exe" -open {APP_NAME} -save {APP_NAME} -action addskip -res {APP_ICON} -mask ICONGROUP,MAINICON,
del {APP_ICON} 
del install-icon.cmd
