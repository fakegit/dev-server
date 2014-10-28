echo "========================================================================="
echo "                   ___           ___           ___           ___         "
echo "     ___          /  /\         /  /\         /  /\         /  /\        "
echo "    /  /\        /  /:/_       /  /::\       /  /::\       /  /:/        "
echo "   /  /:/       /  /:/ /\     /  /:/\:\     /  /:/\:\     /  /:/         "
echo "  /__/::\      /  /:/ /::\   /  /:/~/::\   /  /:/~/::\   /  /:/  ___     "
echo "  \__\/\:\__  /__/:/ /:/\:\ /__/:/ /:/\:\ /__/:/ /:/\:\ /__/:/  /  /\    "
echo "     \  \:\/\ \  \:\/:/~/:/ \  \:\/:/__\/ \  \:\/:/__\/ \  \:\ /  /:/    "
echo "      \__\::/  \  \::/ /:/   \  \::/       \  \::/       \  \:\  /:/     "
echo "      /__/:/    \__\/ /:/     \  \:\        \  \:\        \  \:\/:/      "
echo "      \__\/       /__/:/       \  \:\        \  \:\        \  \::/       "
echo "                  \__\/         \__\/         \__\/         \__\/        "
echo "========================================================================="
echo "Setting up nebula.bythewood.me"
echo "========================================================================="


export DEBIAN_FRONTEND=noninteractive


echo "========================================================================="
echo "Installing upgrades..."
echo "========================================================================="
apt-get update
apt-get --yes dist-upgrade


echo "========================================================================="
echo "Installing applications..."
echo "========================================================================="
apt-get --yes install fail2ban ufw vim tmux nginx python-virtualenv git htop \
                      unattended-upgrades pwgen build-essential docker.io \
                      imagemagick
apt-get --yes build-dep python-imaging python-psycopg2 python-lxml
mkdir -p /root/code
cd /root/code


echo "========================================================================="
echo "Enable firewall..."
echo "========================================================================="
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 9987/udp
ufw allow 10011/tcp
ufw allow 30033/tcp
cp /home/isaac/code/nebula.bythewood.me/etc/default/ufw /etc/default/ufw
ufw --force enable


echo "========================================================================="
echo "Setup user..."
echo "========================================================================="
useradd isaac --create-home --shell /bin/bash --password `pwgen -c -n -1 15`
mkdir --parents /home/isaac/code
cd /home/isaac/code
git clone https://github.com/overshard/dot-files
cd dot-files
git submodule update --init
chmod +x setup.sh
./setup.sh
mkdir --parents /home/isaac/.ssh
cp /home/isaac/code/nebula.bythewood.me/home/isaac/ssh/authorized_keys \
   /home/isaac/.ssh/authorized_keys
chmod 700 /home/isaac/.ssh
chmod 600 /home/isaac/.ssh/authorized_keys
chown --recursive isaac:isaac /home/isaac
usermod --append --groups sudo isaac


echo "========================================================================="
echo "Disable root account..."
echo "========================================================================="
passwd -l root


echo "========================================================================="
echo "Lock down ssh..."
echo "========================================================================="
cp /home/isaac/code/nebula.bythewood.me/etc/ssh/sshd_config /etc/ssh/sshd_config


echo "========================================================================="
echo "Setup teamspeak docker container..."
echo "========================================================================="
cd /home/isaac/code
git clone https://github.com/overshard/docker-teamspeak
cd docker-teamspeak
docker.io build -t overshard/teamspeak .
mkdir -p /mnt/teamspeak


echo "========================================================================="
echo "Start all docker containers..."
echo "========================================================================="
docker.io run -d=true -p=9987:9987/udp -p=10011:10011 -p=30033:30033 -v=/mnt/teamspeak:/data overshard/teamspeak /start


echo "========================================================================="
echo "Setup nginx..."
echo "========================================================================="
cp /home/isaac/code/nebula.bythewood.me/etc/nginx/nginx.conf \
      /etc/nginx/nginx.conf
cp /home/isaac/code/nebula.bythewood.me/etc/nginx/sites-available/default \
   /etc/nginx/sites-available/default
cd /etc/nginx/sites-enabled


echo "========================================================================="
echo "Set hostname..."
echo "========================================================================="
cp /home/isaac/code/nebula.bythewood.me/etc/hostname /etc/hostname


echo "========================================================================="
echo "DONE -- Be sure you set a password for 'isaac' before restarting, you can"
echo "no longer access root and the password is randomized by default:"
echo "    passwd isaac"
echo ""
echo "Also stop docker containers and restore backups if you want..."
echo "========================================================================="

