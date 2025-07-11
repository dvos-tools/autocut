import { EventBusOptions } from "src/events/types"

export const deafultEventBusOptions: EventBusOptions = {
    processCurrentEventOnSubscribe: false
}

export * from "./bus"
