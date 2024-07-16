#!/bin/bash

# Function to center a message in the terminal with custom borders and input prompt
version="1.0"

center_message_input() {
    local message="$1"
    local top_border_char="$2"
    local bottom_border_char="$3"
    local input_prompt="$4"

    # Get the terminal dimensions
    local rows=$(tput lines)
    local cols=$(tput cols)

    # Calculate the number of lines in the message
    local message_lines=$(echo "$message" | wc -l)

    # Calculate the vertical position for the message, considering the number of message lines
    local top_padding=$(( (rows - message_lines) / 2 ))
    local bottom_padding=$(( rows - message_lines - top_padding - 2 ))

    # Clear the screen
    clear

    # Print the top border
    printf '%*s\n' "$cols" '' | tr ' ' "$top_border_char"

    # Print empty lines until reaching the vertical position
    for ((i = 1; i < top_padding; i++)); do
        printf "\n"
    done
    
    # Print the message aligned to the left
    echo -e "$message"

    # Print empty lines until reaching the bottom row
    for ((i = 0; i < bottom_padding; i++)); do
        printf "\n"
    done

    # Print the bottom border
    printf '%*s\n' "$cols" '' | tr ' ' "$bottom_border_char"

    # Read user input with the provided prompt
    read -p "$input_prompt" -r -n 1 choice
    
    export choice
}

center_message_input_manual() {
    local message="$1"
    local top_border_char="$2"
    local bottom_border_char="$3"
    local input_prompt="$4"

    # Get the terminal dimensions
    local rows=$(tput lines)
    local cols=$(tput cols)

    # Calculate the number of lines in the message
    local message_lines=$(echo "$message" | wc -l)

    # Calculate the vertical position for the message, considering the number of message lines
    local top_padding=$(( (rows - message_lines) / 2 ))
    local bottom_padding=$(( rows - message_lines - top_padding - 2 ))

    # Clear the screen
    clear

    # Print the top border
    printf '%*s\n' "$cols" '' | tr ' ' "$top_border_char"

    # Print empty lines until reaching the vertical position
    for ((i = 1; i < top_padding; i++)); do
        printf "\n"
    done
    
    # Print the message aligned to the left
    echo -e "$message"

    # Print empty lines until reaching the bottom row
    for ((i = 0; i < bottom_padding; i++)); do
        printf "\n"
    done

    # Print the bottom border
    printf '%*s\n' "$cols" '' | tr ' ' "$bottom_border_char"

    # Read user input with the provided prompt
    read -p "$input_prompt" -r choice
    
    export choice
}

