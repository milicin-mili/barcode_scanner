import { Controller, Get, NotFoundException, Param } from '@nestjs/common';

import { ProductsService } from './products.service';

@Controller()
export class ProductsController {
  constructor(private readonly productsService: ProductsService) {}

  @Get('health')
  health() {
    return { status: 'ok' };
  }

  @Get('products/:barcode')
  getProduct(@Param('barcode') barcode: string) {
    const product = this.productsService.getByBarcode(barcode);
    if (!product) {
      throw new NotFoundException('Product not found');
    }
    return product;
  }
}
