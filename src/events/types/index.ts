export type EventHandler<T = any> = (event: T) => void;

export type EventBusOptions = { 
    processCurrentEventOnSubscribe?: boolean;
};

export interface EventI {
	handle(): void;
}

export type EventMap = Record<string, EventI>;
