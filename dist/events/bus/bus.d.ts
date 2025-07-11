import { SubscriptionI } from "src/events/consumer";
import { EventHandler, EventBusOptions, EventI } from "src/events/types";
export interface EventBusI {
    send(event: EventI): void;
    subscribe<T extends EventI>(handler: EventHandler<T>): SubscriptionI;
    unsubscribe(key: string): void;
}
export declare class EventBus implements EventBusI {
    private handlers;
    private options;
    constructor(options?: EventBusOptions);
    send(event: EventI): void;
    subscribe<T extends EventI>(handler: EventHandler<T>): SubscriptionI;
    unsubscribe(key: string): void;
}
//# sourceMappingURL=bus.d.ts.map