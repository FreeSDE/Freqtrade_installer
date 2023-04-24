# Becomes root
# disabled until later
#$name
#$pass
#echo "What username you would like: "
#read $name
#echo "What password you would like: "
#read -s $pass
#echo "Please, type the password again: "
#addnew $name
#echo "$1" | passwd --stdin "$name"


# update repository
echo "Updating repository"
sudo apt-get update

# install packages
echo "Installing Dependencies"
sudo apt install -y python3-pip python3-venv python3-dev python3-pandas git curl

# Download `develop` branch of freqtrade repository
echo "Downloading Repository"
git clone https://github.com/freqtrade/freqtrade.git

# Enter downloaded directory
echo "Changing dir: /freqtrade"
cd freqtrade

# Checks if directory is correct
git checkout stable

# --install, Install freqtrade from scratch
./setup.sh -i

source testcd.sh 

echo -e "You're now ready to run the bot!\nAll you need to do is 'source .env/bin/activate' to enter the enviroment and 'freqtrade --help' and figure out what to do next!"