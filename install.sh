#!/bin/bash

# 🦝 Lennox ISTEM - One-Click Installation Script for macOS
# This script clones the repository, installs dependencies, sets up VS Code extensions, and provides a launch command

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# ASCII Art
echo -e "${PURPLE}"
cat << "EOF"
    ██╗     ███████╗███╗   ███╗███╗   ██╗ ██████╗ ██╗  ██╗    ██╗███████╗████████╗███████╗███╗   ███╗
    ██║     ██╔════╝████╗ ████║████╗  ██║██╔═══██╗╚██╗██╔╝    ██║██╔════╝╚══██╔══╝██╔════╝████╗ ████║
    ██║     █████╗  ██╔████╔██║██╔██╗ ██║██║   ██║ ╚███╔╝     ██║███████╗   ██║   █████╗  ██╔████╔██║
    ██║     ██╔══╝  ██║╚██╔╝██║██║╚██╗██║██║   ██║ ██╔██╗     ██║╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║
    ███████╗███████╗██║ ╚═╝ ██║██║ ╚████║╚██████╔╝██╔╝ ██╗    ██║███████║   ██║   ███████╗██║ ╚═╝ ██║
    ╚══════╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝
    
    🦝 Lenny Penny Burrow Monitor - AI-Powered Animal Detection Dashboard
    
EOF
echo -e "${NC}"

echo -e "${BLUE}Starting Lennox ISTEM installation...${NC}\n"

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ This script is designed for macOS only!${NC}"
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Homebrew if not present
install_homebrew() {
    if ! command_exists brew; then
        echo -e "${YELLOW}🍺 Installing Homebrew...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        echo -e "${GREEN}✅ Homebrew already installed${NC}"
    fi
}

# Function to install Node.js if not present
install_nodejs() {
    if ! command_exists node; then
        echo -e "${YELLOW}📦 Installing Node.js...${NC}"
        brew install node
    else
        echo -e "${GREEN}✅ Node.js already installed ($(node --version))${NC}"
    fi
}

# Function to install Git if not present
install_git() {
    if ! command_exists git; then
        echo -e "${YELLOW}🔧 Installing Git...${NC}"
        brew install git
    else
        echo -e "${GREEN}✅ Git already installed ($(git --version))${NC}"
    fi
}

# Function to install VS Code if not present
install_vscode() {
    if ! command_exists code; then
        echo -e "${YELLOW}💻 Installing VS Code...${NC}"
        brew install --cask visual-studio-code
        
        # Wait a moment for VS Code to be available
        sleep 3
    else
        echo -e "${GREEN}✅ VS Code already installed${NC}"
    fi
}

# Function to install VS Code extensions
install_vscode_extensions() {
    echo -e "${YELLOW}🔌 Installing VS Code extensions...${NC}"
    
    extensions=(
        "ms-vscode.vscode-json"
        "bradlc.vscode-tailwindcss"
        "esbenp.prettier-vscode"
        "ms-vscode.vscode-typescript-next"
        "formulahendry.auto-rename-tag"
        "christian-kohler.path-intellisense"
        "ms-python.python"
        "ms-toolsai.jupyter"
        "ritwickdey.liveserver"
        "ms-vscode.vscode-json"
        "ms-vscode.js-debug"
        "GitHub.copilot"
        "GitHub.copilot-chat"
    )
    
    for extension in "${extensions[@]}"; do
        echo -e "${BLUE}  Installing: $extension${NC}"
        code --install-extension "$extension" --force
    done
    
    echo -e "${GREEN}✅ VS Code extensions installed${NC}"
}

# Function to create VS Code workspace settings
create_vscode_settings() {
    echo -e "${YELLOW}⚙️  Creating VS Code workspace settings...${NC}"
    
    mkdir -p .vscode
    
    cat > .vscode/settings.json << 'EOF'
{
    "editor.tabSize": 2,
    "editor.insertSpaces": true,
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.fixAll": true
    },
    "files.associations": {
        "*.js": "javascript",
        "*.json": "jsonc"
    },
    "javascript.suggest.autoImports": true,
    "typescript.suggest.autoImports": true,
    "emmet.includeLanguages": {
        "javascript": "javascriptreact"
    },
    "liveServer.settings.port": 5500,
    "prettier.singleQuote": true,
    "prettier.semi": true
}
EOF

    cat > .vscode/launch.json << 'EOF'
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "🦝 Launch Lenny Penny Server",
            "type": "node",
            "request": "launch",
            "program": "${workspaceFolder}/server.js",
            "env": {
                "NODE_ENV": "development"
            },
            "console": "integratedTerminal",
            "skipFiles": ["<node_internals>/**"]
        },
        {
            "name": "🚀 Launch in Browser",
            "type": "node",
            "request": "launch",
            "program": "${workspaceFolder}/server.js",
            "env": {
                "NODE_ENV": "development"
            },
            "console": "integratedTerminal",
            "skipFiles": ["<node_internals>/**"],
            "serverReadyAction": {
                "pattern": "running on http://localhost:([0-9]+)",
                "uriFormat": "http://localhost:%s",
                "action": "openExternally"
            }
        }
    ]
}
EOF

    cat > .vscode/tasks.json << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "🦝 Start Lenny Penny",
            "type": "shell",
            "command": "npm",
            "args": ["start"],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "new",
                "showReuseMessage": true,
                "clear": false
            },
            "problemMatcher": []
        },
        {
            "label": "📦 Install Dependencies",
            "type": "shell",
            "command": "npm",
            "args": ["install"],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "new"
            }
        },
        {
            "label": "🧹 Clean Install",
            "type": "shell",
            "command": "rm -rf node_modules package-lock.json && npm install",
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "new"
            }
        }
    ]
}
EOF

    echo -e "${GREEN}✅ VS Code workspace configured${NC}"
}

