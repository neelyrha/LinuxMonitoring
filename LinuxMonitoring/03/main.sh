#!/bin/bash
function color {
    case "$1" in
    1 ) echo "\e["$2"7m" ;; # white
    2 ) echo "\e["$2"1m" ;; # red
    3 ) echo "\e["$2"2m" ;; # green
    4 ) echo "\e["$2"4m" ;; # blue
    5 ) echo "\e["$2"5m" ;; # purple
    6 ) echo "\e["$2"0m" ;; # black
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
        echo -e "$textcolor_key$bgcolor_key${names[$index]}\e[0m"="$textcolor_value$bgcolor_value${data[$index]}\e[0m"
    done
}

textcolor_key=$(color $2 3)
textcolor_value=$(color $4 3)
bgcolor_key=$(color $1 4)
bgcolor_value=$(color $3 4)

        for i in "$@"
do
        if [[ "$i" -gt 6 || "$i" -lt 1  ]]
        then
                echo "incorrect arguments"
                exit
        fi
done

if [ -z "$4" ]
then
        echo "too few arguments"
elif [[ $1 -eq $2 || $3 -eq $4 ]]
then
    echo "background and text colors are matching! Enter another values"
else
    status
fi
