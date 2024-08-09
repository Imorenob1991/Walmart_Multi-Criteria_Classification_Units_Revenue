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

    - A Products: 43.7% of SKUs generate 80% of total sales in units. These are the fast-moving goods in Walmart stores in terms of units.
    
    - B Products: 28.1% of SKUs generate 15% of total sales in units. These are the regular/medium-moving goods in Walmart stores in term of units.
    
    - C Products: 28.2% of SKUs generate 5% of total sales in units. These are the slow-moving goods in Walmart stores in terms of units.

### Some Questions and additional insights is generated from the analysis:
1. ¿Are there B or C products that are slow movers but have a high contribution to sales in terms of revenue?
2. ¿Are there A products that do not contribute significantly in terms of revenue?

To answer these questions, a deeper analysis is required using a two-dimensional classification that considers both sales in units and revenue.

## ABC Units and Revenue Classification (2 dimensions) with the code: productmix from the Inventorize Package

Identyfing ABC category based on the pareto rule for both units and revenue ,a mix of nine categories are produced. Identyfing ABC category based on the pareto rule. 
1. ABC Classification in tearms of units.
2. ABC Classification in tearms of Revenue.
3. Finally with this two new attributes, generate a join ("_") with these new 9 categories. 

![Rplot02](https://github.com/user-attachments/assets/54a29a0c-6b54-4ca3-872a-b84da4d979d5)

#### A_A Products: 28% of SKUs generate 67% of total sales in units and 62% of total revenue. These are our star products, fast-moving and high-revenue contributors – High service level target.
#### A_B Products: 7% of SKUs generate 11% of total sales in units and 4% of total revenue. Fast-moving products that have a medium impact in terms of revenue – High service level target.
#### A_C Products: 1% of SKUs generate 2% of total sales in units and 0.2% of total revenue. Fast-moving products with a low ticket price (e.g., Toilet Paper).
#### B_A Products: 14% of SKUs generate 7% of total sales in units and 17% of total revenue. Medium-moving goods with a high impact on revenue – High service level target (e.g., iPhone).
#### B_B Products: 13% of SKUs generate 6% of total sales in units and 7% of total revenue. Medium-moving goods with a moderate impact in terms of revenue.
#### B_C Products: 4% of SKUs generate 2% of total sales in units and 1% of total revenue. Medium-moving products with a low ticket price.
#### C_A Products: 2% of SKUs generate 0.1% of total sales in units and 2% of total revenue. Slow-moving goods with a high impact in terms of revenue.
#### C_B Products: 8% of SKUs generate 2% of total sales in units and 4% of total revenue. Slow-moving goods with a low impact in terms of revenue.
#### C_C Products: 23% of SKUs generate 3% of total sales in units and 4% of total revenue. Slow-moving goods with a low impact in terms of revenue.









