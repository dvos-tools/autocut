"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ShortcutTriggerEvent = void 0;
class ShortcutTriggerEvent {
    shortcutName;
    constructor(shortcutName) {
        this.shortcutName = shortcutName;
    }
    handle() {
        console.log("the event: " + this.shortcutName + " has been triggered.");
    }
}
exports.ShortcutTriggerEvent = ShortcutTriggerEvent;
//# sourceMappingURL=shortcutTriggerEvent.js.map