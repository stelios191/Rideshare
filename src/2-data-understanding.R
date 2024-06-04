library('ProjectTemplate')
load.project()

# Providing an overview of the data, including the number of rows and columns, variable names, data types
str(RideShare_train)

###########################################
######### descriptive Statistics ##########
###########################################

# summarizing the data set's key features, such as mean, median, variance, and range
summary(RideShare_train)

# cleaner view of the summary Descriptive Statistics just for the numeric variables
summary_data = RideShare_train %>% 
  within(rm(timestamp, datetime)) %>%
  drop_na(price) %>% 
  select_if(is.numeric) 

data.frame(
  Min = apply(summary_data, 2, min), # minimum
  Q1 = apply(summary_data, 2, quantile, 1/4), # First quartile
  Med = apply(summary_data, 2, median), # median
  Mean = apply(summary_data, 2, mean), # mean
  Q3 = apply(summary_data, 2, quantile, 3/4), # Third quartile
  Max = apply(summary_data, 2, max) # Maximum
  ) %>% round(1)

# Checking the number of rides per Categorical variables of the dataset
plot_bar(RideShare_train) # There is some class imbalance in the "short_summary" variable

# Checking the total amount of money per Categorical variables of the dataset
plot_bar(RideShare_train, with = "price") 


#######################################
####### correlation Analysis ##########
#######################################

# Correlation of Price variable with other variables
numeric_features %>% 
  cor() %>% 
  round(3) %>% 
  as.data.frame() %>%
  select_at(.vars = "price") %>%
  ggcorrplot(title = "Correlation Matrix of Price with all the numeric variables",
             tl.cex = 7) 


# https://sparkbyexamples.com/r-programming/r-group-by-multiple-columns-or-variables/#:~:text=Group%20By%20Multiple%20Columns%20in,it%20using%20library(dplyr)%20.
# https://r-statistics.co/ggplot2-Tutorial-With-R.html

##########################################
###### Principal Component Analysis ######
##########################################


# Split the dataset into predictor variables and response variable
x <- within(df_train, rm(price)) # Select the predictor variables
y <- df_train$price   # Select the response variable

# Perform PCA
pca <- PCA(x, graph = FALSE)

# Plot the scree plot to visualize the variance explained by each principal component
barplot(pca$eig[, 2], names.arg=1:nrow(pca$eig), 
        main = "Variance explained by each Principal component",
        xlab = "Principal Components",
        ylab = "Percentage of variances",
        col ="steelblue")
# Add connected line segments to the plot
lines(x = 1:nrow(pca$eig), pca$eig[, 2], 
      type="b", pch=19, col = "red")

# PCA graph of variables
plot(pca, choix = "var")

# Select the top k principal components that explain most of the variance
k <- 5
top_pcs <- pca$var$coord[1:nrow(pca$var$coord), 1:k]

# Transform the predictor variables into the new space defined by the top k principal components
x_transformed <- as.matrix(x) %*% top_pcs

# Concatenate the transformed predictor variables and response variable into a new dataframe
data_transformed <- data.frame(x_transformed, y)


###########################################
######## Exploratory Data Analysis ########
###########################################

####### Temporal Features #######

# Heat map of the average price of rides per hour of each day of the month (Cost)
RideShare_train %>%
  drop_na(price) %>%
  group_by(day,hour) %>%
  summarise(avg_price=mean(price)) %>% 
  ggplot(aes(x = day, y = hour, fill = avg_price)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  labs(x = "Day of the Month", y = "Hour of the Day", fill = "Average Price")+
  scale_x_discrete(guide = guide_axis(angle = 90))+ 
  ggtitle("Average price per hour of each day of the month")# the dataset doesn't have data for all days of a month
                                                            # this could affect the relevance of this temporal feature

####### Location & Distance Features #######

grid.arrange(
  
  # Heat map of the frequency of rides from Source to Destination areas (Demand)
  RideShare_train %>%
    count(source, destination) %>% 
    ggplot(aes(x = source, y = destination, fill = n)) +
    geom_tile() +
    scale_fill_gradient(low = "white", high = "red") +
    labs(x = "Starting Location", y = "Destination", fill = "Frequency")+
    scale_x_discrete(guide = guide_axis(angle = 90))+ 
    ggtitle("Number of rides requested from and to each location"),
  
  # Heat map of the average price of rides from Source to Destination areas (Cost)
  RideShare_train %>%
    drop_na(price) %>%
    group_by(source,destination) %>%
    summarise(avg_price=mean(price)) %>% 
    ggplot(aes(x = source, y = destination, fill = avg_price)) +
    geom_tile() +
    scale_fill_gradient(low = "white", high = "red") +
    labs(x = "Starting Location", y = "Destination", fill = "Average Price")+
    scale_x_discrete(guide = guide_axis(angle = 90))+ 
    ggtitle("Average price of a ride from and to each location"),
  
  ncol=2
)


# Short Weather Summary
grid.arrange(
  # Average price for each weather condition
  RideShare_train %>%
    drop_na(price) %>% 
    group_by(short_summary) %>% 
    summarise(avg_price=mean(price)) %>%
    ggplot(aes(short_summary, avg_price))  + geom_bar(stat = "identity")+
    scale_x_discrete(guide = guide_axis(angle = 90)) +
    labs(x = "Short Weather Summary", y = "Average Price"),
  # Number of rides for each weather condition
  RideShare_train %>%
    count(short_summary) %>% 
    ggplot(aes(short_summary, n))  + geom_bar(stat = "identity")+
    scale_x_discrete(guide = guide_axis(angle = 90)) +
    labs(x = "Short Weather Summary", y = "Number of Rides (Demand)"),
  nrow = 2
)


# Surge Multiplier
grid.arrange(
  # Average price for each weather condition
  RideShare_train %>%
    drop_na(price) %>% 
    group_by(surge_multiplier) %>%
    mutate_at(c("surge_multiplier"), as.factor) %>%
    summarise(avg_price=mean(price)) %>%
    ggplot(aes(surge_multiplier, avg_price))  + geom_bar(stat = "identity")+
    scale_x_discrete(guide = guide_axis(angle = 90)) +
    labs(x = "Surge Multiplier", y = "Average Price")+
    geom_text(aes(label = round(avg_price, 2), y = avg_price), 
              vjust = -0.5, size = 3),
  # Number of rides for each weather condition
  RideShare_train %>%
    count(surge_multiplier) %>% 
    mutate_at(c("surge_multiplier"), as.factor) %>%
    ggplot(aes(surge_multiplier, n))  + geom_bar(stat = "identity")+
    scale_x_discrete(guide = guide_axis(angle = 90)) +
    labs(x = "Surge Multiplier", y = "Number of Rides (Demand)")+
    geom_text(aes(label = round(n, 2), y = n), 
              vjust = -0.5, size = 3),
  nrow = 2
)
