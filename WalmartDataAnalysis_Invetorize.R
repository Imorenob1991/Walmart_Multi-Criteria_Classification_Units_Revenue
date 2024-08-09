
# Walmart Sales Goods Data Analysis

## First Step is to activate all the packages that we will need to use

library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(scales)
library(inventorize) #Now we are going to use this package for product segmentation

## Importing our data-sets and general exploratory analysis

sell_prices <- read_csv("sell_prices.csv")
sales_train_validation <- read_csv("sales_train_validation.csv")
### sales_train_evaluation <- read_csv("sales_train_evaluation.csv")
calendar<- read_csv("calendar.csv")
### sample_submission <- read_csv("sample_submission.csv")

## Original description of data-sets

### 1. calendar.csv - Contains information about the dates on which the products are sold.
glimpse(calendar) # Key is "d" attribute

### 2. sales_train_validation.csv - Contains the historical daily unit sales data per product and store [d_1 - d_1913]
### It would be easier to work with the Unit Sales only one Columns (Now we have 1.913), but we will have a huge Data-set. Lets start with one month and then reply the query to the rest of the data-set.
glimpse(sales_train_validation)

### 3. sample_submission.csv - The correct format for submissions. Reference the Evaluation tab for more info.
### Is the format for the output of the initial assignment, in this analysis will be omitted.

### 4. sell_prices.csv - Contains information about the price of the products sold per store and date.
### After wrangling the sales_train_validation, we can add this information of prices, to obtain revenue.
glimpse(sell_prices) # Key is a join of three columns (store_id + item_id + wm_yr_wk)

## 5. sales_train_evaluation.csv - Includes sales [d_1 - d_1941] (labels used for the Public leader board)
### In this case, we will work only with the database sales_train_validation.csv 

## 1. GENERAL UNDERSTANDING OF THE DATA

### TOTAL SKUs
length(table(sales_train_validation$item_id)) # Total of 3.049 SKUS

### TOTAL Stores 
length(table(sales_train_validation$store_id)) # Total of 10 Stores

### Total Department or categories ID
Departments <- table(sales_train_validation$dept_id)
DF_Departments <- data.frame(Departments)

### FOODS_(1:3) + HOBBIES(1:2) + HOUSEHOLD(1:2) - Total 7 Subcategories or Departments

Categories <- table(sales_train_evaluation$cat_id)

### FOODS + HOBBIES + HOUSEHOLD - Total 3 Categories.

### States: CA(California) - TX(Texas) - WI(Wisconsin)

States <- table(sales_train_evaluation$state_id)

### Dates Range
min(calendar$date)
max(calendar$date)

## 2. DATA CLEANING AND PREPARATION

### To the initial analysis, we are going to filter 1 Month. Actually, we have 1.913 days that represent approximately 64 months
### We are going to choose March of 2011

Calendar_March_2011 <- calendar %>% filter(date >= "2011-03-01" & date <="2011-03-31" )

### Now we have to determine the D_Columns that correspond to March 2011

Calendar_March_2011$d

sales_train_validation_March_2011 <- sales_train_validation %>%
  select(id, item_id, dept_id, cat_id, store_id, state_id,
         d_32, d_33, d_34, d_35, d_36, d_37, d_38, d_39, d_40, d_41, d_42,
         d_43, d_44, d_45, d_46, d_47, d_48, d_49, d_50, d_51, d_52, d_53,
         d_54, d_55, d_56, d_57, d_58, d_59, d_60, d_61, d_62)

### With pivot table (Pivot_longer) convert all the Columns Days into one Attribute

sales_train_validation_March_2011 <- sales_train_validation_March_2011 %>%
  pivot_longer(cols = starts_with("d_"),
               names_to = "day",
               values_to = "Unit_Sales") %>% 
  filter(Unit_Sales > 0) # Very important, to minimice size of the new data base.

### Join with Calendar Data Frame to obtain more information about day week and week

colnames(sales_train_validation_March_2011)

sales_train_validation_March_2011 <- sales_train_validation_March_2011 %>%
  left_join(Calendar_March_2011, by = c("day" = "d")) %>% 
  select(id,item_id,dept_id,cat_id,store_id,state_id,day,Unit_Sales,date,wm_yr_wk,weekday,wday,month,year)

### Finally, we are going to add the sell_price of each product and calculate Revenue (Quantity*Price). To be able to make a classification based on units and revenue.

