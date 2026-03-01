@echo off
rem START or STOP Services
rem ----------------------------------
rem Check if argument is STOP or START

if not ""%1"" == ""START"" goto stop

if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\hypersonic\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\server\hsql-sample-database\scripts\ctl.bat START)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\ingres\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\ingres\scripts\ctl.bat START)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\mysql\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\mysql\scripts\ctl.bat START)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\postgresql\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\postgresql\scripts\ctl.bat START)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\apache\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\apache\scripts\ctl.bat START)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\openoffice\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\openoffice\scripts\ctl.bat START)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\apache-tomcat\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\apache-tomcat\scripts\ctl.bat START)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\resin\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\resin\scripts\ctl.bat START)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\jetty\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\jetty\scripts\ctl.bat START)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\subversion\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\subversion\scripts\ctl.bat START)
rem RUBY_APPLICATION_START
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\lucene\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\lucene\scripts\ctl.bat START)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\third_application\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\third_application\scripts\ctl.bat START)
goto end

:stop
echo "Stopping services ..."
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\third_application\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\third_application\scripts\ctl.bat STOP)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\lucene\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\lucene\scripts\ctl.bat STOP)
rem RUBY_APPLICATION_STOP
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\subversion\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\subversion\scripts\ctl.bat STOP)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\jetty\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\jetty\scripts\ctl.bat STOP)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\hypersonic\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\server\hsql-sample-database\scripts\ctl.bat STOP)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\resin\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\resin\scripts\ctl.bat STOP)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\apache-tomcat\scripts\ctl.bat (start /MIN /B /WAIT C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\apache-tomcat\scripts\ctl.bat STOP)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\openoffice\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\openoffice\scripts\ctl.bat STOP)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\apache\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\apache\scripts\ctl.bat STOP)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\ingres\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\ingres\scripts\ctl.bat STOP)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\mysql\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\mysql\scripts\ctl.bat STOP)
if exist C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\postgresql\scripts\ctl.bat (start /MIN /B C:\Users\user\Desktop\vizsgahoz szukseges\Messengeres-vizsgaremek\xampp_server\postgresql\scripts\ctl.bat STOP)

:end

