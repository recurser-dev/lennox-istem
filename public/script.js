// Socket.IO connection
const socket = io();

// DOM elements
const startBtn = document.getElementById('startBtn');
const stopBtn = document.getElementById('stopBtn');
const statusIndicator = document.getElementById('statusIndicator');
const videoCanvas = document.getElementById('videoCanvas');
const detectionOverlay = document.getElementById('detectionOverlay');
const streamPlaceholder = document.getElementById('streamPlaceholder');
const totalDetections = document.getElementById('totalDetections');
const animalCount = document.getElementById('animalCount');
const confidence = document.getElementById('confidence');
const uptime = document.getElementById('uptime');
const detectionsList = document.getElementById('detectionsList');
const lennyCharacter = document.getElementById('lennyCharacter');
const speechBubble = document.getElementById('speechBubble');
const toast = document.getElementById('toast');
const toastMessage = document.getElementById('toastMessage');

// State variables
let isStreaming = false;
let startTime = null;
let detectionHistory = [];
let frameCount = 0;
let lastFrameTime = Date.now();
let webcamStream = null;
let video = null;

// Canvas context
const ctx = videoCanvas.getContext('2d');

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    setupEventListeners();
    updateUptime();
    setInterval(updateUptime, 1000);
    setInterval(updateFPS, 1000);
    
    // Lenny Penny interactions
    setupLennyInteractions();
});

// Event listeners
function setupEventListeners() {
    startBtn.addEventListener('click', startStream);
    stopBtn.addEventListener('click', stopStream);
    
    // Filter buttons
    document.querySelectorAll('.filter-btn').forEach(btn => {
        btn.addEventListener('click', (e) => {
            document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
            e.target.classList.add('active');
            filterDetections(e.target.dataset.filter);
        });
    });
}

// Socket event listeners
socket.on('frame', (data) => {
    if (isStreaming) {
        displayFrameWithDetections(data.frame, data.detections, data.frameType);
        frameCount++;
    }
});

// Display frame with detections
function displayFrameWithDetections(frameData, detections, frameType = 'webcam') {
    if (frameType === 'svg') {
        // Handle SVG frames (fallback)
        const svgData = atob(frameData);
        const blob = new Blob([svgData], { type: 'image/svg+xml' });
        const url = URL.createObjectURL(blob);
        
        const img = new Image();
        img.onload = () => {
            ctx.clearRect(0, 0, videoCanvas.width, videoCanvas.height);
            ctx.drawImage(img, 0, 0, videoCanvas.width, videoCanvas.height);
            updateDetections(detections);
            URL.revokeObjectURL(url);
        };
        img.src = url;
    } else if (frameType === 'webcam') {
        // For webcam frames, the canvas already shows the live feed
        // We just need to update the detections overlay
        updateDetections(detections);
    } else {
        // Handle other image types
        const img = new Image();
        img.onload = () => {
            ctx.clearRect(0, 0, videoCanvas.width, videoCanvas.height);
            ctx.drawImage(img, 0, 0, videoCanvas.width, videoCanvas.height);
            updateDetections(detections);
        };
        img.src = 'data:image/jpeg;base64,' + frameData;
    }
}

socket.on('stats', (data) => {
    updateStats(data);
});

// Stream control functions
async function startStream() {
    // First, try to initialize webcam
    const webcamReady = await initWebcam();
    
    if (!webcamReady) {
        showToast('❌ Cannot start without webcam access', 'error');
        return;
    }
    
    socket.emit('start-stream');
    isStreaming = true;
    startTime = Date.now();
    
    startBtn.disabled = true;
    stopBtn.disabled = false;
    
    statusIndicator.classList.add('online');
    statusIndicator.innerHTML = '<div class="pulse"></div><span>LIVE</span>';
    
    streamPlaceholder.style.display = 'none';
    videoCanvas.style.display = 'block';
    
    // Start capturing frames
    const captureInterval = setInterval(() => {
        if (!isStreaming) {
            clearInterval(captureInterval);
            return;
        }
        captureAndSendFrame();
    }, 100); // 10 FPS
    
    showToast('🎥 Webcam monitoring started! AI is analyzing your feed...', 'success');
    updateLennySpeech("Watching your webcam for animals! 📹�");
    
    // Clear previous detections
    detectionHistory = [];
    updateDetectionsList();
}