colnames(sell_prices)

sales_train_validation_March_2011 <- sales_train_validation_March_2011 %>%
  left_join(sell_prices, by = c("store_id", "item_id", "wm_yr_wk")) %>%
  mutate(revenue = Unit_Sales * sell_price)

### Now we have to check if we have NA and the final structure of our dataframe. Check if the datatypes are right.

glimpse(sales_train_validation_March_2011) # OK with all the date types

sum(is.na(sales_train_validation_March_2011$Unit_Sales)) # No NA
sum(is.na(sales_train_validation_March_2011$sell_price)) # No NA
sum(is.na(sales_train_validation_March_2011$revenue)) # No NA

write_csv(sales_train_validation_March_2011,"March_2011_Data_Frame.csv")

### Data set Preparation before applying the ABC and the product mix classification formulas

colnames(sales_train_validation_March_2011)

Classification_Input_Table <- sales_train_validation_March_2011 %>% group_by(item_id) %>% 
  summarise(Total_Quantity = sum(Unit_Sales, na.rm = TRUE),
            Total_Revenue = sum(revenue, na.rm = TRUE)) %>% 
  arrange(desc(Total_Quantity))

## 3. DATA ANALYSIS AND INTERPRETATION - Using ABC Inventorize.

ABC_Classification_Table <- ABC(Classification_Input_Table[,c(2,3)],
                                na.rm = TRUE,
                                plot = TRUE)


Final_ABC_Classification_Table <- ABC_Classification_Table %>% group_by(category) %>% 
  summarise(SKUs = n(),
            Unit_Sale = sum(Total_Quantity),
            Percentage_Sales = sum(percentage)*100) %>% 
  mutate(Percentage_SKUs = SKUs/sum(SKUs)*100) %>% 
  mutate(Cumulative_SKUs1 = cumsum(Percentage_SKUs),
         Cumulative_Sales1 = cumsum(Percentage_Sales))

zero_point2 <- data.frame(category = "", SKUs = 0, Unit_Sale = 0, Percentage_Sales = 0, Percentage_SKUs = 0, Cumulative_SKUs1 = 0, Cumulative_Sales1 = 0)

Final_ABC_Classification_Table <- bind_rows(zero_point2, Final_ABC_Classification_Table)

### Plotting ABC_Classification_Units_All_Stores_All_SKUs

ggplot(Final_ABC_Classification_Table, aes(x = Cumulative_SKUs1, y = Cumulative_Sales1, label = category)) +
  geom_point(size = 3) +  # Scatter plot points
  geom_text(vjust = -0.5, hjust = 0.8, color = "black", fontface = "bold") +
  geom_smooth(method = "lm", formula = y ~ poly(x, 3), se = FALSE, color = "grey") +
  labs(title = "ABC_Classification_Total_SKU_STORES_UNITS",
       x = "Cumulative_SKU (%)",
       y = "Cumulative_Sales (%)") +
  scale_x_continuous(limits = c(0, 110), breaks = seq(0, 100, by = 10)) +  # Set x-axis limit and breaks
  scale_y_continuous(limits = c(0, 110), breaks = seq(0, 100, by = 10)) +  # Set y-axis limit and breaks
  theme_minimal() +
  annotate("point", x = 0, y = 0, size = 3, color = "black") +  # Add (0,0) point
  annotate("text", x = 0, y = 0, label = "(0,0)", vjust = -0.5, hjust = 0.5, color = "grey", fontface = "bold")  # Label for (0,0) point

library(kableExtra)

colnames(Final_ABC_Classification_Table)

Final_ABC_Classification_Table <- Final_ABC_Classification_Table %>%
  mutate(
    Unit_Sale = scales::number(Unit_Sale, accuracy = 1, big.mark = ","),  # Thousand separator
    Percentage_Sales= scales::number(Percentage_Sales, accuracy = 0.1),    # One decimal place
    Percentage_SKUs= scales::number(Percentage_SKUs, accuracy = 0.1),      # One decimal place
    Cumulative_SKUs1= scales::number(Cumulative_SKUs1, accuracy = 0.1),    # One decimal place
    Cumulative_Sales1= scales::number(Cumulative_Sales1, accuracy = 0.1)   # One decimal place
  )

# Generate a table

