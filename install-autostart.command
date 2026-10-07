#!/bin/sh
# ماك: تشغيل تلقائي في الخلفية عبر launchd
cd "$(dirname "$0")"; DIR="$(pwd)"; NODE="$(command -v node)" || { echo "ثبّتي Node.js 22+ أولًا"; exit 1; }
[ -f .env ] || { cp .env.example .env; echo "ADMIN_EMAIL=admin@store.local" >> .env; echo "ADMIN_PASSWORD=ChangeMe12345" >> .env; }
mkdir -p data; P="$HOME/Library/LaunchAgents/com.store.scarf.plist"
cat > "$P" <<PL
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict><key>Label</key><string>com.store.scarf</string>
<key>ProgramArguments</key><array><string>$NODE</string><string>--no-warnings</string><string>server/index.js</string></array>
<key>WorkingDirectory</key><string>$DIR</string><key>RunAtLoad</key><true/><key>KeepAlive</key><true/>
<key>StandardOutPath</key><string>$DIR/data/server.log</string><key>StandardErrorPath</key><string>$DIR/data/server.log</string></dict></plist>
PL
launchctl unload "$P" 2>/dev/null; launchctl load "$P"; sleep 2; open http://localhost:3000
echo "تم. شغّال في الخلفية. للإلغاء: launchctl unload $P"
