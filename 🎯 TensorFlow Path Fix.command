#!/bin/bash

# 🎯 TensorFlow.js Path Fix - Resolves module resolution issues
# Use this if the main fix script shows path errors

clear

echo -e "\033[0;36m"
echo "  🎯 TENSORFLOW.JS PATH FIX 🎯"
echo "  ============================="
echo -e "\033[0m"
echo "📍 Location: $(pwd)"
echo "🕐 Time: $(date)"
echo ""

# Ensure we're in the right place
if [ ! -f "package.json" ]; then
    echo "❌ package.json not found!"
    echo "🚫 Please run this from the LennoxIstem project folder."
    exit 1
fi

echo "📦 Current Node.js setup:"
echo "   Node.js version: $(node --version)"
echo "   npm version: $(npm --version)"
echo "   Working directory: $(pwd)"
echo ""

# Check for conflicting Node.js setups
echo "🔍 Checking for conflicting Node.js installations..."
which node
which npm

# Clear any global npm config that might interfere
echo "🧽 Clearing npm configuration conflicts..."
npm config delete prefix
npm config delete global
npm config set fund false
npm config set audit false

# Force completely clean install
echo "🗑️ Complete cleanup..."
rm -rf node_modules
rm -f package-lock.json
rm -f .npmrc

# Create local .npmrc to force local installation
echo "🎯 Creating local npm configuration..."
echo "prefix = $(pwd)" > .npmrc
echo "global = false" >> .npmrc

# Install with explicit local flag
echo "📦 Installing dependencies locally..."
NODE_PATH="" npm install --no-global

# Test the installation
echo ""
echo "🧪 Testing local module resolution..."

node -e "
const path = require('path');
const fs = require('fs');

console.log('📍 Current working directory:', process.cwd());
console.log('📦 Node.js version:', process.version);

// Check local node_modules
const localNodeModules = path.join(process.cwd(), 'node_modules');
console.log('📁 Local node_modules path:', localNodeModules);
console.log('📂 Local node_modules exists:', fs.existsSync(localNodeModules));

if (fs.existsSync(localNodeModules)) {
    const tfPath = path.join(localNodeModules, '@tensorflow', 'tfjs-node');
    console.log('🔍 TensorFlow.js path:', tfPath);
    console.log('📦 TensorFlow.js exists:', fs.existsSync(tfPath));
    
    if (fs.existsSync(tfPath)) {
        const packagePath = path.join(tfPath, 'package.json');
        if (fs.existsSync(packagePath)) {
            const pkg = JSON.parse(fs.readFileSync(packagePath, 'utf8'));
            console.log('📋 Package main entry:', pkg.main);
            
            const mainPath = path.join(tfPath, pkg.main);
            console.log('📄 Main file path:', mainPath);
            console.log('📝 Main file exists:', fs.existsSync(mainPath));
        }
    }
}

try {
    // Force require from local path
    process.env.NODE_PATH = path.join(process.cwd(), 'node_modules');
    require('module').globalPaths.unshift(path.join(process.cwd(), 'node_modules'));
    
    const tf = require('@tensorflow/tfjs-node');
    const cocoSsd = require('@tensorflow-models/coco-ssd');
    
    console.log('✅ TensorFlow.js loaded successfully!');
    console.log('📦 TensorFlow.js version:', tf.version.tfjs);
    console.log('🎯 COCO-SSD model ready');
} catch (error) {
    console.log('❌ Module loading failed:', error.message);
    console.log('💡 Error type:', error.code);
    console.log('🔧 Try running the Simple TensorFlow Fix instead');
}
"

echo ""
echo "🚀 Path fix complete!"
echo "📱 Try launching: 🦘 Launch Aussie Wildlife Monitor.command"
