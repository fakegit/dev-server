echo "========================================================================="
echo "Setting up dev-server"
echo "========================================================================="


echo "========================================================================="
echo "Installing upgrades..."
echo "========================================================================="
sudo apt update
sudo apt --yes dist-upgrade


echo "========================================================================="
echo "Installing applications..."
echo "========================================================================="
sudo apt --yes install fail2ban ufw vim tmux nginx python-virtualenv git htop \
						build-essential postgresql imagemagick libav-tools mosh \
						redis-server iftop

sudo apt-get --yes build-dep python-imaging python-psycopg2 python-lxml


echo "========================================================================="
echo "Enable firewall..."
echo "========================================================================="
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
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
echo "Setup nginx for development..."
echo "========================================================================="
sudo cat <<-FILE > /etc/nginx/sites-available/default
	server {
		listen 80 default_server;
		listen [::]:80 default_server;

		server_name _;

		location / {
			proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
			proxy_set_header Host $http_host;
			proxy_redirect off;
			proxy_pass http://localhost:8000;
		}
	}
FILE


echo "========================================================================="
echo "DONE"
echo "========================================================================="

