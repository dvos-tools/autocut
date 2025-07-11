#!/usr/bin/env node

import { EventBus } from "src/events/bus";
import { ShortcutTriggerEvent } from "src/shortcuts/shortcutTriggerEvent";

const shortcutBus = new EventBus();

function main(): void {
	shortcutBus.subscribe(handleShortcutTriggerEvent);
	triggerShortcut("MyAmazingShortcut");
}

function handleShortcutTriggerEvent(event: ShortcutTriggerEvent): void {
	console.log(`Shortcut triggered: ${event.shortcutName}`);
	event.handle()
}

function triggerShortcut(shortcutName: string): void {
	console.log(`Triggering shortcut: ${shortcutName}`);
	const shortcutEvent = new ShortcutTriggerEvent(shortcutName);
	shortcutBus.send(shortcutEvent);
}

main(); 
