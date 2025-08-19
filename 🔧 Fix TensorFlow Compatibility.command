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

# Test TensorFlow.js
node -e "
try {
  const tf = require('@tensorflow/tfjs-node');
  const cocoSsd = require('@tensorflow-models/coco-ssd');
  console.log('✅ TensorFlow.js modules load successfully');
  console.log('📦 TensorFlow.js version:', tf.version.tfjs);
} catch (error) {
  console.log('❌ TensorFlow.js test failed:', error.message);
  console.log('💡 You may need to use a different Node.js version');
  console.log('💻 Try: nvm use 18 or nvm use 20');
}
"

echo ""
echo "🚀 You can now try launching the Wildlife Monitor again!"
echo "📱 Double-click: 🦘 Launch Aussie Wildlife Monitor.command"
