import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, Request } from '@nestjs/common';
import { ProductsService } from '@products/products.service';
import { CreateProductDto } from '@products/entities/dto/create-product.dto';
import { UpdateProductDto } from '@products/entities/dto/update-product.dto';
import { JwtAuthGuard } from '@auth/guards/jwt-auth.guard';

@Controller('products')
export class ProductsController {
  constructor(private readonly productsService: ProductsService) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  create(@Body() createProductDto: CreateProductDto, @Request() req) {
    console.log('ProductsController - User from request:', req.user);
    console.log('ProductsController - User ID:', req.user?.userId);
    return this.productsService.create(createProductDto, req.user?.userId);
  }

  @Get()
  findAll() {
    return this.productsService.findAll();
  }

  @Get('my-products')
  @UseGuards(JwtAuthGuard)
  findUserProducts(@Request() req) {
    return this.productsService.findUserProducts(req.user?.userId);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.productsService.findOne(id);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard)
  update(
    @Param('id') id: string,
    @Body() updateProductDto: UpdateProductDto,
    @Request() req,
  ) {
    return this.productsService.update(id, updateProductDto, req.user?.userId, req.user?.isAdmin);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  remove(@Param('id') id: string, @Request() req) {
    return this.productsService.remove(id, req.user?.userId, req.user?.isAdmin);
  }
}