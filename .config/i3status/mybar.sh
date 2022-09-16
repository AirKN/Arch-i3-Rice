#!/bin/sh

# i3 config in ~/.config/i3/config :
# bar {
#   status_command exec /home/you/.config/i3status/mybar.sh
# }

bg_bar_color="#1d2021"
color1="#1d2021"
color2="#fbf1c7"
textcl1="#1d2021"
textcl2="#fbf1c7"

# Print a left caret separator
# @params {string} $1 text color, ex: "#FF0000"
# @params {string} $2 background color, ex: "#FF0000"


separator() {
  echo -n "{"
  echo -n "\"full_text\":\"\"," # CTRL+Ue0b2
  echo -n "\"separator\":false,"
  echo -n "\"separator_block_width\":0,"
  echo -n "\"border\":\"$bg_bar_color\","
  echo -n "\"border_left\":0,"
  echo -n "\"border_right\":0,"
  echo -n "\"border_top\":2,"
  echo -n "\"border_bottom\":2,"
  echo -n "\"color\":\"$1\","
  echo -n "\"background\":\"$2\""
  echo -n "}"
}

common() {
  echo -n "\"border\": \"$bg_bar_color\","
  echo -n "\"separator\":false,"
  echo -n "\"separator_block_width\":0,"
  echo -n "\"border_top\":2,"
  echo -n "\"border_bottom\":2,"
  echo -n "\"border_left\":0,"
  echo -n "\"border_right\":0"
}

<<com
mycrypto() {
  local bg="#FFD180"
  separator $bg $bg_bar_color
  echo -n ",{"
  echo -n "\"name\":\"id_crypto\","
  echo -n "\"full_text\":\" $(~/.config/i3status/crypto.py) \","
  echo -n "\"color\":\"#000000\","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
}


myip_public() {
  local bg="#1976D2"
  separator $bg "#FFD180"
  echo -n ",{"
  echo -n "\"name\":\"ip_public\","
  echo -n "\"full_text\":\" $(~/.config/i3status/ip.py) \","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
}


myvpn_on() {
  local bg="#424242" # grey darken-3
  local icon=""
  if [ -d /proc/sys/net/ipv4/conf/proton0 ]; then
    bg="#E53935" # rouge
    icon=""
  fi
  separator $bg "#1976D2" # background left previous block
  bg_separator_previous=$bg
  echo -n ",{"
  echo -n "\"name\":\"id_vpn\","
  echo -n "\"full_text\":\" ${icon} VPN \","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
}

myip_local() {
  local bg="#2E7D32" # vert
  separator $bg $bg_separator_previous
  echo -n ",{"
  echo -n "\"name\":\"ip_local\","
  echo -n "\"full_text\":\"  $(ip route get 1 | sed -n 's/.*src \([0-9.]\+\).*/\1/p') \","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
}
com

disk_usage() {
  local bg="$color2"
  separator $bg $color1
  echo -n ",{"
  echo -n "\"name\":\"id_disk_usage\","
  echo -n "\"full_text\":\" 📝 $(~/.config/i3status/disk.py)%\","
  echo -n "\"background\":\"$bg\","
  echo -n "\"color\":\"$textcl1\","
  common
  echo -n "}"
}

memory() {
  echo -n ",{"
  echo -n "\"name\":\"id_memory\","
  echo -n "\"full_text\":\" 🪜 $(~/.config/i3status/memory.py)%\","
  echo -n "\"background\":\"$color2\","
  echo -n "\"color\":\"$textcl1\","
  common
  echo -n "}"
}

cpu_usage() {
  echo -n ",{"
  echo -n "\"name\":\"id_cpu_usage\","
  echo -n "\"full_text\":\" 🧠 $(~/.config/i3status/cpu.py)% \","
  echo -n "\"background\":\"$color2\","
  echo -n "\"color\":\"$textcl1\","
  common
  echo -n "},"
}

<<moc
meteo() {
  local bg="#546E7A"
  separator $bg "$color1"
  echo -n ",{"
  echo -n "\"name\":\"id_meteo\","
  echo -n "\"full_text\":\" $(~/.config/i3status/meteo.py) \","
  echo -n "\"background\":\"$bg\","
  echo -n "\"color\":\"$textcl1\","
  common
  echo -n "},"
}
moc

mydate() {
  local bg="$color1"
  separator $bg "$color2"
  echo -n ",{"
  echo -n "\"name\":\"id_time\","
  echo -n "\"full_text\":\" ⏰ $(date "+%a %d/%m/%y %H:%M") \","
  echo -n "\"background\":\"$bg\","
  echo -n "\"color\":\"$textcl2\","
  common
  echo -n "},"
}


