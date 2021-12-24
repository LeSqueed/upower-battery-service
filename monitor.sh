#!/bin/sh
upower -i $(upower -e | grep BAT) | grep -E "state|percentage" | {
	read -r state_label state
	read -r -d '%' percentage_label percentage

	if [ "$state" = discharging -a "$percentage" -lt 5 ]; then
		logger "Battery dropped to critical levels, hibernating."
		systemctl hibernate
	fi
	
	if [ "$state" = discharging -a "$percentage" -lt 21 ]; then
		notify-send-all -u critical "Low battery" "Battery at $percentage%, please plug in the charger to avoid hibernation." --icon=dialog-warning 
	fi
}