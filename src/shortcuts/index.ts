import { EventBus } from "src/events/bus"
import {ShortcutManager} from "src/shortcuts/shortcutManager";
import { handleShortcutTriggerEvent, handleShortcutScheduleEvent } from "src/shortcuts/shortcutHandler";

export * from "./shortcutTriggerEvent";
export * from "./shortcutScheduleEvent";

export const shortcutBus = new EventBus();
export const shortcutManager = new ShortcutManager();

shortcutBus.subscribe(handleShortcutTriggerEvent);
shortcutBus.subscribe(handleShortcutScheduleEvent);

