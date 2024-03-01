#!/bin/bash

# Check if file name is provided
if [ -z "$1" ]
then
    echo "No file name provided. Usage: ./script.sh filename"
    exit 1
fi

# Check if file exists
if [ ! -f "$1" ]
then
    echo "File not found!"
    exit 1
fi

# Convert image to hex and display with spaces between every two hex digits
hex_output=$(xxd -p "$1" | sed 's/\(..\)/\1 /g')

# Display only the 9 bytes (18 digits) after "ff c0"
hex_line=$(echo "$hex_output" | grep -o "ff c0.*" | cut -d ' ' -f 1-9)
echo "Original hex line: $hex_line"

# Extract the image height and width in hex and convert them to decimal
image_height_hex=$(echo "$hex_line" | cut -d ' ' -f 6-7 | tr -d ' ')
image_width_hex=$(echo "$hex_line" | cut -d ' ' -f 8-9 | tr -d ' ')
echo "Original image height in decimal: $((16#$image_height_hex))"
echo "Original image width in decimal: $((16#$image_width_hex))"

# Prompt the user for new image height and width in decimal
read -p "Enter the new image height in decimal: " new_image_height
read -p "Enter the new image width in decimal: " new_image_width

# Convert the new image height and width to hex
new_image_height_hex=$(printf "%04x" "$new_image_height")
new_image_width_hex=$(printf "%04x" "$new_image_width")

# Replace the image height and width in the hex line
new_hex_line=$(echo "$hex_line" | cut -d ' ' -f 1-5)
new_hex_line="$new_hex_line ${new_image_height_hex:0:2} ${new_image_height_hex:2:2} ${new_image_width_hex:0:2} ${new_image_width_hex:2:2} $(echo "$hex_line" | cut -d ' ' -f 10)"
echo "Modified hex line: $new_hex_line"

# Replace the original hex line with the modified hex line in the original hex output
modified_hex_output=$(echo "$hex_output" | sed "s/$hex_line/$new_hex_line/")
echo "$modified_hex_output"

# Remove spaces from the modified hex output
modified_hex_output=$(echo "$modified_hex_output" | tr -d ' ')

# Convert the modified hex output back to binary and create a new image file
echo "$modified_hex_output" | xxd -r -p > modified_image.jpg
echo "A new image file 'modified_image.jpg' has been created."