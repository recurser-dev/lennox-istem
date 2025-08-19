#!/bin/bash

# 🔧 Simple TensorFlow.js Fix - Uses Most Compatible Versions
# Alternative fix for stubborn compatibility issues

clear

echo -e "\033[0;35m"
echo "  🔧 SIMPLE TENSORFLOW.JS FIX 🔧"
echo "  ==============================="
echo -e "\033[0m"
echo "📍 Location: $(pwd)"
echo "🕐 Time: $(date)"
echo ""

echo "🧹 Complete clean install with most compatible versions..."

# Stop any running servers
echo "🛑 Stopping any running servers..."
lsof -ti:3000 | xargs kill -9 2>/dev/null || true
lsof -ti:3001 | xargs kill -9 2>/dev/null || true
lsof -ti:3002 | xargs kill -9 2>/dev/null || true
sleep 2

# Remove everything
echo "🗑️ Removing all dependencies..."
rm -rf node_modules
rm -f package-lock.json

# Clear npm cache
echo "🧽 Clearing npm cache..."
npm cache clean --force

# Use a simpler, more compatible approach
echo "📦 Installing with simplified compatible versions..."

# Create a temporary package.json with exact versions
cat > package.json.temp << EOF
{
  "name": "lenny-penny-burrow-monitor",
  "version": "1.0.0",
  "description": "Animated dashboard for monitoring animals in burrows with fake webcam stream and object detection",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "@tensorflow-models/coco-ssd": "2.2.2",
    "@tensorflow/tfjs": "3.21.0",
    "@tensorflow/tfjs-node": "3.21.0",
    "canvas": "3.1.2",
    "cors": "2.8.5",
    "express": "4.18.2",
    "socket.io": "4.7.2"
  },
  "devDependencies": {
    "nodemon": "3.0.1"
  },
  "keywords": [
    "webcam",
    "object-detection",
    "dashboard",
    "animals",
    "burrow"
  ],
  "author": "Lenny Penny Monitor",
  "license": "MIT"
}
EOF

# Backup original package.json
cp package.json package.json.backup

# Use temp package.json
cp package.json.temp package.json

echo "📦 Installing with exact versions and legacy peer deps..."
npm install --legacy-peer-deps

# Restore original package.json
cp package.json.backup package.json
rm package.json.temp package.json.backup

echo ""
echo -e "\033[0;32m✅ Simple fix complete!\033[0m"
echo ""
echo "🧪 Testing TensorFlow.js installation..."

# Test TensorFlow.js
node -e "
try {
  const tf = require('@tensorflow/tfjs-node');
  const cocoSsd = require('@tensorflow-models/coco-ssd');
  console.log('✅ TensorFlow.js modules load successfully');
  console.log('📦 TensorFlow.js version:', tf.version.tfjs);
  console.log('🎯 COCO-SSD version loaded');
} catch (error) {
  console.log('❌ TensorFlow.js test failed:', error.message);
  console.log('💡 You may need to use a different Node.js version');
  console.log('💻 Current Node.js version:', process.version);
  console.log('🔄 Try Node.js v18 or v20 if issues persist');
}
"

echo ""
echo "🚀 You can now try launching the Wildlife Monitor again!"
echo "📱 Double-click: 🦘 Launch Aussie Wildlife Monitor.command"
