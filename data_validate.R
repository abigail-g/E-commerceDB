# Functions to be performed:

# 1. read csv data 
# 2. checks for data quality and integrity, such as validation of email formats, checking for duplicate entries, and ensuring 
#    referential integrity

library(DBI)

# Checks for data quality and integrity using regular expressions to validate email addresses and phone numbers.

# Check quality of stored emails 

con <- dbConnect(RSQLite::SQLite(), "ecommerce.db")

# List all tables
tables <- dbListTables(con)

for (tableName in tables) {
  # Fetch the table
  query <- paste0("SELECT * FROM ", tableName)
  tableData <- dbGetQuery(con, query)
  
  # Check for columns that are likely to contain email addresses and validate
  emailCols <- grep("Cust_Email|Supplier_Email", names(tableData), value = TRUE)
  
  if (length(emailCols) > 0) { # Proceed only if there are relevant email columns
    for (col in emailCols) {
      # Check for invalid emails
      invalidEmails <- !grepl("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", tableData[[col]])
      
      if (any(invalidEmails)) {
        warning(paste("Invalid emails found in", col, "of table", tableName))
      } else {
        message(paste("No invalid emails exist in", col, "of table", tableName))
      }
    }
  }
  
  # Check for phone number column and validate
  phoneNumCol <- grep("Cust_Phone_Number", names(tableData), value = TRUE)
  
  if (length(phoneNumCol) > 0) # Proceed only if there is a value 
    { 
    for (Numcol in phoneNumCol) {
      # Check for invalid numbers
      invalidPhoneNums <- !grepl("^\\+?1?[-.\\s]?\\(?\\d{3}\\)?[-.\\s]?\\d{3}[-.\\s]?\\d{4}$", tableData[[col]])
      
      if (any(invalidPhoneNums)) {
        warning(paste("Invalid phone numbers found in", Numcol, "of table", tableName))
      } 
      else {
        message(paste("No invalid numbers found in", Numcol, tableName))
      }
    }
}
}
# Close Connection
dbDisconnect(con)




