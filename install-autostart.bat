@echo off
chcp 65001 >nul
cd /d "%~dp0"
where node >nul 2>nul || (echo Node.js غير مثبت. نزّليه من https://nodejs.org ثم أعيدي التشغيل. & pause & exit /b)
if not exist .env (
  copy .env.example .env >nul
  echo ADMIN_EMAIL=admin@store.local>>.env
  echo ADMIN_PASSWORD=ChangeMe12345>>.env
)
set "ST=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\store-start.vbs"
> "%ST%" echo CreateObject("WScript.Shell").Run "wscript.exe """"%~dp0run-hidden.vbs"""""", 0, False
call stop.bat >nul 2>nul
wscript.exe "%~dp0run-hidden.vbs"
timeout /t 3 >nul
start "" http://localhost:3000
echo.
echo تم. المتجر شغال في الخلفية وسيعمل تلقائيًا كلما شغّلتِ الجهاز.
echo لإيقافه: شغّلي stop.bat   |   لإلغاء التشغيل التلقائي: شغّلي uninstall-autostart.bat
pause
