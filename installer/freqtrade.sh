answer=""
version="pre v0.1"
RED='\033[0;31m' # Color red
DARK_RED='\033[0;31;40m' # Color dark red
NC='\033[0m' # No Color
YELLOW='\033[33m' # Color yellow
docker=0
d=0
r=0
yn=""
# Declaring functions
yesorno() {
	# Yes or No function
	b=0 # If this is true than the user stated Yes
	f=0 # If this is true than the user stated No
	j=0 # The result (If j = 2 than it means the user stated yes and if j = 1 than it means the user stated no and if none than an error happened)
	# Code
	while true; do
		read -p "$1 [Y/n]" yn
			case $yn in
				[n]* ) echo "Are you sure? [N/Y]"
				read yn
				case $yn in
					[Y]* ) echo ""; f=1; break;;
					* ) break;;
				esac
				if [ $c -eq 1 ]; then
					break;
				fi
				;;
				* ) echo -e "Are you sure? [N/Y]"
				read yn
				case $yn in
					[Y]* ) echo ""; break;;
					* ) echo ""; b=1 break;;
				esac
				;;
			esac
		echo ""
	done
	
	if [ $f -eq 1 ]; then
		j=1
		echo ""
	else

		j=2
	fi
	
	return $j
}
check_config() {
	# Checks if an installation may've happened
	if [ -e "docker.ftconfig" ] && [ ! -f "fi.ftconfig" ]; then

		
		
		echo "We have detected an attempted installation, Would you like to continue it? [N/y]"
		while true; do
			read yn
			case $yn in
				[y]* ) echo "We will continue in your installation, and we apologize in advance if you had experienced an error"
				d=1
				break
				;;
				* ) echo "we will go back to default, if you didn't mean it you can always ^C and retry this dialogue, we will wait!"
				sleep 5
				echo "It seems like you would like to continue, very well. restarting installation"
				rm *.ftconfig
				break
				;;
			esac
		done
	elif [ -e "regular.ftconfig" ] && [ ! -f "fi.ftconfig" ]; then
		echo "We have detected an attempted installation, Would you like to continue it? [N/y]"
		while true; do
			read yn
			case $yn in
				[y]* ) echo "We will continue in your installation, and we apologize in advance if you had experienced an error"
				r=1
				break
				;;
				* ) echo "we will go back to default, if you didn't mean it you can always ^C and retry this dialogue, we will wait!"
				sleep 5
				echo "It seems like you would like to continue, very well. restarting installation"
				rm *.ftconfig
				break
				;;
			esac
		done
	else
		
		echo ""
	fi
}
create_specialconfig() {
	# Creates a config file to declare the installation is finished


	sudo touch "fi.ftconfig"
	echo ""
}
create_config() {
	# Creates a config file to be used later
	if [ "$docker" -ne 0 ]; then

		
		touch "docker.ftconfig"
		echo "Created file"
	else {


		touch "regular.ftconfig"
		echo "Created file"
	}
	fi
}
k=0
check_system() {
	
	if grep -q -E '^(ID|NAME)="?(debian|ubuntu)' /etc/os-release; then
		echo ""
	else
		echo "${YELLOW}UNSUPPORTED OS${NC}: We have detected an unsupported OS. We advise you to terminiate this process immediately to prevent any potential damage"
		yesorno "Do you want to continue? We don't support this OS however we give you the option to ignore this WE DON'T ADVISE THIS!"
		if [ $? -ne 2 ]; then
			k=1
		fi
	fi
	echo ""
}

cd ..
cd Data
check_system
if [ $k -eq 1 ]; then
	return
fi
check_config
cd ..
cd installer
# Docker request
if [ "$r" -ne 1 ] && [ "$d" -ne 1 ]; then
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
		echo ""
	done
	cd ..
	cd Data
	create_config
	cd ..
	cd ..
else
	cd ..
	cd ..
	if [ "$d" -eq 1 ]; then
		docker=1
	fi
fi
# Whether docker installation or regular
if [ "$docker" -eq 1 ]; then
	# Checks if docker already exists
	if docker --version &> /dev/null; then
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
		com=$(sudo docker run hello-world &> /dev/null)
		DOCKER_ID=$(sudo docker ps -q &> /dev/null)
		sudo docker stop $DOCKER_ID &> /dev/null
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
			fi
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
		cd ft_userdata
	else
		if sudo mkdir ft_userdata &> /dev/null; then
			echo ""
			cd ft_userdata
		else
			echo "${RED}ERR${NC}: Unexpected error appeared. $?"
			echo "Exiting installation (WARNING: THERE MIGHT BE OTHER DIRECTORY THAT WILL BE LEFT BEHIND)"
			cd ..
			cd Freqtrade_installer
			cd installer
			return
		fi
	fi			
	

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
	echo "Finished!"
	echo "Pulling the image into the system"
	sudo docker-compose pull
	echo "Creating the file structure"
	echo "The few next commands might require input. be prepared!"
	sudo docker-compose run --rm freqtrade create-userdir --userdir user_data
	sudo docker-compose run --rm freqtrade new-config --config user_data/config.json
	echo "Installaton Finished!"
	create_specialconfig
	yesorno "Do you want to start the bot?"
	if [ $? -eq 2 ]; then
		sudo docker-compose up
	else
		
		echo "Alright! However, if you do want to run the bot do the following command 'sudo docker-compose up'"
	fi
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
	cd ..
	cd Freqtrade_installer
	cd Data
	create_specialconfig
	cd ..
	cd ..
	cd freqtrade
	echo -e "You're now ready to run the bot!\nAll you need to do is 'source .env/bin/activate' to enter the enviroment and 'freqtrade --help' and figure out what to do next!"
fi