#!/bin/bash

# 🔄 Node.js Version Fix - Automatically fixes Node.js v24+ compatibility issues
# This script detects Node.js v24+ and guides you to downgrade to v20

clear

echo -e "\033[0;33m"
echo "  🔄 NODE.JS VERSION COMPATIBILITY FIX 🔄"
echo "  ======================================="
echo -e "\033[0m"
echo "📍 Location: $(pwd)"
echo "🕐 Time: $(date)"
echo ""

# Check current Node.js version
NODE_VERSION=$(node --version)
MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')

echo "📦 Current Node.js version: $NODE_VERSION"
echo "🔢 Major version: $MAJOR_VERSION"
echo ""

if [ "$MAJOR_VERSION" -ge 24 ]; then
    echo -e "\033[0;31m⚠️ COMPATIBILITY ISSUE DETECTED\033[0m"
    echo "🚫 Node.js v24+ has compatibility issues with TensorFlow.js v3.21.0"
    echo "✅ Your working system uses Node.js v22.15.0"
    echo "🎯 Recommended: Node.js v20 (LTS) for maximum compatibility"
    echo ""
    
    # Check if nvm is available
    if command -v nvm >/dev/null 2>&1; then
        echo "✅ NVM (Node Version Manager) is available"
        echo ""
        echo "🔄 AUTOMATIC FIX AVAILABLE:"
        echo "   We can automatically install and switch to Node.js v20"
        echo ""
        read -p "🤔 Would you like to automatically install Node.js v20? (y/n): " choice
        
        if [[ $choice =~ ^[Yy]$ ]]; then
            echo ""
            echo "📦 Installing Node.js v20 (LTS)..."
            nvm install 20
            
            echo "🔄 Switching to Node.js v20..."
            nvm use 20
            
            echo "📌 Setting Node.js v20 as default..."
            nvm alias default 20
            
            echo "✅ Node.js version updated!"
            echo "📦 New version: $(node --version)"
            echo ""
            
            echo "🧹 Cleaning up existing dependencies..."
            rm -rf node_modules
            rm -f package-lock.json
            
            echo "📦 Reinstalling dependencies with compatible Node.js..."
            npm install --legacy-peer-deps
            
            echo ""
            echo -e "\033[0;32m✅ COMPATIBILITY FIX COMPLETE!\033[0m"
            echo "🎯 Node.js v20 is now active and TensorFlow.js should work"
            echo ""
        else
            echo ""
            echo "📋 MANUAL STEPS TO FIX:"
            echo "   1. Install Node.js v20: nvm install 20"
            echo "   2. Switch to v20: nvm use 20"
            echo "   3. Set as default: nvm alias default 20"
            echo "   4. Reinstall deps: npm install --legacy-peer-deps"
            echo ""
        fi
    else
        echo "❌ NVM (Node Version Manager) not found"
        echo ""
        echo "📋 MANUAL FIX OPTIONS:"
        echo ""
        echo "🔧 Option 1: Install NVM and Node.js v20"
        echo "   1. Install NVM: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash"
        echo "   2. Restart terminal or run: source ~/.bashrc"
        echo "   3. Install Node.js v20: nvm install 20"
        echo "   4. Use Node.js v20: nvm use 20"
        echo "   5. Set as default: nvm alias default 20"
        echo ""
        echo "🔧 Option 2: Download Node.js v20 directly"
        echo "   1. Visit: https://nodejs.org/en/download/"
        echo "   2. Download Node.js v20.x.x LTS"
        echo "   3. Install and restart terminal"
        echo ""
    fi
    
elif [ "$MAJOR_VERSION" -eq 22 ] || [ "$MAJOR_VERSION" -eq 20 ] || [ "$MAJOR_VERSION" -eq 18 ]; then
    echo -e "\033[0;32m✅ COMPATIBLE NODE.JS VERSION\033[0m"
    echo "🎯 Node.js v$MAJOR_VERSION is compatible with TensorFlow.js"
    echo ""
    echo "💡 The issue might be elsewhere. Try:"
    echo "   🔧 Fix TensorFlow Compatibility.command"
    echo "   🔧 Simple TensorFlow Fix.command"
    echo ""
    
else
    echo -e "\033[0;31m⚠️ VERY OLD NODE.JS VERSION\033[0m"
    echo "🔄 Node.js v$MAJOR_VERSION is too old"
    echo "🎯 Recommended: Upgrade to Node.js v20 (LTS)"
    echo ""
fi

echo "🧪 Testing current TensorFlow.js compatibility..."
node -e "
try {
  const tf = require('@tensorflow/tfjs-node');
  console.log('✅ TensorFlow.js loads successfully with Node.js', process.version);
} catch (error) {
  console.log('❌ TensorFlow.js failed with Node.js', process.version);
  console.log('💡 Error:', error.message);
}
" 2>/dev/null || echo "❌ TensorFlow.js modules not installed or incompatible"

echo ""
echo "🚀 After fixing Node.js version, try launching:"
echo "📱 🦘 Launch Aussie Wildlife Monitor.command"
