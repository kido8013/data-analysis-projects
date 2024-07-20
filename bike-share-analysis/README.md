# Cyclistic Bike-Share Analysis

# Overview
This project involves analyzing Cyclistic bike-share data to understand how different types of customers (casual riders vs annual members) use the service. The goal is to design strategies to convert casual riders into annual members.

## Table of Contents
- [Data](#data)
- [Visualizations](#visualizations)
- [Analysis](#analysis)
- [Findings](#findings)
- [Recommendations](#recommendations)
- [Conclusion](#conclusion)

## Data Source
The data used in this analysis comes from Cyclistic's bike-share system, encompassing historical bike trip data over the past 12 months. The dataset includes information such as trip duration, start and end times, starting and ending stations, and user type (casual or member).

## Libraries Used
```
library(tidyverse)  # Data cleaning
library(lubridate)  # Date manipulation
library(hms)        # Time manipulation
library(data.table) # Exporting data
library(readr)      # Reading CSV files
```

**Data Preparation**
Loading and Merging Data
## Load monthly data files
```
X202307_divvy_tripdata <- read_csv("202307-divvy-tripdata.csv")
X202308_divvy_tripdata <- read_csv("202308-divvy-tripdata.csv")
X202309_divvy_tripdata <- read_csv("202309-divvy-tripdata.csv")
X202310_divvy_tripdata <- read_csv("202310-divvy-tripdata.csv")
X202311_divvy_tripdata <- read_csv("202311-divvy-tripdata.csv")
X202312_divvy_tripdata <- read_csv("202312-divvy-tripdata.csv")
X202401_divvy_tripdata <- read_csv("202401-divvy-tripdata.csv")
X202402_divvy_tripdata <- read_csv("202402-divvy-tripdata.csv")
X202403_divvy_tripdata <- read_csv("202403-divvy-tripdata.csv")
X202404_divvy_tripdata <- read_csv("202404-divvy-tripdata.csv")
X202405_divvy_tripdata <- read_csv("202405-divvy-tripdata.csv")
X202406_divvy_tripdata <- read_csv("202406-divvy-tripdata.csv")
```

## Merge files into a single data frame
```
bike_analysis_12_months <- rbind(X202307_divvy_tripdata, X202308_divvy_tripdata, X202309_divvy_tripdata,
                                 X202310_divvy_tripdata, X202311_divvy_tripdata, X202312_divvy_tripdata,
                                 X202401_divvy_tripdata, X202402_divvy_tripdata, X202403_divvy_tripdata,
                                 X202404_divvy_tripdata, X202405_divvy_tripdata, X202406_divvy_tripdata)
```

## Remove individual monthly data frames from the environment
```
remove(X202307_divvy_tripdata, X202308_divvy_tripdata, X202309_divvy_tripdata,
       X202310_divvy_tripdata, X202311_divvy_tripdata, X202312_divvy_tripdata,
       X202401_divvy_tripdata, X202402_divvy_tripdata, X202403_divvy_tripdata,
       X202404_divvy_tripdata, X202405_divvy_tripdata, X202406_divvy_tripdata)
```

## Copy the merged data frame for further analysis
```
bike_analysis_12_months_v2 <- bike_analysis_12_months
```
# Data

## Data Cleaning and Manipulation

```
#remove duplicate rows
bike_analysis_12_months_v2 <- distinct(data_12_months_2)
#remove null values
bike_analysis_12_months_v2 <- na.omit(data_12_months_2)
#remove rows where ride_length <= 0
bike_analysis_12_months_v2 <- data_12_months_2[!(data_12_months_2$ride_length <=0),]
#remove unused columns
bike_analysis_12_months_v2 <- data_12_months_2 %>%  
  select(-c(ride_id, start_station_id, end_station_id, start_lat, start_lng, end_lat, end_lng))
```
  
```
#Convert start and end times to POSIXct format, calculate ride length, and add day of the week
bike_analysis_12_months_v2 <- bike_analysis_12_months_v2 %>% 
  mutate(started_at = as.POSIXct(started_at, format="%Y-%m-%d %H:%M:%S"),
         ended_at = as.POSIXct(ended_at, format="%Y-%m-%d %H:%M:%S"),
         ride_length = difftime(ended_at, started_at, units = "mins"),
         day_of_week = wday(started_at, label = TRUE)) %>%
  filter(!is.na(ride_length) & ride_length > 0)
```

## Summarize the data by membership type
```
bike_analysis_summary <- bike_analysis_12_months_v2 %>%
  group_by(member_casual) %>%
  summarize(mean_ride_length = mean(ride_length))
```

## Export the cleaned data
```
fwrite(bike_analysis_12_months_v2, "bike_analysis_12_months_v2.csv")
```

# Visualizations
Visualizations were made in Tableau creating tables to display total rides by month and day, ride length by day of the week, and total rides by each rideable type. Visualizations were used to draw conclusions and visualize data for analysis. 

![Bike Share Analysis Dashboard](https://github.com/user-attachments/assets/527c658a-d3d5-4f90-9f2d-ec0f1cf565bf)

For full dashboard access on Tableau, please use the direct link: https://public.tableau.com/views/BikeShareRentalAnalysis/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

# Analysis
The business question this study seeks to answer is, how does bicycle use differ between annual members and casual riders with the goal to design strategies to convert casual riders into annual members.

# Findings 

Key findings from the analysis include:

*Annual members commuted by bicycle on weekdays while casual riders commuted mostly on weekends. 
*Casual riders were more likely to commute by bicycle in the warmer seasons while annual members consistently rode throughout the year. 
*Average ride length increased during the weekends vs the weekdays. 

# Recommendations

I would recommend the following to increase member use:

1. **Targeted Marketing at Popular Stations**
Promote membership benefits and exclusive features at stations frequently used by casual riders to highlight the advantages of becoming an annual member.

2. **Offer Seasonal Discounts and Promotions**
Provide limited-time discounts and promotional offers for casual riders during late Spring and early Summer to maximize high use seasons.

3. **Conduct Outreach to High-Traffic Areas**
Engage with local businesses and organizations in high-traffic areas to promote cycling as a convenient commuting option and offer special corporate membership rates.

4. **Promotional Upgrade Offers for Casual Riders**
Target casual users with promotional offers to upgrade to full membership, focusing on the more popular cities where casual ridership is highest.

# Conclusion

The analysis provided valuable insights into the differences in usage patterns between casual riders and annual members. Implementing the proposed strategies could help increase annual memberships and overall customer satisfaction.