Final_ABC_Classification_Table[2:4,] %>%
  select(
    category, Unit_Sale, Percentage_Sales, SKUs, Percentage_SKUs
  ) %>%
  mutate(across(everything(), ~ cell_spec(., align = "center"))) %>%
  kable("html", escape = FALSE, table.attr = "style='width:50%; margin-left:auto; margin-right:auto;'") %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
  row_spec(0, align = "center")  # Center header


### SCOPE Analysis N°2: Multi-Product segmentation using two variables (Units Sales and Revenue)

Revenue_Sales_Classification_Data <- productmix(SKUs = Classification_Input_Table$item_id,
                                             sales = Classification_Input_Table$Total_Quantity,
                                             revenue = Classification_Input_Table$Total_Revenue,
                                             na.rm = TRUE,
                                             plot = TRUE)

Table_Revenue_Sales_Classification <- Revenue_Sales_Classification_Data %>% group_by(product_mix) %>% 
  summarise(Total_Unit_Sales = sum(sales),
            Total_Revenue = sum(revenue),
            sku = n()) %>% 
  mutate(Percentage_SKUs = sku/sum(sku)*100,
         Percentage_Sales = Total_Unit_Sales/sum(Total_Unit_Sales)*100,
         Percentage_Revenue = Total_Revenue/sum(Total_Revenue)*100) 


b <- Revenue_Sales_Classification_Data %>% ggplot(aes(product_mix)) + geom_bar(fill = "darkblue",color = "white")

ggplotly(b)

### Generating a Table to see the results


#Changing Column names
colnames(Table_Revenue_Sales_Classification)

Table_Revenue_Sales_Classification <- Table_Revenue_Sales_Classification %>%
  rename(
    ProductMix = product_mix,
    TotalUnits = Total_Unit_Sales,
    TotalRevenue = Total_Revenue,
    SKU = sku,
    SKU_Percent = Percentage_SKUs,
    Sales_Percent = Percentage_Sales,
    Revenue_Percent = Percentage_Revenue
  )

# Correcting the datatype from character to numeric
Table_Revenue_Sales_Classification <- Table_Revenue_Sales_Classification %>%
  mutate(
    SKU = as.numeric(SKU),
    SKU_Percent = as.numeric(SKU_Percent),
    TotalUnits = as.numeric(TotalUnits),
    Sales_Percent = as.numeric(Sales_Percent),
    TotalRevenue = as.numeric(TotalRevenue),  
    Revenue_Percent = as.numeric(Revenue_Percent)
  )

#Generating the total row
total_row <- Table_Revenue_Sales_Classification %>%
  summarise(
    ProductMix = "Total",
    SKU = sum(SKU, na.rm = TRUE),, # Assuming SKU is not summed
    SKU_Percent = sum(SKU_Percent, na.rm = TRUE),
    TotalUnits = sum(TotalUnits, na.rm = TRUE),
    Sales_Percent = sum(Sales_Percent, na.rm = TRUE),
    TotalRevenue = sum(TotalRevenue, na.rm = TRUE),
    Revenue_Percent = sum(Revenue_Percent, na.rm = TRUE)
  )

#Bind the new row to the Data-Frame

Table_Revenue_Sales_Classification <- bind_rows(
  Table_Revenue_Sales_Classification,
  total_row
) 


#Modify the format of the Final Table
Table_Revenue_Sales_Classification <- Table_Revenue_Sales_Classification %>%
  mutate(
    TotalUnits = scales::number(TotalUnits, accuracy = 1, big.mark = "."),  # Thousand separator
    SKU = scales::number(SKU, accuracy = 1, big.mark = "."),  # Thousand separator
    TotalRevenue = scales::number(TotalRevenue, accuracy = 1, big.mark = "."),  # Thousand separator
    SKU_Percent= scales::number(SKU_Percent, accuracy = 1),    # One decimal place
    Sales_Percent= scales::number(Sales_Percent, accuracy = 1),      # One decimal place
    Revenue_Percent= scales::number(Revenue_Percent, accuracy = 1)   # One decimal place
  ) %>% select(ProductMix,SKU,SKU_Percent,TotalUnits,Sales_Percent,TotalRevenue,Revenue_Percent)


#Finally, generating the Table to use as output to the Github Repository

Table_Revenue_Sales_Classification  %>%
  mutate(across(everything(), ~ cell_spec(., align = "center"))) %>%
  kable("html", escape = FALSE, table.attr = "style='width:50%; margin-left:auto; margin-right:auto;'") %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
  row_spec(0, align = "center")  # Center header








