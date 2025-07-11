#!/usr/bin/env node
"use strict";

// src/background/background.ts
var BackgroundAgent = class {
  isRunning = false;
  heartbeatInterval = null;
  errorCount = 0;
  maxErrors = 20;
  heartbeatIntervalMs = 6e4;
  // 60 seconds
  constructor() {
    this.start = this.start.bind(this);
    this.stop = this.stop.bind(this);
    this.handleError = this.handleError.bind(this);
    this.heartbeat = this.heartbeat.bind(this);
  }
  /**
   * Start the background process and its error handling
   */
  start() {
    if (this.isRunning)
      return;
    console.log("Starting BackgroundAgent...");
    this.heartbeatInterval = setInterval(this.heartbeat, this.heartbeatIntervalMs);
    process.on("uncaughtException", this.handleError);
    process.on("unhandledRejection", this.handleError);
    process.on("SIGINT", this.stop);
    process.on("SIGTERM", this.stop);
    console.log("BackgroundAgent started successfully");
    this.isRunning = true;
  }
  stop() {
    if (!this.isRunning) {
      return;
    }
    console.log("Stopping BackgroundAgent...");
    this.isRunning = false;
    if (this.heartbeatInterval) {
      clearInterval(this.heartbeatInterval);
      this.heartbeatInterval = null;
    }
    process.removeListener("uncaughtException", this.handleError);
    process.removeListener("unhandledRejection", this.handleError);
    process.removeListener("SIGINT", this.stop);
    process.removeListener("SIGTERM", this.stop);
    console.log("BackgroundAgent stopped");
  }
  /**
   * Heartbeat handles error SLO's and log status
   */
  heartbeat() {
    if (!this.isRunning)
      return;
    const timestamp = (/* @__PURE__ */ new Date()).toISOString();
    console.log(`[${timestamp}] BackgroundAgent heartbeat - Running for ${this.getUptime()}ms`);
    if (this.errorCount > 0) {
      console.log(`Error count reset from ${this.errorCount} to 0`);
      this.errorCount = 0;
    }
  }
  /**
   * Handles Errors grafully and tries to fix itself
   */
  handleError(error) {
    this.errorCount++;
    const timestamp = (/* @__PURE__ */ new Date()).toISOString();
    console.error(`[${timestamp}] BackgroundAgent error (${this.errorCount}/${this.maxErrors}):`, error);
    if (this.errorCount >= this.maxErrors) {
      console.error(`Too many errors (${this.errorCount}), restarting BackgroundAgent...`);
      this.restart();
    }
  }
  restart() {
    console.log("Restarting BackgroundAgent...");
    this.stop();
    setTimeout(() => {
      this.start();
    }, 1e3);
  }
  getUptime() {
    return process.uptime() * 1e3;
  }
};

// src/background/index.ts
var backgroundAgent = new BackgroundAgent();

// src/app.ts
function InitApp() {
  console.log("Starting App");
  try {
    backgroundAgent.start();
    process.on("exit", (code) => {
      console.log(`Process exiting with code: ${code}`);
      backgroundAgent.stop();
    });
    process.on("SIGINT", () => {
      console.log("Received SIGINT, shutting down gracefully...");
      backgroundAgent.stop();
      process.exit(0);
    });
    process.on("SIGTERM", () => {
      console.log("Received SIGTERM, shutting down gracefully...");
      backgroundAgent.stop();
      process.exit(0);
    });
  } catch (error) {
    console.error("Failed to start:", error);
    process.exit(1);
  }
  console.log("App started successfully");
}

// src/index.ts
InitApp();
//# sourceMappingURL=app.js.map
