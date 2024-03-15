#Functions to be performed:

# 1. this script will read the csv data 
library(DBI)
library(readr)
library(RSQLite)
library(dplyr)
library(stringr)

# Run all the csv first 
Product_Category <- read_csv("Files/Product_Category.csv")
Suppliers <- read_csv("Files/Suppliers.csv")
Customers <- read_csv("Files/Customers.csv")
Products <- read_csv("Files/Products.csv")
Product_Discounts <- read_csv("Files/Product_Discounts.csv")
Reviews <- read_csv("Files/Reviews.csv",
                    skip = 1)
Order_details <- read_csv("Files/Order_Details.csv",
                          skip = 1)
Order_Item <- read_csv("Files/Order_Item.csv", 
                       skip = 1)
# Clean the data so it can match the database
Suppliers$Supplier_Building_Number <- NULL
Order_details$Billing_Building_Number <- NULL
Order_details$Shipping_Building_Number <- NULL

#Category
csv_count_category <- nrow(Product_Category)

con <- dbConnect(RSQLite::SQLite(), "ecommerce.db")

RSQLite::dbWriteTable(con, "Category", Product_Category, overwrite=TRUE)


#SUPPLIERS
con <- dbConnect(RSQLite::SQLite(), "ecommerce.db")

RSQLite::dbWriteTable(con, "Suppliers", Suppliers, overwrite=TRUE)

# Customers 
csv_count_customer <- count(Customers)

con <- dbConnect(RSQLite::SQLite(), "ecommerce.db")

sql_count_customer <- dbGetQuery(con, 'SELECT count(*) FROM Customers')

if(csv_count_customer$n > sql_count_customer$`count(*)`){
  RSQLite::dbWriteTable(con, "Customers", Customers, overwrite=TRUE)
  print("New records have been added")
}

# The ones above have no foreign key 
# Products
# This is to add suppliers_id in Products
set.seed(123)

Products <- Products %>%
  mutate(Supplier_ID = NA)

# Create a function to find matching supplier ID or assign randomly if no match is found
assign_supplier_id <- function(Product_Name, Suppliers) {
  for (i in 1:nrow(Suppliers)) {
    if (str_detect(Product_Name, regex(Suppliers$Supplier_Name[i], ignore_case = TRUE))) {
      return(Suppliers$Supplier_ID[i])
    }
  }
  # If no match found, assign a random supplier ID
  random_supplier_id <- sample(Suppliers$Supplier_ID, 1)
  return(random_supplier_id)
}

Products$Supplier_ID <- sapply(Products$Product_Name, function(x) assign_supplier_id(x, Suppliers))

# Adding Discount_Code column into Products 
set.seed(123) # This is to ensure reproducibility

Products <- Products %>%
  mutate(Discount_Code = NA)

codes_to_assign <- sample(1:nrow(Products), 50)

random_discounts <- sample(Product_Discounts$Discount_Code, 50)

Products$Discount_Code[codes_to_assign] <- random_discounts

Products <- Products %>%
  mutate(Category_ID = NA)

