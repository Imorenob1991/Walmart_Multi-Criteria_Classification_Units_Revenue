# Walmart_Multi-Criteria_Classification_Units_Revenue
In this repository, we will explore advanced product classification techniques using the Inventorize package in R. Our focus will be on creating two-dimensional classifications based on sales in units and revenue. This dual-dimension analysis will provide deeper insights and enable more informed decision-making regarding product classifications.

## Data Source

First of all, I want to mention that the data was obtained from Kaggle. Kaggle is the world's largest data science community, offering powerful tools and resources to help you achieve your data science goals.

Context: This dataset is openly available for academic purposes. The initial objective of Kaggle was to share historical data and then, through a competition, determine the group that had the best forecast accuracy. In this case, we will use this data for product segmentation. However, it is also an excellent dataset for forecasting and time series analysis.

Link : https://www.kaggle.com/c/m5-forecasting-accuracy/data

## General Understanding of the data from general to specific.

1. States: 3 - California (CA), Texas (TX), and Wisconsin (WI). /Representation of different zones within the United States.
2. Stores: 10
3. Categories: 3 (FOODS, HOBBIES, HOUSEHOLD)
4. Departments: 7 (FOODS_1, FOODS_2, FOODS_3, HOBBIES_1, HOBBIES_2, HOUSEHOLD_1, HOUSEHOLD_2)
5. SKUs: 3.039
6. Date Range (%Y-%m-%d): Between "2011-01-29" to "2016-06-19"

## DATA CLEANING AND PREPARATION 

1. Initial Data Subset: We will begin our analysis by working with a subset of the data (March 2011). By starting with this fraction, we can refine our methodology before applying it to the rest of the months or the entire dataset. This approach will streamline our data cleaning and preparation process, making it more efficient and workable.

2. Pivot Sales Columns: Convert the sales columns into a single column using the pivot_longer() function. This transformation will facilitate more straightforward analysis and manipulation of the sales data.

3. Join with Calendar Data: Perform a left join with the calendar data to incorporate date information. This step will help us align the sales data with specific dates, enhancing our temporal analysis.

4. Join with Sell Prices: Perform a left join with the sell_prices dataset to obtain the prices. This will allow us to calculate revenue (Quantity * Price)

5. Preparing the dataset for the classification functions: Group by the dataset by item_id, summatize two columns Total_quantity, with the sume of the total units and Total_Revenue, with the sume of the total revenue. Finally, we arrange this database in descending order using the new Total_Quantity column.

## DATA ANALYSIS AND INTERPRETATION

### ABC Unit Classification (Only 1 dimension) with the code: ABC from the Inventorize Package

 <img width="673" alt="Graph_ABC_Classification_1_Dimension" src="https://github.com/user-attachments/assets/800e0b94-3564-4c39-bf73-703f12f258c4">

![Table_ABC_Classification_1_Dimension](https://github.com/user-attachments/assets/f86a4fa5-a16a-4d03-bc82-7b6383ece2de)




### ABC Units and Revenue Classification (2 dimensions) with the code: productmix from the Inventorize Package

![Rplot02](https://github.com/user-attachments/assets/54a29a0c-6b54-4ca3-872a-b84da4d979d5)


