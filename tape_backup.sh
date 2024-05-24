#!/bin/bash

# Function to handle tape changes
handle_tape_change() {
  # Eject the current tape and move it to an empty slot
  mtx -f /dev/sg0 unload 1
  # Assuming the barcode of the tapes follows a sequential pattern
  next_barcode=$((barcode+1))
  # Load the next tape with the matching barcode
  mtx -f /dev/sg0 load "$next_barcode" 1
}

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

# Initialize barcode for tape handling
barcode=1

# Create multi-volume tar archive
echo "Creating multi-volume tape archive..."
tar -M -c -v -f /dev/st0 -L 1024 -b 20 --label="$tape_label" "$directory" | \
while IFS= read -r line; do
  # Check if the output line indicates a tape change request
  if [[ "$line" == *"Please insert volume"* ]]; then
    echo "Tape change requested..."
    handle_tape_change
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
