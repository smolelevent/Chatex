@echo off
rem START or STOP Services
rem ----------------------------------
rem Check if argument is STOP or START

if not ""%1"" == ""START"" goto stop


"C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\mysql\bin\mysqld" --defaults-file="C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\mysql\bin\my.ini" --standalone
if errorlevel 1 goto error
goto finish

:stop
cmd.exe /C start "" /MIN call "C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\killprocess.bat" "mysqld.exe"

if not exist "C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\mysql\data\%computername%.pid" goto finish
echo Delete %computername%.pid ...
del "C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\mysql\data\%computername%.pid"
goto finish


:error
echo MySQL could not be started

:finish
exit
