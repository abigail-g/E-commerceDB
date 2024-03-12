#the distribution of counts by order date

# Create a histogram of Order Dates
ggplot(Order_details, aes(x = Order_Date)) +
  geom_histogram(color = "black", fill = "blue") +
  theme_minimal() +
  labs(title = "Distribution of Order Dates", x = "Order Date", y = "Count")

