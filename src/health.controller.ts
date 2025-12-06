import { Controller, Get } from '@nestjs/common';

@Controller()
export class HealthController {
  @Get('/')
  health() {
    return {
      status: 'ok',
      message: 'NestJS Backend API is running',
      timestamp: new Date().toISOString(),
      endpoints: {
        users: '/users',
        auth: '/auth',
        products: '/products',
      },
    };
  }

  @Get('/health')
  healthCheck() {
    return {
      status: 'healthy',
      uptime: process.uptime(),
      timestamp: new Date().toISOString(),
    };
  }
}