function stopStream() {
    socket.emit('stop-stream');
    isStreaming = false;
    startTime = null;
    
    // Stop webcam stream
    if (webcamStream) {
        webcamStream.getTracks().forEach(track => track.stop());
        webcamStream = null;
    }
    
    startBtn.disabled = false;
    stopBtn.disabled = true;
    
    statusIndicator.classList.remove('online');
    statusIndicator.innerHTML = '<div class="pulse"></div><span>OFFLINE</span>';
    
    streamPlaceholder.style.display = 'flex';
    videoCanvas.style.display = 'none';
    detectionOverlay.innerHTML = '';
    
    showToast('⏹️ Webcam monitoring stopped', 'info');
    updateLennySpeech("Ready to monitor again! 🦝");
}

// Initialize webcam access
async function initWebcam() {
    try {
        // Create video element for webcam
        video = document.createElement('video');
        video.width = 640;
        video.height = 480;
        video.autoplay = true;
        video.muted = true;
        video.playsInline = true; // Important for mobile/Safari
        
        // Get webcam stream with better constraints
        const constraints = {
            video: { 
                width: { ideal: 640 },
                height: { ideal: 480 },
                frameRate: { ideal: 30, max: 30 }
                // Remove facingMode to use default (front) camera
            },
            audio: false
        };
        
        webcamStream = await navigator.mediaDevices.getUserMedia(constraints);
        video.srcObject = webcamStream;
        
        // Also set the debug video for visual confirmation
        const debugVideo = document.getElementById('debugVideo');
        if (debugVideo) {
            debugVideo.srcObject = webcamStream;
        }
        
        // Wait for video to be ready
        return new Promise((resolve) => {
            video.onloadedmetadata = () => {
                video.play().then(() => {
                    console.log('✅ Webcam stream ready:', video.videoWidth, 'x', video.videoHeight);
                    resolve(true);
                }).catch(error => {
                    console.error('❌ Error playing video:', error);
                    resolve(false);
                });
            };
            
            video.onerror = (error) => {
                console.error('❌ Video element error:', error);
                resolve(false);
            };
        });
        
    } catch (error) {
        console.error('❌ Error accessing webcam:', error);
        showToast('⚠️ Please enable webcam access for animal detection', 'warning');
        return false;
    }
}

// Capture frame from webcam and send to server
function captureAndSendFrame() {
    if (!video || !isStreaming || video.readyState !== 4) {
        console.log('Video not ready yet, skipping frame...');
        return;
    }
    
    try {
        // Check if video has actual dimensions
        if (video.videoWidth === 0 || video.videoHeight === 0) {
            console.log('Video dimensions not ready yet...');
            return;
        }
        
        // Set canvas size to match video
        videoCanvas.width = video.videoWidth;
        videoCanvas.height = video.videoHeight;
        
        // Draw video frame to canvas
        ctx.drawImage(video, 0, 0, videoCanvas.width, videoCanvas.height);
        
        // Convert canvas to base64
        const frameData = videoCanvas.toDataURL('image/jpeg', 0.8);
        
        // Send frame to server for processing
        socket.emit('webcam-frame', {
            frame: frameData,
            timestamp: Date.now()
        });
        
        frameCount++;
        
    } catch (error) {
        console.error('Error capturing frame:', error);
    }
}

// Update detection overlays
function updateDetections(detections) {
    detectionOverlay.innerHTML = '';
    
    detections.forEach((detection, index) => {
        const [x, y, width, height] = detection.bbox;
        
        // Create detection box
        const box = document.createElement('div');
        box.className = 'detection-box';
        box.style.left = `${(x / 640) * 100}%`;
        box.style.top = `${(y / 480) * 100}%`;
        box.style.width = `${(width / 640) * 100}%`;
        box.style.height = `${(height / 480) * 100}%`;
        
        // Create label
        const label = document.createElement('div');
        label.className = 'detection-label';
        label.textContent = `${detection.class} (${Math.round(detection.score * 100)}%)`;
        box.appendChild(label);
        
        detectionOverlay.appendChild(box);
        
        // Add to history if new
        const isNew = !detectionHistory.some(h => 
            h.class === detection.class && 
            Math.abs(h.timestamp - Date.now()) < 2000
        );
        
        if (isNew) {
            const historyItem = {
                ...detection,
                timestamp: Date.now(),
                id: Date.now() + index
            };
            detectionHistory.unshift(historyItem);
            
            // Keep only last 20 detections
            if (detectionHistory.length > 20) {
                detectionHistory = detectionHistory.slice(0, 20);
            }
            
            updateDetectionsList();
            
            // Show excitement for new animal
            if (detection.class === 'rabbit' || detection.class === 'mouse') {
                updateLennySpeech(`Wow! A ${detection.class}! 🎉`);
                showToast(`🎯 New ${detection.class} detected!`, 'success');
            }
        }
    });
}

