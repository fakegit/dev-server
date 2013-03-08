echo "                  ___           ___           ___           ___      "
echo "    ___          /  /\         /  /\         /  /\         /  /\     "
echo "   /  /\        /  /:/_       /  /::\       /  /::\       /  /:/     "
echo "  /  /:/       /  /:/ /\     /  /:/\:\     /  /:/\:\     /  /:/      "
echo " /__/::\      /  /:/ /::\   /  /:/~/::\   /  /:/~/::\   /  /:/  ___  "
echo " \__\/\:\__  /__/:/ /:/\:\ /__/:/ /:/\:\ /__/:/ /:/\:\ /__/:/  /  /\ "
echo "    \  \:\/\ \  \:\/:/~/:/ \  \:\/:/__\/ \  \:\/:/__\/ \  \:\ /  /:/ "
echo "     \__\::/  \  \::/ /:/   \  \::/       \  \::/       \  \:\  /:/  "
echo "     /__/:/    \__\/ /:/     \  \:\        \  \:\        \  \:\/:/   "
echo "     \__\/       /__/:/       \  \:\        \  \:\        \  \::/    "
echo "                 \__\/         \__\/         \__\/         \__\/     "


export DEBIAN_FRONTEND=noninteractive


echo "Updating repos..."
apt-get update
echo "Installing upgrades..."
apt-get --yes dist-upgrade


echo "Installing applications..."
apt-get --yes install fail2ban ufw vim tmux nginx lftp git python-virtualenv unattended-upgrades
echo "Installing build dependencies..."
apt-get --yes build-dep python-imaging


echo "Create user..."
useradd -m isaac
echo "Setup code dir and dot files..."
cd /home/isaac
mkdir code
cd code
mkdir isaac
cd isaac
git clone https://github.com/overshard/dot-files.git
cd dot-files
chmod +x bootstrap.sh
./bootstrap.sh
echo "Add pub key..."
cd /home/isaac
mkdir .ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAy5XMcfPGgYptBZrInhhpAnUbAa1e+uqgaT90c5KeqkMMKdejxBlxSU11eKcK0Ns3FCivbl/QB319sOHMqB6JV3HgSd/sg+zIPSRZA+iaufZ9Bkj3lkkWI4kWO9PttRqnuWvdIewPK+1X3UUQQeVHf7Cv++kEUDfFYnxfQDFJ13pcvy8Ja6aINdbPQ6MIXVUKsGLIL2hQyFhpX8RFQbsQYcwBwa+kWYCCzRiqj9ijvyTAZJ0OujT9Xj3ccNHJj7eUhwKSjzlHHq4uBKquQByXAenFTTsmAhu3u/2f5yJmRbIqInu6/DrNbJydpRUL3ah+XpyaN2EvudoBAfUSlRv6lXOyrumfZJEs+EIoshMEVHuv4ldlgnkQjuyF6MoFGg7AjnnG53IRDOWQrXPB+F2wMV5mxx2j31uEENwc/pkP2sHLYKsOLLIajSZjv1y4PyKt8xvlPSzGs/r6T0+tM16SV8kQShj+gDZvXeVBvTI97XQUzHDIN/Lr//QTeFOmtVFr4Ol6258/B8vaSiyjU80w8BXqFreoTtYqwnETlU3P7lM5XghunfPxveUUYDtADz/0vnA5VGmleenGuFoI91KuTC0N1n3doN/KJLIXAKf8gR7Blw5DtMfLv6T/fSuM9TuoEMfHXYuTLySCNrD7dt8VlajnvElDy1vI/Utg7Pu7X+k= isaac@bythewood.me" > .ssh/authorized_keys
echo "Normalize permissions..."
chown -R isaac:isaac /home/isaac
echo "Add user to sudoers..."
sed -i 's/root    ALL=(ALL:ALL) ALL/isaac   ALL=(ALL:ALL) ALL/g' /etc/sudoers


echo "Disable root account..."
passwd -l root


echo "Lock down ssh..."
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config


echo "Enable firewall..."
ufw allow 22/tcp
ufw allow 80/tcp
ufw --force enable


echo "Setup nginx..."
echo "server {
    listen 80;
    server_name _;
    access_log /var/log/nginx/dev.access.log;
    location / {
        proxy_set_header X-Forward-For \$proxy_add_x_forwarded_for;
        proxy_set_header Host \$http_host;
        proxy_redirect off;
        proxy_pass http://localhost:8000;
    }
}" > /etc/nginx/sites-available/default
service nginx restart


echo "Enable auto-updates..."
AUTOUPDATEVAR="APT::Periodic::Update-Package-Lists \"1\";
APT::Periodic::Download-Upgradeable-Packages \"1\";
APT::Periodic::AutocleanInterval \"7\";
APT::Periodic::Unattended-Upgrade \"1\";" > /etc/apt/apt.conf.d/10periodic

