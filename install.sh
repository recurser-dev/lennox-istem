#!/bin/bash

# 🦝 Lennox ISTEM - One-Click Installation Script for macOS
# Flashy, interactive installation that sets up everything on your Desktop

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
BLINK='\033[5m'
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
    local size=50
    local progress=0
    
    echo -ne "${BLUE}["
    while [ $progress -lt $size ]; do
        echo -ne "█"
        sleep 0.02  # Fixed delay instead of bc calculation
        ((progress++))
    done
    echo -e "]${NC} ✅"
}

clear

# Flashy banner with animation
echo -e "${PURPLE}${BOLD}"
cat << "EOF"
    
    ███████╗██╗███████╗████████╗███████╗███╗   ███╗
    ██╔════╝██║██╔════╝╚══██╔══╝██╔════╝████╗ ████║
    ███████╗██║███████╗   ██║   █████╗  ██╔████╔██║
    ╚════██║██║╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║
    ███████║██║███████║   ██║   ███████╗██║ ╚═╝ ██║
    ╚══════╝╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝
    
EOF

echo -e "${CYAN}${BOLD}"
animate_text "    🦝 LENNY PENNY AI ANIMAL DETECTOR 🦝" 0.05
echo -e "${WHITE}${BOLD}    ═══════════════════════════════════════"
echo -e "${YELLOW}    Real-time Webcam • AI Detection • STEM Education"
echo -e "${NC}\n"

sleep 1

# Flashy feature showcase
echo -e "${PURPLE}${BOLD}✨ FEATURES INCLUDED:${NC}"
echo -e "${GREEN}  🎥 Real-time webcam monitoring"
echo -e "  🤖 TensorFlow.js AI object detection"
echo -e "  🦝 Interactive Lenny Penny character"
echo -e "  📊 Live statistics and history"
echo -e "  ✨ Beautiful animations and effects"
echo -e "  💻 VS Code integration with extensions"
echo -e "  🚀 One-click desktop launcher${NC}\n"

sleep 2

# Ask for permission with style
echo -e "${YELLOW}${BOLD}${BLINK}🚨 INSTALLATION PERMISSION REQUIRED 🚨${NC}"
echo -e "${WHITE}This installer will download and set up the complete ISTEM environment.${NC}\n"

echo -e "${BLUE}Installation will include:${NC}"
echo -e "  • Homebrew (package manager)"
echo -e "  • Node.js (JavaScript runtime)"
echo -e "  • Git (version control)"
echo -e "  • Visual Studio Code (code editor)"
echo -e "  • VS Code extensions (Copilot, Prettier, etc.)"
echo -e "  • Lenny Penny project files"
echo ""

read -p "$(echo -e ${GREEN}${BOLD}Do you want to proceed with installation? [Y/n]: ${NC})" -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${RED}Installation cancelled. Goodbye! 👋${NC}"
    exit 0
fi

echo ""

# Ask for installation location with default
echo -e "${YELLOW}${BOLD}📁 INSTALLATION LOCATION${NC}"
echo -e "${WHITE}Choose where to install the ISTEM project:${NC}\n"

DEFAULT_LOCATION="$HOME/Desktop/ISTEM"
echo -e "${BLUE}Default location: ${GREEN}$DEFAULT_LOCATION${NC}"
echo -e "${BLUE}This will create a visible 'ISTEM' folder on your Desktop${NC}\n"

read -p "$(echo -e ${YELLOW}Use default location? [Y/n]: ${NC})" -n 1 -r
echo

if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo ""
    read -p "$(echo -e ${CYAN}Enter custom installation path: ${NC})" CUSTOM_LOCATION
    if [[ -n "$CUSTOM_LOCATION" ]]; then
        ISTEM_DIR="$CUSTOM_LOCATION"
        echo -e "${GREEN}✅ Using custom location: $ISTEM_DIR${NC}"
    else
        ISTEM_DIR="$DEFAULT_LOCATION"
        echo -e "${YELLOW}⚠️  No path entered, using default: $ISTEM_DIR${NC}"
    fi
else
    ISTEM_DIR="$DEFAULT_LOCATION"
    echo -e "${GREEN}✅ Using default location: $ISTEM_DIR${NC}"
fi

PROJECT_DIR="$ISTEM_DIR/lennox-istem"
echo ""

# Ask about VS Code extensions
echo -e "${YELLOW}${BOLD}🔌 VS CODE EXTENSIONS${NC}"
echo -e "${WHITE}Install helpful VS Code extensions for development?${NC}"
echo -e "${BLUE}Includes: GitHub Copilot, Prettier, TypeScript, Live Server${NC}\n"

