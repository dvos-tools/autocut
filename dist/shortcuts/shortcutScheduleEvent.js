"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ShortcutScheduleEvent = void 0;
class ShortcutScheduleEvent {
    shortcutName;
    // This should turn into a cron class but for now its just a number
    cronDefinition;
    constructor(shortcutName, cronDefinition) {
        this.shortcutName = shortcutName;
        this.cronDefinition = cronDefinition;
    }
    handle() {
        console.log("the event: " + this.shortcutName + " has been triggered.");
    }
}
exports.ShortcutScheduleEvent = ShortcutScheduleEvent;
//# sourceMappingURL=shortcutScheduleEvent.js.map