#!/bin/bash

# 🦝 Lenny Penny Launcher Script
# This script starts the Lenny Penny Burrow Monitor

clear

echo "🦝 Starting Lenny Penny Burrow Monitor..."
echo "📍 Location: $(pwd)"
echo "🕐 Time: $(date)"
echo ""

# Check if dependencies are installed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
    echo ""
fi

# Start the server in background
echo "🚀 Launching server..."
npm start &
SERVER_PID=$!

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "🛑 Stopping Lenny Penny..."
    kill $SERVER_PID 2>/dev/null
    exit 0
}

# Set trap to cleanup on script exit
trap cleanup SIGINT SIGTERM

# Wait a moment for server to start
sleep 3

# Check if server is running
if ps -p $SERVER_PID > /dev/null; then
    echo "✅ Server started successfully!"
    
    # Open browser
    echo "🌐 Opening browser..."
    open http://localhost:3000
    
    echo ""
    echo "🦝 Lenny Penny is ready!"
    echo "📱 Dashboard: http://localhost:3000"
    echo "📊 Features:"
    echo "   • Real-time webcam monitoring"
    echo "   • AI object detection"
    echo "   • Interactive dashboard"
    echo "   • Live statistics"
    echo ""
    echo "⏹️  To stop: Press Ctrl+C"
    echo ""
    
    # Wait for server process
    wait $SERVER_PID
else
    echo "❌ Failed to start server"
    exit 1
fi
