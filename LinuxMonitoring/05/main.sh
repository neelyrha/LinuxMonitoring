#!/bin/bash

start=`date +%s.%N`

if [[ $# != 1 ]] ; then
    echo "Invalid number of arguments (expected 1, input $#)"
    exit 1
elif [[ !(-d $1) ]] ; then
    echo "it is not a directory"
    exit 1
elif [[ $1 != */ ]] ; then
    echo "incorrect input"
    exit 1
fi

total_num_folders=$(($(sudo find $1 -type d | grep . -c)-1))
echo "Total number of folders (including all nested ones) = $total_num_folders"

top5biggestfolderspath=($(du $1 -h | sort -rh | head -6 | awk '{print$2}'))
top5biggestfolderssize=($(du $1 -h | sort -rh | head -6 | awk '{print$1}'))
echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
for (( i=1; i<6; i++)); do
    printf "$((i+0))"" - "
    printf "${top5biggestfolderspath[i]}, "
    printf "${top5biggestfolderssize[i]}\n"
done

totalnumberfiles=$(sudo find $1 -type f | grep . -c)
echo "Total number of files = $totalnumberfiles"

conf=$(sudo find $1 -type f | grep "\.conf" -c)
echo "Number of:
Configuration files (with the .conf extension) = $conf"

text=$(sudo find $1 -type f -name "*.txt" | grep . -c)
echo "Text files = $text"

exe=$(find $1 -type f -perm /a=x | wc -l) # ПРОВЕРКА?
echo "Executable files = $exe"

log=$(sudo find $1 -type f -name "*.log" | grep . -c)
echo "Log files (with the extension .log) = $log"

arch=$(sudo find $1 -type f \( -name '*.zip' -o     \
          -name '*.tar' -o     \
          -name '*.tar.gz' -o  \
          -name '*.tar.bz2' -o \
          -name '*.tar.xz' -o  \
          -name '*.tgz' -o     \
          -name '*.tbz2' -o    \
          -name '*.7z' -o      \
          -name '*.iso' -o     \
          -name '*.cpio' -o    \
          -name '*.a' -o       \
          -name '*.ar' \)      \
       -type f  | grep . -c)
echo "Archive files = $arch"

symlink=$(sudo ls -lR $1 | grep ^l -c) #find $1 -type l | wc -l
echo "Symbolic links = $symlink"

topfiles=$(find $1 -xdev -type f -size -100G -print | xargs ls -lh | sort -k5,5 -h -r | head -10 | awk -F '[^[:alpha:]]' '{ print $0,$NF }' | awk '{print $9", "$5", "$10}' | grep -n $1)

echo "TOP 10 files of maximum size arranged in descending order (path, size and type): "
echo "$topfiles"

echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"

if [[ $exe != 0 ]] ; then
    j=$(find $1 -type f -perm /a=x -size -100G | xargs ls -lh | sort -k5,5 -h -r | head -10 | wc -l)
    for ((i=1; i <= 10 && i <= j; i++))
    do
        info_param=$(find $1 -type f -perm /a=x -size -100G | xargs ls -lh | sort -k5,5 -h -r |
                    head -$i | tail -n 1 | awk '{print $9", "$5}')
        hash_param=$(find $1 -type f -perm /a=x -size -100G | xargs ls -lh | sort -k5,5 -h -r |
                    head -$i | tail -n 1 | awk '{print $9}' | xargs md5sum | awk '{print $1}')
        echo "$i - $info_param, $hash_param"
    done
fi

end=`date +%s.%N`

scripexectime=$( echo "$end - $start" | bc -l )
printf "Script execution time (in seconds) = %.1f \n" $scripexectime
