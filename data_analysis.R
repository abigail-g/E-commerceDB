
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
