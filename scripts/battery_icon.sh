#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

# script global variables
charged_icon=""
charging_icon=""
attached_icon=""
# discharging_icon=""
full_charge_icon=""
high_charge_icon=""
medium_charge_icon=""
low_charge_icon=""
high_threshold=""
medium_threshold=""
low_threshold=""

charged_default="❇ "
charged_default_osx="🔋 "
charging_default="⚡️ "
attached_default="⚠️ "
full_charge_icon_default="🌕 "
high_charge_icon_default="🌖 "
medium_charge_icon_default="🌗 "
low_charge_icon_default="🌘 "
high_threshold_default=99
medium_threshold_default=51
low_threshold_default=16

charged_default() {
	if is_osx; then
		echo "$charged_default_osx"
	else
		echo "$charged_default"
	fi
}

# icons are set as script global variables
get_icon_settings() {
	charged_icon=$(get_tmux_option "@batt_charged_icon" "$(charged_default)")
	charging_icon=$(get_tmux_option "@batt_charging_icon" "$charging_default")
	attached_icon=$(get_tmux_option "@batt_attached_icon" "$attached_default")
	full_charge_icon=$(get_tmux_option "@batt_full_charge_icon" "$full_charge_icon_default")
	high_charge_icon=$(get_tmux_option "@batt_high_charge_icon" "$high_charge_icon_default")
	medium_charge_icon=$(get_tmux_option "@batt_medium_charge_icon" "$medium_charge_icon_default")
	low_charge_icon=$(get_tmux_option "@batt_low_charge_icon" "$low_charge_icon_default")
    high_threshold=$(get_tmux_option "@batt_high_threshold" "$high_threshold_default")
    medium_threshold=$(get_tmux_option "@batt_medium_threshold" "$medium_threshold_default")
    low_threshold=$(get_tmux_option "@batt_low_threshold" "$low_threshold_default")
}

print_icon() {
	local status=$1
	if [[ $status =~ (charged) ]]; then
		printf "$charged_icon"
	elif [[ $status =~ (^charging) ]]; then
		printf "$charging_icon"
	elif [[ $status =~ (^discharging) ]]; then
        # use code from the bg color
        percentage=$($CURRENT_DIR/battery_percentage.sh | sed -e 's/%//')
        if [ $percentage -ge $high_threshold ]; then
            printf "$full_charge_icon"
        elif [ $percentage -lt $high_threshold -a $percentage -ge $medium_threshold ];then
            printf "$high_charge_icon"
        elif [ $percentage -lt $medium_threshold -a $percentage -ge $low_threshold ];then
            printf "$medium_charge_icon"
        elif [ "$percentage" == "" ];then  
            printf "$full_charge_icon_default"  # assume it's a desktop
        else
            printf "$low_charge_icon"
        fi
	elif [[ $status =~ (attached) ]]; then
		printf "$attached_icon"
	fi
}

main() {
	get_icon_settings
	local status=$(battery_status)
	print_icon "$status"
}
main
