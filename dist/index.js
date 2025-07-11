#!/usr/bin/env node
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const bus_1 = require("src/events/bus");
const shortcutTriggerEvent_1 = require("src/shortcuts/shortcutTriggerEvent");
const shortcutBus = new bus_1.EventBus();
function main() {
    console.log("Setting up event bus...");
    shortcutBus.subscribe(handleShortcutTriggerEvent);
    console.log("Event handler subscribed successfully");
    triggerShortcut("MyAmazingShortcut");
}
function handleShortcutTriggerEvent(event) {
    console.log(`Shortcut triggered: ${event.shortcutName}`);
    event.handle();
}
function triggerShortcut(shortcutName) {
    console.log(`Triggering shortcut: ${shortcutName}`);
    const shortcutEvent = new shortcutTriggerEvent_1.ShortcutTriggerEvent(shortcutName);
    shortcutBus.send(shortcutEvent);
}
main();
//# sourceMappingURL=index.js.map