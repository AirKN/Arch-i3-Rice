#!/bin/bash

# i3 config in ~/.config/i3/config :
# bar {
#   status_command exec /home/you/.config/status/mybar.sh
# }

bg_bar_color="#1d2021"
color1="#1d2021"
color2="#fbf1c7"
#textcl="#1d2021"
textcl="#fbf1c7"

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

    titlebar() {
      title=$(~/.config/status/i3-focusedwindow)
      separator $bg "$bg"
      echo -n ",{"
      echo -n "\"full_text\":\" $title \","
      echo -n "\"color\":\"$textcl\","
      common
      echo -n "},"
    }


    meteo() {
      local bg=$color1
      #local bg="#a89984"
      separator $textcl $bg
      echo -n ",{"
      echo -n "\"name\":\"id_meteo\","
      echo -n "\"full_text\":\" $(~/.config/status/meteo.sh) \","
      echo -n "\"background\":\"$bg\","
      echo -n "\"color\":\"$textcl\","
      common
      echo -n "},"
    }


    disk_usage() {
      #local bg="#cc241d"
      local bg=$color1
      separator $bg "$bg"
      echo -n ",{"
      echo -n "\"name\":\"id_disk_usage\","
      echo -n "\"full_text\":\" 📂 $(~/.config/status/disk.py)% \","
      echo -n "\"background\":\"$bg\","
      echo -n "\"color\":\"$textcl\","
      common
      echo -n "}"
    }

    memory() {
      mem=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
      local bg=$color1
      #local bg="#b16286"
      echo -n ",{"
      echo -n "\"name\":\"id_memory\","
      echo -n "\"full_text\":\" 📝 $mem \","
      echo -n "\"background\":\"$bg\","
      echo -n "\"color\":\"$textcl\","
      common
      echo -n "}"
    }

    cpu_usage() {
      local bg=$color1
      #local bg="#458588"
      echo -n ",{"
      echo -n "\"name\":\"id_cpu_usage\","
      echo -n "\"full_text\":\" 🧠 $(~/.config/status/cpu.py)% \","
      echo -n "\"background\":\"$bg\","
      echo -n "\"color\":\"$textcl\","
      common
      echo -n "},"
    }


battery() {
    local bg=$color1
    #local bg="#689d6a"
    bg_separator_previous=$bg
    separator $bg "$bg"
    echo -n ",{"
    echo -n "\"name\":\"battery0\","
    echo -n "\"full_text\":\" $(~/.config/status/battery.sh) \","
    echo -n "\"color\":\"$textcl\","
    echo -n "\"background\":\"$bg\","
    common
    echo -n "},"

}


volume() {
  local bg=$color1
  vol=$(pamixer --get-volume)
  #local bg="#b8bb26"
  bg_separator_previous=$bg
  separator $bg "$bg"
  echo -n ",{"
  echo -n "\"name\":\"id_volume\","
  if [ $vol -le 0 ]; then
    echo -n "\"full_text\":\" 🔇 ${vol}% \","
  else
    echo -n "\"full_text\":\" 🔊 ${vol}% \","
  fi
  echo -n "\"background\":\"$bg\","
  echo -n "\"color\":\"$textcl\","
  common
  echo -n "},"
}


mydate() {
  local bg=$color1
  #local bg="#fabd2f"
  separator $bg "$bg"
  echo -n ",{"
  echo -n "\"name\":\"id_date\","
  echo -n "\"full_text\":\" 📅 $(date "+%a %d %b") \","
  echo -n "\"background\":\"$bg\","
  echo -n "\"color\":\"$textcl\","
  common
  echo -n "},"
}

mytime() {
  local bg=$color1
  #local bg="#cc241d"
  separator $bg "$bg"
  echo -n ",{"
  echo -n "\"name\":\"id_time\","
  echo -n "\"full_text\":\" ⌚ $(date "+%H:%M") \","
  echo -n "\"background\":\"$bg\","
  echo -n "\"color\":\"$textcl\","
  common
  echo -n "},"
  separator $bg "$bg"
}


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
  titlebar
  meteo
  disk_usage
  memory
  cpu_usage
  battery
  volume
  mydate
  mytime
  logout
  echo "]"
  #sleep 1
done) &

# click events
while read line;
do
  # echo $line > /home/you/gitclones/github/i3/tmp.txt
  # {"name":"id_vpn","button":1,"modifiers":["Mod2"],"x":2982,"y":9,"relative_x":67,"relative_y":9,"width":95,"height":22}

  # CPU
  if [[ $line == *"name"*"id_cpu_usage"* ]]; then
    notify-send "CPU Temperature: $(sensors | awk '/^CPU:/ {print $2}')"
    notify-send "Most CPU intensive processes(by %):
$(ps axch -o cmd:40,%cpu --sort:-%cpu | head)"
  # MEMORY
  elif [[ $line == *"name"*"id_memory"* ]]; then
    notify-send "Most Memory intensive processes(by %):
$(ps axch -o cmd:40,%mem --sort:-%mem | head)"

  # DISK
  elif [[ $line == *"name"*"id_disk_usage"* ]]; then
    notify-send "$(df -h)"

  # DATE
  elif [[ $line == *"name"*"id_date"* ]]; then
    notify-send "$(cal --months 2)"

  # TIME
  elif [[ $line == *"name"*"id_time"* ]]; then
    notify-send "Yes, This is Time ⌚, Yes"

  # METEO
  elif [[ $line == *"name"*"id_meteo"* ]]; then
    st -e curl wttr.in/manouba &

 # BATTERY
  elif [[ $line == *"name"*"battery0"* ]]; then
    notify-send "⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡"

  # VOLUME
  elif [[ $line == *"name"*"id_volume"* ]]; then
    st -e alsamixer &

  # LOGOUT
  elif [[ $line == *"name"*"id_logout"* ]]; then
    i3-nagbar -t warning -m 'Log out ?' -b 'yes' 'i3-msg exit' > /dev/null &

  fi
done


