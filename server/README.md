# Mock Server (NestJS + SQLite)

## Запуск

1. Установить зависимости:

```bash
npm install
```

2. Запустить сервер:

```bash
npm run start
```

Сервер стартует на `http://localhost:3000` и создает базу `server/data/catalog.db`.

## Эндпоинты

- `GET /health` — проверка статуса.
- `GET /products/:barcode` — информация о товаре по штрихкоду.
