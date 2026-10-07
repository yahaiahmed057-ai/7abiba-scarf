@echo off
call "%~dp0stop.bat" >nul
del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\store-start.vbs" 2>nul
echo تم إلغاء التشغيل التلقائي وإيقاف المتجر.
pause
