import { EventI } from "src/events/types"
import {runAppleScript} from "src/shortcuts/util";

export class ShortcutTriggerEvent implements EventI {
	public shortcutName: string;
	public shortcutInput?: string;

	constructor(
		shortcutName: string,
		shortcutInput?: string,
	) {
		this.shortcutName = shortcutName
		this.shortcutInput = shortcutInput
	}

	async handle() {
		console.log("the event: " + this.shortcutName + " has been triggered.")
		const escapedShortcutName = this.shortcutName.replace(/"/g, '\\"');

		let appleScript;
		if (this.shortcutInput) {
			const escapedShortcutInput = this.shortcutInput.replace(/"/g, '\\"');
			appleScript = `
			  tell application "Shortcuts Events"
				run the shortcut named "${escapedShortcutName}" with input "${escapedShortcutInput}"
			  end tell`;
		} else {
			appleScript = `
			  tell application "Shortcuts Events"
				run the shortcut named "${escapedShortcutName}"
			  end tell`;
		}
		await runAppleScript(appleScript);
	}
}
