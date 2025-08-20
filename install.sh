#!/bin/bash

# 🦘 Australian Wildlife Monitor - Fresh Installation Script
# One-click setup for completely fresh computers
# Fixed version with proper line breaks

set -e  # Exit on any error

# Colors and effects
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Animation function
animate_text() {
    local text="$1"
    local delay="$2"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo
}

# Progress bar function
progress_bar() {
    local duration=$1
    local size=30
    local progress=0
    
    echo -ne "${BLUE}["
    while [ $progress -lt $size ]; do
        echo -ne "█"
        sleep 0.02
        ((progress++))
    done
    echo -e "]${NC} ✅"
}

clear

# Flashy banner
echo -e "${PURPLE}${BOLD}"
cat << "EOF"
    
  🦘 AUSTRALIAN WILDLIFE MONITOR 🦘
  ==================================
    
    Real AI Detection • Australian Animals
    TensorFlow.js • Live Webcam Feed
    
EOF
echo -e "${NC}"

animate_text "🚀 Setting up your Wildlife Monitor..." 0.03
echo ""

# Check macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ This installer is designed for macOS only${NC}"
    exit 1
fi

# Check and setup Node.js
echo -e "${CYAN}📦 Checking Node.js installation...${NC}"
NODE_VERSION=""
if command -v node >/dev/null 2>&1; then
    NODE_VERSION=$(node --version)
    MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
    
    echo -e "${WHITE}   Current Node.js: $NODE_VERSION${NC}"
    
    if [ "$MAJOR_VERSION" -ge 24 ]; then
        echo -e "${YELLOW}⚠️  Node.js v24+ detected - will need compatibility fix${NC}"
        NEEDS_NODE_FIX=true
    elif [ "$MAJOR_VERSION" -lt 18 ]; then
        echo -e "${YELLOW}⚠️  Old Node.js version - will recommend upgrade${NC}"
        NEEDS_NODE_FIX=true
    else
        echo -e "${GREEN}✅ Compatible Node.js version${NC}"
        NEEDS_NODE_FIX=false
    fi
else
    echo -e "${YELLOW}❌ Node.js not found${NC}"
    echo -e "${WHITE}📥 You'll need to install Node.js v20 (LTS)...${NC}"
    echo -e "${BLUE}   Visit: https://nodejs.org${NC}"
    echo -e "${WHITE}   Download Node.js v20 (LTS) and run this script again${NC}"
    open "https://nodejs.org/"
    echo ""
    read -p "Press Enter after installing Node.js to continue..."
    
    # Check again after user says they installed it
    if ! command -v node >/dev/null 2>&1; then
        echo -e "${RED}❌ Node.js still not found. Please install it and try again${NC}"
        exit 1
    fi
    
    NODE_VERSION=$(node --version)
    MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
    echo -e "${GREEN}✅ Node.js $NODE_VERSION detected${NC}"
    
    if [ "$MAJOR_VERSION" -ge 24 ]; then
        NEEDS_NODE_FIX=true
    else
        NEEDS_NODE_FIX=false
    fi
fi

echo ""

# Choose installation directory
echo -e "${CYAN}📁 Choose installation location:${NC}"
echo -e "${WHITE}   1) Desktop (recommended)${NC}"
echo -e "${WHITE}   2) Documents${NC}"
echo -e "${WHITE}   3) Custom location${NC}"
echo ""
read -p "Choose (1-3): " location_choice

case $location_choice in
    1)
        INSTALL_DIR="$HOME/Desktop/LennoxIstem"
        ;;
    2)
        INSTALL_DIR="$HOME/Documents/LennoxIstem"
        ;;
    3)
        read -p "Enter custom path: " custom_path
        INSTALL_DIR="$custom_path/LennoxIstem"
        ;;
    *)
        INSTALL_DIR="$HOME/Desktop/LennoxIstem"
        echo -e "${YELLOW}Using default: Desktop${NC}"
        ;;
esac

