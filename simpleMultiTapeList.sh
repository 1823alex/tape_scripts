mbuffer -i /dev/st0 -s 2M -m 5G -L -p 5 -f -A "echo Insert next tape and press enter; mt-st -f /dev/nst0 eject; read a < /dev/tty" -n 0 | tar -tvpf - | tee contents.txt
