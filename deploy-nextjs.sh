#!/bin/bash

# -------- CONFIGURATION --------
PROJECT_NAME="my-nextjs-app"
GIT_REPO="https://github.com/your-username/your-repo.git"  # 🔁 Change to your repo
DOMAIN_OR_IP="your-domain-or-ip"                           # 🔁 Replace with your domain or public IP
PORT=3000

echo "📁 Starting from home directory"
cd ~

# -------- SYSTEM UPDATE --------
echo "🔄 Updating system packages..."
sudo apt-get update -y && sudo apt-get upgrade -y

# -------- INSTALL ESSENTIALS --------
echo "🛠 Installing essential tools and Nginx..."
sudo apt-get install -y build-essential nginx curl git

# -------- INSTALL NVM IF MISSING --------
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

# -------- INSTALL NODE IF MISSING --------
if ! command -v node &> /dev/null; then
    echo "📦 Installing latest LTS Node.js..."
    nvm install --lts
else
    echo "✅ Node.js already installed: $(node -v)"
fi

# Ensure NPM is available
if ! command -v npm &> /dev/null; then
    echo "⚠️ npm not found, something is wrong with Node install"
    exit 1
fi

# -------- CLONE OR PULL PROJECT --------
if [ ! -d "$PROJECT_NAME" ]; then
    echo "📥 Cloning the project from GitHub..."
    git clone "$GIT_REPO" "$PROJECT_NAME"
else
    echo "🔁 Project already exists. Pulling latest changes..."
    cd "$PROJECT_NAME"
    git pull
    cd ..
fi

cd "$PROJECT_NAME"

echo "📦 Installing dependencies..."
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
    echo "🚀 Installing PM2 globally..."
    npm install -g pm2
else
    echo "✅ PM2 already installed"
fi

# -------- START APP WITH PM2 --------
echo "▶️ Starting app with PM2..."
pm2 start npm --name "$PROJECT_NAME" -- start
pm2 startup systemd -u $USER --hp $HOME
pm2 save

echo "✅ Deployment complete! Visit http://$DOMAIN_OR_IP"
