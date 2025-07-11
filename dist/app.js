#!/usr/bin/env node
"use strict";
var __create = Object.create;
var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __getProtoOf = Object.getPrototypeOf;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __copyProps = (to, from, except, desc) => {
  if (from && typeof from === "object" || typeof from === "function") {
    for (let key of __getOwnPropNames(from))
      if (!__hasOwnProp.call(to, key) && key !== except)
        __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
  }
  return to;
};
var __toESM = (mod, isNodeMode, target) => (target = mod != null ? __create(__getProtoOf(mod)) : {}, __copyProps(
  // If the importer is in node compatibility mode or this is not an ESM
  // file that has been converted to a CommonJS file using a Babel-
  // compatible transform (i.e. "__esModule" has not been set), then set
  // "default" to the CommonJS "module.exports" for node compatibility.
  isNodeMode || !mod || !mod.__esModule ? __defProp(target, "default", { value: mod, enumerable: true }) : target,
  mod
));

// src/events/consumer/subscription.ts
var Subscription = class {
  key;
  eventBus;
  constructor(eventBus, key) {
    this.eventBus = eventBus;
    this.key = key;
  }
  unsubscribe() {
    this.eventBus.unsubscribe(this.key);
  }
};

// node_modules/uuid/dist/esm-node/rng.js
var import_crypto = __toESM(require("crypto"));
var rnds8Pool = new Uint8Array(256);
var poolPtr = rnds8Pool.length;
function rng() {
  if (poolPtr > rnds8Pool.length - 16) {
    import_crypto.default.randomFillSync(rnds8Pool);
    poolPtr = 0;
  }
  return rnds8Pool.slice(poolPtr, poolPtr += 16);
}

// node_modules/uuid/dist/esm-node/stringify.js
var byteToHex = [];
for (let i = 0; i < 256; ++i) {
  byteToHex.push((i + 256).toString(16).slice(1));
}
function unsafeStringify(arr, offset = 0) {
  return byteToHex[arr[offset + 0]] + byteToHex[arr[offset + 1]] + byteToHex[arr[offset + 2]] + byteToHex[arr[offset + 3]] + "-" + byteToHex[arr[offset + 4]] + byteToHex[arr[offset + 5]] + "-" + byteToHex[arr[offset + 6]] + byteToHex[arr[offset + 7]] + "-" + byteToHex[arr[offset + 8]] + byteToHex[arr[offset + 9]] + "-" + byteToHex[arr[offset + 10]] + byteToHex[arr[offset + 11]] + byteToHex[arr[offset + 12]] + byteToHex[arr[offset + 13]] + byteToHex[arr[offset + 14]] + byteToHex[arr[offset + 15]];
}

// node_modules/uuid/dist/esm-node/native.js
var import_crypto2 = __toESM(require("crypto"));
var native_default = {
  randomUUID: import_crypto2.default.randomUUID
};

// node_modules/uuid/dist/esm-node/v4.js
function v4(options, buf, offset) {
  if (native_default.randomUUID && !buf && !options) {
    return native_default.randomUUID();
  }
  options = options || {};
  const rnds = options.random || (options.rng || rng)();
  rnds[6] = rnds[6] & 15 | 64;
  rnds[8] = rnds[8] & 63 | 128;
  if (buf) {
    offset = offset || 0;
    for (let i = 0; i < 16; ++i) {
      buf[offset + i] = rnds[i];
    }
    return buf;
  }
  return unsafeStringify(rnds);
}
var v4_default = v4;

// src/events/service/util.ts
function generateKey() {
  return v4_default();
}

// src/events/bus/bus.ts
var EventBus = class {
  handlers = /* @__PURE__ */ new Map();
  options;
  constructor(options = deafultEventBusOptions) {
    this.options = options;
  }
  send(event) {
    this.handlers.forEach((handler) => {
      try {
        handler(event);
      } catch (error) {
        console.error("Error in event handler:", error);
      }
    });
  }
  subscribe(handler) {
    const key = generateKey();
    if (this.options.processCurrentEventOnSubscribe) {
      this.handlers.set(key, handler);
    } else {
      queueMicrotask(() => this.handlers.set(key, handler));
    }
    return new Subscription(this, key);
  }
  unsubscribe(key) {
    if (!this.handlers.has(key)) {
      console.warn(`Attempted to unsubscribe with invalid key: ${key}`);
      return;
    }
    this.handlers.delete(key);
  }
};

// src/events/bus/index.ts
var deafultEventBusOptions = {
  processCurrentEventOnSubscribe: false
};

// src/shortcuts/shortcutTriggerEvent.ts
var ShortcutTriggerEvent = class {
  shortcutName;
  constructor(shortcutName) {
    this.shortcutName = shortcutName;
  }
  handle() {
    console.log("The event: " + this.shortcutName + " has been triggered.");
  }
};

// src/index.ts
var shortcutBus = new EventBus();
function main() {
  shortcutBus.subscribe(handleShortcutTriggerEvent);
  triggerShortcut("MyAmazingShortcut");
}
function handleShortcutTriggerEvent(event) {
  console.log(`Shortcut triggered: ${event.shortcutName}`);
  event.handle();
}
function triggerShortcut(shortcutName) {
  console.log(`Triggering shortcut: ${shortcutName}`);
  const shortcutEvent = new ShortcutTriggerEvent(shortcutName);
  shortcutBus.send(shortcutEvent);
}
main();
//# sourceMappingURL=app.js.map
