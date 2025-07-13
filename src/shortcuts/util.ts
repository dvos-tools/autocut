import {exec, ExecException} from "child_process";

/**
 * Runs an AppleScript command using osascript.
 * @param script The AppleScript code as a string.
 * @returns A Promise that resolves with the stdout of the osascript command,
 * or rejects with an error if the command fails.
 */
export function runAppleScript(script: string): Promise<string> {
    return new Promise((resolve, reject) => {
        // The -e flag allows you to pass script code directly.
        const command = `osascript -e '${script}'`;

        exec(command, (error: ExecException | null, stdout: string, stderr: string) => {
            if (error) {
                const errorMessage = `osascript error: ${error.message}\nStderr: ${stderr}`;
                reject(new Error(errorMessage));
                return;
            }

            if (stderr) {
                console.warn('osascript stderr:', stderr);
            }
            resolve(stdout.trim());
        });
    });
}
