$answer
$version="v0.1"
echo "Do you want docker [Y/n] "
read $answer
#Switches to docker install than exits
if [$answer!="n"]; then
	echo "Srry, this repository doesn't have docker. Don't worry the current version is $version"
fi

# update repository
cd ..
echo "Updating repository"
sleep 1
sudo apt-get update

# install packages
echo "Installing Dependencies"
sleep 1
sudo apt install -y python3-pip python3-venv python3-dev python3-pandas git curl

# Download `develop` branch of freqtrade repository
echo "Downloading Repository"
sleep 1
git clone https://github.com/freqtrade/freqtrade.git

# Enter downloaded directory
echo "Changing dir: /freqtrade"
sleep 1
cd freqtrade

# Checks if directory is correct
git checkout stable

# --install, Install freqtrade from scratch
./setup.sh -i

echo -e "You're now ready to run the bot!\nAll you need to do is 'source .env/bin/activate' to enter the enviroment and 'freqtrade --help' and figure out what to do next!"