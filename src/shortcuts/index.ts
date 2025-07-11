import { EventBus } from "src/events/bus"
export enum ShortcutEvent { Trigger, Schedule };

export * from "./shortcutTriggerEvent";
export * from "./shortcutScheduleEvent";

export const shortcutBus = new EventBus();

