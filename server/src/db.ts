import path from "path";
import Database from "better-sqlite3";

type ProductSeed = {
  barcode: string;
  name: string;
  imageUrl: string;
  sizes: Array<{ size: string; qty: number }>;
};

const seedData: ProductSeed[] = [
  {
    barcode: "5901234123457",
    name: "Кроссовки New Balance Garoe",
    imageUrl: "https://ir.ozone.ru/s3/multimedia-1-k/wc1000/8230585736.jpg",
    sizes: [
      { size: "39", qty: 4 },
      { size: "40", qty: 2 },
      { size: "41", qty: 0 },
      { size: "42", qty: 7 },
    ],
  },
  {
    barcode: "4006381333931",
    name: "Футболка Essential",
    imageUrl: "https://ir.ozone.ru/s3/multimedia-1-a/wc1000/7726797478.jpg",
    sizes: [
      { size: "S", qty: 12 },
      { size: "M", qty: 5 },
      { size: "L", qty: 1 },
      { size: "XL", qty: 0 },
    ],
  },
  {
    barcode: "4601234567890",
    name: "Куртка Peak",
    imageUrl: "https://ir.ozone.ru/s3/multimedia-1-6/wc1000/7228689234.jpg",
    sizes: [
      { size: "S", qty: 3 },
      { size: "M", qty: 0 },
      { size: "L", qty: 2 },
      { size: "XL", qty: 1 },
    ],
  },
];

let db: Database.Database | null = null;

export function getDb(): Database.Database {
  if (db) return db;

  const dbPath = path.join(__dirname, "..", "data", "catalog.db");
  db = new Database(dbPath);
  db.pragma("foreign_keys = ON");

  db.exec(`
    CREATE TABLE IF NOT EXISTS products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      barcode TEXT UNIQUE NOT NULL,
      name TEXT NOT NULL,
      image_url TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS sizes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_id INTEGER NOT NULL,
      size TEXT NOT NULL,
      quantity INTEGER NOT NULL,
      FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE
    );
  `);

  const existing = db
    .prepare("SELECT COUNT(*) as count FROM products")
    .get() as {
    count: number;
  };

  if (existing.count === 0) {
    const insertProduct = db.prepare(
      "INSERT INTO products (barcode, name, image_url) VALUES (?, ?, ?)",
    );
    const insertSize = db.prepare(
      "INSERT INTO sizes (product_id, size, quantity) VALUES (?, ?, ?)",
    );

    const insertAll = db.transaction(() => {
      for (const product of seedData) {
        const result = insertProduct.run(
          product.barcode,
          product.name,
          product.imageUrl,
        );
        const productId = Number(result.lastInsertRowid);
        for (const size of product.sizes) {
          insertSize.run(productId, size.size, size.qty);
        }
      }
    });

    insertAll();
  }

  return db;
}
