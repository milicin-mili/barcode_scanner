import { Injectable } from '@nestjs/common';

import { getDb } from './db';

type ProductRow = {
  id: number;
  barcode: string;
  name: string;
  image_url: string;
};

type SizeRow = {
  size: string;
  qty: number;
};

@Injectable()
export class ProductsService {
  getByBarcode(barcode: string) {
    const db = getDb();
    const product = db
      .prepare('SELECT * FROM products WHERE barcode = ?')
      .get(barcode) as ProductRow | undefined;

    if (!product) {
      return null;
    }

    const sizes = db
      .prepare(
        'SELECT size, quantity as qty FROM sizes WHERE product_id = ? ORDER BY size',
      )
      .all(product.id) as SizeRow[];

    return {
      barcode: product.barcode,
      name: product.name,
      imageUrl: product.image_url,
      sizes,
    };
  }
}