# To apply the foreign key into the table 
# Define a function to assign Category_ID based on keywords in Product_Name
assign_category_id <- function(Product_Name) {
  if (grepl("TV|Television", Product_Name, ignore.case = TRUE)) {
    return("CAT1")
  } else if (grepl("Laptop|Tablet|Computing|Book|Surface|Monitor", Product_Name, ignore.case = TRUE)) {
    return("CAT2")
  } else if (grepl("Phone|Galaxy|Mi|P Series|OnePlus", Product_Name, ignore.case = TRUE)) {
    return("CAT3")
  } else if (grepl("Refrigerator|Washing Machine|Home Appliance|Microwave|Vacuum|Dishwasher", Product_Name, ignore.case = TRUE)){
    return("CAT4")
  } else if (grepl("Headphones|Speakers|Sound System|Earbuds|Speaker|Technica|Soundbar", Product_Name, ignore.case = TRUE)) {
    return("CAT5")
  } else if (grepl("Camera|Photography|GoPro|Mirrorless|Nikon|Camcorder|Compact", Product_Name, ignore.case = TRUE)) {
    return("CAT6")
  } else if (grepl("Xbox|PS|Gaming|Switch", Product_Name, ignore.case = TRUE)) {
    return("CAT7")
  } else if (grepl("Smart Home|Echo|Smart Lock|Steam Deck|Hue Light", Product_Name, ignore.case = TRUE)) {
    return("CAT8")
  } else if (grepl("Watch|Wearable|Quest|Tracker|Gear|Band|Glasses", Product_Name, ignore.case = TRUE)) {
    return("CAT9")
  } else if (grepl("Keyboard|Mouse|Peripheral|Thermostat", Product_Name, ignore.case = TRUE)) {
    return("CAT10")
  } else {
    return(NA) # For products that do not match any category
  }
}

# Apply the function to assign Category_ID to each product
Products$Category_ID <- sapply(Products$Product_Name, assign_category_id)

con <- dbConnect(RSQLite::SQLite(), "ecommerce.db")

RSQLite::dbWriteTable(con, "Products", Products, overwrite=TRUE)


# Discounts

discounted_products <- Products %>%
  filter(!is.na(Discount_Code)) %>%
  select(Product_ID, Discount_Code)

# Do a left join to join it together 
Product_Discounts <- Product_Discounts %>%
  left_join(discounted_products, by = "Discount_Code")

# Same step for cat_id
# Filter out the rows from Products that have a discount code assigned on the cat ID
discounted_cat <- Products %>%
  filter(!is.na(Category_ID)) %>%
  select(Category_ID, Discount_Code)

# Do a left join to join it together, thus we get to see which discount code assign to which category of goods
Product_Discounts <- Product_Discounts %>%
  left_join(discounted_cat, by = "Discount_Code")

con <- dbConnect(RSQLite::SQLite(), "ecommerce.db")

RSQLite::dbWriteTable(con, "Product_Discounts", Product_Discounts, overwrite = TRUE)

# Reviews

set.seed(123)
Reviews <- Reviews %>% 
  mutate(Product_ID = sample(Products$Product_ID, nrow(Reviews), replace = TRUE))


# Order_details

set.seed(123)
Order_details <- Order_details %>%
  mutate(Cust_ID = sample(Customers$Cust_ID, nrow(Order_details), replace = TRUE))

csv_count_order <- nrow(Order_details)

con <- dbConnect(RSQLite::SQLite(), "ecommerce.db")

sql_count_order <- dbGetQuery(con, 'SELECT count(*) FROM Order_Details')

if(csv_count_order > sql_count_order$`count(*)`){
  RSQLite::dbWriteTable(con, "Order_Details", Order_details, overwrite=TRUE)
  print("New order details are being added")
}


# Order_Item

# Order_Items, product_ID
set.seed(123)
Order_Item <- Order_Item %>% 
  mutate(Product_ID = NA)

# Assign first 150 unique Product_IDs to the first 150 rows
Order_Item$Product_ID[1:150] <- sample(Products$Product_ID, size = 150, replace = FALSE)

# For the remaining 50 rows, randomly assign Product_IDs (allowing repeats)
Order_Item$Product_ID[151:200] <- sample(Products$Product_ID, size = 50, replace = TRUE)

# Joining Order_Item with Products to get the Price for each Product_ID
Order_Item <- merge(Order_Item, Products[, c("Product_ID", "Product_Price")], by = "Product_ID", all.x = TRUE)

Order_Item <- Order_Item %>% rename(Quantity = Order_Item)
# Calculating Sum_Price as Price * Quantity
Order_Item <- Order_Item %>%
  mutate(Sum_Price = Product_Price * Quantity)

# Remove the Product_Price column 
Order_Item$Product_Price <- NULL

# Close the database connection
dbDisconnect(con)

