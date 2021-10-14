#!/bin/bash

#if [ -z "$SUDO_USER" ]; then
#    echo "This script needs to be executed with sudo!"
#    exit 1
#fi
#
#Update and Upgrade
echo "Updating and Upgrading"
sudo apt-get update && sudo apt-get upgrade -y

echo "Installing gitand stow"
sudo apt-get install git stow -y

#user=$SUDO_USER
#user_home=$(sudo -u $SUDO_USER sh -c 'echo $HOME')
user_home=$HOME
#run as user when sudo
#sudo -u $user 

cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
options=(1 "I3WM + Base" on    # any option can be set to default to "on"
         2 "Mail" on
         3 "Web Dev" on
         4 "ST" off
         5 "Surf" off
         6 "DWM" off
         7 "JDK 8" off
         8 "Latex" off
         9 "Docker" off
         10 "VS Code" off)
	choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	clear
	for choice in $choices
	do
	    case $choice in
        1)
            #Install Genereal Software
			echo "Installing I3WM + Base"

            sudo apt install -y i3 i3-wm i3blocks i3lock-fancy feh suckless-tools xbindkeys
            sudo apt install -y newsboat task-spooler mpv lxappearance arandr python3-pip vim tmux zathura zathura-pdf-poppler stow sdcv calibre htop gparted ffmpeg cmus keepassx chromium-browser ranger ufw figlet

            #==== Copy dot Files ====
            echo "Copy dotfiles"
            for dir in $user_home/.local/repos/dotfiles/*/; 
                do stow -t $user_home -d $(dirname $dir) $(basename $dir)
            done
            
            #==== I3WM ===============
            echo "Setting i3wm"
            wget https://getwallpapers.com/wallpaper/full/4/2/7/863978-best-the-wheel-of-time-wallpapers-1920x1080-for-android.jpg -O $user_home/.config/i3/pic
            sed -i 's;#exec_always feh --bg-scale ~/.config/i3/pic;exec_always feh --bg-scale ~/.config/i3/pic;g' $user_home/.config/i3/config
			;;

		2)
		    #Setting up MAIL
			echo "Setting up Mutt"
			sudo apt install -y urlview urlscan w3m w3m-img mutt offlineimap
            printf "Enter id name: "
            read ID_NAME

            printf "Enter imap server: "
            read ID_NAME_IMAP

            printf "Enter smtp server: "
            read ID_NAME_SMTP

            printf "Enter email from: "
            read ID_NAME_FROM

            printf "Enter real name: "
            read -r ID_NAME_REALNAME

            printf "Enter login name: "
            read ID_NAME_LOGIN

            printf "Enter gpg-email: "
            read GPG_EMAIL

            read -s -p "Enter Password: " ID_NAME_PASS

            mkdir -p $user_home/.local/mailKeys
            #copy offlineimap
            cp $user_home/.local/repos/dotfiles/mail/offlineimap $user_home/.config/ -r

            sed -i -e "s;id_example;$ID_NAME;g" \
                -e "s;imap.example.com;$ID_NAME_IMAP;g" \
                -e "s;example@example.com;$ID_NAME_LOGIN;g" \
                $user_home/.config/offlineimap/config

            printf "$ID_NAME_PASS" | gpg -e -r $GPG_EMAIL > $user_home/.local/mailKeys/$ID_NAME.gpg

            #Mutt
            cp $user_home/.local/repos/dotfiles/mail/mutt $user_home/.config/ -r
            cp $user_home/.config/mutt/accounts/example $user_home/.config/mutt/accounts/$ID_NAME
            sed -i -e "s;'realname';'$ID_NAME_REALNAME';g" \
                -e "s;example@example.com;$ID_NAME_FROM;g" \
                -e "s;id_example;$ID_NAME;g" \
                $user_home/.config/mutt/accounts/$ID_NAME

            sed -i -e "s;id_example;$ID_NAME;g" \
                $user_home/.config/mutt/muttrc

            #msmtprc
            cp $user_home/.local/repos/dotfiles/mail/.msmtprc $user_home/.config/ -r
            sed -i -e "s;from_example@example.com;'$ID_NAME_FROM';g" \
                -e "s;user_example@example.com;$ID_NAME_LOGIN;g" \
                -e "s;id_example;$ID_NAME;g" \
                -e "s;smtp.example.com;$ID_NAME;g" \
                $user_home/.msmtprc
			;;
		3)	
			#Install Web Dev
			echo "Installing hugo"
			sudo apt install -y hugo
			;;
			
		4)
			#Install ST
			echo "Installing st libs"
			sudo apt install -y cmake build-essential libx11-dev libxft-dev libxext-dev
			;;

		5)
			#Install surf
			echo "Installing Surf libs"
			sudo apt install -y pkg-config libglib2.0-dev libgcc-4.8-dev libseed-gtk4-dev libgtk-3-dev gdb libgcr-3-dev
			;;
		6)
			#DWM
			echo "Installing DWM libs"
			sudo apt install libxinerama-dev -y
			;;
		7)
			#JDK 8
			echo "Installing JDK 8"
			sudo apt install python-software-properties -y
			sudo add-apt-repository ppa:webupd8team/java -y
			sudo apt update
			sudo apt install oracle-java8-installer -y
			;;
		8)
			#Latex
			echo "Installing Latex"
			sudo apt install texlive texlive-full texmaker python-pygments -y
			;;
        9)
            #Docker
            echo "Installing Docker"
            sudo apt update
            sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release -y
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            # might need to change focal to distribution
            sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu focal stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt update
            sudo apt install docker-ce docker-ce-cli containerd.io -y
            ;;
        10)
            #VS Code
            echo "Installing VS Code"
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
            sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
            sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
            rm -f packages.microsoft.gpg

            sudo apt install apt-transport-https -y
            sudo apt update
            sudo apt-get install code -y

            code --install-extension visualstudioexptteam.vscodeintellicode
            code --install-extension vscjava.vscode-java-debug
            code --install-extension vscjava.vscode-maven
            code --install-extension redhat.java
            code --install-extension pivotal.vscode-spring-boot
            ;;
    esac
done
