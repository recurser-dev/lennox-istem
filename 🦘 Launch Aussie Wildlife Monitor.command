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

# Verify we're in the correct project directory
if [ ! -f "server.js" ] || [ ! -f "package.json" ]; then
    echo "❌ Error: Could not find server.js or package.json"
    echo "🚫 Make sure this script is in the LennoxIstem project folder"
    echo "📁 Current directory: $(pwd)"
    echo "📁 Expected files: server.js, package.json"
    exit 1
fi

echo "✅ Project files found - proceeding with launch..."
echo ""

# Check Node.js version compatibility
NODE_VERSION=$(node --version)
MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')

echo "📦 Node.js version: $NODE_VERSION"

if [ "$MAJOR_VERSION" -ge 24 ]; then
    echo -e "\033[0;33m⚠️ WARNING: Node.js v24+ may have TensorFlow.js compatibility issues\033[0m"
    echo "💡 If you encounter errors, run: 🔄 Node.js Version Fix.command"
    echo ""
elif [ "$MAJOR_VERSION" -eq 22 ] || [ "$MAJOR_VERSION" -eq 20 ] || [ "$MAJOR_VERSION" -eq 18 ]; then
    echo "✅ Compatible Node.js version detected"
    echo ""
else
    echo -e "\033[0;31m⚠️ Old Node.js version detected\033[0m"
    echo "💡 Consider upgrading to Node.js v20 for best compatibility"
    echo ""
fi

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
