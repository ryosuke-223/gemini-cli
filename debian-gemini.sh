sudo apt update

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

node -v
npm -v

sudo npm install -g @google/gemini-cli

gemini --version

which node
node -v
sudo apt remove nodejs -y
sudo apt autoremove -y
which node
ls /etc/apt/sources.list.d/
sudo rm /etc/apt/sources.list.d/nodesource.list
sudo rm /usr/share/keyrings/nodesource.gpg 2>/dev/null
sudo apt update



curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc

nvm install 20
nvm use 20

npm install -g @google/gemini-cli