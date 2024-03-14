#the distribution of counts by order date
library(ggplot2)
library(readr)

#rmarkdown::render('E-commerceDB.Rmd')

Order_details <- read_csv("Files/Order_Details.csv",skip = 1)

# Create a histogram of Order Dates
plot1 <- ggplot(Order_details, aes(x = Order_Date)) +
  geom_histogram(color = "black", fill = "blue") +
  theme_minimal() +
  labs(title = "Distribution of Order Dates", x = "Order Date", y = "Count")

ggsave(plot = plot1, width = 10, height = 8, dpi = 300,
       filename =  "Order_Date_Histogram.jpeg")

