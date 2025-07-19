#!/bin/bash

# Autocut Configuration Setup Script
# Uses Gum for interactive terminal UI

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration file path
CONFIG_FILE="config.yml"

# Function to detect if running as brew service
is_brew_service() {
    if [ -n "$HOMEBREW_PREFIX" ] || [ -d "/usr/local/opt/autocut" ] || [ -d "/opt/homebrew/opt/autocut" ]; then
        return 0
    else
        return 1
    fi
}

# Function to get the correct config file path
get_config_path() {
    if is_brew_service; then
        # If installed via brew, use the libexec directory
        if [ -d "/usr/local/opt/autocut" ]; then
            echo "/usr/local/opt/autocut/libexec/config.yml"
        elif [ -d "/opt/homebrew/opt/autocut" ]; then
            echo "/opt/homebrew/opt/autocut/libexec/config.yml"
        else
            echo "config.yml"
        fi
    else
        echo "config.yml"
    fi
}

# Update CONFIG_FILE to use the correct path
CONFIG_FILE=$(get_config_path)

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Autocut Configuration Setup${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Function to check if Gum is installed
check_gum() {
    if ! command -v gum &> /dev/null; then
        print_error "Gum is not installed. Please install it first:"
        echo "Visit: https://github.com/charmbracelet/gum#installation"
        exit 1
    fi
}

# Function to create default config if it doesn't exist
create_default_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        print_status "Creating default configuration file..."
        cat > "$CONFIG_FILE" << EOF
# Autocut Configuration File
# This file defines the cron delay and shortcuts for the autocut application

# Cron delay in cron format (e.g., "*/5 * * * *" for every 5 minutes)

# List of shortcuts to be processed
shortcuts:
  - displayName: "Example Shortcut"
    shortcutName: "ExampleShortcut"
    shortcutInput: {}
    cronDelay: "*/5 * * * *"
    delay: 0
    description: "An example shortcut configuration"
    enabled: true
EOF
        print_status "Default configuration created at $CONFIG_FILE"
    fi
}

# Function to parse YAML and extract shortcuts
parse_shortcuts() {
    # This is a simplified parser - in production you might want to use a proper YAML parser
    local config_content=$(cat "$CONFIG_FILE")
    echo "$config_content"
}

# Function to display current shortcuts
show_shortcuts() {
    print_header
    print_status "Current shortcuts in configuration:"
    echo ""
    
    if [ -f "$CONFIG_FILE" ]; then
        # Extract and display shortcuts in a nice format
        local shortcuts=$(grep -A 6 "displayName:" "$CONFIG_FILE" || true)
        if [ -n "$shortcuts" ]; then
            echo "$shortcuts" | while IFS= read -r line; do
                if [[ $line == *"displayName:"* ]]; then
                    name=$(echo "$line" | sed 's/.*displayName: *"\([^"]*\)".*/\1/')
                    echo "📱 $name"
                elif [[ $line == *"shortcutName:"* ]]; then
                    shortcut=$(echo "$line" | sed 's/.*shortcutName: *"\([^"]*\)".*/\1/')
                    echo "   Shortcut: $shortcut"
                elif [[ $line == *"cronDelay:"* ]]; then
                    cron=$(echo "$line" | sed 's/.*cronDelay: *"\([^"]*\)".*/\1/')
                    echo "   Schedule: $cron"
                elif [[ $line == *"enabled:"* ]]; then
                    enabled=$(echo "$line" | sed 's/.*enabled: *\([^ ]*\).*/\1/')
                    if [ "$enabled" = "true" ]; then
                        echo "   Status: ✅ Enabled"
                    else
                        echo "   Status: ❌ Disabled"
                    fi
                    echo ""
                fi
            done
        else
            print_warning "No shortcuts found in configuration"
        fi
    else
        print_warning "Configuration file not found"
    fi
}

