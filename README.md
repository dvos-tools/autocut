# Autocut

A TypeScript-based automation tool that runs scheduled shortcuts and tasks in the background. Autocut uses cron scheduling to execute custom shortcuts at specified intervals.

## Features

- **Background Processing**: Runs as a persistent background service
- **Cron Scheduling**: Execute shortcuts on custom schedules using cron expressions
- **Error Recovery**: Built-in error handling with automatic restart capabilities
- **Configurable**: Easy YAML-based configuration
- **Event-Driven**: Uses an event bus system for clean architecture

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd autocut
```

2. Install dependencies:
```bash
npm install
```

3. Build the project:
```bash
npm run build
```

## Usage

### Start the application:
```bash
npm start
```

### Development mode:
```bash
npm run dev
```

## Configuration

Configure your shortcuts in `config.yml`:

```yaml
# Autocut Configuration File
shortcuts:
  - displayName: "Update Focus Mode HA"
    shortcutName: "FocusMode"
    shortcutInput: {}
    cronDelay: "*/1 * * * *"  # Every minute
    delay: 0
    description: "Gets the current active status by name and syncs it to HA"
    enabled: true
```

### Configuration Options

- `displayName`: Human-readable name for the shortcut
- `shortcutName`: Internal identifier for the shortcut
- `shortcutInput`: Input parameters for the shortcut (JSON object)
- `cronDelay`: Cron expression for scheduling (e.g., "*/5 * * * *" for every 5 minutes)
- `delay`: Additional delay in milliseconds before execution
- `description`: Description of what the shortcut does
- `enabled`: Whether the shortcut is active (true/false)

## Development


### Available Scripts

- `npm run build`: Build the TypeScript project
- `npm start`: Run the built application
- `npm run dev`: Run in development mode with hot reload

## Dependencies

- **node-cron**: Cron job scheduling
- **js-yaml**: YAML configuration parsing
- **uuid**: Unique identifier generation
