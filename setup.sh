echo "========================================================================="
echo "Installing upgrades..."
echo "========================================================================="
sudo apt update
sudo apt --yes dist-upgrade


echo "========================================================================="
echo "Installing applications..."
echo "========================================================================="
sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/pgdg.list
curl -L https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

sudo echo "deb https://cli-assets.heroku.com/branches/stable/apt ./" > /etc/apt/sources.list.d/heroku.list
curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add -

sudo apt update

sudo apt --yes install fail2ban ufw vim tmux nginx python-virtualenv git htop \
						build-essential postgresql-9.6 imagemagick libav-tools \
						redis-server iftop heroku

sudo apt-get --yes build-dep pillow psycopg2 lxml


echo "========================================================================="
echo "Enable firewall..."
echo "========================================================================="
sudo ufw allow 22/tcp
sudo ufw allow 8000/tcp
sudo ufw --force enable


echo "========================================================================="
echo "Disable root account..."
echo "========================================================================="
sudo passwd -l root


echo "========================================================================="
echo "Lock down ssh..."
echo "========================================================================="
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config


echo "========================================================================="
echo "Setup swapfile..."
echo "========================================================================="
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab


echo "========================================================================="
echo "DONE"
echo "========================================================================="

