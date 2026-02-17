#!/bin/bash
# Script to run the Bhandara Locator app on Linux

# Ensure we are in the project directory
cd "$(dirname "$0")"

# Path to local Flutter SDK
FLUTTER_BIN="/home/oli/.gemini/antigravity/scratch/flutter/bin/flutter"

# Add local ninja to PATH
export PATH="/home/oli/.gemini/antigravity/scratch:$PATH"

# Build the web app
echo "Building Bhandara Locator for Web..."
"$FLUTTER_BIN" build web --release

# Serve the web app
echo "Launching Bhandara Locator on Web Server (Port 8080)..."
python3 -m http.server 8080 --directory build/web
