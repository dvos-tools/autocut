import { EventI } from "src/events/types"

export class ShortcutScheduleEvent implements EventI{
	public shortcutName: string;
	// This should turn into a cron class but for now its just a number
	public cronDefinition: number;

	constructor(
		shortcutName: string,
		cronDefinition: number
	) {
		this.shortcutName = shortcutName
		this.cronDefinition = cronDefinition
	} 

	async handle() {
		console.log("the event: " + this.shortcutName + " has been triggered.")
	}
}

