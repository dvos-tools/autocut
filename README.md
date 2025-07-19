# Autocut

A TypeScript-based background service that runs scheduled shortcuts and tasks using cron scheduling. Installable via Homebrew as a macOS service.

## Quick Install

```bash
# Install from Homebrew tap (recommended)
brew install dvos-tools/autocut/autocut

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

## Configuration

The interactive setup tool (`autocut-setup`) guides you through:
- Adding shortcuts with custom schedules
- Setting cron expressions
- Enabling/disabling shortcuts
- Service management

## Service Management

```bash
# Start/Stop/Restart
brew services start autocut
brew services stop autocut
brew services restart autocut

# Check status
brew services list | grep autocut
```

## Uninstall

```bash
brew uninstall autocut
```

## Troubleshooting

- **Service won't start**: Check logs with `tail -f /usr/local/var/log/autocut.error.log`
- **Configuration issues**: Run `autocut-setup` to reconfigure


## Dependencies

- Node.js 22+
- Gum (for interactive UI)
- node-cron, js-yaml, uuid
