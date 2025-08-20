#!/bin/bash

# 🦘 Simple Test Installation Script
# Testing if the issue is with GitHub sync

set -e

echo "🦘 Australian Wildlife Monitor - Test Installer"
echo "=============================================="
echo ""
echo "✅ Script downloaded and running successfully!"
echo ""
echo "📦 Checking Node.js..."
if command -v node >/dev/null 2>&1; then
    echo "✅ Node.js found: $(node --version)"
else
    echo "❌ Node.js not found"
    echo "📥 Please install Node.js v20 from: https://nodejs.org"
    exit 1
fi

echo ""
echo "📁 Choose installation location:"
echo "   1) Desktop"
echo "   2) Documents" 
echo ""
read -p "Choose (1-2): " choice

case $choice in
    1) INSTALL_DIR="$HOME/Desktop/LennoxIstem" ;;
    2) INSTALL_DIR="$HOME/Documents/LennoxIstem" ;;
    *) INSTALL_DIR="$HOME/Desktop/LennoxIstem" ;;
esac

echo "📁 Installing to: $INSTALL_DIR"
echo ""

# Clean install
if [ -d "$INSTALL_DIR" ]; then
    echo "🗑️ Removing existing installation..."
    rm -rf "$INSTALL_DIR"
fi

echo "📥 Downloading from GitHub..."
mkdir -p "$(dirname "$INSTALL_DIR")"
cd "$(dirname "$INSTALL_DIR")"

if git clone https://github.com/recurser-dev/lennox-istem.git "$(basename "$INSTALL_DIR")"; then
    echo "✅ Download successful"
else
    echo "❌ Download failed"
    exit 1
fi

cd "$INSTALL_DIR"

echo "🔧 Making scripts executable..."
chmod +x *.command 2>/dev/null || true

echo "📦 Installing dependencies..."
if npm install --legacy-peer-deps; then
    echo "✅ Dependencies installed"
else
    echo "❌ Dependencies failed"
fi

echo ""
echo "🚀 Creating desktop launcher..."
cat > "$HOME/Desktop/🦘 Test Launch.command" << 'EOF'
#!/bin/bash
echo "🦘 Test launcher working!"
echo "Real launcher: 🦘 Launch Aussie Wildlife Monitor.command"
read -p "Press Enter to exit..."
EOF

chmod +x "$HOME/Desktop/🦘 Test Launch.command"

echo ""
echo "✅ Test installation complete!"
echo "📱 Check Desktop for: 🦘 Test Launch.command"
echo ""
echo "🎯 If this worked, the issue was with the main script format"
echo "🔧 Run the fix scripts in the LennoxIstem folder if needed"
