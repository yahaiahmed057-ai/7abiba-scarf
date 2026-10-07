#!/bin/sh
cd "$(dirname "$0")"
command -v node >/dev/null || { echo "Node.js 22+ غير مثبت: https://nodejs.org"; exit 1; }
[ -f .env ] || { cp .env.example .env; echo "ADMIN_EMAIL=admin@store.local" >> .env; echo "ADMIN_PASSWORD=ChangeMe12345" >> .env; }
echo "المتجر: http://localhost:3000   |   الإدارة: http://localhost:3000/admin/  (admin@store.local / ChangeMe12345)"
(sleep 1; (open http://localhost:3000 || xdg-open http://localhost:3000) >/dev/null 2>&1) &
exec node --no-warnings server/index.js
