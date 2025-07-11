"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.EventBus = void 0;
const bus_1 = require("src/events/bus");
const consumer_1 = require("src/events/consumer");
const service_1 = require("src/events/service");
class EventBus {
    handlers = new Map();
    options;
    constructor(options = bus_1.deafultEventBusOptions) {
        this.options = options;
    }
    send(event) {
        this.handlers.forEach((handler) => {
            try {
                handler(event);
            }
            catch (error) {
                console.error('Error in event handler:', error);
            }
        });
    }
    subscribe(handler) {
        const key = (0, service_1.generateKey)();
        if (this.options.processCurrentEventOnSubscribe) {
            this.handlers.set(key, handler);
        }
        else {
            // Use queueMicrotask instead of setTimeout for better performance
            queueMicrotask(() => this.handlers.set(key, handler));
        }
        return new consumer_1.Subscription(this, key);
    }
    unsubscribe(key) {
        if (!this.handlers.has(key)) {
            console.warn(`Attempted to unsubscribe with invalid key: ${key}`);
            return;
        }
        this.handlers.delete(key);
    }
}
exports.EventBus = EventBus;
//# sourceMappingURL=bus.js.map