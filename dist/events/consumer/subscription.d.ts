import { EventBusI } from "src/events/bus";
export interface SubscriptionI {
    unsubscribe(): void;
}
export declare class Subscription implements SubscriptionI {
    private key;
    private eventBus;
    constructor(eventBus: EventBusI, key: string);
    unsubscribe(): void;
}
//# sourceMappingURL=subscription.d.ts.map