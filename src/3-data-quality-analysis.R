library('ProjectTemplate')
load.project()

#####################################
########## Missing Values ###########
#####################################

# percentage of null rows per column (variable) - Training set
as.data.frame((colMeans(is.na(RideShare_train)))*100) %>%
  ggplot(aes(x = rownames(.), y = .[,1])) +
  geom_bar(stat = "identity", colour=rainbow(34)) +
  scale_x_discrete(guide = guide_axis(angle = 90)) +
  xlab("Dataset Columns") +
  ylab("Percentage of nulls (%)") + 
  ggtitle("Percentage of null rows per column - Training set") # column price needs cleaning
                                                               # and the 2 date columns should be dropped

# percentage of null rows per column (variable) - Testing set
as.data.frame((colMeans(is.na(RideShare_test)))*100) %>% 
  ggplot(aes(x = rownames(.), y = .[,1])) + 
  geom_bar(stat = "identity", colour=rainbow(34)) + 
  scale_x_discrete(guide = guide_axis(angle = 90)) + 
  xlab("Dataset Columns") + 
  ylab("Percentage of nulls (%)") + 
  ggtitle("Percentage of null rows per column - Testing set") # column price needs cleaning 
                                                              # and the 2 date columns should be dropped

# plot the amount of missing values in each variable and the 
# amount of missing values in certain combinations of variables.
# https://www.rdocumentation.org/packages/VIM/versions/6.2.2/topics/aggr
RideShare_train %>% 
  select_if(is.numeric) %>% 
  aggr(col=c('navyblue','yellow'),
       numbers=TRUE, sortVars=TRUE,
       labels=names(.), cex.axis=.5,
       cex.lab=.8, cex.numbers=0.6,
       ylab=c("Missing data","Pattern"),
       gap=0.5)

# Checking the influx of the "price" variable which quantifies how well its 
# missing data connect to the observed data on other variables
RideShare_train %>%
  within(rm(timestamp, datetime)) %>%
  plot_flux() # "price" has low influx, which means that its null values are missing at random (MAR). 
              # Therefore, omitting the rows when price is null should not negatively influence our modelling.



#####################################
############ Outliers ###############
#####################################

# Histogram of the Price variable
hist(RideShare_train$price, xlab = "Price", main = "Histogram of the Price variable")
# boxplot of "price" to check for outliers
RideShare_train %>%
  select(price) %>%
  drop_na(price) %>% 
  boxplot(main = "Boxplot of the Price variable") # There are many outliers

# Correlation of all features with the values of the "clean" price variable vs the values of just its outliers
data.frame(
  price_outliers = cor(numeric_features %>%
    filter(is_outlier(price))) [,][,4], # Correlation of 'just the price outliers' with all other features
  clean_price = cor(numeric_features %>%
    filter(!is_outlier(price))) [,][,4] # Correlation of 'price values without outliers' with all other features
) %>%   ggcorrplot(title = "Correlation of Price outliers vs Price with no outliers",
                   tl.cex = 7) # The outliers in the Price are not random as we can see that they are
                               # correlated differently with the other variables when compared to the 
                               # non-outlying price values, therefore they are explained and are not an error.

# checking all other numeric features for outliers (too many to consider individually)
for (i in colnames(numeric_features)) {
  numeric_features %>%
    select_at(i) %>%
    boxplot(i)
  title(i)
}



#####################################
######### Multicollinearity #########
#####################################
# https://www.analyticsvidhya.com/blog/2020/03/what-is-multicollinearity/

# Correlation Analysis of the numeric variables
numeric_features %>% 
  cor() %>%
  ggcorrplot(title = "Correlation Matrix of all the numeric variables",
             tl.cex = 7)# There is multicollinearity between some predictor variables
                        # Some form of feature reduction/selection method in necessary.

# finding which features to remove
numeric_features %>% 
  cor() %>%
  findCorrelation() %>% # searches through a correlation matrix and returns a vector of integers corresponding to columns to remove to reduce pair-wise correlations
  numeric_features [,.] %>%
  colnames()



#####################################
############# Scaling ###############
#####################################

RideShare_train %>% 
  select_if(is.numeric) %>% 
  within(rm(timestamp)) %>%
  drop_na(price) %>%
  boxplot() # Values between the features vary greatly, scaling should be used to mitigate the difference.



#####################################
####### Investigate variables #######
#####################################

####### Recursive Feature Elimination (RFE) #######
# Algorithm used to find the best performing combination of features for predictive modelling
# https://towardsdatascience.com/effective-feature-selection-recursive-feature-elimination-using-r-148ff998e4f7

#setting up some control parameters for the Recursive Feature Elimination Algorithm
control = rfeControl(functions = lmFuncs,   # Linear Model function
                     method = "repeatedcv", # repeated Cross-Validation
                     repeats = 10,          # number of repeats
                     number = 10,           # number of Cross-Validation folds
                     rerank = T,            # re-calculate feature importance after each feature elimination
                     allowParallel = T,     # enable parallel computation 
                     verbose = T)           # Printing the iterations

# set seed
set.seed(1)
# run the RFE algorithm
rfe = rfe(price ~ .,
          df_train,
          sizes = c(1:20),
          rfeControl = control)

# summarize the results
print(rfe) # 6 features

# list the chosen features
predictors(rfe)

# Saving the RFE result data
saveRDS(rfe, "./data/cached-data/rfe.rds")

