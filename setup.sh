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
                      unattended-upgrades htop linux-image-extra-`uname -r` \
                      pwgen build-essential libssl-dev zlib1g-dev e2fslibs-dev
apt-get --yes build-dep python-imaging python-psycopg2
mkdir -p /root/code
cd /root/code


echo "========================================================================="
echo "Installing docker..."
echo "========================================================================="
sudo sh -c "wget -qO- https://get.docker.io/gpg | apt-key add -"
sh -c "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
apt-get update
apt-get --yes install lxc-docker


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
echo "Setup pinry docker container..."
echo "========================================================================="
cd /home/isaac/code
git clone https://github.com/pinry/docker-pinry
cd docker-pinry
docker build -t pinry/pinry .
mkdir -p /mnt/pinry


echo "========================================================================="
echo "Start all docker containers..."
echo "========================================================================="
docker run -d=true -p=10000:80 -v=/mnt/pinry:/data pinry/pinry /start


echo "========================================================================="
echo "Setup nginx..."
echo "========================================================================="
cp /home/isaac/code/nebula.bythewood.me/etc/nginx/nginx.conf \
      /etc/nginx/nginx.conf
cp /home/isaac/code/nebula.bythewood.me/etc/nginx/sites-available/default \
   /etc/nginx/sites-available/default
cp /home/isaac/code/nebula.bythewood.me/etc/nginx/sites-available/pinry \
      /etc/nginx/sites-available/pinry
ln -s ../sites-available/pinry


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

