
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

# Recreate the chart with Category_Name as a fill for coloring the bars
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

# Save the chart with a modified background color
ggsave(plot = plot1, filename = "product_rating_by_category.jpeg", width = 10, height = 8, dpi = 300)




#top 5 sales

top_5_products_revenue <- dbGetQuery(con, '
SELECT b.Product_ID, 
       c.Product_Name, 
       SUM( a.Sum_Price - b.Discount_Amount) AS Total_Revenue
FROM Order_Items a
LEFT JOIN Discounts b ON a.Product_ID = b.Product_ID
JOIN Products c ON a.Product_ID = c.Product_ID
GROUP BY b.Product_ID, c.Product_Name
ORDER BY Total_Revenue DESC
LIMIT 5
')


# Convert Product_ID to a factor for plotting
top_5_products_revenue$Product_Name <- factor(top_5_products_revenue$Product_Name, levels = top_5_products_revenue$Product_Name)

# Create a bar plot



# Assuming top_5_products_revenue is already populated with the correct data
plot2 <- ggplot(top_5_products_revenue, aes(x = Product_Name, y = Total_Revenue, fill = Product_Name)) +
  geom_bar(stat = "identity", color = "black", width = 0.7) +  # Add border and adjust bar width
  scale_fill_brewer(palette = "Blues", direction = -1) +  # Use a blue color palette from ColorBrewer
  theme_minimal(base_size = 14) +  # Clean theme with larger base font size
  labs(title = "Top 5 Products by Revenue",
       x = "Product Name",
       y = "Total Revenue (£)") +  # Assume currency is GBP
  theme(plot.title = element_text(face = "bold", hjust = 0.5),  # Bold and center the title
        axis.title.x = element_text(face = "bold"),
        axis.title.y = element_text(face = "bold"),
        legend.position = "none",  # Remove the legend since colors correspond to product names
        axis.text.x = element_text(angle = 45, hjust = 1),  # Rotate x-axis labels for readability
        panel.grid.major = element_blank(),  # Remove major grid lines
        panel.grid.minor = element_blank(),  # Remove minor grid lines
        panel.background = element_blank(),  # Remove panel background
        axis.line = element_line(colour = "black"))  # Add axis lines for definition

# Save the plot to a file with high resolution
ggsave("top_5_products_revenue.png", plot = plot2, width = 8, height = 6, dpi = 300)






country_code <- dbGetQuery(con, 'SELECT Cust_Country_Code, COUNT(*) AS Count
FROM Customers
GROUP BY Cust_Country_Code
ORDER BY Count DESC;
')

plot3 <- ggplot(country_code , aes(x = factor(Cust_Country_Code), y = Count, fill = Cust_Country_Code)) +
  geom_col(show.legend = FALSE) + 
  theme_minimal() + 
  labs(title = "Distribution of Customers by Country Code", x = "Country Code", y = "Number of Customers") +
  theme(axis.text.x = element_text(angle = 65, hjust = 1)) 

ggsave(filename = "Cust_Country_Code_Distribution.png", plot = plot3, width = 10, height = 6, dpi = 300)













  




