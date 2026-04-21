# OTUS Типы данных в MySQL 

## Описание

В рамках домашнего задания был проведен анализ типов данных в учебном проекте на MySQL.

За основу взята структура базы данных интернет-магазина с таблицами:

- `categories`
- `suppliers`
- `manufacturers`
- `products`
- `customers`
- `prices`
- `purchases`

Цель работы:
- подобрать более подходящие типы данных;
- определиться с типом идентификаторов;
- добавить тип `JSON`;
- показать примеры добавления и выборки данных из `JSON`.

## Выполнено

Проведен анализ типов данных в проекте.

### Изменения типов данных

- Для всех первичных ключей и внешних ключей оставлен тип `INT UNSIGNED NOT NULL AUTO_INCREMENT`.
- Для полей `email` в таблицах `suppliers`, `manufacturers`, `customers` длина изменена с `VARCHAR(64)` на `VARCHAR(100)`, так как email может быть длиннее 64 символов.
- Для поля `quantity` в таблице `purchases` тип изменен с `INT` на `SMALLINT UNSIGNED`, так как количество товара в одной покупке обычно невелико.
- Для поля `purchase_date` в таблице `purchases` тип изменен с `DATE` на `DATETIME`, чтобы хранить не только дату, но и время покупки.

### Выбор типа ID

Для идентификаторов был выбран тип:

```sql
INT UNSIGNED NOT NULL AUTO_INCREMENT
```

Причины выбора:

подходит для автоинкрементных идентификаторов;
достаточно для учебного проекта;
экономичнее, чем BIGINT;
одинаковый тип используется и для первичных, и для внешних ключей.
Добавлен тип JSON

В таблицу products добавлено поле:

attributes JSON

Оно используется для хранения дополнительных характеристик товара, которые могут отличаться у разных типов продукции.

Пример структуры таблицы products:

CREATE TABLE IF NOT EXISTS products (
    product_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    attributes JSON,
    category_id INT UNSIGNED NOT NULL,
    supplier_id INT UNSIGNED NOT NULL,
    manufacturer_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (product_id),
    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id) REFERENCES categories(category_id),
    CONSTRAINT fk_products_supplier
        FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    CONSTRAINT fk_products_manufacturer
        FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(manufacturer_id)
);
Какие данные можно хранить в JSON

В поле attributes можно хранить разные свойства товара.

Для ноутбука:
процессор
объем оперативной памяти
объем диска
цвет
гарантия
Для мыши:
DPI
беспроводная или проводная
тип батарейки
цвет
Для монитора:
диагональ
разрешение
тип матрицы
порты подключения
Пример добавления записей
Добавление ноутбука
INSERT INTO products (
    name,
    description,
    attributes,
    category_id,
    supplier_id,
    manufacturer_id
) VALUES (
    'Lenovo ThinkBook',
    'Ноутбук для офиса',
    JSON_OBJECT(
        'cpu', 'Intel Core i5',
        'ram_gb', 16,
        'storage_gb', 512,
        'color', 'gray',
        'warranty_months', 24
    ),
    1,
    1,
    1
);
Добавление мыши
INSERT INTO products (
    name,
    description,
    attributes,
    category_id,
    supplier_id,
    manufacturer_id
) VALUES (
    'Logitech M185',
    'Беспроводная мышь',
    JSON_OBJECT(
        'dpi', 1600,
        'wireless', true,
        'battery', 'AA',
        'color', 'black'
    ),
    2,
    2,
    2
);
Добавление монитора
INSERT INTO products (
    name,
    description,
    attributes,
    category_id,
    supplier_id,
    manufacturer_id
) VALUES (
    'Dell Monitor 24',
    'Монитор 24 дюйма',
    JSON_OBJECT(
        'diagonal', 24,
        'resolution', '1920x1080',
        'panel', 'IPS',
        'ports', JSON_ARRAY('HDMI', 'DisplayPort'),
        'color', 'black'
    ),
    3,
    1,
    1
);
Примеры выборки данных из JSON
Вывести JSON целиком
SELECT product_id, name, attributes
FROM products;
Вытащить отдельные поля из JSON
SELECT
    name,
    attributes->>'$.color' AS color,
    attributes->>'$.cpu' AS cpu,
    attributes->>'$.ram_gb' AS ram_gb
FROM products;
Поиск товаров по цвету
SELECT *
FROM products
WHERE attributes->>'$.color' = 'black';
Поиск ноутбуков с 16 ГБ оперативной памяти
SELECT *
FROM products
WHERE CAST(attributes->>'$.ram_gb' AS UNSIGNED) = 16;
Поиск по JSON_EXTRACT
SELECT *
FROM products
WHERE JSON_EXTRACT(attributes, '$.color') = 'black';

