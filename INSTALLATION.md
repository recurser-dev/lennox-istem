# 🦘 Australian Wildlife Monitor - Installation Guide

## 🎯 **Quick Start (Recommended)**

### For Fresh Computer Installations:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/recurser-dev/lennox-istem.git
   cd lennox-istem
   ```

2. **Check Node.js compatibility:**
   - **If you have Node.js v24+**: Run `🔄 Node.js Version Fix.command`
   - **If you have Node.js v18-v22**: You're good to go!
   - **If no Node.js**: Install Node.js v20 from [nodejs.org](https://nodejs.org)

3. **Fix any TensorFlow.js issues:**
   - Double-click: `🔧 Fix TensorFlow Compatibility.command`
   - Alternative: `🔧 Simple TensorFlow Fix.command`

4. **Launch the monitor:**
   - Double-click: `🦘 Launch Aussie Wildlife Monitor.command`

## 🔧 **Troubleshooting**

### **Issue: "Cannot find module" errors**
**Cause:** Node.js v24+ compatibility issues with TensorFlow.js v3.21.0

**Solution:**
1. Run `🔄 Node.js Version Fix.command`
2. This will automatically downgrade to Node.js v20
3. Then run `🔧 Fix TensorFlow Compatibility.command`

### **Issue: "SyntaxError: Identifier 'http' has already been declared"**
**Cause:** Corrupted server.js file from editing conflicts

**Solution:** This has been fixed in the latest version. Pull the latest changes:
```bash
git pull origin main
```

### **Issue: npm ERESOLVE dependency conflicts**
**Cause:** TensorFlow.js version mismatches

**Solution:**
1. Run `🔧 Fix TensorFlow Compatibility.command`
2. This uses `--legacy-peer-deps` to resolve conflicts

## 📦 **Node.js Version Compatibility**

| Node.js Version | Compatibility | Status |
|----------------|---------------|---------|
| v18.x | ✅ Excellent | Recommended |
| v20.x | ✅ Excellent | **Best Choice** |
| v22.x | ✅ Good | Works well |
| v24.x | ❌ Issues | Use fix script |
| v25.x+ | ❌ Issues | Use fix script |

## 🚀 **What the Monitor Does**

- **Real AI Detection**: Uses TensorFlow.js with COCO-SSD model
- **Australian Wildlife**: Converts detections to native animals
  - Cats → Quolls 🐱
  - Dogs → Dingoes 🐕
  - Birds → Kookaburras 🦜
  - People → Wombats 🧑
- **Live Webcam**: Real-time detection from your camera
- **Detection Counting**: Per-frame detection statistics
- **Auto-Updates**: Built-in update system

## 📁 **Included Scripts**

- `🦘 Launch Aussie Wildlife Monitor.command` - Main launcher
- `🔧 Fix TensorFlow Compatibility.command` - Dependency fixer
- `🔧 Simple TensorFlow Fix.command` - Alternative fixer
- `🔄 Node.js Version Fix.command` - Node.js version manager
- `🔄 Update Wildlife Monitor.command` - Auto-updater

## 🌐 **Browser Access**

Once launched, visit: `http://localhost:3000`

The monitor automatically:
- Finds available ports (3000-3003, 8000, 8080)
- Opens your default browser
- Starts webcam detection

## 💡 **Tips**

1. **For best compatibility**: Use Node.js v20 (LTS)
2. **If scripts don't work**: Make sure they're executable
3. **For updates**: Run `🔄 Update Wildlife Monitor.command`
4. **For fresh installs**: Always run the fix scripts first

## 🐛 **Still Having Issues?**

1. Check that you're running scripts from the project directory
2. Ensure Node.js v20 is installed and active
3. Try the Simple TensorFlow Fix for stubborn cases
4. Make sure all scripts are executable (`chmod +x *.command`)

---

**Tested Configurations:**
- ✅ macOS with Node.js v20.x
- ✅ macOS with Node.js v22.15.0 
- ❌ Node.js v24.6.0 (requires fix script)
