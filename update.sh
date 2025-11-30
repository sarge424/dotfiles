# Check if links.txt exists
if [ ! -f links.txt ]; then
    echo "links.txt file not found!"
    exit 1
fi

# Delete all subdirectories in the current directory
for dir in */; do
    if [ -d "$dir" ]; then
        rm -rf "$dir"
        echo "Deleted directory $dir"
    fi
done

# Read each line in links.txt (including the last line even if it doesn't end with a newline)
while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip lines that are empty or have only whitespace
    folder=$(echo "$line" | awk '{print $1}')
    destination=$(echo "$line" | awk '{print $2}')
    
    if [[ -z "$folder" || -z "$destination" ]]; then
        continue
    fi
    
    # Trim whitespace from the folder name and destination path
    folder=$(echo "$folder" | xargs)
    destination=$(echo "$destination" | xargs)

    # Expand ~ to the full home directory path
    destination=$(eval echo "$destination")

    # Check if the source folder exists
    if [ ! -d "$destination" ]; then
        echo "Source directory $destination does not exist. Skipping..."
        continue
    fi
    
    # Create the target directory in the current directory
    mkdir -p "./$folder"
    
    # Copy the contents of the source folder into the target folder
    cp -r "$destination/"* "./$folder/"
    
    echo "Copied contents of $destination to ./$folder"
done < links.txt
