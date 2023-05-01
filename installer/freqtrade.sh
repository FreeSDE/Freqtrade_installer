answer=""
version="pre v0.1"
RED='\033[0;31m' # Color red
NC='\033[0m' # No Color
docker=0
#Switches to docker install than exits
yn=""
while true; do
    read -p "Do you want docker [Y/n]: " yn
    case $yn in
        [n]* ) echo "Are you sure to not use docker? Docker is recommended for more user friendly experience [Press Y (cap sensitive) to accept or press any key to decline";
		read yn
		c=1
		case $yn in
			
			[Y]* ) echo "Docker installation won't be used!"; c=1 break;;
			* ) break;;
		esac
		
		if [ c -eq 1 ]; then
			break;
		fi
		;;
        * ) echo -e "Docker installation might have some specific requirements for users.\nYou have been warned... [Press Y (cap sensitive) to accept or press any key to decline"
		read 
		case $yn in
			
			[Y]* ) echo "Docker installation Enabled!"; docker=1; break;;
			* ) echo "Docker installation won't be used!" break;;
		esac
		;;
    esac
done

if [ "$docker" -eq 1 ]; then
	echo "Hello, world"
	sleep 2
fi

# update repository
cd ..
cd ..
echo "Updating repository"
sleep 1
# Checks if internet exists
if ping -c 1 archive.ubuntu.com &> /dev/null; then
	echo ""
else
	echo -e "${RED}ERR${NC}: Internet connection doesn't exist or you have weak internet.\nPlease check your router, ethernet or wifi for any reasons. Few solutions that may assist you:\nconnect the internet\nReboot your router"
	cd Freqtrade_installer
	cd installer
	return
fi

sudo apt-get update

# install packages
echo "Installing Dependencies"
sleep 1
# Checks if internet exists
if ping -c 1 archive.ubuntu.com &> /dev/null; then
	echo ""
else
	echo -e "${RED}ERR${NC}: Internet connection doesn't exist or you have weak internet.\nPlease check your router, ethernet or wifi for any reasons. Few solutions that may assist you:\nconnect the internet\nReboot your router\n\nif all option fail than it is possible that software doesn't exist"
	cd Freqtrade_installer
	cd installer
	return
fi
sudo apt install -y python3-pip python3-venv python3-dev python3-pandas git curl

# Download `develop` branch of freqtrade repository
echo "Downloading Repository"
sleep 1
# Checks if internet exists
if ping -c 1 github.com &> /dev/null; then
	echo ""
else
	echo -e "${RED}ERR${NC}: Internet connection doesn't exist or you have weak internet.\nPlease check your router, ethernet or wifi for any reasons. Few solutions that may assist you:\nconnect the internet\nReboot your router\n\nif all option fail than it is possible that software doesn't exist"
	cd Freqtrade_installer
	cd installer
	return
fi
git clone https://github.com/freqtrade/freqtrade.git

# Enter downloaded directory
echo "Verifying if directory exists"
if [ -d freqtrade ]; then
  echo "Verification successful"
else
  echo "${RED}ERR${NC}: Folder doesn't exist!. Installation possibly failed to detect an error!? This should be reported to the repository immediately!"
  cd Freqtrade_installer
  cd installer
  return
fi
echo "Going to dir: /freqtrade"
sleep 1
cd freqtrade

# Checks if directory is correct
git checkout stable

# --install, Install freqtrade from scratch
./setup.sh -i
if [ $? -ne 0 ]; then
	echo "${RED}ERR${NC}: Something went wrong, check the above for a possible error"
	return
fi
echo -e "You're now ready to run the bot!\nAll you need to do is 'source .env/bin/activate' to enter the enviroment and 'freqtrade --help' and figure out what to do next!"