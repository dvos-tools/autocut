export interface EventBusI<T> {
    fire(event: T, payload?: any): void;
    unsubscribe(key: string): void;
}
//# sourceMappingURL=busInterfaces.d.ts.map