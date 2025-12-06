import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Product } from './entities/product.entity';
import { CreateProductDto } from './entities/dto/create-product.dto';
import { UpdateProductDto } from './entities/dto/update-product.dto';
import { User } from '@users/entities/user.entity';

@Injectable()
export class ProductsService {
  constructor(
    @InjectRepository(Product)
    private productsRepository: Repository<Product>,
  ) {}

  async create(createProductDto: CreateProductDto, userId: string): Promise<Product> {
    const product = this.productsRepository.create({
      ...createProductDto,
      userId: userId,
      user: { id: userId } as User,
    });

    return this.productsRepository.save(product);
  }

  async findAll(): Promise<Product[]> {
    return this.productsRepository.find({
      relations: ['user'],
      select: {
        user: {
          id: true,
          email: true,
          fullName: true,
        },
      },
    });
  }

  async findOne(id: string): Promise<Product> {
    const product = await this.productsRepository.findOne({
      where: { id },
      relations: ['user'],
      select: {
        user: {
          id: true,
          email: true,
          fullName: true,
        },
      },
    });

    if (!product) {
      throw new NotFoundException(`Product with ID ${id} not found`);
    }

    return product;
  }

  async update(id: string, updateProductDto: UpdateProductDto, userId: string, isAdmin: boolean): Promise<Product> {
    const product = await this.findOne(id);

    if (product.user.id !== userId && !isAdmin) {
      throw new ForbiddenException('You can only update your own products');
    }

    Object.assign(product, updateProductDto);
    return this.productsRepository.save(product);
  }

  async remove(id: string, userId: string, isAdmin: boolean): Promise<void> {
    const product = await this.findOne(id);

    if (product.user.id !== userId && !isAdmin) {
      throw new ForbiddenException('You can only delete your own products');
    }

    await this.productsRepository.remove(product);
  }

  async findUserProducts(userId: string): Promise<Product[]> {
    return this.productsRepository.find({
      where: { user: { id: userId } },
    });
  }
}