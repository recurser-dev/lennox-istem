#!/bin/bash

# 🦝 Lennox ISTEM - One-Click Installation Script for macOS
# Simple, interactive installation that sets up everything on your Desktop

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

clear

# Simple banner
echo -e "${PURPLE}"
echo "  🦝 LENNOX ISTEM INSTALLER 🦝"
echo "  ==============================="
echo "  AI Animal Detection Dashboard"
echo -e "${NC}\n"

echo -e "${BLUE}This installer will:${NC}"
echo "  📁 Create 'ISTEM' folder on your Desktop"
echo "  📦 Download the Lenny Penny project"
echo "  🔧 Install all required software"
echo "  🚀 Set up VS Code with extensions"
echo "  ✨ Create a one-click launcher"
echo ""

read -p "$(echo -e ${YELLOW}Ready to install? Press Enter to continue or Ctrl+C to cancel...${NC})"

echo -e "\n${GREEN}🚀 Starting installation...${NC}\n"

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ This script is for macOS only!${NC}"
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Set up the project directory on Desktop
DESKTOP_DIR="$HOME/Desktop"
ISTEM_DIR="$DESKTOP_DIR/ISTEM"
PROJECT_DIR="$ISTEM_DIR/lennox-istem"

echo -e "${BLUE}📁 Setting up project directory...${NC}"
mkdir -p "$ISTEM_DIR"

# Install Homebrew if needed
if ! command_exists brew; then
    echo -e "${YELLOW}🍺 Installing Homebrew (this may take a few minutes)...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo -e "${GREEN}✅ Homebrew already installed${NC}"
fi

# Install Git if needed
if ! command_exists git; then
    echo -e "${YELLOW}🔧 Installing Git...${NC}"
    brew install git
else
    echo -e "${GREEN}✅ Git already installed${NC}"
fi

# Install Node.js if needed
if ! command_exists node; then
    echo -e "${YELLOW}📦 Installing Node.js...${NC}"
    brew install node
else
    echo -e "${GREEN}✅ Node.js already installed ($(node --version))${NC}"
fi

# Install VS Code if needed
if ! command_exists code; then
    echo -e "${YELLOW}💻 Installing VS Code...${NC}"
    brew install --cask visual-studio-code
    sleep 3
else
    echo -e "${GREEN}✅ VS Code already installed${NC}"
fi

# Clone the project
echo -e "${YELLOW}📥 Downloading Lenny Penny project...${NC}"
if [ -d "$PROJECT_DIR" ]; then
    echo -e "${BLUE}Project already exists, updating...${NC}"
    cd "$PROJECT_DIR"
    git pull
else
    cd "$ISTEM_DIR"
    git clone https://github.com/recurser-dev/lennox-istem.git
    cd "$PROJECT_DIR"
fi

# Install project dependencies
echo -e "${YELLOW}📦 Installing project dependencies...${NC}"
npm install

# Install VS Code extensions
echo -e "${YELLOW}🔌 Installing VS Code extensions...${NC}"
extensions=(
    "ms-vscode.vscode-json"
    "esbenp.prettier-vscode"
    "ms-vscode.vscode-typescript-next"
    "christian-kohler.path-intellisense"
    "ritwickdey.liveserver"
    "GitHub.copilot"
    "GitHub.copilot-chat"
)

for extension in "${extensions[@]}"; do
    code --install-extension "$extension" --force >/dev/null 2>&1
done

# Create a simple launcher on the Desktop
echo -e "${YELLOW}🚀 Creating Desktop launcher...${NC}"
cat > "$DESKTOP_DIR/🦝 Launch Lenny Penny.command" << 'EOF'
#!/bin/bash
cd "$HOME/Desktop/ISTEM/lennox-istem"
clear
echo "🦝 Starting Lenny Penny Burrow Monitor..."
echo "📍 Location: $(pwd)"
echo ""

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Start the server
echo "🚀 Launching server..."
npm start &
SERVER_PID=$!

# Wait for server to start
sleep 3

# Open browser
echo "🌐 Opening browser..."
open http://localhost:3000

echo ""
echo "✅ Lenny Penny is ready!"
echo "📱 Dashboard: http://localhost:3000"
echo "⏹️  To stop: Close this window or press Ctrl+C"
echo ""

# Wait for server
wait $SERVER_PID
EOF

chmod +x "$DESKTOP_DIR/🦝 Launch Lenny Penny.command"

# Create instructions file
cat > "$ISTEM_DIR/📋 HOW TO USE.txt" << 'EOF'
🦝 LENNY PENNY BURROW MONITOR - INSTRUCTIONS

🚀 QUICK START:
1. Double-click "🦝 Launch Lenny Penny.command" on your Desktop
2. Allow webcam access when prompted
3. Click "Start Monitoring" in the browser
4. Watch Lenny Penny detect animals in real-time!

💻 DEVELOPMENT:
1. Open the "lennox-istem" folder in VS Code
2. Press Cmd+Shift+P and type "Tasks: Run Task"
3. Select "🦝 Start Lenny Penny"

🔧 FEATURES:
• Real-time webcam monitoring
• AI object detection (cats, dogs, birds, people, etc.)
• Animated dashboard with Lenny Penny character
• Live statistics and detection history
• Beautiful particle effects

🆘 TROUBLESHOOTING:
• If webcam shows black: Refresh browser and allow camera access
• If server won't start: Check that port 3000 isn't in use
• For other issues: Check the GitHub repository

📦 PROJECT LOCATION:
Desktop/ISTEM/lennox-istem/

🌐 GITHUB:
https://github.com/recurser-dev/lennox-istem

Made with ❤️ for STEM education!
EOF

echo -e "\n${GREEN}🎉 Installation Complete!${NC}\n"

echo -e "${PURPLE}📁 Files created on your Desktop:${NC}"
echo -e "  🦝 Launch Lenny Penny.command  - Double-click to start!"
echo -e "  📁 ISTEM/                      - Your project folder"
echo -e "  📋 HOW TO USE.txt              - Complete instructions"

echo -e "\n${PURPLE}🚀 Quick Start:${NC}"
echo -e "  1. Double-click ${BLUE}🦝 Launch Lenny Penny.command${NC} on your Desktop"
echo -e "  2. Allow webcam access when prompted"
echo -e "  3. Click 'Start Monitoring' and watch the magic! ✨"

echo -e "\n${GREEN}Opening project folder for you...${NC}"

# Open the project folder in Finder
open "$ISTEM_DIR"

# Ask if user wants to launch now
echo ""
read -p "$(echo -e ${YELLOW}🦝 Launch Lenny Penny now? [Y/n]: ${NC})" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${GREEN}🚀 Starting Lenny Penny...${NC}"
    cd "$PROJECT_DIR"
    npm start &
    sleep 3
    open http://localhost:3000
    echo -e "${GREEN}✅ Lenny Penny is running! Check your browser!${NC}"
fi

echo -e "\n${PURPLE}🦝 Happy animal detecting! 🦝${NC}"
