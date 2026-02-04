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

Пример ответа:

```json
{
  "barcode": "5901234123457",
  "name": "Кроссовки Trail Run",
  "imageUrl": "https://picsum.photos/seed/trail-run/600/400",
  "sizes": [
    { "size": "39", "qty": 4 },
    { "size": "40", "qty": 2 }
  ]
}
```
