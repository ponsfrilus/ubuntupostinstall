#!/bin/bash
##
## @title     Post Install *buntu
## @author    ponsfrilus
## @email     ponsfrilus@gmail.com
## @create_dt 2013-05-29
## @Update_dt 2015-04-15
## @version   0.0.2
##
## Usage:
##  chmod +x ubuntupostinstall.sh
##  sudo ./ubuntupostinstall.sh


## http://tldp.org/LDP/abs/html/

if [ ! -w /etc/passwd ]; then
    echo "Super-user privileges are required. Please run this with 'sudo ./ubuntupostinstall.sh'." >&2
    exit 1
fi

show_title() {
    clear;
    echo "=====================================================";
    echo "";
    echo "   __ponsfrilus _      _____           _        _ _ ";
    echo "  / _ \___  ___| |_    \_   \_ __  ___| |_ __ _| | |";
    echo " / /_)/ _ \/ __| __|    / /\/ '_ \/ __| __/ _\` | | |";
    echo "/ ___/ (_) \__ \ |_  /\/ /_ | | | \__ \ || (_| | | |";
    echo "\/    \___/|___/\__| \____/ |_| |_|___/\__\__,_|_|_|";
    echo "        make the installation of *buntu stuff easier";
    echo "";
    echo "=====================================================";
}

# Menu 1 : Dev Tools
menu1() {
    sudo apt-get install -y gedit vim git markdown;
    export EDITOR=/usr/bin/vim
    echo "installation of Sublime Text";
    sudo add-apt-repository ppa:webupd8team/sublime-text-2
    sudo apt-get update
    sudo apt-get install sublime-text
    sudo apt-get install meld
    sudo apt-get install mysql-workbench
    sudo apt-get install apache2 php5 mysql-server php5-mysql php5-curl php5-ldap
    echo "sudo a2enmod rewrite ldap"
    sudo service apache2 restart
    #sudo a2enmod

    ## Not really dev tools but to mount smb share in fstab
    ## Read http://askubuntu.com/questions/157128/proper-fstab-entry-to-mount-a-samba-share-on-boot
    ## https://wiki.ubuntu.com/MountWindowsSharesPermanently
    sudo apt-get install -y cifs-utils
    echo "Try with:
        sudo mkdir /mnt/LENINAS
        sudo mount -t cifs //stisrv.epfl.ch/igm/leni/ /mnt/LENINAS -o username=YourUsername,domain=STI"
    echo "Then, you can permanently add it to /etc/fstab"
        echo "~/.smbcredentials should contains
        username=YourUsername
        password=YourPassword
        domain=YourDomain
        ";
        echo "Then chmod 0600 ~/.smbcredentials";
    echo "//server/share /pathto/mountpoint cifs credentials=/home/username/.smbcredentials,uid=shareuser,gid=sharegroup 0 0"
    sudo apt-get install -y rdesktop
    # Android
    sudo apt-get install -y openjdk-7-jdk
    sudo apt-get install -y android-tools-fastboot && sudo apt-get install android-tools-adb
# sudo apt-get install xrdp

## Git migration (https://github.com/nirvdrum/svn2git)
#sudo apt-get install git-core git-svn ruby rubygems
#sudo gem install svn2git
}
# Menu 2 : Geek Stuff
menu2() {
        echo "installing ZSH";
        sudo apt-get install -y zsh
        echo "change the default shell (answer /bin/zsh)";
    sh -s /bin/zsh
        echo "Read https://github.com/robbyrussell/oh-my-zsh#readme";
        echo "installing oh my zsh";
        wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
    echo "In EPFL, you can change you default shell in "
    echo "https://dinfo.epfl.ch/cgi-bin/accountprefs"
    sudo apt-get install -y openssh-server
    # http://dinozaur1982.deviantart.com/art/conky2-316541287
    sudo apt-get install -y conky
}

# Menu 3 : Internet / Desktop
menu3(){
    sudo apt-get install -y libreoffice
    sudo apt-get install -y chromium-browser
    #sudo apt-get install dropbox
    #Install KeepNote.org
    #Intall markdown GUI / Gummy
}

# Menu 4: Multimedia
menu4(){
    echo "multimedia stuff";
    sudo apt-get -y install vlc ffmpeg mplayer dvdrip
    # Spotify
    sudo sh -c 'echo "deb http://repository.spotify.com stable non-free" >> /etc/apt/sources.list'
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59
    sudo apt-get update
    sudo apt-get install spotify-client
## sudo /usr/share/doc/libdvdread4/install-css.sh
}

# Menu 5: Drawing
menu5(){
    echo "Drawing stuff";
    sudo apt-get install -y inkscape gimp gthumb pinta gpicks
}

# Menu 6: Confort
menu6(){
    echo "Confort stuff";
    #sudo apt-get install inkscape gimp gthumbs pinta
## CONFORT
## workrave

#echo "Installing f.lux"
#sudo add-apt-repository ppa:kilian/f.lux
#sudo apt-get update
#sudo apt-get install fluxgui
}

