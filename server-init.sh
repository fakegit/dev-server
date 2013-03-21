echo "================================================================================"
echo "                       ___           ___           ___           ___            "
echo "         ___          /  /\         /  /\         /  /\         /  /\           "
echo "        /  /\        /  /:/_       /  /::\       /  /::\       /  /:/           "
echo "       /  /:/       /  /:/ /\     /  /:/\:\     /  /:/\:\     /  /:/            "
echo "      /__/::\      /  /:/ /::\   /  /:/~/::\   /  /:/~/::\   /  /:/  ___        "
echo "      \__\/\:\__  /__/:/ /:/\:\ /__/:/ /:/\:\ /__/:/ /:/\:\ /__/:/  /  /\       "
echo "         \  \:\/\ \  \:\/:/~/:/ \  \:\/:/__\/ \  \:\/:/__\/ \  \:\ /  /:/       "
echo "          \__\::/  \  \::/ /:/   \  \::/       \  \::/       \  \:\  /:/        "
echo "          /__/:/    \__\/ /:/     \  \:\        \  \:\        \  \:\/:/         "
echo "          \__\/       /__/:/       \  \:\        \  \:\        \  \::/          "
echo "                      \__\/         \__\/         \__\/         \__\/           "
echo "================================================================================"


export DEBIAN_FRONTEND=noninteractive


echo "================================================================================"
echo "Installing upgrades..."
echo "================================================================================"
apt-get update
apt-get --yes dist-upgrade


echo "================================================================================"
echo "Installing applications..."
echo "================================================================================"
apt-get --yes install fail2ban ufw vim tmux nginx lftp git python-virtualenv unattended-upgrades
apt-get --yes build-dep python-imaging


echo "================================================================================"
echo "Setup user..."
echo "================================================================================"
useradd isaac -m -p `mkpasswd changeme`
cd /home/isaac
mkdir code
cd code
mkdir isaac
cd isaac
git clone https://github.com/overshard/dot-files.git
cd dot-files
chmod +x bootstrap.sh
./bootstrap.sh
cd /home/isaac
mkdir .ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAy5XMcfPGgYptBZrInhhpAnUbAa1e+uqgaT90c5KeqkMMKdejxBlxSU11eKcK0Ns3FCivbl/QB319sOHMqB6JV3HgSd/sg+zIPSRZA+iaufZ9Bkj3lkkWI4kWO9PttRqnuWvdIewPK+1X3UUQQeVHf7Cv++kEUDfFYnxfQDFJ13pcvy8Ja6aINdbPQ6MIXVUKsGLIL2hQyFhpX8RFQbsQYcwBwa+kWYCCzRiqj9ijvyTAZJ0OujT9Xj3ccNHJj7eUhwKSjzlHHq4uBKquQByXAenFTTsmAhu3u/2f5yJmRbIqInu6/DrNbJydpRUL3ah+XpyaN2EvudoBAfUSlRv6lXOyrumfZJEs+EIoshMEVHuv4ldlgnkQjuyF6MoFGg7AjnnG53IRDOWQrXPB+F2wMV5mxx2j31uEENwc/pkP2sHLYKsOLLIajSZjv1y4PyKt8xvlPSzGs/r6T0+tM16SV8kQShj+gDZvXeVBvTI97XQUzHDIN/Lr//QTeFOmtVFr4Ol6258/B8vaSiyjU80w8BXqFreoTtYqwnETlU3P7lM5XghunfPxveUUYDtADz/0vnA5VGmleenGuFoI91KuTC0N1n3doN/KJLIXAKf8gR7Blw5DtMfLv6T/fSuM9TuoEMfHXYuTLySCNrD7dt8VlajnvElDy1vI/Utg7Pu7X+k= isaac@bythewood.me" > .ssh/authorized_keys
chown -R isaac:isaac /home/isaac
sed -i 's/root    ALL=(ALL:ALL) ALL/isaac   ALL=(ALL:ALL) ALL/g' /etc/sudoers


echo "================================================================================"
echo "Disable root account..."
echo "================================================================================"
passwd -l root


echo "================================================================================"
echo "Lock down ssh..."
echo "================================================================================"
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config


echo "================================================================================"
echo "Enable firewall..."
echo "================================================================================"
ufw allow 22/tcp
ufw allow 80/tcp
ufw --force enable


echo "================================================================================"
echo "Setup nginx..."
echo "================================================================================"
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


echo "================================================================================"
echo "Enable auto-updates..."
echo "================================================================================"
AUTOUPDATEVAR="APT::Periodic::Update-Package-Lists \"1\";
APT::Periodic::Download-Upgradeable-Packages \"1\";
APT::Periodic::AutocleanInterval \"7\";
APT::Periodic::Unattended-Upgrade \"1\";" > /etc/apt/apt.conf.d/10periodic

echo "================================================================================"
echo "DONE - Be sure you switch to the new user 'isaac' using the password 'changeme'"
echo "and set a strong password."
echo "================================================================================"
