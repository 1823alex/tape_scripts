#!/bin/bash
read -p "Enter tape path: " tapepath
echo $tapepath
#read -p "File Name" $name
#echo $name
echo "THIS SCRIPT ONLY WORKS FOR /dev/st0 or /dev/st1 TAPE DRIVE"


if [[ "$tapepath" == "/dev/st0" ]]; then
    echo "Reading from drive st0"
    mbuffer -i /dev/st0 -s 2M -m 5G -L -p 5 -f -A "echo Insert next tape and press enter; mt-st -f /dev/nst0 eject; read a < /dev/tty" -n 0 | tar -tvpf - | tee st0_out.txt
elif [[ "$tapepath" == "/dev/st1" ]]; then
    echo "Reading from drive st1"
    mbuffer -i /dev/st1 -s 2M -m 5G -L -p 5 -f -A "echo Insert next tape and press enter; mt-st -f /dev/nst0 eject; read a < /dev/tty" -n 0 | tar -tvpf - | tee st1_out.txt
fi
exit


