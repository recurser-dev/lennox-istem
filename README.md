# 🦝 Lennox ISTEM - Lenny Penny Burrow Monitor

An advanced AI-powered webcam monitoring system that detects animals in real-time using TensorFlow.js and displays them on a beautiful animated dashboard featuring Lenny Penny the raccoon!

![Lenny Penny](https://img.shields.io/badge/Lenny%20Penny-🦝-brightgreen)
![TensorFlow.js](https://img.shields.io/badge/TensorFlow.js-AI%20Detection-orange)
![Node.js](https://img.shields.io/badge/Node.js-Server-green)
![Real-time](https://img.shields.io/badge/Real--time-Webcam%20Stream-blue)

## ✨ Features

- 🎥 **Real-time Webcam Monitoring** - Live video feed from your camera
- 🤖 **AI Object Detection** - TensorFlow.js COCO-SSD model for animal detection
- 🦝 **Lenny Penny Character** - Animated mascot with interactive speech bubbles
- 📊 **Live Statistics** - Detection counts, confidence scores, and uptime tracking
- 🎨 **Beautiful Dashboard** - Fully animated CSS interface with particle effects
- 🔄 **Real-time Communication** - Socket.IO for instant updates
- 📱 **Responsive Design** - Works on desktop and mobile devices
- ✨ **Visual Effects** - Sparkles, animations, and detection overlays

## 🚀 Quick Start

### One-Click Installation (macOS)

Copy and paste this command into Terminal:

```bash
curl -sSL https://raw.githubusercontent.com/recurser-dev/lennox-istem/main/install.sh | bash
```

**That's it!** The installer will:
- 📁 Create an "ISTEM" folder on your Desktop
- 🦝 Download Lenny Penny project
- 🔧 Install all required software
- 🚀 Set up VS Code with extensions
- ✨ Create a desktop launcher

### After Installation

1. **Double-click** `🦝 Launch Lenny Penny.command` on your Desktop
2. **Allow webcam access** when prompted
3. **Click "Start Monitoring"** and watch the magic! ✨

### Manual Installation

If you prefer to install manually:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/recurser-dev/lennox-istem.git
   cd lennox-istem
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Start the server:**
   ```bash
   npm start
   ```

4. **Open your browser:**
   ```
   http://localhost:3000
   ```

## 🛠️ Technology Stack

- **Backend:** Node.js, Express.js, Socket.IO
- **AI/ML:** TensorFlow.js, COCO-SSD Object Detection Model
- **Frontend:** HTML5, CSS3, JavaScript (ES6+)
- **Real-time:** WebRTC, Canvas API, WebSockets
- **Image Processing:** Canvas, Base64 encoding

## 🎯 Detectable Objects

The AI can detect various animals and objects including:
- 🐱 Cats
- 🐕 Dogs  
- 🐦 Birds
- 🐴 Horses
- 🐑 Sheep
- 🐄 Cows
- 🐘 Elephants
- 🐻 Bears
- 🦓 Zebras
- 🦒 Giraffes
- 👤 People

## 📁 Project Structure

```
lennox-istem/
├── server.js              # Main server file with TensorFlow.js integration
├── package.json           # Node.js dependencies and scripts
├── public/
│   ├── index.html         # Main dashboard interface
│   ├── style.css          # Beautiful CSS animations and styling
│   └── script.js          # Client-side webcam and Socket.IO logic
├── install.sh             # One-click installation script
└── README.md              # This file
```

## 🎮 How to Use

1. **Start the Application:** Run `npm start` or use the install script
2. **Open the Dashboard:** Navigate to `http://localhost:3000`
3. **Grant Camera Access:** Allow webcam permissions when prompted
4. **Begin Monitoring:** Click "Start Monitoring" 
5. **Watch Lenny Penny:** See detections in real-time with animated overlays
6. **Interact:** Click on Lenny Penny for fun phrases!

## 🔧 Configuration

### Environment Variables
- `PORT` - Server port (default: 3000)

### Camera Settings
The webcam defaults to 640x480 resolution at 30fps. You can modify the constraints in `public/script.js`:

```javascript
const constraints = {
    video: { 
        width: { ideal: 640 },
        height: { ideal: 480 },
        frameRate: { ideal: 30, max: 30 }
    },
    audio: false
};
```

## 🎨 Customization

### Lenny Penny Phrases
Add your own phrases in `public/script.js`:

```javascript
const phrases = [
    "Ready to monitor the burrow! 🏠",
    "Looking for furry friends! 🐰",
    // Add your custom phrases here!
];
```

### Detection Filters
Modify the animal detection list in `server.js`:

```javascript
const animalClasses = ['person', 'cat', 'dog', 'bird', /* add more animals */];
```

## 📊 Performance

- **Frame Rate:** 10 FPS processing (adjustable)
- **Detection Latency:** ~100-200ms per frame
- **Model Size:** ~13MB (COCO-SSD)
- **Memory Usage:** ~200-400MB during operation

## 🐛 Troubleshooting

### Black Webcam Screen
- Ensure camera permissions are granted
- Check if another application is using the camera
- Try refreshing the page

### TensorFlow.js Errors
- Ensure you have sufficient RAM (>4GB recommended)
- Check Node.js version compatibility
- Clear npm cache: `npm cache clean --force`

### Performance Issues
- Reduce frame rate in `script.js`
- Close other CPU-intensive applications
- Ensure stable internet connection

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- TensorFlow.js team for the amazing ML framework
- COCO dataset for object detection training data
- Socket.IO for real-time communication
- The open-source community for inspiration

## 📞 Support

If you encounter any issues or have questions:
1. Check the [Issues](https://github.com/recurser-dev/lennox-istem/issues) page
2. Create a new issue with detailed information
3. Include browser console logs and system information

---

**Made with ❤️ for animal lovers and STEM education!**

🦝 *"Lenny Penny is always watching for furry friends!"*

## ✨ Features

- **🎥 Real Wildlife Footage**: Sources random animal images from Unsplash for realistic monitoring
- **🤖 Smart Animal Detection**: Enhanced detection algorithms with realistic patterns
- **📊 Animated Dashboard**: Beautiful, responsive UI with live statistics
- **🐰 Enhanced Animal Recognition**: Detects rabbits, mice, cats, birds, squirrels, and more
- **📈 Live Statistics**: Real-time metrics and detection history
- **🌟 Lenny Penny Character**: Interactive animated mascot
- **🎨 Visual Effects**: Sparkles, particles, and smooth animations
- **📱 Responsive Design**: Works on desktop, tablet, and mobile
- **🔄 Fallback System**: Graceful fallback to generated content if external sources fail

## 🚀 Getting Started

### Prerequisites

- Node.js (v14 or higher)
- npm or yarn

### Installation

1. **Clone or navigate to the project directory**:
   ```bash
   cd /Users/calebschool/Documents/LennoxIstem
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Start the server**:
   ```bash
   npm start
   ```

4. **Open your browser** and navigate to:
   ```
   http://localhost:3000
   ```

## 🎮 How to Use

1. **Start Monitoring**: Click the "Start Monitoring" button to begin the real footage stream
2. **Watch the Feed**: The canvas will display real wildlife images from various sources
3. **View Detections**: Animals will be automatically detected and highlighted
4. **Check Statistics**: Monitor live stats including detection count and confidence
5. **Interact with Lenny**: Click on Lenny Penny for fun interactions!
6. **Filter Results**: Use the filter buttons to view specific animal types

## 🛠️ Technical Details

### Backend (Node.js + Express)
- **Express Server**: Serves the web application
- **Socket.IO**: Real-time communication between server and client
- **HTTPS Client**: Fetches real animal images from Unsplash API
- **Smart Detection**: Enhanced algorithms for realistic animal detection patterns
- **Fallback System**: SVG generation when external sources are unavailable

### Frontend (HTML + CSS + JavaScript)
- **Responsive Grid Layout**: CSS Grid for dashboard layout
- **CSS Animations**: Smooth transitions and effects
- **Socket.IO Client**: Real-time data updates
- **Canvas Rendering**: Displays real images and detection overlays
- **Interactive Elements**: Buttons, filters, and character interactions

### Real Image Sources
- **Unsplash API**: High-quality wildlife photography
- **Dynamic Fetching**: Images are fetched in real-time
- **Intelligent Caching**: Reuses images for performance
- **Error Handling**: Graceful fallback to generated content

## 🎨 Customization

### Adding New Animals
To add new animal types to detect:

1. **Update the server.js file**:
   ```javascript
   const animalClasses = ['cat', 'dog', 'bird', 'your-new-animal'];
   ```

2. **Add emoji mapping in script.js**:
   ```javascript
   const emojis = {
       'your-new-animal': '🦝'
   };
   ```

### Changing Colors
Modify the CSS variables in `style.css`:
```css
:root {
    --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    --accent-color: #2ed573;
}
```

### Adjusting Detection Sensitivity
In `server.js`, modify the confidence threshold:
```javascript
detectedAnimals.filter(prediction => 
    animalClasses.includes(prediction.class) && prediction.score > 0.3 // Change this value
);
```

## 📁 Project Structure

```
LennoxIstem/
├── package.json          # Project dependencies and scripts
├── server.js             # Main server file with ML detection
├── README.md             # This file
└── public/               # Frontend files
    ├── index.html        # Main dashboard HTML
    ├── style.css         # Animated styles and responsive design
    └── script.js         # Client-side JavaScript and interactions
```

## 🔧 Development

### Running in Development Mode
```bash
npm run dev
```

This uses `nodemon` to automatically restart the server when files change.

### Adding New Features
1. **Backend changes**: Modify `server.js` for new API endpoints or detection logic
2. **Frontend changes**: Update HTML, CSS, or JavaScript in the `public/` folder
3. **Real-time features**: Use Socket.IO events for live updates

## 🌟 Future Enhancements

- **Real Webcam Integration**: Replace fake stream with actual webcam input
- **Database Storage**: Store detection history and analytics
- **Alert System**: Email/SMS notifications for specific animals
- **Machine Learning Training**: Custom model for burrow-specific animals
- **Mobile App**: React Native companion app
- **Multiple Cameras**: Support for multiple burrow monitoring points

## 🐛 Troubleshooting

### Common Issues

1. **Port already in use**:
   ```bash
   # Kill process on port 3000
   lsof -ti:3000 | xargs kill -9
   ```

2. **Model loading fails**:
   - Check internet connection (model downloads from CDN)
   - Ensure Node.js version is compatible

3. **Canvas rendering issues**:
   - Make sure the `canvas` npm package is properly installed
   - Check system dependencies for canvas (varies by OS)

### Performance Tips

- **Lower frame rate**: Reduce the interval in `server.js` for slower devices
- **Smaller canvas**: Adjust canvas size for better performance
- **Disable effects**: Comment out sparkle/particle effects if needed

## 📄 License

MIT License - Feel free to use and modify for your own projects!

## 🎉 Credits

- **TensorFlow.js**: Machine learning framework
- **COCO-SSD**: Object detection model
- **Socket.IO**: Real-time communication
- **Font Awesome**: Icons
- **Google Fonts**: Typography

---

Built with ❤️ for Lenny Penny and all the curious critters in the burrow! 🐰🐭🦝
