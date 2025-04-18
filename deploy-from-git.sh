#!/bin/bash

# -------- CONFIGURATION --------
PROJECT_NAME="my-nextjs-app"
PROJECT_DIR="$HOME/$PROJECT_NAME"
GIT_REPO="https://github.com/your-username/your-repo.git"  # 🔁 Change this

echo "📁 Navigating to home directory..."
cd ~

# -------- CLONE OR PULL --------
if [ ! -d "$PROJECT_DIR" ]; then
    echo "📥 Project not found. Cloning fresh repo..."
    git clone "$GIT_REPO" "$PROJECT_DIR"
else
    echo "🔁 Pulling latest changes from Git..."
    cd "$PROJECT_DIR"
    git pull
fi

cd "$PROJECT_DIR"

# -------- ENSURE NVM + NODE ENV --------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm use --lts

# -------- INSTALL DEPENDENCIES --------
echo "📦 Installing/updating dependencies..."
npm install

# -------- BUILD PROJECT --------
echo "🏗 Building the Next.js app..."
npm run build

# -------- RESTART WITH PM2 --------
echo "🔄 Restarting app with PM2..."
pm2 delete "$PROJECT_NAME" 2>/dev/null || true
pm2 start npm --name "$PROJECT_NAME" -- start
pm2 save

echo "✅ Deployment complete and live!"
