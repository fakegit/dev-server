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
echo "Bootstrapping nebula.bythewood.me..."
echo "========================================================================="


export DEBIAN_FRONTEND=noninteractive


echo "========================================================================="
echo "Installing git..."
echo "========================================================================="
apt-get update
apt-get --yes install git


echo "========================================================================="
echo "Pulling repo and running setup..."
echo "========================================================================="
mkdir --parents /home/isaac/code
cd /home/isaac/code
git clone https://github.com/overshard/nebula.bythewood.me
cd nebula.bythewood.me
chmod +x setup.sh
./setup.sh
