$answer
$version="pre v0.1"
echo "Do you want docker [Y/n] "
read $answer
#Switches to docker install than exits
if [ $answer! = "n" ]; then
	echo "Srry, this repository doesn't have docker. Don't worry the current version is $version"
fi

# update repository
cd ..
echo "Updating repository"
sleep 1
if ping -c 1 archive.ubuntu.com &> /dev/null; then
	echo ""
	
else
	echo -e "ERR: Internet connection doesn't exist or very weak.\nPlease check your router, ethernet or wifi for any reasons. Few solutions that may assist you:\nconnect the internet\nReboot your router"
	return
fi

sudo apt-get update

# install packages
echo "Installing Dependencies"
sleep 1
if ping -c 1 archive.ubuntu.com &> /dev/null; then
	echo ""
	
else
	echo -e "ERR: Internet connection doesn't exist or very weak.\nPlease check your router, ethernet or wifi for any reasons. Few solutions that may assist you:\nconnect the internet\nReboot your router\n\nif all option fail than it is possible that software doesn't exist"
	return
fi
sudo apt install -y python3-pip python3-venv python3-dev python3-pandas git curl

# Download `develop` branch of freqtrade repository
echo "Downloading Repository"
sleep 1
if ping -c 1 github.com &> /dev/null; then
	echo ""
	
else
	echo -e "ERR: Internet connection doesn't exist or very weak.\nPlease check your router, ethernet or wifi for any reasons. Few solutions that may assist you:\nconnect the internet\nReboot your router\n\nif all option fail than it is possible that software doesn't exist"
	return
fi
git clone https://github.com/freqtrade/freqtrade.git

# Enter downloaded directory
echo "Verifying if directory exists"
if [ -d freqtrade ]; then
    echo "Verification successful"
else
    echo "ERR: Folder doesn't exist!. Installation possibly failed?"
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
	echo "ERR: Something went wrong, check the above for a possible error"
	return
fi
echo -e "You're now ready to run the bot!\nAll you need to do is 'source .env/bin/activate' to enter the enviroment and 'freqtrade --help' and figure out what to do next!"