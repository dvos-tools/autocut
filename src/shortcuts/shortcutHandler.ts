import { ShortcutTriggerEvent } from "src/shortcuts/shortcutTriggerEvent";
import { ShortcutScheduleEvent } from "src/shortcuts";

export function handleShortcutTriggerEvent(event: ShortcutTriggerEvent): void {
	console.log(`Shortcut triggered: ${event.shortcutName}`);
	event.handle()
}

export function handleShortcutScheduleEvent(event: ShortcutScheduleEvent): void {
	console.log(`Shortcut triggered: ${event.shortcutName}`);
	event.handle()
}