# Menu 7 : Multi screen
menu7(){
    ## http://www.webupd8.org/2012/11/how-to-use-multiple-monitors-in-xubuntu.html
    ## Make the Multiscreen available + Thunar Tabs
    sudo add-apt-repository ppa:xubuntu-dev/xfce-4.12
    sudo apt-get update
    sudo apt-get upgrade
    echo "Now run the following command to configure your displays:"
    echo "xfce4-display-settings -m"
    echo "And run the fillowing command to restart Thunar and have tabs support:"
    echo "thunar -q"
}

# Menu 8: Optimization
menu8(){
    echo "Optimization";
    sudo apt-get autoremove
    sudo apt-get autoclean
}


show_menu() {

    ##read opt
    ##    $1        $2      $3      $4      $5      $6      $7      $8
    options=("Dev-Tools"    "Geek Stuff"    "Desktop / Internet"    "Multimedia"    "Drawing"   "Confort"   "Multi-Screen"  "Optimization")
    echo "Please select your objectives : "
    PS3="Pick an option (press enter to see choices): "
    select opt in "${options[@]}" "All" "Quit (or q)"; do
        case "$REPLY" in
            1 )     echo "$opt: will install gedit, vim, git, markdown, sublime"
                while true
                    do
                        read -r -p 'Dev-Tools option will install gedit, vim, git, markdown. Would you to continue [y/n] ? ' choice
                        case "$choice" in
                            n|N) clear; break;; ##TODO: find a way to show_menu() again without recusrivity
                            y|Y) menu1
                                break;;
                        esac
                    done
                    ;;

            2 ) echo "$opt: will install "
                                while true
                                        do
                                                read -r -p 'Geek Stuffs option will install zsh, oh my zsh, openssh-server. Would you to continue [y/n] ? ' choice
                                                case "$choice" in
                                                        n|N) break;; ##TODO: find a way to show_menu() again without recusrivity
                                                        y|Y) menu2
                                                                break;;
                                                esac
                                        done
                                ;;

            3 ) echo "$opt: will install libreoffice & chromium browser"
                                while true
                                        do
                                                read -r -p 'Internet option will install chromium. Would you to continue [y/n] ? ' choice
                                                case "$choice" in
                                                        n|N) break;; ##TODO: find a way to show_menu() again without recusrivity
                                                        y|Y) menu3
                                                                break;;
                                                esac
                                        done
                                ;;

            4 ) echo "$opt: will install vlc, mplayer, ffmpeg"
                                while true
                                        do
                                                read -r -p 'Multimedia option will install vlc, mplayer, ffmpeg. Would you to continue [y/n] ? ' choice
                                                case "$choice" in
                                                        n|N) break;; ##TODO: find a way to show_menu() again without recusrivity
                                                        y|Y) menu4
                                                                break;;
                                                esac
                                        done
                                ;;

            5 ) echo "$opt: will install inkscape gimp gthumbs pinta "
                                while true
                                        do
                                                read -r -p 'Drawing option will install inkscape gimp gthumbs pinta . Would you to continue [y/n] ? ' choice
                                                case "$choice" in
                                                        n|N) break;; ##TODO: find a way to show_menu() again without recusrivity
                                                        y|Y) menu5
                                                                break;;
                                                esac
                                        done
                                ;;

            6 ) echo "$opt: will install ? "
                                while true
                                        do
                                                read -r -p $opt ' option will install workrave and flux. Would you to continue [y/n] ? ' choice
                                                case "$choice" in
                                                        n|N) break;; ##TODO: find a way to show_menu() again without recusrivity
                                                        y|Y) menu6
                                                                break;;
                                                esac
                                        done
                                ;;

            7 ) echo "$opt: will install  MultiScreen "
                                while true
                                        do
                                                read -r -p $opt ' option will install ppa:xubuntu-dev/xfce-4.12 and new xfce4-display-settings. Would you to continue [y/n] ? ' choice
                                                case "$choice" in
                                                        n|N) break;; ##TODO: find a way to show_menu() again without recusrivity
                                                        y|Y) menu7
                                                                break;;
                                                esac
                                        done
                                ;;

            8 ) echo "$opt: will autoremove and autoclean and install preload ? "
                                while true
                                        do
                                                read -r -p $opt ' option will install ?. Would you to continue [y/n] ? ' choice
                                                case "$choice" in
                                                        n|N) break;; ##TODO: find a way to show_menu() again without recusrivity
                                                        y|Y) menu8
                                                                break;;
                                                esac
                                        done
                                ;;

            $(( ${#options[@]}+1 )) ) echo "You are a crazy monkey !"
                        menu1
                        menu2
                        menu3
                        menu4
                        menu5
                        menu6
                        menu7
                        menu8
                    break;;

            $(( ${#options[@]}+1 )) ) echo "Goodbye!"; break;;

            q|Q|Quit|quit|Exit|exit ) echo "Goodbye!"; break;;

            *) echo "Invalid option. Pick another one.";continue;;
        esac
    done
}

clear
show_title
show_menu

exit 0