echo -e "${WHITE}📁 Installing to: $INSTALL_DIR${NC}"
echo ""

# Create directory and clone
echo -e "${CYAN}📥 Downloading Australian Wildlife Monitor...${NC}"
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}⚠️  Directory exists. Removing old installation...${NC}"
    rm -rf "$INSTALL_DIR"
fi

mkdir -p "$(dirname "$INSTALL_DIR")"
cd "$(dirname "$INSTALL_DIR")"

echo -e "${BLUE}   Cloning from GitHub...${NC}"
if git clone https://github.com/recurser-dev/lennox-istem.git "$(basename "$INSTALL_DIR")"; then
    echo -e "${GREEN}✅ Download complete${NC}"
else
    echo -e "${RED}❌ Failed to download from GitHub${NC}"
    echo -e "${WHITE}💡 Please check your internet connection and try again${NC}"
    exit 1
fi

cd "$INSTALL_DIR"
echo ""

# Make scripts executable
echo -e "${CYAN}🔧 Setting up executable scripts...${NC}"
chmod +x *.command 2>/dev/null || true
progress_bar 1

# Install dependencies with compatibility handling
echo -e "${CYAN}📦 Installing dependencies...${NC}"
echo -e "${WHITE}   This may take a few minutes...${NC}"

# Try standard install first
if npm install --legacy-peer-deps >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Dependencies installed successfully${NC}"
else
    echo -e "${YELLOW}⚠️  Standard install failed, trying compatibility fix...${NC}"
    
    # Clean and retry
    rm -rf node_modules
    rm -f package-lock.json
    npm cache clean --force >/dev/null 2>&1
    
    # Force compatible versions
    npm install --save --legacy-peer-deps \
        "@tensorflow/tfjs@3.21.0" \
        "@tensorflow/tfjs-node@3.21.0" \
        "@tensorflow-models/coco-ssd@2.2.2" \
        "express@4.18.2" \
        "socket.io@4.7.2" \
        "cors@2.8.5" \
        "canvas@3.1.2" >/dev/null 2>&1
    
    # Install remaining dependencies
    npm install --legacy-peer-deps >/dev/null 2>&1
    echo -e "${GREEN}✅ Dependencies installed with compatibility mode${NC}"
fi

echo ""

