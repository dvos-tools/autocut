import {ConfigManager} from "src/config/configService";

export * from './shortcutConfig';
export * from './configService';
export * from './types';

export const configManager: ConfigManager  = new ConfigManager();