battery() {
    local bg="$color2"
    bg_separator_previous=$bg
    separator $bg "$color1"

  if [ -f /sys/class/power_supply/BAT0/uevent ]; then
    prct=$(cat /sys/class/power_supply/BAT0/uevent | grep "POWER_SUPPLY_CAPACITY=" | cut -d'=' -f2)
    charging=$(cat /sys/class/power_supply/BAT0/uevent | grep "POWER_SUPPLY_STATUS" | cut -d'=' -f2) # POWER_SUPPLY_STATUS=Discharging|Charging
    icon="🔋"
    if [ "$charging" == "Charging" ]; then
      icon=""
    fi
    echo -n ",{"
    echo -n "\"name\":\"battery0\","
    echo -n "\"full_text\":\" ${icon} ${prct}% \","
    echo -n "\"color\":\"$textcl1\","
    echo -n "\"background\":\"$bg\","
    common
    echo -n "},"
  else
    echo -n ",{"
    echo -n "\"name\":\"id_time\","
    echo -n "\"full_text\":\" 🔌 Plugged \","
    echo -n "\"color\":\"$textcl1\","
    echo -n "\"background\":\"$bg\","
    common
    echo -n "},"

  fi
}


volume() {
  local bg="$color1"
  separator $bg $bg_separator_previous
  vol=$(pamixer --get-volume)
  echo -n ",{"
  echo -n "\"name\":\"id_volume\","
  if [ $vol -le 0 ]; then
    echo -n "\"full_text\":\"  ${vol}% \","
  else
    echo -n "\"full_text\":\" 🔊 ${vol}% \","
  fi
  echo -n "\"background\":\"$bg\","
  echo -n "\"color\":\"$textcl2\","
  common
  echo -n "},"
  separator $bg_bar_color $bg
}

<<br
systemupdate() {
  local nb=$(checkupdates | wc -l)
  if (( $nb > 0)); then
    echo -n ",{"
    echo -n "\"name\":\"id_systemupdate\","
    echo -n "\"full_text\":\"  ${nb}\""
    echo -n "}"
  fi
}
br

logout() {
  echo -n ",{"
  echo -n "\"name\":\"id_logout\","
  echo -n "\"full_text\":\"  \""
  echo -n "}"
}

# https://github.com/i3/i3/blob/next/contrib/trivial-bar-script.sh
echo '{ "version": 1, "click_events":true }'     # Send the header so that i3bar knows we want to use JSON:
echo '['                    # Begin the endless array.
echo '[]'                   # We send an empty first array of blocks to make the loop simpler:

# Now send blocks with information forever:
(while :;
do
	echo -n ",["
  #mycrypto
  #myip_public
  #myvpn_on
  #myip_local
  disk_usage
  memory
  cpu_usage
  #meteo
  mydate
  battery
  volume
  #systemupdate
  logout
  echo "]"
	sleep 1
done) &

# click events
while read line;
do
  # echo $line > /home/you/gitclones/github/i3/tmp.txt
  # {"name":"id_vpn","button":1,"modifiers":["Mod2"],"x":2982,"y":9,"relative_x":67,"relative_y":9,"width":95,"height":22}

  # VPN click
  if [[ $line == *"name"*"id_vpn"* ]]; then
    alacritty -e ~/.config/i3status/click_vpn.sh &

  # CHECK UPDATES
  elif [[ $line == *"name"*"id_systemupdate"* ]]; then
    alacritty -e ~/.config/i3status/click_checkupdates.sh &

  # CPU
  elif [[ $line == *"name"*"id_cpu_usage"* ]] || [[ $line == *"name"*"id_memory"* ]]; then
    alacritty -e htop &

  elif [[ $line == *"name"*"id_disk_usage"* ]]; then
    notify-send "$(df -h)"

  # TIME
  elif [[ $line == *"name"*"id_time"* ]]; then
    #alacritty -e ~/.config/i3status/click_time.sh &
    notify-send "$(cal --months 2)"

  # METEO
  elif [[ $line == *"name"*"id_meteo"* ]]; then
    xdg-open https://openweathermap.org/city/2986140 > /dev/null &

  # CRYPTO
  elif [[ $line == *"name"*"id_crypto"* ]]; then
    xdg-open https://www.livecoinwatch.com/ > /dev/null &

  # VOLUME
  elif [[ $line == *"name"*"id_volume"* ]]; then
    alacritty -e alsamixer &

  # LOGOUT
  elif [[ $line == *"name"*"id_logout"* ]]; then
    i3-nagbar -t warning -m 'Log out ?' -b 'yes' 'i3-msg exit' > /dev/null &

  fi
done
