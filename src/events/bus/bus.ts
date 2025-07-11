import { deafultEventBusOptions } from "src/events/bus"
import { SubscriptionI, Subscription } from "src/events/consumer"
import { generateKey } from "src/events/service"
import { EventHandler, EventBusOptions, EventI } from "src/events/types";


export interface EventBusI {
    send(event: EventI): void;
    subscribe<T extends EventI>(handler: EventHandler<T>): SubscriptionI;
    unsubscribe(key: string): void;
}

export class EventBus implements EventBusI {
    private handlers: Map<string, EventHandler> = new Map();
    private options: EventBusOptions;

    constructor(options: EventBusOptions = deafultEventBusOptions) {
        this.options = options;
    }

    send(event: EventI): void {
        this.handlers.forEach((handler) => {
            try {
                handler(event);
            } catch (error) {
                console.error('Error in event handler:', error);
            }
        });
    }

    subscribe<T extends EventI>(handler: EventHandler<T>): SubscriptionI {
        const key = generateKey();

        if (this.options.processCurrentEventOnSubscribe) {
            this.handlers.set(key, handler as EventHandler);
        } else {
            // Use queueMicrotask instead of setTimeout for better performance
            queueMicrotask(() => this.handlers.set(key, handler as EventHandler));
        }

        return new Subscription(this, key);
    }

    unsubscribe(key: string): void {
        if (!this.handlers.has(key)) {
            console.warn(`Attempted to unsubscribe with invalid key: ${key}`);
            return;
        }
        this.handlers.delete(key);
    }
}
