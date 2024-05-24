#!/bin/bash
mtx -f /dev/sg3 status
# Initialize an empty array to store the status of each tape element
declare -a tape_status

# Parse the output and store the text after "VolumeTag" for each element in the array
while IFS= read -r line; do
    # Check if the line contains "Storage Element"
    if [[ $line =~ Storage\ Element\ ([0-9]+):(.*)VolumeTag=(.*) ]]; then
        element="${BASH_REMATCH[1]}"
        volume_tag="${BASH_REMATCH[3]}"
        tape_status[$element]=$volume_tag
        echo $element
        echo $volume_tag
        echo $tape_status
    fi
done <<< "$(grep 'Storage Element' /home/alex/Documents/out.txt)"

# Print the status of each tape element
for index in "${!tape_status[@]}"; do
    echo "Element $index: ${tape_status[$index]}"
done