# Function to add a new shortcut
add_shortcut() {
    print_header
    print_status "Adding new shortcut..."
    echo ""
    
    # Get shortcut details using Gum with clear field labels
    print_status "Entering Display Name:"
    local display_name=$(gum input --placeholder "Enter display name (e.g., Update Focus Mode HA)")
    
    echo ""
    print_status "Entering Shortcut Name:"
    local shortcut_name=$(gum input --placeholder "Enter shortcut name (e.g., FocusMode)")
    
    echo ""
    print_status "Entering Description:"
    local description=$(gum input --placeholder "Enter description")
    
    echo ""
    print_status "Entering Cron Delay:"
    local cron_delay=$(gum input --placeholder "Enter cron delay (e.g., */5 * * * *)" --value "*/5 * * * *")
    
    echo ""
    print_status "Entering Delay:"
    local delay=$(gum input --placeholder "Enter delay in seconds" --value "0")
    
    # Ask if shortcut should be enabled
    echo ""
    print_status "Setting Enabled Status:"
    local enabled_choice=$(gum choose "Enabled" "Disabled")
    local enabled="true"
    if [ "$enabled_choice" = "Disabled" ]; then
        enabled="false"
    fi
    
    # Confirm the details
    echo ""
    print_status "Please confirm the shortcut details:"
    echo "Display Name: $display_name"
    echo "Shortcut Name: $shortcut_name"
    echo "Description: $description"
    echo "Cron Delay: $cron_delay"
    echo "Delay: $delay"
    echo "Enabled: $enabled"
    echo ""
    
    if gum confirm "Add this shortcut?"; then
        # Add the shortcut to the config file
        # Find the shortcuts section and add the new shortcut
        local temp_file=$(mktemp)
        local in_shortcuts=false
        local added=false
        
        while IFS= read -r line; do
            echo "$line" >> "$temp_file"
            
            if [[ $line == *"shortcuts:"* ]]; then
                in_shortcuts=true
            elif [[ $in_shortcuts == true && $line == *"- "* && $added == false ]]; then
                # Add new shortcut before the first existing shortcut
                cat >> "$temp_file" << EOF
  - displayName: "$display_name"
    shortcutName: "$shortcut_name"
    shortcutInput: {}
    cronDelay: "$cron_delay"
    delay: $delay
    description: "$description"
    enabled: $enabled
EOF
                added=true
            fi
        done < "$CONFIG_FILE"
        
        # If no shortcuts existed, add the new one
        if [ "$added" = "false" ]; then
            # Find the end of the file and add shortcuts section
            echo "shortcuts:" >> "$temp_file"
            cat >> "$temp_file" << EOF
  - displayName: "$display_name"
    shortcutName: "$shortcut_name"
    shortcutInput: {}
    cronDelay: "$cron_delay"
    delay: $delay
    description: "$description"
    enabled: $enabled
EOF
        fi
        
        mv "$temp_file" "$CONFIG_FILE"
        print_status "Shortcut added successfully!"
    else
        print_warning "Shortcut addition cancelled"
    fi
}

