erDiagram
    DIM_CUSTOMERS ||--o{ FACT_SALES : "customer_key"
    DIM_PRODUCTS  ||--o{ FACT_SALES : "product_key"

    DIM_CUSTOMERS {
        int     customer_key      PK
        int     customer_id
        string  customer_number
        string  first_name
        string  last_name
        string  country
        string  marital_status
        string  gender
        date    birthdate
        date    create_date
    }
    FACT_SALES {
        string  order_number
        int     product_key       FK
        int     customer_key      FK
        date    order_date
        date    shipping_date
        date    due_date
        int     sales_amount
        int     quantity
        int     price
    }
    DIM_PRODUCTS {
        int     product_key       PK
        int     product_id
        string  product_number
        string  product_name
        int     category_id
        string  category
        string  subcategory
        string  maintenance
        int     cost
        string  product_line
        date    start_date
    }
