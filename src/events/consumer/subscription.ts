import { EventBusI } from "src/events/bus"

export interface SubscriptionI {
    unsubscribe(): void;
}

export class Subscription implements SubscriptionI {
    private key: string;
    private eventBus: EventBusI;

    constructor(eventBus: EventBusI, key: string) {
        this.eventBus = eventBus;
        this.key = key;
    }

    unsubscribe() {
        this.eventBus.unsubscribe(this.key);
    }
}
