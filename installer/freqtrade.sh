answer=""
version="pre v0.1"
RED='\033[0;31m' # Color red
DARK_RED='\033[0;31;40m' # Color dark red
NC='\033[0m' # No Color
docker=0
# Docker request
yn=""
while true; do
    read -p "Do you want docker [Y/n]: " yn
    case $yn in
        [n]* ) echo "Are you sure to not use docker? Docker is recommended for more user friendly experience [Press Y (cap sensitive) to accept or press any key to decline"
		read yn
		case $yn in
			
			[Y]* ) echo "Docker installation won't be used!"; c=1; break;;
			* ) break;;
		esac
		
		if [ $c -eq 1 ]; then
			break;
		fi
		;;
        * ) echo -e "Docker installation might have some specific requirements for users.\nYou have been warned... [Press Y (cap sensitive) to accept or press any key to decline"
		read yn
		case $yn in
			
			[Y]* ) echo "Docker installation Enabled!"; docker=1; break;;
			* ) echo "Docker installation won't be used!"; break;;
		esac
		;;
    esac
done
cd ..
cd ..
# Whether docker installation or regular
if [ "$docker" -eq 1 ]; then
	# Checks if docker already exists
	if docker --version &> dev/null; then
		echo "Docker already exists on the System!"
	else
		echo "Installing Docker"
		if ping -c 1 archive.ubuntu.com &> /dev/null; then
			echo ""
		else
			echo -e "${RED}ERR${NC}: Internet connection doesn't exist or you have weak internet.\nPlease check your router, ethernet or wifi for any reasons. Few solutions that may assist you:\nconnect the internet\nReboot your router"
			cd Freqtrade_installer
			cd installer
			return
		fi
		sudo apt install docker docker-compose &> /dev/null
		echo "Verifying if Docker installed correctly"
		com=$(sudo docker run hello-world)
		DOCKER_ID=$(docker ps -q)
		sudo docker stop $DOCKER_ID
		if [ -z "$com" ]; then
			echo "${RED}ERR${NC}: Docker wasn't installed properly. Installation will be attempt to remove docker"
			sudo apt-get remove docker docker-engine docker.io containerd runc &> /dev/null
			echo "Checking if removal was successful"
			com=$(docker --version)
			if [ $? -ne 0 ]; then
				echo "Successful! Exiting installation"
				cd Freqtrade_installer
				cd installer
				return
			else
				echo "${DARK_RED}DANGER${NC}: Removal process failed fatally!"
			cd Freqtrade_installer
			cd installer
			return
		fi
 
		echo "The installation of docker was successful!"
	fi
	echo "Creating directory"
	cd /opt
	if [ -d "ft_userdata/" ]; then
		echo "Canceling operation due to already having the directory created"
	else
		if sudo mkdir ft_userdata &> /dev/null; then
			echo ""
			cd ft_userdata/
		else
			echo "${RED}ERR${NC}: Unexpected error appeared. $?"
			echo "Exiting installation (WARNING: THERE MIGHT BE OTHER DIRECTORY THAT WILL BE LEFT BEHIND)"
			cd ..
			cd Freqtrade_installer
			cd installer
			return
		fi
	fi			
	cd ft_userdata/

	echo "Downloading Freqtrade Docker Image"
	if ping -c 1 raw.githubusercontent.com &> /dev/null; then
		echo ""
	else
		echo -e "${RED}ERR${NC}: Internet connection doesn't exist or you have weak internet.\nPlease check your router, ethernet or wifi for any reasons. Few solutions that may assist you:\nconnect the internet\nReboot your router"
		cd ..
		cd Freqtrade_installer
		cd installer
		return
	fi
	sudo curl https://raw.githubusercontent.com/freqtrade/freqtrade/stable/docker-compose.yml -o docker-compose.yml &> /dev/null
	sudo docker-compose pull &> /dev/null
else
	# update repository
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
	
	sudo apt-get update &> /dev/null
	
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
	sudo apt install -y python3-pip python3-venv python3-dev python3-pandas git curl &> /dev/null

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
	git clone https://github.com/freqtrade/freqtrade.git &> /dev/null

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
	git checkout stable &> /dev/null

	# --install, Install freqtrade from scratch
	./setup.sh -i
	if [ $? -ne 0 ]; then
		echo "${RED}ERR${NC}: Something went wrong, check the above for a possible error"
		return
	fi
	echo -e "You're now ready to run the bot!\nAll you need to do is 'source .env/bin/activate' to enter the enviroment and 'freqtrade --help' and figure out what to do next!"
fi