apps_from_webpage() {

    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

    center_message_input "This will extract app id's from a webiste with links to iOS apps.
    
(e.g. containing https://apps.apple.com/XXX links)

They will then be put them in a list." '#' '#' "Press Any Key To Continue: "

    
    choice="example"
    
    done=0
    
    first=0
    
    while [ "$done" = 0 ]; do
        while [ "$first" = 0 ]; do
            while [[ "$choice" != "1" && "$choice" != "2" ]]; do
                center_message_input "Press 1 to download the html of your chosen webiste.
    
Alternatively press 2 if you have already have the html." '#' '#' "Choice: "

                if [[ "$choice" != "1" && "$choice" != "2" ]]; then
                    center_message_input "Invalid Choice" '#' '#' "Press Any Key To Continue: "
                fi
            done
        
            #choice 1
            if [ "$choice" == "1" ]; then
                center_message_input_manual "Paste the link to the page." '#' '#' "Link to page: "

                curl -o "$SCRIPT_DIR/webpage.html" $choice
        
                if [[ $? -ne 0 ]]; then
                    #failed
                    center_message_input "Failed to download webpage.
            
Check the link and try again or use option 2." '#' '#' "Press Any Key To Continue: "
                else
                    #didnt fail
                    center_message_input "Webpage downloaded successfully and saved to:

$SCRIPT_DIR/webpage.html" '#' '#' "Press Any Key To Continue: "
                    first=1
                fi
            fi
        
            #choice 2
            if [ "$choice" == "2" ]; then
                center_message_input "Place the html file in the same folder as this script
            
($SCRIPT_DIR)

And name it \"webpage.html\"" '#' '#' "Press Any Key Once You Have Done The Above: "
                if [ -e "$SCRIPT_DIR/webpage.html" ]; then
                    first=1
                else
                    center_message_input "File doesn't exist.
                
Make sure the file exists or try option 1." '#' '#' "Press Any Key To Continue: "
                fi
            fi
        done
        #part 2
        
        
        sed_output=$(sed -n 's/.*\/id\([^?]*\)?.*/\1/p' "$SCRIPT_DIR/webpage.html")
    
        if [ -z "$sed_output" ]; then
            center_message_input "No ID's found.
        
Make sure the webpage contains \"https://apps.apple.com/\" links." '#' '#' "Press Any Key To Continue: "
            first=0
        else
            # If sed_output is not empty, write to the temporary file and process it
            echo "$sed_output" >> "$SCRIPT_DIR/appIdsTemp.txt"

            # Remove duplicates using awk and save to the final file
            awk '!seen[$0]++' "$SCRIPT_DIR/appIdsTemp.txt" > "$SCRIPT_DIR/appIds.txt"

            # Remove the temporary file
            rm "$SCRIPT_DIR/appIdsTemp.txt"
            
            center_message_input "App IDs extracted and saved to:
            
\"$SCRIPT_DIR/appIds.txt\"" '#' '#' "Press Any Key To Retrun To The Main Menu: "
            main_menu
            return
        fi
    done
}

main_menu() {
    choice=0
    while [[ "$choice" != "1" && "$choice" != "2" ]]; do

        center_message_input "Insane iOS App Converter, $version by @disfordottie


1. Get app id's from a web page w/ app store links.

2. Convert a list of App ID's to bundle id's.
" '#' '#' "Choice: "
    
        if [[ "$choice" != "1" && "$choice" != "2" ]]; then
            center_message_input "Invalid Choice" '#' '#' "Press Any Key To Continue: "
        fi
    
    done

    if [ "$choice" == "1" ]; then
        apps_from_webpage
    else
        apps_to_bundles
    fi
}

apps_to_bundles() {

    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
        
    center_message_input "Before starting make sure you have a list of app id's
saved to the directory the script is currently in:
            
(\"$SCRIPT_DIR/appIds.txt\")

The file should be in the formt: app id (new line) app id (new line) etc." '#' '#' "Press Any Key Once You Have Done The Above: "

    center_message_input "A good internet connection will speed up this process.
    
This may take a while." '#' '#' "Press Any Key To Continue: "
    
    # Define the input file
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    INFILE=${SCRIPT_DIR}/appIds.txt
    HTML=${SCRIPT_DIR}/temp.txt

    # Read the input file line by line using a for loop
    IFS=$'\n' # set the Internal Field Separator to newline
    for LINE in $(cat "$INFILE")
    do
        echo "$LINE"
    
        urlencode() {
            # Replace all special characters with their URL-encoded equivalents
            local string="$1"
            local encoded=""
            local i
            for ((i=0; i<${#string}; i++)); do
                if [[ "${string:$i:1}" =~ [a-zA-Z0-9\.\_\~\-] ]]; then
                    encoded+="${string:$i:1}"
                else
                    encoded+=$(printf '%%%02X' "'${string:$i:1}")
                fi
            done
            echo "$encoded"
        }

        # Encode the LINE value to ensure it is properly formatted in the URL
        ENCODED_LINE=$(urlencode "$LINE")
    
        url="https://itunes.apple.com/lookup?id=${ENCODED_LINE}&country=us"
        echo "$url"
        output_file=$HTML

        # Download HTML content from the URL and save it to the output file
        curl "$url" -o "$output_file"
    
        # Extract The bundle id
        sed -n 's/.*bundleId":"\([^"]*\)".*/\1/p' $output_file >> $SCRIPT_DIR/bundleIdsTemp.txt
    done

    awk '!seen[$0]++' "${SCRIPT_DIR}/bundleIdsTemp.txt" > "${SCRIPT_DIR}/bundleIds.txt"
    rm ${SCRIPT_DIR}/bundleIdsTemp.txt
    rm ${SCRIPT_DIR}/temp.txt
    
    center_message_input "Converted to bundle id's successfully and saved to:
            
\"$SCRIPT_DIR/bundleIds.txt\"" '#' '#' "Press Any Key To Retrun To The Main Menu: "
    main_menu
    return

}

######################
### actual program ###
######################

main_menu