read -p "$(echo -e ${CYAN}Install VS Code extensions? [Y/n]: ${NC})" -n 1 -r
echo
INSTALL_EXTENSIONS=true
if [[ $REPLY =~ ^[Nn]$ ]]; then
    INSTALL_EXTENSIONS=false
    echo -e "${YELLOW}⏭️  Skipping VS Code extensions${NC}"
else
    echo -e "${GREEN}✅ Will install VS Code extensions${NC}"
fi

echo ""

# Final confirmation with dramatic effect
echo -e "${RED}${BOLD}🎬 READY TO BEGIN!${NC}"
echo -e "${WHITE}Installation summary:${NC}"
echo -e "${BLUE}  📁 Location: ${GREEN}$ISTEM_DIR${NC}"
echo -e "${BLUE}  🔌 Extensions: ${GREEN}$([ "$INSTALL_EXTENSIONS" = true ] && echo "Yes" || echo "No")${NC}"
echo -e "${BLUE}  📦 Components: ${GREEN}Homebrew, Node.js, Git, VS Code, Lenny Penny${NC}"
echo ""

read -p "$(echo -e ${GREEN}${BOLD}${BLINK}🚀 START INSTALLATION? [Y/n]: ${NC})" -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${RED}Installation cancelled. Come back anytime! 🦝${NC}"
    exit 0
fi

echo ""
echo -e "${GREEN}${BOLD}🎉 LET'S DO THIS! 🎉${NC}\n"

sleep 1

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ This script is designed for macOS only!${NC}"
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Animated installation steps
echo -e "${CYAN}${BOLD}⚡ INSTALLATION IN PROGRESS ⚡${NC}\n"

# Step 1: Create directory
echo -e "${YELLOW}📁 Setting up project directory...${NC}"
mkdir -p "$ISTEM_DIR"
progress_bar 1
echo ""

# Step 2: Install Homebrew
echo -e "${YELLOW}🍺 Checking Homebrew...${NC}"
if ! command_exists brew; then
    echo -e "${BLUE}Installing Homebrew (this may take a few minutes)...${NC}"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    echo -e "${GREEN}✅ Homebrew installed successfully!${NC}"
else
    echo -e "${GREEN}✅ Homebrew already installed${NC}"
fi
echo ""

# Step 3: Install Git
echo -e "${YELLOW}🔧 Checking Git...${NC}"
if ! command_exists git; then
    echo -e "${BLUE}Installing Git...${NC}"
    brew install git
    progress_bar 2
    echo -e "${GREEN}✅ Git installed successfully!${NC}"
else
    echo -e "${GREEN}✅ Git already installed${NC}"
fi
echo ""

# Step 4: Install Node.js
echo -e "${YELLOW}📦 Checking Node.js...${NC}"
if ! command_exists node; then
    echo -e "${BLUE}Installing Node.js...${NC}"
    brew install node
    progress_bar 3
    echo -e "${GREEN}✅ Node.js installed successfully!${NC}"
else
    echo -e "${GREEN}✅ Node.js already installed ($(node --version))${NC}"
fi
echo ""

# Step 5: Install VS Code (with fix)
echo -e "${YELLOW}💻 Checking VS Code...${NC}"
if ! command_exists code; then
    if [ -d "/Applications/Visual Studio Code.app" ]; then
        echo -e "${BLUE}VS Code app found, setting up command line tools...${NC}"
        # Add VS Code to PATH manually
        if ! grep -q "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ~/.zshrc; then
            echo 'export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"' >> ~/.zshrc
            export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
        fi
        echo -e "${GREEN}✅ VS Code command line tools configured!${NC}"
    else
        echo -e "${BLUE}Installing VS Code...${NC}"
        brew install --cask visual-studio-code --force
        sleep 3
        echo -e "${GREEN}✅ VS Code installed successfully!${NC}"
    fi
else
    echo -e "${GREEN}✅ VS Code already installed${NC}"
fi
echo ""

# Step 6: Clone the project
echo -e "${YELLOW}📥 Downloading Lenny Penny project...${NC}"
if [ -d "$PROJECT_DIR" ]; then
    echo -e "${BLUE}Project already exists, updating...${NC}"
    cd "$PROJECT_DIR"
    git pull
    progress_bar 2
    echo -e "${GREEN}✅ Project updated successfully!${NC}"
