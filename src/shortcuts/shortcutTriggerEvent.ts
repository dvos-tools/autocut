import { EventI } from "src/events/types"

export class ShortcutTriggerEvent implements EventI {
	public shortcutName: string;

	constructor(shortcutName: string) {
		this.shortcutName = shortcutName;
	}

	async handle() {
		console.log("The event: " + this.shortcutName + " has been triggered.")
	}
}
