import { Controller, Get } from '@nestjs/common';

@Controller()
export class AppController {
  @Get()
  getHello() {
    return {
      status: 'ok',
      message: 'Nest.js API is working!',
      timestamp: new Date().toISOString()
    };
  }
}
