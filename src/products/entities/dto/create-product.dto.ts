import { IsString, IsNumber, IsPositive, Min, IsOptional, IsEnum } from 'class-validator';

export class CreateProductDto {
  @IsString()
  name: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsNumber()
  @IsPositive({ message: 'Price must be a positive number' })
  price: number;

  @IsNumber()
  @Min(0, { message: 'Quantity cannot be negative' })
  quantity: number;

  @IsOptional()
  @IsEnum(['active', 'inactive', 'discontinued'], {
    message: 'Status must be either active, inactive, or discontinued',
  })
  status?: string;
}