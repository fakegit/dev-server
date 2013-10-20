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
                      pwgen
apt-get --yes build-dep python-imaging python-psycopg2


echo "========================================================================="
echo "Enable firewall..."
echo "========================================================================="
ufw allow 22/tcp
ufw allow 80/tcp
ufw --force enable


echo "========================================================================="
echo "Setup user..."
echo "========================================================================="
useradd isaac --create-home --shell /bin/bash --password `pwgen -c -n -1 15`
mkdir --parents /home/isaac/code
cd /home/isaac/code
git clone https://github.com/overshard/dot-files
cd dot-files
git submodules update --init
chmod +x bootstrap.sh
./bootstrap.sh
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
echo "Setup nginx for development..."
echo "========================================================================="
cp /home/isaac/code/nebula.bythewood.me/etc/nginx/sites-available/default \
   /etc/nginx/sites-available/default


echo "========================================================================="
echo "Enable auto-updates to everything..."
echo "========================================================================="
cp /home/isaac/code/nebula.bythewood.me/etc/apt/apt.conf.d/50unattended-upgrades \
   /etc/apt/apt.conf.d/50unattended-upgrades


echo "========================================================================="
echo "DONE -- Be sure you set a password for 'isaac' before restarting, you can"
echo "no longer access root and the password is randomized by default:"
echo "    passwd isaac"
echo "========================================================================="

