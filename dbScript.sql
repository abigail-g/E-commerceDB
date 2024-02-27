-- !This is the sql script to create the ecommerce db 


CREATE TABLE REVIEWS(
'review_id' VARCHAR(50) PRIMARY KEY,
'product_id' VARCHAR(50),
'review_timestamp' DATETIME NOT NULL,
'product_rating' INT NOT NULL,
'review_text' TEXT,
'review_likes' INT,
FOREIGN KEY (product_id) REFERENCES PRODUCTS(product_id)
);

CREATE TABLE CART(
'cust_id' VARCHAR(50) NOT NULL,
'product_id' VARCHAR(50) NOT NULL,
'quantity' INT NOT NULL,
'cart_cost' INT NOT NULL,
FOREIGN KEY (cust_id) REFERENCES CUSTOMERS(cust_id),
FOREIGN KEY (product_id) REFERENCES PRODUCTS(product_id)
);

CREATE TABLE DISCOUNTS(
'discount_code' VARCHAR(50) PRIMARY KEY,
'product_id' VARCHAR(50),
'category_id' VARCHAR(50),
'discount_amount' INT NOT NULL,
'discount_status' BOOLEAN NOT NULL,
FOREIGN KEY (category_id) REFERENCES CATEGORY(category_id),
FOREIGN KEY (product_id) REFERENCES PRODUCTS(product_id)
);

CREATE TABLE PAYMENT_DETAILS(
'payment_id' VARCHAR(50) PRIMARY KEY, 
'order_id' VARCHAR(50) NOT NULL,
'payment_type' VARCHAR(20),
'payment_timestamp' DATETIME,
'billing_address' TEXT,
'payment_status' VARCHAR(10),
FOREIGN KEY (order_id) REFERENCES ORDERS(order_id)
);

