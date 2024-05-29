#!/bin/bash
read -p "Enter tape path (st0/st1): " tapepath
echo $tapepath
# Prompt user for directory
read -p "Enter the directory path to archive: " directory
echo $directory
# Check if directory exists
if [ ! -d "$directory" ]; then
  echo "Error: Directory not found."
  exit 1
fi

# Prompt user for tape label
read -p "Enter tape label: " tape_label



# Create multi-volume tar archive
echo "Creating multi-volume tape archive..."
tar -b 4096 --directory="$directory" --multi-volume --label="$tape_label" -cf - ./ | mbuffer -m 6G -L -P 80 -f -o $tapepath
#tar clpMvf - $directory -V $tape_label | mbuffer -m 4g -L -P 80 > /dev/st0 
#tar -M -c -v -f /dev/st0 -L 1024 -b 20 --label="$tape_label" "$directory" | \
while IFS= read -r line; do
  # Check if the output line indicates a tape change request
  if [[ "$line" == *"Please insert volume"* ]]; then
    echo "Tape change requested..."
  fi
  echo "$line"
done

# Check if tar command was successful
if [ $? -eq 0 ]; then
  echo "Multi-volume tape archive creation successful."
else
  echo "Error: Failed to create multi-volume tape archive."
  exit 1
fi

exit 0
