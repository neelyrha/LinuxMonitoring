#!/bin/bash
  
function get_color_name {
        case "$1" in
        1) echo "(white)" ;;
        2) echo "(red)" ;;
        3) echo "(green)" ;;
        4) echo "(blue)" ;;
        5) echo "(purple)" ;;
        6) echo "(black)" ;;
        esac
}

function color {
    case "$1" in
    1 ) echo "\e["$2"7m" ;; # white
    2 ) echo "\e["$2"1m" ;; # red
    3 ) echo "\e["$2"2m" ;; # green
    4 ) echo "\e["$2"4m" ;; # blue
    5 ) echo "\e["$2"5m" ;; # purple
    6 ) echo "\e["$2"0m" ;; # black
    * ) echo "default"   ;; # error
    esac

}

function status {
    declare -a data
    data+=("$HOSTNAME")
    data+=("$(date +"%Z %z")")
    data+=("$USER")
    data+=("$(hostnamectl | grep "Operating System" | cut -b 21-)")
    data+=("$(date +"%d %b %Y %H:%M:%S")")
    data+=("$(uptime -p)")
    data+=("$(cat /proc/uptime | cut -d " " -f 1)")
    data+=("$(ip route get 1 | awk '{print $(NF-2);exit}')")
    data+=("$(ifconfig | awk 'NR==11{print $4}')")
    data+=("$(ip r | awk '{print $3}' | head -1)")
    data+=("$(free | awk '/Mem:/{printf "%.3f Gb", $2/1048576}')")
    data+=("$(free | awk '/Mem:/{printf "%.3f Gb", $3/1048576}')")
    data+=("$(free | awk '/Mem:/{printf "%.3f Gb", $4/1048576}')")
    data+=("$(df /root | awk '/\/$/ {printf "%.2f MB", $2/1024}')")
    data+=("$(df /root | awk '/\/$/ {printf "%.2f MB", $3/1024}')")
    data+=("$(df /root | awk '/\/$/ {printf "%.2f MB", $4/1024}')")

    declare -a names
    names+=("HOSTNAME")
    names+=("TIMEZONE")
    names+=("USER")
    names+=("OS")
    names+=("DATE")
    names+=("UPTIME")
    names+=("UPTIME_SEC")
    names+=("IP")
    names+=("MASK")
    names+=("GATEWAY")
    names+=("RAM_TOTAL")
    names+=("RAM_USED")
    names+=("RAM_FREE")
    names+=("SPACE_ROOT")
    names+=("SPACE_ROOT_USED")
    names+=("SPACE_ROOT_FREE")

        for index in "${!data[@]}"
    do
        echo -e "$column1_font_color$column1_background${names[$index]}\e[0m"="$column2_font_color$column2_background${data[$index]}\e[0m"
    done
}
default=""
color_name=""
color_from_config=$(grep column1_background config | cut -b 20-)
defcolor=$(color "$color_from_config" 4)
key=$(get_color_name $color_from_config)
if [ $defcolor = "default" ]
then
        column1_background="\e[40m" #black
        default="default"
        key="(black)"
else
        column1_background=$(echo $defcolor)
        default=$color_from_config
fi
column1bg="Column 1 background = $default $key"

color_from_config=$(grep column1_font_color config | cut -b 20-)
defcolor=$(color "$color_from_config" 3)
key=$(get_color_name $color_from_config)
if [ $defcolor = "default" ]
then
        column1_font_color="\e[37m" #white
        default="default"
        key="(white)"
else
        column1_font_color=$(echo $defcolor)
        default=$color_from_config
fi
column1font="Column 1 font color = $default $key"

color_from_config=$(grep column2_background config | cut -b 20-)
defcolor=$(color "$color_from_config" 4)
key=$(get_color_name $color_from_config)
if [ $defcolor = "default" ]
then
        column2_background="\e[45m" #purple
        default="default"
        key="(purple)"
else
        column2_background=$(echo $defcolor)
        default=$color_from_config
fi
column2bg="Column 2 background = $default $key"

color_from_config=$(grep column2_font_color config | cut -b 20-)
defcolor=$(color "$color_from_config" 3)
key=$(get_color_name $color_from_config)
if [ $defcolor = "default" ]
then
        column2_font_color="\e[34m" #blue
        default="default"
        key="(blue)"
else
        column2_font_color=$(echo $defcolor)
        default=$color_from_config
fi
column2font="Column 2 font color = $default $key"

status
echo -e "$column1bg\n$column1font\n$column2bg\n$column2font"

                                                                                                                                 130,7         Bot
