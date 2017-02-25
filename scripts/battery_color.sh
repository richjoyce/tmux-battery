#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

color_full_charge_default="green"
color_high_charge_default="yellow"
color_medium_charge_default="colour208" # orange
color_low_charge_default="red"
color_high_charging_default="yellow"
color_medium_charging_default="yellow"
color_low_charging_default="yellow"
high_threshold_default=99
medium_threshold_default=51
low_threshold_default=16

color_full_charge=""
color_high_charge=""
color_medium_charge=""
color_low_charge=""
color_high_charging=""
color_medium_charging=""
color_low_charging=""
high_threshold=""
medium_threshold=""
low_threshold=""

get_charge_color_settings() {
    color_full_charge=$(get_tmux_option "@batt_color_full_charge" "$color_full_charge_default")
    color_high_charge=$(get_tmux_option "@batt_color_high_charge" "$color_high_charge_default")
    color_medium_charge=$(get_tmux_option "@batt_color_medium_charge" "$color_medium_charge_default")
    color_low_charge=$(get_tmux_option "@batt_color_low_charge" "$color_low_charge_default")
    color_high_charging=$(get_tmux_option "@batt_color_high_charging" "$color_high_charging_default")
    color_medium_charging=$(get_tmux_option "@batt_color_medium_charging" "$color_medium_charging_default")
    color_low_charging=$(get_tmux_option "@batt_color_low_charging" "$color_low_charging_default")
    high_threshold=$(get_tmux_option "@batt_high_threshold" "$high_threshold_default")
    medium_threshold=$(get_tmux_option "@batt_medium_threshold" "$medium_threshold_default")
    low_threshold=$(get_tmux_option "@batt_low_threshold" "$low_threshold_default")
}

print_color() {
    printf "#[${1}=${2}]"
}

print_battery_color() {
    # Call `battery_percentage.sh`.
    percentage=$($CURRENT_DIR/battery_percentage.sh | sed -e 's/%//')
	  local status=$(battery_status)
    if [ $percentage -ge $high_threshold ]; then
        print_color $1 $color_full_charge
    elif [ $percentage -lt $high_threshold -a $percentage -ge $medium_threshold ];then
        if [[ $status =~ (^charging) ]]; then
          print_color $1 $color_high_charging
        else
          print_color $1 $color_high_charge
        fi
    elif [ $percentage -lt $medium_threshold -a $percentage -ge $low_threshold ];then
        if [[ $status =~ (^charging) ]]; then
          print_color $1 $color_medium_charging
        else
          print_color $1 $color_medium_charge
        fi
    else
        if [[ $status =~ (^charging) ]]; then
          print_color $1 $color_low_charging
        else
          print_color $1 $color_low_charge
        fi
    fi
}

main() {
    get_charge_color_settings
	print_battery_color $1
}
main $1
