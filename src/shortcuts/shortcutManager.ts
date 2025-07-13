import { ShortcutConfig, configManager } from "src/config";
import {ShortcutScheduleEvent, shortcutBus, ShortcutTriggerEvent} from "src/shortcuts";
import cron from "node-cron";
import * as console from "node:console";

export class ShortcutManager {
  private readonly enabledShortcuts: ShortcutConfig[];
  private cronJobs: Map<string, any> = new Map(); // Store cron job references

  constructor() {
    this.enabledShortcuts = configManager.Config().shortcuts.filter(shortcut  => shortcut.enabled);
  }

  public initializeShortcuts() {
    console.log(`Initializing ${this.enabledShortcuts.length} shortcuts`);
    this.enabledShortcuts.forEach((shortcut) => {
      this.initializeShortcut(shortcut);
    })
  }

  public initializeShortcut(shortcut: ShortcutConfig): void {
    if(!this.enabledShortcuts.find(enabledShortcut => enabledShortcut.displayName === shortcut.displayName)) return
    console.log(`Initializing shortcut: ${shortcut.toString()}`);

    // Check if this shortcut has a cron job defined
    if (shortcut.cronString && shortcut.cronString.trim() !== '') {
      this.initializeCronJob(shortcut);
    } else if (shortcut.delay > 0) {
      // Create and send a schedule event for delay-based scheduling
      const scheduleEvent = new ShortcutScheduleEvent(
        shortcut.delay,
        shortcut.shortcutName,
      );
      shortcutBus.send(scheduleEvent);
    }
  }

  private initializeCronJob(shortcut: ShortcutConfig): void {
    try {
      // Validate cron string
      if (!cron.validate(shortcut.cronString)) {
        console.error(`Invalid cron string for shortcut ${shortcut.displayName}: ${shortcut.cronString}`);
        return;
      }

      // Schedule the cron job
      const job = cron.schedule(shortcut.cronString, () => {
        console.log(`Executing cron job for shortcut: ${shortcut.displayName}`);
        if (shortcut.delay > 0) {
          const scheduleEvent = new ShortcutScheduleEvent(
              shortcut.delay,
              shortcut.shortcutName,
          );
          // Create and send a schedule event for this shortcut
          shortcutBus.send(scheduleEvent);
        } else {
          const triggerEvent = new ShortcutTriggerEvent(
              shortcut.shortcutName,
          );
          // Create and send a trigger event for this shortcut
          shortcutBus.send(triggerEvent);
        }
      }, {
        scheduled: true,
        timezone: "UTC"
      });

      // Store the job reference for potential cleanup
      this.cronJobs.set(shortcut.shortcutName, job);

      console.log(`Cron job initialized for shortcut: ${shortcut.displayName} with schedule: ${shortcut.cronString}`);
    } catch (error) {
      console.error(`Failed to initialize cron job for shortcut ${shortcut.displayName}:`, error);
    }
  }

  public stopCronJob(shortcutName: string): void {
    const job = this.cronJobs.get(shortcutName);
    if (job) {
      job.stop();
      this.cronJobs.delete(shortcutName);
      console.log(`Stopped cron job for shortcut: ${shortcutName}`);
    }
  }

  public stopAllCronJobs(): void {
    this.cronJobs.forEach((job, shortcutName) => {
      job.stop();
      console.log(`Stopped cron job for shortcut: ${shortcutName}`);
    });
    this.cronJobs.clear();
  }
}