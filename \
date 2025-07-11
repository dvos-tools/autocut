
/*
 * BackgroundAgent is the background process runner. everything should inderectly go through this agent.
 * This Agent should never crash or recieve any fatal errors. If this agent gets in a state where 
 * it seems broken. the Agent should *always* try to fix itself and repair its state.
 */

export class BackgroundAgent {
	public isRunning: boolean = false;
	private heartbeatInterval: NodeJS.Timeout | null = null;
	private errorCount: number = 0;
	private readonly maxErrors: number = 20;
	private readonly heartbeatIntervalMs: number = 60000; // 60 seconds

	constructor() {
		this.start = this.start.bind(this);
		this.stop = this.stop.bind(this);
		this.handleError = this.handleError.bind(this);
		this.heartbeat = this.heartbeat.bind(this);
	}

	/**
	 * Start the background process and its error handling
	 */
	public start(): void {
		if (this.isRunning) return
		console.log('Starting BackgroundAgent...');

		this.heartbeatInterval = setInterval(this.heartbeat, this.heartbeatIntervalMs);
		process.on('uncaughtException', this.handleError);
		process.on('unhandledRejection', this.handleError);
		process.on('SIGINT', this.stop);
		process.on('SIGTERM', this.stop);

		console.log('BackgroundAgent started successfully');
		this.isRunning = true;
	}

	public stop(): void {
		if (!this.isRunning) {
			return;
		}

		console.log('Stopping BackgroundAgent...');
		this.isRunning = false;

		// Clear heartbeat interval
		if (this.heartbeatInterval) {
			clearInterval(this.heartbeatInterval);
			this.heartbeatInterval = null;
		}

		// Remove event listeners
		process.removeListener('uncaughtException', this.handleError);
		process.removeListener('unhandledRejection', this.handleError);
		process.removeListener('SIGINT', this.stop);
		process.removeListener('SIGTERM', this.stop);

		console.log('BackgroundAgent stopped');
	}

	/**
	 * Heartbeat handles error SLO's and log status
	 */
	private heartbeat(): void {
		if (!this.isRunning) return;

		const timestamp = new Date().toISOString();
		console.log(`[${timestamp}] BackgroundAgent heartbeat - Running for ${this.getUptime()}ms`);
		
		// Reset error count on successful heartbeat
		if (this.errorCount > 0) {
			console.log(`Error count reset from ${this.errorCount} to 0`);
			this.errorCount = 0;
		}
	}

	/**
	 * Handles Errors grafully and tries to fix itself
	 */
	private handleError(error: Error | string): void {
		this.errorCount++;
		const timestamp = new Date().toISOString();
		
		console.error(`[${timestamp}] BackgroundAgent error (${this.errorCount}/${this.maxErrors}):`, error);

		// If too many errors, restart the process
		if (this.errorCount >= this.maxErrors) {
			console.error(`Too many errors (${this.errorCount}), restarting BackgroundAgent...`);
			this.restart();
		}
	}

	private restart(): void {
		console.log('Restarting BackgroundAgent...');
		this.stop();
		
		setTimeout(() => {
			this.start();
		}, 1000);
	}

	private getUptime(): number {
		return process.uptime() * 1000;
	}
}