// Update statistics
function updateStats(data) {
    totalDetections.textContent = detectionHistory.length;
    animalCount.textContent = data.animalTypes ? data.animalTypes.length : 0;
    confidence.textContent = data.averageConfidence ? `${Math.round(data.averageConfidence * 100)}%` : '0%';
    
    // Add animation to numbers
    [totalDetections, animalCount, confidence].forEach(el => {
        el.style.transform = 'scale(1.1)';
        setTimeout(() => {
            el.style.transform = 'scale(1)';
        }, 200);
    });
}

// Update detections list
function updateDetectionsList() {
    if (detectionHistory.length === 0) {
        detectionsList.innerHTML = `
            <div class="no-detections">
                <i class="fas fa-search"></i>
                <p>No animals detected yet...</p>
                <p class="subtitle">Start monitoring to see Lenny Penny's friends!</p>
            </div>
        `;
        return;
    }
    
    const activeFilter = document.querySelector('.filter-btn.active').dataset.filter;
    const filteredDetections = activeFilter === 'all' 
        ? detectionHistory 
        : detectionHistory.filter(d => d.class === activeFilter);
    
    detectionsList.innerHTML = filteredDetections.map(detection => {
        const emoji = getAnimalEmoji(detection.class);
        const timeAgo = getTimeAgo(detection.timestamp);
        
        return `
            <div class="detection-item">
                <div class="detection-icon">${emoji}</div>
                <div class="detection-info">
                    <h4>${detection.class.charAt(0).toUpperCase() + detection.class.slice(1)}</h4>
                    <p>${timeAgo}</p>
                </div>
                <div class="detection-confidence">${Math.round(detection.score * 100)}%</div>
            </div>
        `;
    }).join('');
}

// Filter detections
function filterDetections(filter) {
    updateDetectionsList();
}

// Update uptime
function updateUptime() {
    if (!startTime) {
        uptime.textContent = '00:00';
        return;
    }
    
    const elapsed = Date.now() - startTime;
    const minutes = Math.floor(elapsed / 60000);
    const seconds = Math.floor((elapsed % 60000) / 1000);
    
    uptime.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
}

// Update FPS display
function updateFPS() {
    const now = Date.now();
    const fps = Math.round(frameCount / ((now - lastFrameTime) / 1000));
    document.getElementById('fps').textContent = `${fps || 0} FPS`;
    frameCount = 0;
    lastFrameTime = now;
}

// Lenny Penny interactions
function setupLennyInteractions() {
    const phrases = [
        "G'day! Ready to spot some Aussie wildlife! 🦘",
        "Looking for kangaroos and koalas! �",
        "I love watching native Australian animals! 💕",
        "The Outback is calling! �",
        "Any cute Aussie critters today? 👀",
        "Fair dinkum, nature is bonkers! 🦜",
        "Crikey! What animals will we see? 🐊",
        "Strewth! Keep your eyes peeled for wombats! 🪃",
        "She'll be right mate! 🇦�",
        "Stone the flamin' crows! Look at those animals! 🦅",
        "Too right! Australian wildlife is the best! 🦘",
        "No worries! We'll find some amazing animals! �"
    ];
    
    lennyCharacter.addEventListener('click', () => {
        const randomPhrase = phrases[Math.floor(Math.random() * phrases.length)];
        updateLennySpeech(randomPhrase);
    });
    
    // Random speech every 30 seconds when not streaming
    setInterval(() => {
        if (!isStreaming) {
            const randomPhrase = phrases[Math.floor(Math.random() * phrases.length)];
            updateLennySpeech(randomPhrase);
        }
    }, 30000);
}

function updateLennySpeech(text) {
    speechBubble.querySelector('p').textContent = text;
    speechBubble.style.opacity = '1';
    speechBubble.style.transform = 'translateY(0)';
    
    setTimeout(() => {
        speechBubble.style.opacity = '0';
        speechBubble.style.transform = 'translateY(10px)';
    }, 3000);
}

