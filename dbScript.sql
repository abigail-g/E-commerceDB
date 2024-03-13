CREATE TABLE 'Category'( 'Category_ID' VARCHAR(250) PRIMARY KEY, 'Category_Name' VARCHAR(250) NOT NULL );
CREATE TABLE 'Suppliers'( 'Supplier_ID' VARCHAR(250) PRIMARY KEY, 'Supplier_Name' VARCHAR(250) NOT NULL, 'Supplier_Building_Name' VARCHAR(250), 'Supplier_Street_Name' VARCHAR(250) NOT NULL, 'Supplier_Zip' VARCHAR(250) NOT NULL, 'Supplier_Email' VARCHAR(250) NOT NULL, 'Supplier_Status' VARCHAR(250) NOT NULL );
CREATE TABLE 'Products' ( 'Product_ID' VARCHAR(250) PRIMARY KEY, 'Product_Name' VARCHAR(250) NOT NULL, 'Product_Availability' VARCHAR(25) , 'Product_Price' FLOAT(10,2) NOT NULL, 'Category_ID' VARCHAR(250) NOT NULL,'Supplier_ID' VARCHAR(250) NOT NULL,FOREIGN KEY ('Category_ID') REFERENCES Category(Category_ID), FOREIGN KEY ('Supplier_ID') REFERENCES Suppliers(Supplier_ID)); 
CREATE TABLE 'Customers' ( 'Cust_ID' VARCHAR(250) PRIMARY KEY, 'Cust_Name' VARCHAR(250) NOT NULL, 'Cust_Building_Name' VARCHAR(250) , 'Cust_Street_Name' VARCHAR(250) NOT NULL, 'Cust_Zip' VARCHAR(25) NOT NULL, 'Cust_Email' VARCHAR(250) NOT NULL, 'Cust_Phone_Number' INT NOT NULL, 'Cust_Country_Code' VARCHAR(250) );
CREATE TABLE 'Reviews' ( 'Review_ID' VARCHAR(50) PRIMARY KEY,'Review_Timestamp' DATETIME NOT NULL, 'Product_Rating' INT NOT NULL, 'Review_Text' TEXT, 'Review_Likes' INT, 'Product_ID' VARCHAR(250) NOT NULL, FOREIGN KEY ('Product_ID') REFERENCES Products('Product_ID') );
CREATE TABLE 'Discounts'( 'Discount_Code' VARCHAR(50) PRIMARY KEY, 'Discount_Amount' FLOAT(10,2) NOT NULL, 'Discount_Status' BOOLEAN NOT NULL, 'Category_ID' VARCHAR(250) NOT NULL, 'Product_ID' VARCHAR(250) NOT NULL, FOREIGN KEY ('Category_ID') REFERENCES Category('Category_ID'), FOREIGN KEY ('Product_ID') REFERENCES Products('Product_ID') );
CREATE TABLE 'Order_Items'( 'Quantity' INT NOT NULL, 'Sum_Price' INT NOT NULL, 'Order_ID' VARCHAR(250) NOT NULL,'Product_ID' VARCHAR(250) NOT NULL, PRIMARY KEY ('Order_ID','Product_ID'), FOREIGN KEY ('Order_ID') REFERENCES Orders('Order_ID'), FOREIGN KEY ('Product_ID') REFERENCES Products('Product_ID'));
CREATE TABLE 'Order_Details' ( 'Order_ID'  VARCHAR(250) PRIMARY KEY, 'Order_Date' DATETIME NOT NULL, 'Shipping_Building_Name' VARCHAR(250), 'Shipping_Street_Name' VARCHAR(250) NOT NULL, 'Shipping_Zip_Code' VARCHAR(250) NOT NULL, 'Discount' VARCHAR(250) NOT NULL, 'Order_Total' FLOAT(10,2) NOT NULL, 'Order_Status' VARCHAR(50) NOT NULL, 'Payment_Type' VARCHAR(50) NOT NULL, 'Payment_Status' VARCHAR(50) NOT NULL, 'Billing_Building_Name' VARCHAR(250), 'Billing_Street_Name' VARCHAR(250) NOT NULL, 'Billing_Zip' VARCHAR(50) NOT NULL, 'Cust_ID' VARCHAR(250) NOT NULL, 'Discount_Code' VARCHAR(250) NOT NULL, FOREIGN KEY ('Cust_ID') REFERENCES Customers('Cust_ID'), FOREIGN KEY ('Discount_Code') REFERENCES DISCOUNTS('Discount_Code') );

