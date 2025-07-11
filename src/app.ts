import { backgroundAgent } from "src/background";


export function InitApp(): void {
	console.log("Starting App");
	try {
		backgroundAgent.start();
		
		// Keep the process alive
		process.on('exit', (code) => {
			console.log(`Process exiting with code: ${code}`);
			backgroundAgent.stop();
		});

		// Handle graceful shutdown
		process.on('SIGINT', () => {
			console.log('Received SIGINT, shutting down gracefully...');
			backgroundAgent.stop();
			process.exit(0);
		});

		process.on('SIGTERM', () => {
			console.log('Received SIGTERM, shutting down gracefully...');
			backgroundAgent.stop();
			process.exit(0);
		});

	} catch (error) {
		console.error('Failed to start:', error);
		process.exit(1);
	}

	console.log('App started successfully');
}

