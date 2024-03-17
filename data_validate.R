# Functions to be performed:

# 1. read csv data 
# 2. checks for data quality and integrity, such as validation of email formats, checking for duplicate entries, and ensuring 
#    referential integrity

library(DBI)
library(readr)
library(dplyr)

# Checks for data quality and integrity using regular expressions to validate email addresses and phone numbers.

# List all CSV files in the "data" folder
csv_files <- list.files(path = "Files", pattern = "\\.csv$", full.names = TRUE)

# Iterate through each CSV file
for (file in csv_files) {
  # Extract the file name without extension
  file_name <- tools::file_path_sans_ext(basename(file))
  
  print(paste("CHECKING FILE :  ", file_name))
  
  # Read the CSV file into a data frame and assign it the same name as the CSV file
  assign(file_name, read.csv(file))
  
  # Check for columns that are likely to contain email addresses and validate
  emailCols <- grep("Email$", colnames(get(file_name)), value = TRUE)
  
  if (length(emailCols) > 0) { # Proceed only if there are relevant email columns
    for (col in emailCols) {
      df <- get(file_name)[col]
      
      # Check for invalid emails
      invalidEmails <- grep("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", df[,1], value= FALSE, invert = TRUE)
      
      if (length(invalidEmails)>0 ){
        cleaned_data  <- get(file_name)[-invalidEmails, ]
        write.csv(cleaned_data, file, row.names = FALSE)
        print("---Invalid emails found and removed")
      } else {
        print("---No invalid emails exist")
      }
    }
  }
  
  # Check for phone number column and validate
  phoneNumCol <- grep("Phone", colnames(get(file_name)), value = TRUE)
  
  if (length(phoneNumCol) > 0) # Proceed only if there is a value
  {
    for (Numcol in phoneNumCol) {
      df <- get(file_name)[Numcol]
      # Check for invalid numbers
      invalidPhoneNums <- grep("[0-9]{8}", df[,1], value= FALSE, invert = TRUE)
      
      if (length(invalidPhoneNums)>0 ){
        cleaned_data  <- get(file_name)[-invalidPhoneNums, ]
        write.csv(cleaned_data, file, row.names = FALSE)
        print("---Invalid phone numbers found and removed")
      } else {
        print("---No invalid phone numbers exist")
      }
    }
  }
  
  #check for duplicate entries
  if(file_name != "Order_Item"){
    duplicate_entries <- get(file_name)[duplicated(get(file_name)), ]
    
    if (count(duplicate_entries)$n > 0) {
      cleaned_data <- distinct(get(file_name))
      write.csv(cleaned_data, file, row.names = FALSE)
      print("---Duplicate entries found and removed.\n")
    } else {
      print("---No duplicate entries found in the data")
    }
  }
  
  #ensuring primary key integrity
  ID_columns <- grep("ID", colnames(get(file_name)), value = TRUE)
  
  if (length(ID_columns) > 0) {
    for(col in ID_columns){
      df <- get(file_name)[col]
      duplicate_indices <- which(duplicated(df) | duplicated(df, fromLast = TRUE))
      if (length(duplicate_indices) > 0) {
        cleaned_data <- get(file_name)[-duplicate_indices, ]
        write.csv(cleaned_data, file, row.names = FALSE)
        print("---Duplicate values found in the primary key attribute and removed\n")
      }
    }
  }
  
}