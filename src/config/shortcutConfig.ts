
export class ShortcutConfig {
  public readonly displayName: string;
  public readonly shortcutName: string;
  public readonly shortcutInput: any;
  public readonly cronString: string;
  public readonly delay: number;
  public readonly description: string;
  public readonly enabled: boolean;

  constructor(
      displayName: string,
      shortcutName: string,
      shortcutInput: any,
      cronDelay: string,
      delay: number,
      description: string,
      enabled: boolean,
  ) {
    this.displayName = displayName;
    this.shortcutName = shortcutName;
    this.shortcutInput = shortcutInput || null ;
    this.cronString = cronDelay || "";
    this.delay = delay || 0;
    this.description = description || "";
    this.enabled = enabled || true;
  }
  public toString(): string {
    return `ShortcutConfig(displayName="${this.displayName}", shortcutName="${this.shortcutName}", shortcutInput="${this.shortcutInput}", enabled=${this.enabled}, cronString="${this.cronString}")`;
  }
} 