
# Make sure the necessary libraries are loaded
library(ggplot2)
library(RColorBrewer)
library(RSQLite)

# Establish a connection to the database
con <- dbConnect(RSQLite::SQLite(), "ecommerce.db")

# Run the SQL query to get product ratings count by category
product_rating_count <- dbGetQuery(con, 'SELECT c.Category_Name, a.Product_Rating, COUNT(a.Product_Rating) AS Product_Rating_Count
FROM Reviews a
JOIN Products b ON a.Product_ID = b.Product_ID
JOIN Category c ON b.Category_ID = c.Category_ID
GROUP BY c.Category_Name, a.Product_Rating')

# Convert Product_Rating to a factor for the ggplot
product_rating_count$Product_Rating <- as.factor(product_rating_count$Product_Rating)

# Create Chart 1
plot1 <- ggplot(product_rating_count, aes(x = Product_Rating, y = Product_Rating_Count, fill = Category_Name)) +
  geom_bar(stat = "identity", colour = "black") + # Adding a border
  scale_fill_brewer(palette = "Spectral", direction = -1) + # Using a colorful palette suitable for discrete values
  geom_text(aes(label = Product_Rating_Count), position = position_stack(vjust = 0.5), size = 3.5) + # Adding text labels
  theme_minimal(base_size = 14) + # Adjusting theme and base font size
  labs(title = "Distribution of Product Ratings by Category",
       x = "Product Rating",
       y = "Count of Ratings") +
  theme(plot.background = element_rect(fill = "white"), # Change the background color of the entire plot
        panel.background = element_rect(fill = "white"), # Change the background color of the plot panel
        axis.text.x = element_text(angle = 45, hjust = 1)) # Improve the axis label display

# Save Chart 1
ggsave(plot = plot1, filename = "Images/Product_Rating_By_Category.jpeg", width = 10, height = 8, dpi = 300)



# Top 5 Product Revenue
top_5_products_revenue <- dbGetQuery(con, '
SELECT b.Product_ID, 
       c.Product_Name, 
       SUM(a.Order_Item * c.Product_Price - b.Discount_Amount) AS Total_Revenue
FROM Order_Items a
LEFT JOIN Discounts b ON a.Product_ID = b.Product_ID
JOIN Products c ON a.Product_ID = c.Product_ID
GROUP BY b.Product_ID, c.Product_Name
ORDER BY Total_Revenue DESC
LIMIT 5
')

top_5_products_revenue$Product_Name <- factor(top_5_products_revenue$Product_Name, levels = top_5_products_revenue$Product_Name)

# Create Plot 2
plot2 <- ggplot(top_5_products_revenue, aes(x = Product_Name, y = Total_Revenue, fill = Product_Name)) +
  geom_bar(stat = "identity", color = "black", width = 0.7) + 
  scale_fill_brewer(palette = "Blues", direction = -1) +  
  theme_minimal(base_size = 14) +  
  labs(title = "Top 5 Products by Revenue",
       x = "Product Name",
       y = "Total Revenue (£)") +  
  theme(plot.title = element_text(face = "bold", hjust = 0.5),  
        axis.title.x = element_text(face = "bold"),
        axis.title.y = element_text(face = "bold"),
        legend.position = "none",  
        axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid.major = element_blank(),  
        panel.grid.minor = element_blank(),  
        panel.background = element_blank(),  
        axis.line = element_line(colour = "black"))  

# Save Plot 2
ggsave("Images/Top_5_Products_Revenue.png", plot = plot2, width = 8, height = 6, dpi = 300)


# Customer Phone Country Code Count
country_code <- dbGetQuery(con, 'SELECT Cust_Country_Code, COUNT(*) AS Count
FROM Customers
GROUP BY Cust_Country_Code
ORDER BY Count DESC;
')

# Create Plot 3
<<<<<<< HEAD
plot3 <- ggplot(country_code , aes(x = factor(Cust_Country_Code), y = Count))  +
  geom_col(fill = "blue") + 
  theme_minimal() + 
  labs(title = "Customers Distribution by Phone Country Codes", x = "Customers Phone Numbers Country Codes", y = "Number of Customers") +
=======
plot3 <- ggplot(country_code, aes(x = factor(Cust_Country_Code), y = Count)) +
  geom_col(fill = "skyblue", color = "black", size = 0.5) +  # Set fill color to skyblue and add a black border with size 0.5
  theme_minimal() +
  labs(title = "Customers Distribution by Phone Country Code", x = "Cust Phone Country Code", y = "Number of Customers") +
>>>>>>> 55cc6d87bdb7e507b1dc3aa2be7e13b73980a2a1
  theme(axis.text.x = element_text(angle = 65, hjust = 1))

# Save Plot 3
ggsave(filename = "Images/Cust_Phone_Country_Code_Distribution.png", plot = plot3, width = 10, height = 6, dpi = 300)



# Order Status Count
order_status<- dbGetQuery(con, 'SELECT Order_Status, COUNT(*) AS Count
FROM Order_Details
GROUP BY Order_Status
ORDER BY Count DESC;
')

# Create Plot 4
plot4 <- ggplot(order_status, aes(x = Order_Status, y = Count)) +
  geom_bar(stat = "identity", fill = "#0072B2", color = "black", size = 0.5) + # Darker blue fill color
  theme_minimal(base_size = 14) +
  labs(title = "Order Status Count", x = "Order Status", y = "Count") +
  coord_flip() +
  theme(plot.background = element_rect(fill = "white"),
        panel.background = element_rect(fill = "white"),
        axis.text.y = element_text(angle = 0, hjust = 1)) +
  scale_y_continuous(labels = scales::comma) 

# Save Plot 4
ggsave("Images/Order_Status_Distribution.png", plot = plot4, width = 10, height = 6, dpi = 300)
