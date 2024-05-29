#!/bin/bash
echo "This script restores data from tape path specified to the directory from which the script is stored. MUST RUN AS SUDO or HAVE TAPE R/W PERMS!"

read -p "Enter tape path (st0/st1): " tapepath
echo $tapepath


mbuffer -i $tapepath -s 2M -m 5G -L -p 5 -f -A "echo Insert next tape and press enter; mt-st -f $tapepath eject; read a < /dev/tty" -n 0 | tar -xvpf -
