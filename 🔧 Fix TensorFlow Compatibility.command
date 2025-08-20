#!/bin/bash

# 🔧 TensorFlow.js Compatibility Fix Script
# Run this if you're experiencing TensorFlow.js compatibility issues

clear

echo -e "\033[0;35m"
echo "  🔧 TENSORFLOW.JS COMPATIBILITY FIX 🔧"
echo "  ====================================="
echo -e "\033[0m"
echo "📍 Location: $(pwd)"
echo "🕐 Time: $(date)"
echo ""

# Ensure we're in the project directory
if [ ! -f "package.json" ]; then
    echo "❌ package.json not found! Make sure you're in the project directory."
    echo "🚫 This script must be run from the LennoxIstem project folder."
    exit 1
fi

echo "✅ Found package.json - proceeding with fix..."
echo ""

echo "🧹 Cleaning up existing dependencies..."

# Stop any running servers
echo "🛑 Stopping any running servers..."
lsof -ti:3000 | xargs kill -9 2>/dev/null || true
lsof -ti:3001 | xargs kill -9 2>/dev/null || true
lsof -ti:3002 | xargs kill -9 2>/dev/null || true
sleep 2

# Remove node_modules and package-lock.json
echo "🗑️ Removing node_modules and package-lock.json..."
rm -rf node_modules
rm -f package-lock.json

# Clear npm cache
echo "🧽 Clearing npm cache..."
npm cache clean --force

# Set npm to prefer local installations
echo "🎯 Configuring npm for local installation..."
npm config set prefix "$(pwd)"
npm config set global false

# Install specific compatible versions
echo "📦 Installing compatible TensorFlow.js versions..."
echo "   @tensorflow/tfjs@3.21.0"
echo "   @tensorflow/tfjs-node@3.21.0"
echo "   @tensorflow-models/coco-ssd@2.2.2"

# Try normal install first
if npm install --save @tensorflow/tfjs@3.21.0 @tensorflow/tfjs-node@3.21.0 @tensorflow/tfjs-backend-cpu@3.21.0 @tensorflow-models/coco-ssd@2.2.2; then
    echo "✅ Normal installation successful"
else
    echo "⚠️ Normal install failed, trying with legacy peer deps..."
    npm install --save --legacy-peer-deps @tensorflow/tfjs@3.21.0 @tensorflow/tfjs-node@3.21.0 @tensorflow/tfjs-backend-cpu@3.21.0 @tensorflow-models/coco-ssd@2.2.2
fi

# Install other dependencies
echo "📦 Installing other dependencies..."
if npm install; then
    echo "✅ All dependencies installed successfully"
else
    echo "⚠️ Some dependencies failed, trying with legacy peer deps..."
    npm install --legacy-peer-deps
fi

echo ""
echo -e "\033[0;32m✅ Compatibility fix complete!\033[0m"
echo ""
echo "🧪 Testing TensorFlow.js installation..."

# Verify we're in the right directory
echo "📁 Current directory: $(pwd)"
echo "📦 Checking if node_modules exists..."
if [ -d "node_modules" ]; then
    echo "✅ node_modules directory found"
    echo "📊 Size: $(du -sh node_modules | cut -f1)"
else
    echo "❌ node_modules directory missing!"
    echo "🔄 Running npm install again..."
    npm install --legacy-peer-deps
fi

# Test TensorFlow.js with proper path resolution
echo "🧪 Testing TensorFlow.js installation..."
node -e "
console.log('📍 Working directory:', process.cwd());
console.log('📦 Node.js version:', process.version);

// Check Node.js version compatibility
const nodeVersion = process.version;
const majorVersion = parseInt(nodeVersion.split('.')[0].substring(1));

if (majorVersion >= 24) {
  console.log('⚠️ WARNING: Node.js v24+ has known compatibility issues with TensorFlow.js');
  console.log('� RECOMMENDED: Downgrade to Node.js v18 or v20 for best compatibility');
  console.log('💻 Use: nvm install 20 && nvm use 20');
  console.log('');
}

console.log('�🔍 Module resolution paths:');
console.log('   node_modules:', require('path').join(process.cwd(), 'node_modules'));

try {
  // Test if local node_modules exists
  const fs = require('fs');
  const path = require('path');
  const nodeModulesPath = path.join(process.cwd(), 'node_modules');
  
  if (!fs.existsSync(nodeModulesPath)) {
    throw new Error('Local node_modules directory not found at: ' + nodeModulesPath);
  }
  
  const tf = require('@tensorflow/tfjs-node');
  const cocoSsd = require('@tensorflow-models/coco-ssd');
  console.log('✅ TensorFlow.js modules load successfully');
  console.log('📦 TensorFlow.js version:', tf.version.tfjs);
  console.log('🎯 COCO-SSD model available');
} catch (error) {
  console.log('❌ TensorFlow.js test failed:', error.message);
  console.log('💡 This suggests a Node.js version compatibility issue');
  console.log('🔧 SOLUTION for Node.js v24+:');
  console.log('   1. Install Node.js v20: nvm install 20 && nvm use 20');
  console.log('   2. Or use Node.js v18: nvm install 18 && nvm use 18');
  console.log('   3. Then re-run this fix script');
  console.log('');
  console.log('💡 Alternative solutions:');
  console.log('   • Check if you have conflicting global installations');
  console.log('   • Try the Simple TensorFlow Fix script instead');
}
"

echo ""
echo "🚀 You can now try launching the Wildlife Monitor again!"
echo "📱 Double-click: 🦘 Launch Aussie Wildlife Monitor.command"
