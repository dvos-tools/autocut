import { v4 as uuidv4 } from 'uuid';

export function generateKey(): string {
    return uuidv4();
}
