import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Enable validation globally
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: true,
    }),
  );

  // Enable CORS - Allow all origins in production (Railway/cloud)
  app.enableCors({
    origin: process.env.NODE_ENV === 'production' ? '*' : 'http://localhost:3000',
    credentials: true,
  });

  // Error handlers
  process.on('unhandledRejection', (reason, promise) => {
    console.error('Unhandled Rejection at:', promise, 'reason:', reason);
    process.exit(1);
  });

  process.on('uncaughtException', (error) => {
    console.error('Uncaught Exception:', error);
    process.exit(1);
  });

  const port = process.env.PORT || 3000;
  // Bind to 0.0.0.0 for Railway/cloud deployment compatibility
  await app.listen(port, '0.0.0.0');
  console.log(`Application is running on port ${port}`);
}

bootstrap();
