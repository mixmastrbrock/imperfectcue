#!/bin/bash

# The path to the original .sub file
original_file="template.sub"

# Verify that the file exists and is readable
if [ ! -f "$original_file" ]; then
    echo "Error: File does not exist or the path is incorrect."
    exit 1
elif [ ! -r "$original_file" ]; then
    echo "Error: File is not readable."
    exit 1
fi

# Subdirectory for the output files
output_dir="./fwd"

# Check if the output directory exists, if not, create it
[ -d "$output_dir" ] || mkdir "$output_dir"

# File to store the list of outputted filenames
output_list="${output_dir}/output_filenames.txt"

# Clear the output list file if it exists, or create it if it doesn't
> "$output_list"

# Loop through all hexadecimal values for the two middle characters
for i in {0..15}; do
    for j in {0..15}; do
        # Convert numbers to hexadecimal
        hex1=$(printf "%X" $i)
        hex2=$(printf "%X" $j)

        # Construct the new key with exact spacing and character count
        new_key="Key: 00 00 00 00 00 00 0${hex1} ${hex2}B"

        # Create a new file name without the "0" and "B"
        new_file="${hex1}${hex2}-FWD.sub"

        # Use awk to replace the key and save to new file
        awk -v newkey="$new_key" '{if ($1 == "Key:") print newkey; else print $0}' "$original_file" > "${output_dir}/${new_file}"

        # Append the new file path to the list
        echo "sub: /ext/subghz/PerfectCue/${hex1}${hex2}-FWD.sub" >> "$output_list"
    done
done
