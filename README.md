# Autocut

A TypeScript-based background service that runs scheduled shortcuts and tasks using cron scheduling. Installable via Homebrew as a macOS service.

## Quick Install

```bash
# Install from Homebrew tap (recommended)
brew tap dvos-tools/autocut
brew install autocut
brew services start autocut

# Or install locally
./install.sh
```

## What it does

- Runs shortcuts on custom schedules using cron expressions
- Background service with automatic error recovery
- Interactive configuration via terminal UI
- Event-driven architecture with logging

## Installation Options

### 1. Homebrew Tap (Recommended)
```bash
brew tap dvos-tools/autocut
brew install autocut
```

### 2. Local Installation
```bash
./install.sh
```

### 3. Development
```bash
npm install
npm run build
npm start
```

## Usage

### Start the Service
```bash
brew services start autocut
```

### Configure Shortcuts
```bash
autocut-setup
```

### Check Status
```bash
brew services list | grep autocut
```

### View Logs
```bash
tail -f /usr/local/var/log/autocut.log
```

## Configuration

The interactive setup tool (`autocut-setup`) guides you through:
- Adding shortcuts with custom schedules
- Setting cron expressions
- Enabling/disabling shortcuts
- Service management

Example configuration:
```yaml
shortcuts:
  - displayName: "Update Focus Mode"
    shortcutName: "FocusMode"
    cronDelay: "*/5 * * * *"  # Every 5 minutes
    enabled: true
```

## Service Management

```bash
# Start/Stop/Restart
brew services start autocut
brew services stop autocut
brew services restart autocut

# Check status
brew services list | grep autocut

# View logs
tail -f /usr/local/var/log/autocut.log
tail -f /usr/local/var/log/autocut.error.log
```

## Development

### Setup Homebrew Tap
```bash
./setup-tap.sh
```

### Available Scripts
```bash
npm run build          # Build for production
npm run dev            # Development mode
npm start              # Run built app
npm run service:start  # Start brew service
```

### Test Installation
```bash
./test-installation.sh
```

## Uninstall

```bash
./uninstall.sh
```

## Troubleshooting

- **Service won't start**: Check logs with `tail -f /usr/local/var/log/autocut.error.log`
- **Configuration issues**: Run `autocut-setup` to reconfigure
- **Installation problems**: Run `./test-installation.sh` to diagnose

## Architecture

- **Background Agent**: Main process with error recovery
- **Shortcut Manager**: Handles scheduled task execution
- **Event Bus**: Inter-component communication
- **Configuration Service**: YAML-based config management

## Dependencies

- Node.js 18+
- Gum (for interactive UI)
- node-cron, js-yaml, uuid