# Test TensorFlow.js compatibility
echo -e "${CYAN}🧪 Testing TensorFlow.js compatibility...${NC}"
TEST_RESULT=$(node -e "
try {
  const tf = require('@tensorflow/tfjs-node');
  const cocoSsd = require('@tensorflow-models/coco-ssd');
  console.log('SUCCESS');
} catch (error) {
  console.log('FAILED:', error.message);
}
" 2>/dev/null || echo "FAILED: Module not found")

if [[ "$TEST_RESULT" == "SUCCESS" ]]; then
    echo -e "${GREEN}✅ TensorFlow.js working perfectly${NC}"
    TENSORFLOW_OK=true
else
    echo -e "${YELLOW}⚠️  TensorFlow.js needs fixing${NC}"
    TENSORFLOW_OK=false
fi

echo ""

# Create desktop launcher
echo -e "${CYAN}🚀 Creating desktop launcher...${NC}"
LAUNCHER_PATH="$HOME/Desktop/🦘 Launch Wildlife Monitor.command"

cat > "$LAUNCHER_PATH" << EOF
#!/bin/bash
cd "$INSTALL_DIR"

# Check if project exists
if [ ! -f "server.js" ]; then
    echo "❌ Wildlife Monitor not found at: $INSTALL_DIR"
    echo "💡 Please run the installer again"
    read -p "Press Enter to exit..."
    exit 1
fi

# Check Node.js compatibility
NODE_VERSION=\$(node --version 2>/dev/null || echo "MISSING")
if [[ "\$NODE_VERSION" == "MISSING" ]]; then
    echo "❌ Node.js not found. Please install Node.js v20 from nodejs.org"
    open "https://nodejs.org/"
    read -p "Press Enter to exit..."
    exit 1
fi

MAJOR_VERSION=\$(echo \$NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
if [ "\$MAJOR_VERSION" -ge 24 ]; then
    echo "⚠️  Node.js v24+ detected. Running compatibility fix..."
    if [ -f "🔄 Node.js Version Fix.command" ]; then
        bash "🔄 Node.js Version Fix.command"
    else
        echo "💡 Please downgrade to Node.js v20 for best compatibility"
        echo "   Visit: https://nodejs.org/"
        read -p "Continue anyway? (y/n): " choice
        if [[ ! \$choice =~ ^[Yy]\$ ]]; then
            exit 1
        fi
    fi
fi

# Launch the monitor
echo "🦘 Starting Australian Wildlife Monitor..."
exec bash "🦘 Launch Aussie Wildlife Monitor.command"
EOF

chmod +x "$LAUNCHER_PATH"
echo -e "${GREEN}✅ Desktop launcher created${NC}"
echo ""

# Installation complete
echo -e "${GREEN}${BOLD}"
cat << "EOF"
    
    ✅ INSTALLATION COMPLETE! ✅
    
EOF
echo -e "${NC}"

echo -e "${CYAN}📁 FILES CREATED:${NC}"
echo -e "${GREEN}  🦘 Launch Wildlife Monitor.command  ${BLUE}(Desktop)${NC}"
echo -e "${GREEN}  📁 LennoxIstem/                     ${BLUE}($INSTALL_DIR)${NC}"
echo -e "${GREEN}  🔧 Fix scripts                      ${BLUE}(If needed)${NC}"
echo ""

echo -e "${YELLOW}${BOLD}🚀 QUICK START:${NC}"
echo -e "${WHITE}  1. ${BLUE}Double-click${NC} 🦘 Launch Wildlife Monitor.command on Desktop"
echo -e "${WHITE}  2. ${BLUE}Allow webcam access${NC} when browser prompts"
echo -e "${WHITE}  3. ${BLUE}Click 'Start Monitoring'${NC} and watch AI detect Australian wildlife! 🦘${NC}"
echo ""

# Show specific next steps based on detected issues
if [[ "$NEEDS_NODE_FIX" == true ]] || [[ "$TENSORFLOW_OK" == false ]]; then
    echo -e "${YELLOW}${BOLD}🔧 IMPORTANT - FIX NEEDED:${NC}"
    
    if [[ "$NEEDS_NODE_FIX" == true ]]; then
        echo -e "${WHITE}  • ${RED}Node.js compatibility issue detected${NC}"
        echo -e "${WHITE}    Run: ${BLUE}🔄 Node.js Version Fix.command${NC}"
    fi
    
    if [[ "$TENSORFLOW_OK" == false ]]; then
        echo -e "${WHITE}  • ${RED}TensorFlow.js needs fixing${NC}"
        echo -e "${WHITE}    Run: ${BLUE}🔧 Fix TensorFlow Compatibility.command${NC}"
    fi
    
    echo -e "${WHITE}  • ${BLUE}Then launch normally${NC}"
    echo ""
else
    echo -e "${GREEN}${BOLD}🎉 Everything looks good! Ready to launch! 🎉${NC}"
    echo ""
fi

echo -e "${PURPLE}📱 The monitor will open in your browser at: ${WHITE}http://localhost:3000${NC}"
echo -e "${PURPLE}🦘 Detects: Cats→Quolls, Dogs→Dingoes, Birds→Kookaburras, People→Wombats${NC}"
echo ""

# Ask if user wants to launch now
read -p "🚀 Launch the Wildlife Monitor now? (y/n): " launch_choice
if [[ $launch_choice =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${CYAN}🚀 Launching Australian Wildlife Monitor...${NC}"
    exec bash "$LAUNCHER_PATH"
else
    echo ""
    echo -e "${BLUE}👍 Run ${WHITE}🦘 Launch Wildlife Monitor.command${BLUE} when ready!${NC}"
fi