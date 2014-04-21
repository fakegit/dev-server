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
apt-get --yes install fail2ban ufw vim tmux nginx lftp python-virtualenv git \
                      unattended-upgrades htop pwgen build-essential \
                      libssl-dev zlib1g-dev e2fslibs-dev coffeescript node-less \
                      docker.io
apt-get --yes build-dep python-imaging python-psycopg2 python-lxml
mkdir -p /root/code
cd /root/code


echo "========================================================================="
echo "Installing tarsnap..."
echo "========================================================================="
curl https://www.tarsnap.com/download/tarsnap-autoconf-1.0.35.tgz -o tarsnap-autoconf-1.0.35.tgz
tar zxvf tarsnap-autoconf-1.0.35.tgz
cd tarsnap-autoconf-1.0.35
./configure
make all install clean
cp /home/isaac/code/nebula.bythewood.me/usr/local/bin/tarsnap-manual-backup \
      /usr/local/bin/tarsnap-manual-backup
cp /home/isaac/code/nebula.bythewood.me/usr/local/bin/tarsnap-manual-restore \
      /usr/local/bin/tarsnap-manual-restore
chmod +x /usr/local/bin/tarsnap-manual-backup
chmod +x /usr/local/bin/tarsnap-manual-restore


echo "========================================================================="
echo "Enable auto-updates to everything..."
echo "========================================================================="
cp /home/isaac/code/nebula.bythewood.me/etc/apt/apt.conf.d/10periodic \
   /etc/apt/apt.conf.d/10periodic
cp /home/isaac/code/nebula.bythewood.me/etc/apt/apt.conf.d/20auto-upgrades \
   /etc/apt/apt.conf.d/20auto-upgrades
cp /home/isaac/code/nebula.bythewood.me/etc/apt/apt.conf.d/50unattended-upgrades \
   /etc/apt/apt.conf.d/50unattended-upgrades


echo "========================================================================="
echo "Enable firewall..."
echo "========================================================================="
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 9987/udp
ufw allow 10011/tcp
ufw allow 30033/tcp
ufw allow 25565/tcp
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
mkdir --parents /home/isaac/.tarsnap
touch /home/isaac/.tarsnap/tarsnap.key
chmod 700 /home/isaac/.tarsnap
chmod 600 /home/isaac/.tarsnap/tarsnap.key
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
echo "Setup pinry docker container..."
echo "========================================================================="
cd /home/isaac/code
git clone https://github.com/pinry/docker-pinry
cd docker-pinry
docker.io build -t pinry/pinry .
mkdir -p /mnt/pinry


echo "========================================================================="
echo "Setup teamspeak docker container..."
echo "========================================================================="
cd /home/isaac/code
git clone https://github.com/overshard/docker-teamspeak
cd docker-teamspeak
docker.io build -t overshard/teamspeak .
mkdir -p /mnt/teamspeak


echo "========================================================================="
echo "Setup minecraft docker container..."
echo "========================================================================="
cd /home/isaac/code
git clone https://github.com/overshard/docker-minecraft
cd docker-minecraft
docker.io build -t overshard/minecraft .
mkdir -p /mnt/minecraft


echo "========================================================================="
echo "Start all docker containers..."
echo "========================================================================="
docker.io run -d=true -p=10000:80 -v=/mnt/pinry:/data pinry/pinry /start
docker.io run -d=true -p=9987:9987/udp -p=10011:10011 -p=30033:30033 -v=/mnt/teamspeak:/data overshard/teamspeak /start
docker.io run -d=true -p=25565:25565 -v=/mnt/minecraft:/data overshard/minecraft /start


echo "========================================================================="
echo "Setup tarsnap backups..."
echo "========================================================================="
cp /home/isaac/code/nebula.bythewood.me/usr/local/etc/tarsnap.conf \
      /usr/local/etc/tarsnap.conf
cp /home/isaac/code/nebula.bythewood.me/etc/cron.daily/tarsnap-daily-backup \
      /etc/cron.daily/tarsnap-daily-backup
chmod +x /etc/cron.daily/tarsnap-daily-backup


echo "========================================================================="
echo "Setup nginx..."
echo "========================================================================="
cp /home/isaac/code/nebula.bythewood.me/etc/nginx/nginx.conf \
      /etc/nginx/nginx.conf
cp /home/isaac/code/nebula.bythewood.me/etc/nginx/sites-available/default \
   /etc/nginx/sites-available/default
cp /home/isaac/code/nebula.bythewood.me/etc/nginx/sites-available/pinry \
      /etc/nginx/sites-available/pinry
cd /etc/nginx/sites-enabled
ln -s ../sites-available/pinry


echo "========================================================================="
echo "Set hostname..."
echo "========================================================================="
cp /home/isaac/code/nebula.bythewood.me/etc/hostname /etc/hostname


echo "========================================================================="
echo "DONE -- Be sure you set a password for 'isaac' before restarting, you can"
echo "no longer access root and the password is randomized by default:"
echo "    passwd isaac"
echo ""
echo "You'll also need to upload any ssh keys to '/home/isaac/.ssh/' and"
echo "tarsnap key files to '/home/isaac/.tarsnap/'. If you are restoring from a"
echo "backup on tarsnap just run:"
echo "    tarsnap-manual-restore"
echo "========================================================================="

