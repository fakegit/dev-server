echo "========================================================================="
echo "Bootstrapping dev-server..."
echo "========================================================================="


echo "========================================================================="
echo "Installing git..."
echo "========================================================================="
apt update
apt --yes install git


echo "========================================================================="
echo "Pulling repo and running setup..."
echo "========================================================================="
mkdir --parents ~/code
cd ~/code
git clone https://github.com/overshard/dev-server
cd dev-server
chmod +x setup.sh
./setup.sh

