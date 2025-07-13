import {AppConfig} from "src/config/types";
import path from "path";
import fs from "fs";
import * as yaml from "js-yaml";
import {ShortcutConfig} from "src/config/shortcutConfig";

export class ConfigManager {
    private readonly config: AppConfig
    private readonly configPath: string;

    public constructor() {
        this.configPath = path.join(process.cwd(), 'config.yml');
        this.config = this.loadConfig();
    }

    public Config(): AppConfig {
       return this.config;
    }
    
    public loadConfig(): AppConfig {
        if (this.config) {
            return this.config;
        }

        try {
            console.log(`Loading configuration from: ${this.configPath}`);
            if (!fs.existsSync(this.configPath)) {
                throw new Error(`Configuration file not found: ${this.configPath}`);
            }

            const configContent = fs.readFileSync(this.configPath, 'utf8');
            const rawConfig = yaml.load(configContent) as any;

            // Parse shortcuts from the raw config
            const shortcuts: ShortcutConfig[] = [];
            if (rawConfig.shortcuts && Array.isArray(rawConfig.shortcuts)) {
                console.log(`Loading ${rawConfig.shortcuts.length} shortcuts`);
                for (const shortcutData of rawConfig.shortcuts) {
                    // Log missing fields
                    if (!shortcutData.displayName) console.warn('Missing displayName');
                    if (!shortcutData.shortcutName) console.warn('Missing shortcutName');
                    if (!shortcutData.cronDelay && !shortcutData.delay) console.warn('No scheduling configured');
                    
                    const shortcut = new ShortcutConfig(
                        shortcutData.displayName,
                        shortcutData.shortcutName,
                        shortcutData.shortcutInput,
                        shortcutData.cronDelay,
                        shortcutData.delay,
                        shortcutData.description,
                        shortcutData.enabled !== undefined ? shortcutData.enabled : true // enabled
                    );
                    shortcuts.push(shortcut);
                }
            } else {
                console.warn('No shortcuts found in config');
            }

            return {
                shortcuts: shortcuts
            };
        } catch (error) {
            console.error('Failed to load configuration:', error);
            throw error;
        }
    }
}