# Function to create launcher script
create_launcher() {
    echo -e "${YELLOW}🚀 Creating launcher script...${NC}"
    
    cat > launch-lenny-penny.sh << 'EOF'
#!/bin/bash

# 🦝 Lenny Penny Launcher Script
# This script starts the Lenny Penny Burrow Monitor

echo "🦝 Starting Lenny Penny Burrow Monitor..."
echo "📍 Location: $(pwd)"
echo "🕐 Time: $(date)"
echo ""

# Check if dependencies are installed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Start the server
echo "🚀 Launching server..."
npm start &
SERVER_PID=$!

# Wait a moment for server to start
sleep 3

# Open browser
echo "🌐 Opening browser..."
open http://localhost:3000

echo ""
echo "✅ Lenny Penny is ready!"
echo "📱 Dashboard: http://localhost:3000"
echo "⏹️  To stop: Press Ctrl+C or close this terminal"
echo ""

# Wait for server process
wait $SERVER_PID
EOF

    chmod +x launch-lenny-penny.sh
    
    echo -e "${GREEN}✅ Launcher script created${NC}"
}

# Function to create desktop app (optional)
create_desktop_app() {
    echo -e "${YELLOW}🖥️  Creating desktop app...${NC}"
    
    app_dir="$HOME/Applications/Lenny Penny.app"
    mkdir -p "$app_dir/Contents/MacOS"
    mkdir -p "$app_dir/Contents/Resources"
    
    cat > "$app_dir/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>LennyPenny</string>
    <key>CFBundleIdentifier</key>
    <string>com.lennoxistem.lennypenny</string>
    <key>CFBundleName</key>
    <string>Lenny Penny</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
</dict>
</plist>
EOF

    cat > "$app_dir/Contents/MacOS/LennyPenny" << EOF
#!/bin/bash
cd "$(dirname "\$0")/../../../Documents/LennoxIstem" || cd "$PWD"
./launch-lenny-penny.sh
EOF

    chmod +x "$app_dir/Contents/MacOS/LennyPenny"
    
    echo -e "${GREEN}✅ Desktop app created in Applications folder${NC}"
}

# Main installation process
main() {
    echo -e "${BLUE}🔍 Checking system requirements...${NC}\n"
    
    # Install prerequisites
    install_homebrew
    install_git
    install_nodejs
    install_vscode
    
    echo -e "\n${BLUE}📥 Setting up project...${NC}\n"
    
    # Get the project directory name
    PROJECT_DIR="LennoxIstem"
    
    # If we're not already in the project directory, clone it
    if [[ ! -f "package.json" ]]; then
        echo -e "${YELLOW}📦 Cloning repository...${NC}"
        # For now, we'll assume the project already exists locally
        # git clone https://github.com/YOUR_USERNAME/lennox-istem.git "$PROJECT_DIR"
        # cd "$PROJECT_DIR"
        echo -e "${RED}⚠️  Please ensure you're running this script from the project directory${NC}"
        exit 1
    fi
    
    # Install project dependencies
    echo -e "${YELLOW}📦 Installing project dependencies...${NC}"
    npm install
    
    # Set up VS Code
    install_vscode_extensions
    create_vscode_settings
    
    # Create launcher
    create_launcher
    
    # Create desktop app (optional)
    read -p "$(echo -e ${YELLOW}🖥️  Create desktop app? [y/N]: ${NC})" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        create_desktop_app
    fi
    
    echo -e "\n${GREEN}🎉 Installation complete!${NC}\n"
    
    # Show usage instructions
    echo -e "${PURPLE}🚀 Quick Start:${NC}"
    echo -e "  ${BLUE}./launch-lenny-penny.sh${NC}    - Start with one command"
    echo -e "  ${BLUE}npm start${NC}                 - Start server manually"
    echo -e "  ${BLUE}code .${NC}                    - Open in VS Code"
    echo -e "  ${BLUE}open http://localhost:3000${NC} - Open dashboard"
    
    echo -e "\n${PURPLE}🦝 Lenny Penny Features:${NC}"
    echo -e "  • Real-time webcam monitoring"
    echo -e "  • AI object detection with TensorFlow.js"
    echo -e "  • Interactive animated dashboard"
    echo -e "  • Live statistics and detection history"
    echo -e "  • Particle effects and visual feedback"
    
    echo -e "\n${PURPLE}💡 VS Code Integration:${NC}"
    echo -e "  • Press ${BLUE}Cmd+Shift+P${NC} and type 'Tasks: Run Task'"
    echo -e "  • Select '🦝 Start Lenny Penny' for quick launch"
    echo -e "  • Use the debugger with F5 for development"
    
    echo -e "\n${GREEN}Ready to monitor some animals! 🦝${NC}"
    
    # Ask if user wants to launch now
    read -p "$(echo -e ${YELLOW}🚀 Launch Lenny Penny now? [Y/n]: ${NC})" -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        ./launch-lenny-penny.sh
    fi
}

# Run the main function
main "$@"
