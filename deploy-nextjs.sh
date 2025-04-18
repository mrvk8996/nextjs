#!/bin/bash

# -------- CONFIGURATION --------
PROJECT_NAME="my-nextjs-app"
GIT_REPO="https://github.com/your-username/your-repo.git"  # 🔁 Update this
DOMAIN_OR_IP="your-domain-or-ip"                           # 🔁 Update this
PORT=3000

echo "📁 Switching to home directory..."
cd ~

# -------- SYSTEM UPDATE --------
echo "🔄 Updating system packages..."
sudo apt-get update -y && sudo apt-get upgrade -y

# -------- INSTALL ESSENTIALS --------
echo "🛠 Installing essential tools and Nginx..."
sudo apt-get install -y build-essential nginx curl git

# -------- INSTALL NVM IF NEEDED --------
if ! command -v nvm &> /dev/null; then
    echo "📥 Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh"
else
    echo "✅ NVM already installed"
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh"
fi

# -------- INSTALL NODE IF NEEDED --------
if ! command -v node &> /dev/null; then
    echo "📦 Installing latest LTS Node.js..."
    nvm install --lts
else
    echo "✅ Node.js version: $(node -v)"
fi

# Ensure NPM is available
if ! command -v npm &> /dev/null; then
    echo "❌ npm not found! Exiting."
    exit 1
fi

# -------- CLONE OR PULL PROJECT --------
if [ ! -d "$PROJECT_NAME" ]; then
    echo "📥 Cloning the project from GitHub..."
    git clone "$GIT_REPO" "$PROJECT_NAME"
else
    echo "🔁 Pulling latest changes..."
    cd "$PROJECT_NAME"
    git pull
    cd ..
fi

cd "$PROJECT_NAME"

echo "📦 Installing project dependencies..."
npm install

echo "🏗 Building Next.js project..."
npm run build

# -------- CONFIGURE NGINX --------
echo "🌐 Setting up Nginx reverse proxy..."

NGINX_FILE="/etc/nginx/sites-available/$PROJECT_NAME"

sudo bash -c "cat > $NGINX_FILE" <<EOF
server {
    listen 80;
    server_name $DOMAIN_OR_IP;

    location / {
        proxy_pass http://127.0.0.1:$PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

sudo ln -sf $NGINX_FILE /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl restart nginx

# -------- INSTALL PM2 IF MISSING --------
if ! command -v pm2 &> /dev/null; then
    echo "🚀 Installing PM2..."
    npm install -g pm2
else
    echo "✅ PM2 already installed"
fi

# -------- STOP & DELETE OLD PM2 APP --------
echo "🧹 Cleaning up old PM2 instances..."
pm2 delete "$PROJECT_NAME" 2>/dev/null || true

# -------- START WITH PM2 --------
echo "▶️ Starting app with PM2..."
pm2 start npm --name "$PROJECT_NAME" -- start
pm2 save
pm2 startup systemd -u $USER --hp $HOME

echo "✅ DONE! App deployed and running at: http://$DOMAIN_OR_IP"