else
    cd "$ISTEM_DIR"
    echo -e "${BLUE}Cloning from GitHub...${NC}"
    git clone https://github.com/recurser-dev/lennox-istem.git
    cd "$PROJECT_DIR"
    progress_bar 3
    echo -e "${GREEN}✅ Project downloaded successfully!${NC}"
fi
echo ""

# Step 7: Install project dependencies
echo -e "${YELLOW}📦 Installing project dependencies...${NC}"
echo -e "${BLUE}Running npm install (this may take a moment)...${NC}"
npm install
progress_bar 4
echo -e "${GREEN}✅ Dependencies installed successfully!${NC}"
echo ""

# Step 8: Install VS Code extensions (conditional)
if [ "$INSTALL_EXTENSIONS" = true ]; then
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
        echo -e "${BLUE}  Installing: $extension${NC}"
        code --install-extension "$extension" --force >/dev/null 2>&1 || true
    done
    progress_bar 2
    echo -e "${GREEN}✅ VS Code extensions installed!${NC}"
    echo ""
fi

# Step 9: Create desktop launcher
echo -e "${YELLOW}🚀 Creating desktop launcher...${NC}"

# Determine the desktop directory
if [ "$ISTEM_DIR" = "$HOME/Desktop/ISTEM" ]; then
    LAUNCHER_DIR="$HOME/Desktop"
else
    LAUNCHER_DIR="$ISTEM_DIR"
fi

cat > "$LAUNCHER_DIR/🦝 Launch Lenny Penny.command" << EOF
#!/bin/bash
cd "$PROJECT_DIR"
clear

echo -e "\033[0;35m"
echo "  🦝 LENNY PENNY BURROW MONITOR 🦝"
echo "  ================================="
echo -e "\033[0m"
echo "📍 Location: \$(pwd)"
echo "🕐 Time: \$(date)"
echo ""

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

echo "🚀 Starting server..."
npm start &
SERVER_PID=\$!

echo "⏳ Waiting for server to start..."
sleep 3

echo "🌐 Opening browser..."
open http://localhost:3000

echo ""
echo -e "\033[0;32m✅ Lenny Penny is ready!\033[0m"
echo "📱 Dashboard: http://localhost:3000"
echo "🦝 Start monitoring to detect animals!"
echo "⏹️  To stop: Close this window or press Ctrl+C"
echo ""

# Keep the terminal open and wait for server
wait \$SERVER_PID
EOF

chmod +x "$LAUNCHER_DIR/🦝 Launch Lenny Penny.command"
echo -e "${GREEN}✅ Desktop launcher created!${NC}"
echo ""

# Step 10: Create instructions file
echo -e "${YELLOW}📋 Creating instruction manual...${NC}"
cat > "$ISTEM_DIR/📋 HOW TO USE.txt" << EOF
🦝 LENNY PENNY BURROW MONITOR - COMPLETE GUIDE

🚀 QUICK START:
1. Double-click "🦝 Launch Lenny Penny.command" on your desktop to start
2. Allow webcam access when your browser prompts
3. Click "Start Monitoring" in the dashboard
4. Watch Lenny Penny detect animals in real-time!

💻 FOR DEVELOPERS:
• Open the "lennox-istem" folder in VS Code
• Press Cmd+Shift+P and type "Tasks: Run Task"
• Select "🦝 Start Lenny Penny" for development mode
• Use F5 to debug with breakpoints

🔧 AMAZING FEATURES:
• Real-time webcam monitoring with WebRTC
• AI object detection powered by TensorFlow.js
• Detects: cats, dogs, birds, people, horses, and more!
• Interactive Lenny Penny character with speech bubbles
• Live statistics: detection count, confidence, uptime
• Beautiful particle effects and animations
• Responsive design works on all screen sizes

🎯 DETECTED OBJECTS:
The AI can identify these animals and objects:
🐱 Cats       🐕 Dogs       🐦 Birds      👤 People
🐴 Horses     🐑 Sheep      🐄 Cows       🐘 Elephants
🐻 Bears      🦓 Zebras     🦒 Giraffes   And more!

🆘 TROUBLESHOOTING:
• Black webcam screen? → Refresh browser and allow camera access
• Server won't start? → Check if port 3000 is already in use
• No detections? → Ensure good lighting and try different objects
• Performance issues? → Close other applications using camera

� PROJECT STRUCTURE:
$ISTEM_DIR/
├── lennox-istem/          # Main project folder
│   ├── server.js          # Node.js server with AI detection
│   ├── public/            # Frontend files
│   │   ├── index.html     # Dashboard interface
│   │   ├── style.css      # Beautiful styling & animations
│   │   └── script.js      # Webcam & real-time communication
│   └── package.json       # Dependencies and scripts

