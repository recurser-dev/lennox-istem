#!/bin/bash
cd "$(dirname "$0")"
clear

echo -e "\033[0;35m"
echo "  🦘 LENNY PENNY AUSTRALIAN WILDLIFE MONITOR 🦘"
echo "  =============================================="
echo -e "\033[0m"
echo "📍 Location: $(pwd)"
echo "🕐 Time: $(date)"
echo ""

# Check for package.json changes and update dependencies if needed
if [ ! -d "node_modules" ] || [ "package.json" -nt "node_modules" ]; then
    echo "📦 Installing/updating dependencies..."
    npm install
    echo ""
fi

# Kill any existing processes on port 3000
echo "🛑 Checking for existing processes..."
lsof -ti:3000 | xargs kill -9 2>/dev/null || true
sleep 1

echo "🚀 Starting server..."
npm start &
SERVER_PID=$!

echo "⏳ Waiting for server to start..."
sleep 4

echo "🌐 Opening browser..."
open http://localhost:3000

echo ""
echo -e "\033[0;32m✅ Lenny Penny's Wildlife Monitor is ready!\033[0m"
echo "📱 Dashboard: http://localhost:3000"
echo "🦘 Start monitoring to detect Australian wildlife!"
echo "⏹️  To stop: Close this window or press Ctrl+C"
echo ""

# Keep the terminal open and wait for server
wait $SERVER_PID
