@echo off

if "%COMPUTERNAME%" == "MACBETH" goto MACBETH
if "%COMPUTERNAME%" == "CAESAR2" goto CAESAR2
goto ELSE

:MACBETH
set PATH=E:\home\bin\ruby-1.8.7-p72\bin;%PATH%
set PATH=E:\home\bin\gettext-0.14.4\bin;%PATH%
goto END

:CAESAR2
set PATH=D:\bin\ruby-1.8.7-p72\bin;%PATH%
goto END

:ELSE
echo Unknown Host
goto END

:END

set RUBYOPT=-Itest

cmd
