@echo off
chcp 65001 >nul
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (
  echo Node.js غير مثبت. نزّليه من https://nodejs.org ^(الإصدار 22 أو أحدث^) ثم شغّلي الملف مرة ثانية.
  pause
  exit /b
)
if not exist .env (
  copy .env.example .env >nul
  echo ADMIN_EMAIL=admin@store.local>>.env
  echo ADMIN_PASSWORD=ChangeMe12345>>.env
)
echo.
echo المتجر:  http://localhost:3000
echo لوحة التحكم:  http://localhost:3000/admin/
echo ^(بيانات الدخول أول مرة: admin@store.local / ChangeMe12345^)
echo لا تغلقي هذه النافذة طالما تستخدمين الموقع.
echo.
start "" http://localhost:3000
node --no-warnings server/index.js
pause
