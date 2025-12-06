import { Injectable } from '@nestjs/common';
import { TypeOrmModuleOptions, TypeOrmOptionsFactory } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';
import { User } from '../users/entities/user.entity';
import { Product } from '../products/entities/product.entity';

@Injectable()
export class DatabaseConfig implements TypeOrmOptionsFactory {
  constructor(private configService: ConfigService) {}

  createTypeOrmOptions(): TypeOrmModuleOptions {
    // Support Railway.app DATABASE_URL environment variable
    const databaseUrl = this.configService.get<string>('DATABASE_URL');
    
    if (databaseUrl) {
      // Use connection string provided by Railway
      return {
        type: 'postgres',
        url: databaseUrl,
        entities: [User, Product],
        synchronize: true,
        dropSchema: false,
        logging: process.env.NODE_ENV === 'production' ? ['error'] : ['error', 'warn'],
        ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
      };
    }

    // Fallback to individual environment variables for local development
    return {
      type: 'postgres',
      host: this.configService.get<string>('DB_HOST', 'localhost'),
      port: this.configService.get<number>('DB_PORT', 5432),
      username: this.configService.get<string>('DB_USERNAME', 'postgres'),
      password: this.configService.get<string>('DB_PASSWORD', 'password'),
      database: this.configService.get<string>('DB_NAME', 'nestjs_api'),
      entities: [User, Product],
      synchronize: true,
      dropSchema: false,
      logging: ['error', 'warn'],
      maxQueryExecutionTime: 5000,
    };
  }
}