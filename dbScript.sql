-- !This is the sql script to create the ecommerce db 
CREATE TABLE 'Products' ( 
'product_id' VARCHAR(250) PRIMARY KEY, 
'product_name' VARCHAR(250) NOT NULL,     
'product_price' FLOAT(10,2) NOT NULL, 
FOREIGN KEY 'category_id'
REFERENCES CATEGORY ('category_id'), 
FOREIGN KEY ('supplier_id') 
REFERENCES SUPPLIERS ('supplier_id'),  
'product_availability' VARCHAR(25) 
); 

Customers 

CREATE TABLE 'Customers' ( 
'cust_id' VARCHAR(250) PRIMARY KEY,  
'cust_name' VARCHAR(250), 
'cust_zip' VARCHAR(25), 
'cust_address' VARCHAR(250), 
'cust_email' VARCHAR(250) NOT NULL, 
'cust_no' INT NOT NULL 
); 

Order_details 

CREATE TABLE 'Order_Details' ( 
'order_id'  VARCHAR(250) PRIMARY KEY, 
'order_date' DATE NOT NULL,  
'order_price' FLOAT(10,2) NOT NULL, 
'discount' FLOAT(10,2), 
'order_total' FLOAT(10,2), 
FOREIGN KEY ('customer_id') 
REFERENCES Customers ('customer_id'),  
'delivery_charge' FLOAT(10,2), 
'expedited_delivery' VARCHAR(250), 
FOREIGN KEY ('Payment_id') 
REFERENCES Payment_details ('Payment_id') 
);  

Order_stage 

CREATE TABLE 'Order_stage'( 
'id' VARCHAR(250) PRIMARY KEY,  
'status_name' VARCHAR(250), 
'status_code' VARCHAR(250) NOT NULL 
); 



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