// Utility functions
function getAnimalEmoji(animal) {
    const emojis = {
        // Native Australian Animals
        kangaroo: '🦘',
        koala: '🐨',
        wombat: '🪃',  // Using boomerang as closest match
        platypus: '🦫',  // Using beaver as closest aquatic mammal
        echidna: '🦔',   // Hedgehog as closest spiny mammal
        dingo: '🐕',
        kookaburra: '🐦',
        cockatoo: '🦜',
        emu: '🐦‍⬛',
        quoll: '🐱',     // Cat-like marsupial
        brumby: '🐴',    // Wild horse
        merino: '🐑',    // Sheep
        cattle: '🐄',
        // Fallback for common animals
        rabbit: '🐰',
        mouse: '🐭',
        cat: '🐱',
        dog: '🐕',
        bird: '🐦',
        horse: '🐴',
        sheep: '🐑',
        cow: '🐄',
        elephant: '🐘',
        bear: '🐻',
        zebra: '🦓',
        giraffe: '🦒',
        squirrel: '🐿️',
        fox: '🦊',
        wolf: '🐺',
        deer: '🦌',
        person: '👤'
    };
    return emojis[animal] || '🐾';
}

function getTimeAgo(timestamp) {
    const now = Date.now();
    const diff = now - timestamp;
    
    if (diff < 60000) {
        return 'Just now';
    } else if (diff < 3600000) {
        const minutes = Math.floor(diff / 60000);
        return `${minutes}m ago`;
    } else {
        const hours = Math.floor(diff / 3600000);
        return `${hours}h ago`;
    }
}

function showToast(message, type = 'info') {
    toastMessage.textContent = message;
    toast.classList.add('show');
    
    // Auto hide after 3 seconds
    setTimeout(() => {
        toast.classList.remove('show');
    }, 3000);
}

// Add some sparkle effects
function createSparkle() {
    const sparkle = document.createElement('div');
    sparkle.style.position = 'fixed';
    sparkle.style.width = '4px';
    sparkle.style.height = '4px';
    sparkle.style.background = '#ffd700';
    sparkle.style.borderRadius = '50%';
    sparkle.style.pointerEvents = 'none';
    sparkle.style.zIndex = '999';
    sparkle.style.left = Math.random() * window.innerWidth + 'px';
    sparkle.style.top = Math.random() * window.innerHeight + 'px';
    sparkle.style.animation = 'sparkle 2s linear forwards';
    
    document.body.appendChild(sparkle);
    
    setTimeout(() => {
        sparkle.remove();
    }, 2000);
}

// Add sparkle animation to CSS if not already there
if (!document.querySelector('#sparkle-style')) {
    const style = document.createElement('style');
    style.id = 'sparkle-style';
    style.textContent = `
        @keyframes sparkle {
            0% {
                transform: scale(0) rotate(0deg);
                opacity: 1;
            }
            50% {
                transform: scale(1) rotate(180deg);
                opacity: 1;
            }
            100% {
                transform: scale(0) rotate(360deg);
                opacity: 0;
            }
        }
    `;
    document.head.appendChild(style);
}

// Create sparkles periodically when streaming
setInterval(() => {
    if (isStreaming && Math.random() < 0.3) {
        createSparkle();
    }
}, 2000);

// Add some particle effects when animals are detected
function createParticleEffect(x, y) {
    for (let i = 0; i < 5; i++) {
        setTimeout(() => {
            const particle = document.createElement('div');
            particle.style.position = 'absolute';
            particle.style.width = '6px';
            particle.style.height = '6px';
            particle.style.background = '#2ed573';
            particle.style.borderRadius = '50%';
            particle.style.left = x + 'px';
            particle.style.top = y + 'px';
            particle.style.pointerEvents = 'none';
            particle.style.animation = `particle-burst 1s ease-out forwards`;
            
            detectionOverlay.appendChild(particle);
            
            setTimeout(() => {
                particle.remove();
            }, 1000);
        }, i * 100);
    }
}

// Add particle burst animation
const particleStyle = document.createElement('style');
particleStyle.textContent = `
    @keyframes particle-burst {
        0% {
            transform: scale(1) translate(0, 0);
            opacity: 1;
        }
        100% {
            transform: scale(0) translate(${Math.random() * 100 - 50}px, ${Math.random() * 100 - 50}px);
            opacity: 0;
        }
    }
`;
document.head.appendChild(particleStyle);
