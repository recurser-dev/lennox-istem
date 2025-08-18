#!/bin/bash

# 🦘 Australian Wildlife Monitor - Update Script
# This script updates the Lenny Penny project to the latest version

clear

echo -e "\033[0;35m"
echo "  🦘 AUSTRALIAN WILDLIFE MONITOR UPDATE 🦘"
echo "  ==========================================="
echo -e "\033[0m"
echo "📍 Location: $(pwd)"
echo "🕐 Time: $(date)"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 Checking for updates...${NC}"
echo ""

# Check if we're in a git repository

# Stop any running server
echo -e "${YELLOW}🛑 Stopping any running servers...${NC}"
pkill -f "npm start" 2>/dev/null || true
pkill -f "node server.js" 2>/dev/null || true
sleep 2

# Fetch latest changes
echo -e "${BLUE}📡 Fetching latest updates from GitHub...${NC}"
git fetch origin

# Check if there are updates available
LOCAL_COMMIT=$(git rev-parse HEAD)
REMOTE_COMMIT=$(git rev-parse origin/main)

if [ "$LOCAL_COMMIT" = "$REMOTE_COMMIT" ]; then
    echo -e "${GREEN}✅ You already have the latest version!${NC}"
    echo ""
    echo -e "${BLUE}Current features:${NC}"
    echo -e "${GREEN}  • Real-time Australian wildlife detection"
    echo -e "  • TensorFlow.js AI object detection"
    echo -e "  • Interactive Lenny Penny with Aussie slang"
    echo -e "  • Live statistics and animal counting"
    echo -e "  • Beautiful animations and effects${NC}"
    echo ""
    read -p "$(echo -e ${BLUE}🚀 Start Wildlife Monitor? [Y/n]: ${NC})" -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${GREEN}🚀 Starting Australian Wildlife Monitor...${NC}"
        npm start &
        sleep 3
        open http://localhost:3000
        echo -e "${GREEN}✅ Wildlife Monitor is running at http://localhost:3000${NC}"
    fi
    exit 0
fi

echo -e "${YELLOW}🆕 Updates available!${NC}"
echo ""

# Show what's changed
echo -e "${BLUE}📋 Recent changes:${NC}"
git log --oneline --pretty=format:"  • %s" $LOCAL_COMMIT..$REMOTE_COMMIT | head -5
echo ""
echo ""

# Ask for confirmation
read -p "$(echo -e ${GREEN}Do you want to update to the latest version? [Y/n]: ${NC})" -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}Update cancelled. You can run this script anytime to update.${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}🔄 Updating to latest version...${NC}"

# Stash any local changes
echo -e "${YELLOW}💾 Backing up any local changes...${NC}"
git stash push -m "Auto-stash before update $(date)" 2>/dev/null || true

# Pull latest changes
echo -e "${BLUE}⬇️ Downloading latest updates...${NC}"
if git pull origin main; then
    echo -e "${GREEN}✅ Successfully updated from GitHub!${NC}"
else
    echo -e "${RED}❌ Failed to update from GitHub${NC}"
    echo -e "${YELLOW}💡 Try running: git pull origin main${NC}"
    read -p "Press any key to continue anyway..."
fi

# Update dependencies
echo ""
echo -e "${BLUE}📦 Updating dependencies...${NC}"
if npm install; then
    echo -e "${GREEN}✅ Dependencies updated successfully!${NC}"
else
    echo -e "${YELLOW}⚠️ Some dependencies may need manual attention${NC}"
fi

echo ""
echo -e "${GREEN}🎉 UPDATE COMPLETE! 🎉${NC}"
echo ""
echo -e "${BLUE}✨ Latest features now available:${NC}"
echo -e "${GREEN}  • Enhanced Australian wildlife detection"
echo -e "  • Improved animal counting system" 
echo -e "  • Better emoji compatibility"
echo -e "  • Updated Aussie slang phrases"
echo -e "  • Performance improvements${NC}"
echo ""

# Ask to start the updated version
read -p "$(echo -e ${GREEN}🚀 Start the updated Wildlife Monitor? [Y/n]: ${NC})" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${GREEN}🚀 Starting updated Australian Wildlife Monitor...${NC}"
    npm start &
    sleep 4
    open http://localhost:3000
    
    echo ""
    echo -e "${GREEN}✅ Updated Wildlife Monitor is now running!${NC}"
    echo -e "${BLUE}🌐 Dashboard: http://localhost:3000${NC}"
    echo -e "${YELLOW}🦘 Enjoy the latest Australian wildlife detection features!${NC}"
else
    echo ""
    echo -e "${BLUE}No worries! You can start the monitor anytime with:${NC}"
    echo -e "${GREEN}  🦘 Launch Aussie Wildlife Monitor.command${NC}"
fi

echo ""
echo -e "\033[0;35mThank you for keeping your Wildlife Monitor updated! 🦘✨\033[0m"
