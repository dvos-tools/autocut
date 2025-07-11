"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Subscription = void 0;
class Subscription {
    key;
    eventBus;
    constructor(eventBus, key) {
        this.eventBus = eventBus;
        this.key = key;
    }
    unsubscribe() {
        this.eventBus.unsubscribe(this.key);
    }
}
exports.Subscription = Subscription;
//# sourceMappingURL=subscription.js.map