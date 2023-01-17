#!/bin/bash
  
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
    
        for i in "${!data[@]}"
    do
        echo "${names[$i]}=${data[$i]}"
    done
}

status
echo "Write to file? [y/n]"
read answer
if [[ "$answer" = 'y' || "$answer" = 'Y' ]];
then
        date=$(date +"%d_%m_%Y_%H_%M_%S")
        status > "${date}.txt"
fi
