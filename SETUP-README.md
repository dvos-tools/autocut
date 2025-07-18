# Autocut Configuration Setup

This project includes an interactive terminal-based configuration setup script that uses [Gum](https://github.com/charmbracelet/gum) to provide a beautiful and user-friendly interface for managing your `config.yml` file.

## Prerequisites

Before using the setup script, you need to install Gum:

### macOS
```bash
# Using Homebrew
brew install charmbracelet/tap/gum

# Using MacPorts
sudo port install gum
```

### Linux
```bash
# Using the install script
curl -fsSL https://raw.githubusercontent.com/charmbracelet/gum/main/scripts/install.sh | sh

# Using apt (Ubuntu/Debian)
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install gum
```

### Windows
```bash
# Using Chocolatey
choco install gum

# Using Scoop
scoop install gum
```

For more installation options, visit: https://github.com/charmbracelet/gum#installation

## Usage

Run the setup script from your project root:

```bash
./setup-config.sh
```

## Features

The setup script provides the following interactive features:

### 1. View Current Shortcuts
- Displays all configured shortcuts in a readable format
- Shows display name, shortcut name, cron schedule, and enabled status
- Uses emojis and colors for better visual feedback

### 2. Add New Shortcut
- Interactive form to input all shortcut details:
  - Display Name (e.g., "Update Focus Mode HA")
  - Shortcut Name (e.g., "FocusMode")
  - Description
  - Cron Delay (e.g., "*/5 * * * *")
  - Delay in seconds
  - Enabled/Disabled status
- Confirmation before adding to configuration

### 3. Edit Existing Shortcut
- Select from existing shortcuts to edit
- Pre-fills current values for easy modification
- Confirms changes before applying

### 4. Remove Shortcut
- Select from existing shortcuts to remove
- Confirmation dialog before deletion

### 5. Toggle Shortcut Status
- Quickly enable/disable shortcuts without editing all fields
- Visual feedback showing current status

### 6. Cron Expression Help
- Comprehensive guide to cron expressions
- Examples for common scheduling patterns
- Field descriptions and special characters

## Configuration File Format

The script manages a `config.yml` file with the following structure:

```yaml
# Autocut Configuration File
# This file defines the cron delay and shortcuts for the autocut application

# List of shortcuts to be processed
shortcuts:
  - displayName: "Update Focus Mode HA"
    shortcutName: "FocusMode"
    shortcutInput: {}
    cronDelay: "*/1 * * * *"
    delay: 0
    description: "Gets the current active status by name and syncs it to HA"
    enabled: true
```

## Cron Expression Examples

Common cron patterns you can use:

| Pattern | Description |
|---------|-------------|
| `*/5 * * * *` | Every 5 minutes |
| `0 */2 * * *` | Every 2 hours |
| `0 9 * * 1-5` | Every weekday at 9 AM |
| `0 0 1 * *` | First day of every month at midnight |
| `30 14 * * *` | Every day at 2:30 PM |
| `0 8 * * 0` | Every Sunday at 8 AM |

## Error Handling

The script includes comprehensive error handling:

- Checks if Gum is installed before running
- Validates configuration file existence
- Provides clear error messages with colored output
- Graceful handling of empty configurations
- Confirmation dialogs for destructive operations

## Integration with Your Project

The setup script is designed to work seamlessly with your existing autocut project:

1. **No Dependencies**: Uses only Gum and standard shell commands
2. **Safe Operations**: Creates backups and validates changes
3. **Consistent Format**: Maintains the exact YAML structure your application expects
4. **Non-Destructive**: Won't overwrite existing configurations without confirmation

## Troubleshooting

### Gum Not Found
If you get an error that Gum is not installed:
```bash
# Check if gum is in your PATH
which gum

# If not found, install it using the methods above
```

### Permission Denied
If you get a permission error:
```bash
# Make the script executable
chmod +x setup-config.sh
```

### Configuration File Issues
If the configuration file becomes corrupted:
```bash
# The script will create a new default configuration
# Or you can manually restore from backup
```

## Contributing

To extend the setup script:

1. Add new functions for additional configuration options
2. Update the main menu to include new choices
3. Follow the existing pattern for error handling and user feedback
4. Test with various configuration scenarios

The script is designed to be modular and easy to extend with new features. 