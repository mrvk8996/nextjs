https://www.youtube.com/watch?v=vtlZWotRmTI

npx create-next-app@latest

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install build-essential
sudo apt-get install nginx

nvm install
https://github.com/nvm-sh/nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash


source ~/.bashrc
nvm
nvm install --lts

upload your project to git
now clone your project here 

pwd  -- find my dir path on ubuntu

cd your-project-dir

npm i
npm run build
ll


now run my project which is run on 3000 port and route to 80
cd /

sudo nano /etc/nginx/sites-available/demo


put this 


server {
    listen 80;
    server_name your-domain-or-ip;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}


sudo ln -s /etc/nginx/sites-available/demo /etc/nginx/sites-enabled/
sudo nginx -t ------ to test all ok

sudo service nginx restart

npm i -g pm2
pm2 start npm --name "my nextjs app deployed" -- start ######### run from that folder only


