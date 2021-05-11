#    _             _ _
#   / \  _   _  __| (_) ___
#  / _ \| | | |/ _` | |/ _ \
# / ___ \ |_| | (_| | | (_) |
#/_/   \_\__,_|\__,_|_|\___/
#
pa-list() { pacmd list-sinks | awk '/index/ || /name:/' ;}
pa-set() { 
	# list all apps in playback tab (ex: cmus, mplayer, vlc)
	inputs=($(pacmd list-sink-inputs | awk '/index/ {print $2}')) 
	# set the default output device
	pacmd set-default-sink $1 &> /dev/null
	# apply the changes to all running apps to use the new output device
	for i in ${inputs[*]}; do pacmd move-sink-input $i $1 &> /dev/null; done
}
pa-playbacklist() { 
	# list individual apps
	echo "==============="
	echo "Running Apps"
	pacmd list-sink-inputs | awk '/index/ || /application.name /'

	# list all sound device
	echo "==============="
	echo "Sound Devices"
	pacmd list-sinks | awk '/index/ || /name:/'
}
pa-playbackset() { 
	# set the default output device
	pacmd set-default-sink "$2" &> /dev/null
	# apply changes to one running app to use the new output device
	pacmd move-sink-input "$1" "$2" &> /dev/null
}

#  ____ _               _
# / ___| |__   ___  ___| | _____ _   _ _ __ ___
#| |   | '_ \ / _ \/ __| |/ / __| | | | '_ ` _ \
#| |___| | | |  __/ (__|   <\__ \ |_| | | | | | |
# \____|_| |_|\___|\___|_|\_\___/\__,_|_| |_| |_|
#

checkSha256() {
	echo "$1" | shasum -a 256 --check
}

checkMd5() {
	echo "$1" | md5sum --check
}

checkSha512() {
	echo "$1" | shasum -a 512 --check
}

checkSha1() {
	echo "$1" | shasum -a 1 --check
}

# ____  _      _   _                        _
#|  _ \(_) ___| |_(_) ___  _ __   __ _ _ __(_) ___  ___
#| | | | |/ __| __| |/ _ \| '_ \ / _` | '__| |/ _ \/ __|
#| |_| | | (__| |_| | (_) | | | | (_| | |  | |  __/\__ \
#|____/|_|\___|\__|_|\___/|_| |_|\__,_|_|  |_|\___||___/
#

deen() {
		sdcv -u "German - English" -c $1
}

ende() {
		sdcv -u "English - German" -c $1
}

duden() {
		sdcv -u "Duden" -c $1
}

collins() {
		sdcv -u "Collins Cobuild English Dictionary" -c $1
}

oxford() {
		sdcv -u "Oxford Advanced Learner's Dictionary" -c $1
}

#__        ___ _    _
#\ \      / (_) | _(_)
# \ \ /\ / /| | |/ / |
#  \ V  V / | |   <| |
#   \_/\_/  |_|_|\_\_|
#

offlinewiki-daemon() {
	~/kiwix/./kiwix-serve --port 49849 --daemon ~/data/zim/*.zim ;
}

offlinewiki-quit() {
	kill $(ps -ef | grep -i '[K]iwix-serve' | awk '{print $2}') ;
}

# _   _      _                      _    _
#| \ | | ___| |___      _____  _ __| | _(_)_ __   __ _
#|  \| |/ _ \ __\ \ /\ / / _ \| '__| |/ / | '_ \ / _` |
#| |\  |  __/ |_ \ V  V / (_) | |  |   <| | | | | (_| |
#|_| \_|\___|\__| \_/\_/ \___/|_|  |_|\_\_|_| |_|\__, |
#

block-ufw() {
	sudo ufw reset
	sudo ufw default deny incoming
	sudo ufw default deny outgoing
	sudo ufw allow out on tun0 from any to any
    #sudo ufw allow out to address
	sudo ufw enable
}

unblock-ufw() {
	sudo ufw reset
	sudo ufw default deny incoming
	sudo ufw default allow outgoing
	sudo ufw enable
}

iplocation() {
		curl ipinfo.io
}

# __  __ _
#|  \/  (_)___  ___
#| |\/| | / __|/ __|
#| |  | | \__ \ (__
#|_|  |_|_|___/\___|
#

timer() {
	date1=`date +%s`; while true; do 
   echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
   done
}

ref_cheat {
    cat ~/.local/cheat/$1
}

#mouse-shift-num() {
#	setxkbmap -option keypad:pointerkeys
#}

#weather() {
#		curl wttr.in/city
#}

#powerOnServer() {
#	powerwake mac-address
#}
