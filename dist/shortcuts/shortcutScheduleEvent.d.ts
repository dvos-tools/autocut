import { EventI } from "src/events/types";
export declare class ShortcutScheduleEvent implements EventI {
    shortcutName: string;
    cronDefinition: number;
    constructor(shortcutName: string, cronDefinition: number);
    handle(): void;
}
//# sourceMappingURL=shortcutScheduleEvent.d.ts.map