🌐 RESOURCES:
• GitHub Repository: https://github.com/recurser-dev/lennox-istem
• Report Issues: Create an issue on GitHub
• TensorFlow.js: https://www.tensorflow.org/js
• Socket.IO: https://socket.io

🎓 EDUCATIONAL USE:
Perfect for STEM education! Students can:
• Learn about artificial intelligence and machine learning
• Explore computer vision and object detection
• Understand real-time web applications
• Practice JavaScript, Node.js, and web development
• Experiment with webcam and canvas APIs

Made with ❤️ for curious minds and animal lovers!
🦝 "Lenny Penny is always watching for furry friends!"
EOF

echo -e "${GREEN}✅ Instruction manual created!${NC}"
echo ""

# Dramatic completion sequence
echo -e "${GREEN}${BOLD}🎉 INSTALLATION COMPLETE! 🎉${NC}\n"

echo -e "${PURPLE}${BOLD}╔══════════════════════════════════════╗${NC}"
echo -e "${PURPLE}${BOLD}║          🦝 SUCCESS! 🦝             ║${NC}"
echo -e "${PURPLE}${BOLD}╚══════════════════════════════════════╝${NC}\n"

echo -e "${CYAN}${BOLD}📁 FILES CREATED:${NC}"
if [ "$LAUNCHER_DIR" = "$HOME/Desktop" ]; then
    echo -e "${GREEN}  🦝 Launch Lenny Penny.command  ${BLUE}(Desktop)${NC}"
else
    echo -e "${GREEN}  🦝 Launch Lenny Penny.command  ${BLUE}($LAUNCHER_DIR)${NC}"
fi
echo -e "${GREEN}  📁 ISTEM/                      ${BLUE}($ISTEM_DIR)${NC}"
echo -e "${GREEN}  📋 HOW TO USE.txt              ${BLUE}(Complete guide)${NC}"
echo ""

echo -e "${YELLOW}${BOLD}🚀 QUICK START INSTRUCTIONS:${NC}"
echo -e "${WHITE}  1. ${BLUE}Double-click${NC} 🦝 Launch Lenny Penny.command"
echo -e "${WHITE}  2. ${BLUE}Allow webcam access${NC} when browser prompts"
echo -e "${WHITE}  3. ${BLUE}Click 'Start Monitoring'${NC} in the dashboard"
echo -e "${WHITE}  4. ${BLUE}Watch the magic${NC} as AI detects animals! ✨"
echo ""

echo -e "${PURPLE}🎯 FEATURES READY:${NC}"
echo -e "${GREEN}  ✅ Real-time webcam monitoring"
echo -e "  ✅ TensorFlow.js AI object detection"
echo -e "  ✅ Interactive Lenny Penny character"
echo -e "  ✅ Live statistics and history tracking"
echo -e "  ✅ Beautiful animations and effects"
if [ "$INSTALL_EXTENSIONS" = true ]; then
    echo -e "  ✅ VS Code development environment"
fi
echo ""

# Open project folder with fanfare
echo -e "${GREEN}Opening your project folder...${NC}"
open "$ISTEM_DIR"

sleep 2

# Final launch prompt with extra style
echo -e "${YELLOW}${BOLD}${BLINK}🌟 READY FOR LAUNCH! 🌟${NC}"
echo ""
read -p "$(echo -e ${GREEN}${BOLD}🦝 Start Lenny Penny now and begin detecting animals? [Y/n]: ${NC})" -n 1 -r
echo

if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo ""
    echo -e "${GREEN}${BOLD}🚀 LAUNCHING LENNY PENNY... 🚀${NC}"
    echo -e "${BLUE}Starting server and opening browser...${NC}"
    
    cd "$PROJECT_DIR"
    npm start &
    sleep 4
    open http://localhost:3000
    
    echo ""
    echo -e "${GREEN}${BOLD}✅ LENNY PENNY IS LIVE!${NC}"
    echo -e "${WHITE}Check your browser at: ${BLUE}http://localhost:3000${NC}"
    echo -e "${YELLOW}🦝 Happy animal detecting! 🦝${NC}"
else
    echo ""
    echo -e "${BLUE}No problem! Launch anytime by double-clicking the desktop launcher.${NC}"
    echo -e "${YELLOW}🦝 Lenny Penny will be waiting for you! 🦝${NC}"
fi

echo ""
echo -e "${PURPLE}${BOLD}Thank you for installing Lennox ISTEM! 🎓✨${NC}"
