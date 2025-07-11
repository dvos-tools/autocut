import { ShortcutTriggerEvent } from "src/shortcuts/shortcutTriggerEvent";
import { ShortcutScheduleEvent, shortcutBus } from "src/shortcuts";


shortcutBus.subscribe(handleShortcutTriggerEvent);
shortcutBus.subscribe(handleShortcutScheduleEvent);

function handleShortcutTriggerEvent(event: ShortcutTriggerEvent): void {
	console.log(`Shortcut triggered: ${event.shortcutName}`);
	event.handle()
}

function handleShortcutScheduleEvent(event: ShortcutScheduleEvent): void {
	console.log(`Shortcut triggered: ${event.shortcutName}`);
	event.handle()
}

