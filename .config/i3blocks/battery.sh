#!/bin/bash
if [ -f /sys/class/power_supply/BAT0/uevent ]; then
	prct=$(cat /sys/class/power_supply/BAT0/uevent | grep "POWER_SUPPLY_CAPACITY=" | cut -d'=' -f2)
	charging=$(cat /sys/class/power_supply/BAT0/uevent | grep "POWER_SUPPLY_STATUS" | cut -d'=' -f2)
	# POWER_SUPPLY_STATUS=Discharging|Charging
	case "$charging" in
		"Full") icon="⚡" ;;
		"Discharging")
		case "$prct" in
			[0-9]|1[0-9]|20) icon="" ;;
			2[1-9]|3[0-9]|40) icon="" ;;
			4[1-9]|5[0-9]|60) icon="" ;;
			6[1-9]|7[0-9]|80) icon="" ;;
			8[1-9]|9[0-9]|100) icon="" ;;
			*) icon="❓" ;
		esac && [ "$prct" -le 25 ] && printf "⚠️ ";;
		*) icon="⚡🔄" ;;
	esac
	echo -n "${icon}  ${prct}%"
else
	echo -n "🔌 Plugged"
fi