# Function to remove a shortcut
remove_shortcut() {
    print_header
    print_status "Removing shortcut..."
    echo ""
    
    if [ ! -f "$CONFIG_FILE" ]; then
        print_error "Configuration file not found"
        return
    fi
    
    # Extract shortcut names for selection
    local shortcuts=()
    local current_shortcut=""
    
    while IFS= read -r line; do
        if [[ $line == *"displayName:"* ]]; then
            current_shortcut=$(echo "$line" | sed 's/.*displayName: *"\([^"]*\)".*/\1/')
            shortcuts+=("$current_shortcut")
        fi
    done < "$CONFIG_FILE"
    
    if [ ${#shortcuts[@]} -eq 0 ]; then
        print_warning "No shortcuts found to remove"
        return
    fi
    
    # Let user select which shortcut to remove
    local selected=$(gum choose "${shortcuts[@]}")
    
    if [ -n "$selected" ]; then
        if gum confirm "Remove shortcut '$selected'?"; then
            # Remove the selected shortcut
            local temp_file=$(mktemp)
            local in_shortcut=false
            local skip_shortcut=false
            
            while IFS= read -r line; do
                if [[ $line == *"displayName:"* ]]; then
                    local shortcut_name=$(echo "$line" | sed 's/.*displayName: *"\([^"]*\)".*/\1/')
                    if [ "$shortcut_name" = "$selected" ]; then
                        skip_shortcut=true
                        continue
                    fi
                fi
                
                if [ "$skip_shortcut" = "true" ]; then
                    if [[ $line == *"- "* && $line != *"displayName:"* ]]; then
                        # End of current shortcut, stop skipping
                        skip_shortcut=false
                        echo "$line" >> "$temp_file"
                    fi
                    # Skip lines until we find the next shortcut
                    continue
                fi
                
                echo "$line" >> "$temp_file"
            done < "$CONFIG_FILE"
            
            mv "$temp_file" "$CONFIG_FILE"
            print_status "Shortcut '$selected' removed successfully!"
        else
            print_warning "Shortcut removal cancelled"
        fi
    fi
}

# Function to edit a shortcut
edit_shortcut() {
    print_header
    print_status "Editing shortcut..."
    echo ""
    
    if [ ! -f "$CONFIG_FILE" ]; then
        print_error "Configuration file not found"
        return
    fi
    
    # Extract shortcut names for selection
    local shortcuts=()
    local current_shortcut=""
    
    while IFS= read -r line; do
        if [[ $line == *"displayName:"* ]]; then
            current_shortcut=$(echo "$line" | sed 's/.*displayName: *"\([^"]*\)".*/\1/')
            shortcuts+=("$current_shortcut")
        fi
    done < "$CONFIG_FILE"
    
    if [ ${#shortcuts[@]} -eq 0 ]; then
        print_warning "No shortcuts found to edit"
        return
    fi
    
    # Let user select which shortcut to edit
    local selected=$(gum choose "${shortcuts[@]}")
    
    if [ -n "$selected" ]; then
        print_status "Editing shortcut: $selected"
        echo ""
        
        # Extract current values
        local current_values=()
        local in_selected_shortcut=false
        
        while IFS= read -r line; do
            if [[ $line == *"displayName:"* ]]; then
                local shortcut_name=$(echo "$line" | sed 's/.*displayName: *"\([^"]*\)".*/\1/')
                if [ "$shortcut_name" = "$selected" ]; then
                    in_selected_shortcut=true
                else
                    in_selected_shortcut=false
                fi
            fi
            
            if [ "$in_selected_shortcut" = "true" ]; then
                current_values+=("$line")
            fi
        done < "$CONFIG_FILE"
        
        # Extract current values
        local current_display_name=""
        local current_shortcut_name=""
        local current_description=""
        local current_cron_delay=""
        local current_delay=""
        local current_enabled=""
        
        for line in "${current_values[@]}"; do
            if [[ $line == *"displayName:"* ]]; then
                current_display_name=$(echo "$line" | sed 's/.*displayName: *"\([^"]*\)".*/\1/')
            elif [[ $line == *"shortcutName:"* ]]; then
                current_shortcut_name=$(echo "$line" | sed 's/.*shortcutName: *"\([^"]*\)".*/\1/')
            elif [[ $line == *"description:"* ]]; then
                current_description=$(echo "$line" | sed 's/.*description: *"\([^"]*\)".*/\1/')
            elif [[ $line == *"cronDelay:"* ]]; then
                current_cron_delay=$(echo "$line" | sed 's/.*cronDelay: *"\([^"]*\)".*/\1/')
            elif [[ $line == *"delay:"* ]]; then
                current_delay=$(echo "$line" | sed 's/.*delay: *\([^ ]*\).*/\1/')
            elif [[ $line == *"enabled:"* ]]; then
                current_enabled=$(echo "$line" | sed 's/.*enabled: *\([^ ]*\).*/\1/')
            fi
        done
        
        # Get new values using Gum with clear field labels
        echo ""
        print_status "Editing Display Name:"
        local new_display_name=$(gum input --placeholder "Enter display name" --value "$current_display_name")
        
        echo ""
        print_status "Editing Shortcut Name:"
        local new_shortcut_name=$(gum input --placeholder "Enter shortcut name" --value "$current_shortcut_name")
        
        echo ""
        print_status "Editing Description:"
        local new_description=$(gum input --placeholder "Enter description" --value "$current_description")
        
        echo ""
        print_status "Editing Cron Delay:"
        local new_cron_delay=$(gum input --placeholder "Enter cron delay (e.g., */5 * * * *)" --value "$current_cron_delay")
        
        echo ""
        print_status "Editing Delay:"
        local new_delay=$(gum input --placeholder "Enter delay in seconds" --value "$current_delay")
        
        # Ask for enabled status
        echo ""
        print_status "Editing Enabled Status:"
        local enabled_choice
        if [ "$current_enabled" = "true" ]; then
            enabled_choice=$(gum choose "Enabled" "Disabled")
        else
            enabled_choice=$(gum choose "Disabled" "Enabled")
        fi
        
        local new_enabled="true"
        if [ "$enabled_choice" = "Disabled" ]; then
            new_enabled="false"
        fi
        
        # Confirm changes
        echo ""
        print_status "Please confirm the changes:"
        echo "Display Name: $current_display_name → $new_display_name"
        echo "Shortcut Name: $current_shortcut_name → $new_shortcut_name"
        echo "Description: $current_description → $new_description"
        echo "Cron Delay: $current_cron_delay → $new_cron_delay"
        echo "Delay: $current_delay → $new_delay"
        echo "Enabled: $current_enabled → $new_enabled"
        echo ""
        
        if gum confirm "Apply these changes?"; then
            # Update the shortcut in the config file
            local temp_file=$(mktemp)
            local in_selected_shortcut=false
            local skip_shortcut=false
            
            while IFS= read -r line; do
                if [[ $line == *"displayName:"* ]]; then
                    local shortcut_name=$(echo "$line" | sed 's/.*displayName: *"\([^"]*\)".*/\1/')
                    if [ "$shortcut_name" = "$selected" ]; then
                        in_selected_shortcut=true
                        skip_shortcut=true
                        # Write the updated shortcut
                        cat >> "$temp_file" << EOF
  - displayName: "$new_display_name"
    shortcutName: "$new_shortcut_name"
    shortcutInput: {}
    cronDelay: "$new_cron_delay"
    delay: $new_delay
    description: "$new_description"
    enabled: $new_enabled
EOF
                        continue
                    else
                        in_selected_shortcut=false
                        skip_shortcut=false
                    fi
                fi
                
                if [ "$skip_shortcut" = "true" ]; then
                    if [[ $line == *"- "* && $line != *"displayName:"* ]]; then
                        # End of current shortcut, stop skipping
                        skip_shortcut=false
                        echo "$line" >> "$temp_file"
                    fi
                    # Skip lines until we find the next shortcut
                    continue
                fi
                
                echo "$line" >> "$temp_file"
            done < "$CONFIG_FILE"
            
            mv "$temp_file" "$CONFIG_FILE"
            print_status "Shortcut updated successfully!"
        else
            print_warning "Shortcut update cancelled"
        fi
    fi
}

# Function to toggle shortcut enabled/disabled
toggle_shortcut() {
    print_header
    print_status "Toggle shortcut status..."
    echo ""
    
    if [ ! -f "$CONFIG_FILE" ]; then
        print_error "Configuration file not found"
        return
    fi
    
    # Extract shortcut names for selection
    local shortcuts=()
    local current_shortcut=""
    
    while IFS= read -r line; do
        if [[ $line == *"displayName:"* ]]; then
            current_shortcut=$(echo "$line" | sed 's/.*displayName: *"\([^"]*\)".*/\1/')
            shortcuts+=("$current_shortcut")
        fi
    done < "$CONFIG_FILE"
    
    if [ ${#shortcuts[@]} -eq 0 ]; then
        print_warning "No shortcuts found"
        return
    fi
    
    # Let user select which shortcut to toggle
    local selected=$(gum choose "${shortcuts[@]}")
    
    if [ -n "$selected" ]; then
        # Find current enabled status
        local current_enabled=""
        local in_selected_shortcut=false
        
        while IFS= read -r line; do
            if [[ $line == *"displayName:"* ]]; then
                local shortcut_name=$(echo "$line" | sed 's/.*displayName: *"\([^"]*\)".*/\1/')
                if [ "$shortcut_name" = "$selected" ]; then
                    in_selected_shortcut=true
                else
                    in_selected_shortcut=false
                fi
            fi
            
            if [ "$in_selected_shortcut" = "true" ] && [[ $line == *"enabled:"* ]]; then
                current_enabled=$(echo "$line" | sed 's/.*enabled: *\([^ ]*\).*/\1/')
                break
            fi
        done < "$CONFIG_FILE"
        
        local new_enabled="true"
        if [ "$current_enabled" = "true" ]; then
            new_enabled="false"
            print_status "Disabling shortcut: $selected"
        else
            new_enabled="true"
            print_status "Enabling shortcut: $selected"
        fi
        
        # Update the enabled status
        local temp_file=$(mktemp)
        local in_selected_shortcut=false
        
        while IFS= read -r line; do
            if [[ $line == *"displayName:"* ]]; then
                local shortcut_name=$(echo "$line" | sed 's/.*displayName: *"\([^"]*\)".*/\1/')
                if [ "$shortcut_name" = "$selected" ]; then
                    in_selected_shortcut=true
                else
                    in_selected_shortcut=false
                fi
            fi
            
            if [ "$in_selected_shortcut" = "true" ] && [[ $line == *"enabled:"* ]]; then
                echo "    enabled: $new_enabled" >> "$temp_file"
            else
                echo "$line" >> "$temp_file"
            fi
        done < "$CONFIG_FILE"
        
        mv "$temp_file" "$CONFIG_FILE"
        print_status "Shortcut status updated successfully!"
    fi
}

# Function to validate cron expression
validate_cron() {
    local cron_expr="$1"
    # Basic cron validation - you might want to add more sophisticated validation
    if [[ $cron_expr =~ ^(\*|[0-9]+)(/\*|[0-9]+)?\s+(\*|[0-9]+)(/\*|[0-9]+)?\s+(\*|[0-9]+)(/\*|[0-9]+)?\s+(\*|[0-9]+)(/\*|[0-9]+)?\s+(\*|[0-9]+)(/\*|[0-9]+)?$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to show cron help
show_cron_help() {
    print_header
    print_status "Cron Expression Help"
    echo ""
    echo "Cron expressions have 5 fields: minute hour day month weekday"
    echo ""
    echo "Examples:"
    echo "  */5 * * * *     - Every 5 minutes"
    echo "  0 */2 * * *     - Every 2 hours"
    echo "  0 9 * * 1-5     - Every weekday at 9 AM"
    echo "  0 0 1 * *       - First day of every month at midnight"
    echo "  30 14 * * *     - Every day at 2:30 PM"
    echo ""
    echo "Field values:"
    echo "  minute: 0-59"
    echo "  hour: 0-23"
    echo "  day: 1-31"
    echo "  month: 1-12"
    echo "  weekday: 0-7 (0 and 7 are Sunday)"
    echo ""
    echo "Special characters:"
    echo "  * = any value"
    echo "  / = step values (e.g., */5 = every 5th value)"
    echo "  - = range (e.g., 1-5 = 1,2,3,4,5)"
    echo "  , = list (e.g., 1,3,5 = 1,3,5)"
    echo ""
}

# Function to manage brew service
manage_service() {
    print_header
    print_status "Service Management"
    echo ""
    
    if ! is_brew_service; then
        print_warning "This appears to be a development installation."
        print_status "To use brew services, install via: brew install ./Formula/autocut.rb"
        return
    fi
    
    local choice=$(gum choose \
        "Start service" \
        "Stop service" \
        "Restart service" \
        "Check service status" \
        "View service logs" \
        "Back to main menu")
    
    case $choice in
        "Start service")
            print_status "Starting autocut service..."
            brew services start autocut
            ;;
        "Stop service")
            print_status "Stopping autocut service..."
            brew services stop autocut
            ;;
        "Restart service")
            print_status "Restarting autocut service..."
            brew services restart autocut
            ;;
        "Check service status")
            print_status "Service status:"
            brew services list | grep autocut
            ;;
        "View service logs")
            print_status "Recent service logs:"
            if [ -f "/usr/local/var/log/autocut.log" ]; then
                tail -20 "/usr/local/var/log/autocut.log"
            elif [ -f "/opt/homebrew/var/log/autocut.log" ]; then
                tail -20 "/opt/homebrew/var/log/autocut.log"
            else
                print_warning "No log file found"
            fi
            ;;
        "Back to main menu")
            return
            ;;
    esac
    
    echo ""
    gum confirm "Continue with service management" || true
}

# Main menu function
main_menu() {
    while true; do
        print_header
        print_status "What would you like to do?"
        echo ""
        
        local choice=$(gum choose \
            "View current shortcuts" \
            "Add new shortcut" \
            "Edit existing shortcut" \
            "Remove shortcut" \
            "Toggle shortcut status" \
            "Cron expression help" \
            "Service management" \
            "Exit")
        
        case $choice in
            "View current shortcuts")
                show_shortcuts
                echo ""
                gum confirm "Go back to main menu" || true
                ;;
            "Add new shortcut")
                add_shortcut
                echo ""
                gum confirm "Go back to main menu" || true
                ;;
            "Edit existing shortcut")
                edit_shortcut
                echo ""
                gum confirm "Go back to main menu" || true
                ;;
            "Remove shortcut")
                remove_shortcut
                echo ""
                gum confirm "Go back to main menu" || true
                ;;
            "Toggle shortcut status")
                toggle_shortcut
                echo ""
                gum confirm "Go back to main menu" || true
                ;;
            "Cron expression help")
                show_cron_help
                echo ""
                gum confirm "Go back to main menu" || true
                ;;
            "Service management")
                manage_service
                ;;
            "Exit")
                print_status "Goodbye!"
                exit 0
                ;;
        esac
    done
}

# Main execution
main() {
    check_gum
    create_default_config
    main_menu
}

# Run main function
main "$@" 