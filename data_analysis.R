#the distribution of counts by order date
library(ggplot2)
library(readr)

#rmarkdown::render('E-commerceDB.Rmd')

library(ggplot2)
library(RColorBrewer)

con <- dbConnect(RSQLite::SQLite(), "ecommerce.db")

product_rating_count <- dbGetQuery(con, 'SELECT Product_Rating, COUNT(Product_Rating) AS Product_Rating_Count
FROM Reviews
GROUP BY Product_Rating')

library(ggplot2)
library(RColorBrewer)

product_rating_count$Product_Rating <- as.factor(product_rating_count$Product_Rating)
# Recreate the chart with a modified background color
plot1 <- ggplot(product_rating_count, aes(x = Product_Rating, y = Product_Rating_Count, fill = Product_Rating)) +
  geom_bar(stat = "identity", colour = "black") + # Adding a border
  scale_fill_brewer(palette = "Spectral") + # Using a colorful palette
  geom_text(aes(label = Product_Rating_Count), vjust = -0.5, size = 3.5) + # Adding text labels
  theme_minimal(base_size = 14) + # Adjusting theme and base font size
  labs(title = "Distribution of Product Ratings",
       x = "Product Rating",
       y = "Count of Ratings") +
  theme(plot.background = element_rect(fill = "white"), # Change the background color of the entire plot
        panel.background = element_rect(fill = "white"), # Change the background color of the plot panel
        axis.text.x = element_text(angle = 45, hjust = 1)) # Improve the axis label display

# Save the chart
ggsave(plot = plot1, filename = "product_rating.jpeg", width = 10, height = 8, dpi = 300)

