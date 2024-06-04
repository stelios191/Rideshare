# Loading the Feature elimination Data
rfe = readRDS("./data/cached-data/rfe.rds")

###############################################
############## Data Construction ##############
###############################################

# Keeping all the numeric features of the dataset for analysis
numeric_features = RideShare_train %>%
  drop_na(price) %>%
  select_if(is.numeric) %>% 
  within(rm(timestamp, hour, day, month))

# Finding numeric features with smaller than or equal to 0.01 correlation to price
uncorrelated_features = 
  numeric_features %>% # using only numeric features
  cor() %>% # finding their correlation
  round(3) %>% # at 3 decimal points
  as.data.frame() %>% # re-structuring the correlation matrix into a data.frame of rows and columns
  select_at(.vars = "price") %>% # keeping the correlation values of price (column) vs all other features (rows)
  filter(abs(price) <= 0.01) %>%  # keeping features with correlation smaller than or equal to 0.01
  row.names() # storing the names of these uncorrelated features so that we drop them in our pre-processing steps below

################################################
####### Data Cleaning and Pre-processing #######
################################################

####### Training data #######

df_train = RideShare_train %>%
  # dropping unnecessary features that are mostly null or that hold no value for modelling (empirical data understanding)
  drop_columns(c("timestamp", "datetime", "id", "month")) %>%
  # dropping uncorrelated numeric features
  drop_columns(uncorrelated_features) %>%
  # dropping NA values from the "price" variable which will be
  # later used as a response variable in the modelling phase
  drop_na(price) %>% 
  # Re-formatting the Categorical variables as factors so that their values can be used for modelling
  mutate_at(c("surge_multiplier", "hour", "day", "source", "destination", "cab_type", "name", "short_summary"), as.factor) %>% 
  # Scaling all numeric features except the response variable (price) to ensure that all features 
  # have equal importance and enable meaningful comparison of coefficients when modelling
  mutate_at(setdiff(colnames(.), c("surge_multiplier", "hour", "day", "source", "destination", "cab_type", "name", "short_summary", "price")),
            ~(scale(.) %>% as.vector)) %>%
  # Re-formatting the Categorical variables as numeric so that their values can be used for modelling
  mutate_at(c("surge_multiplier", "hour", "day", "source", "destination", "cab_type", "name", "short_summary"), as.numeric) 

# Selecting the best predictors found from the Recursive Feature Elimination
x_train = df_train %>%
  select_at(predictors(rfe))
# Selecting the response variable
y_train = df_train$price


####### Testing data #######

df_test = RideShare_test %>%
  # dropping unnecessary columns that are mostly null or that hold no value for modelling (empirical data understanding)
  drop_columns(c("timestamp", "datetime", "id", "month")) %>%
  # dropping uncorrelated numeric features
  drop_columns(uncorrelated_features) %>%
  # dropping NA values from the "price" variable which will be
  # later used as a response variable in the modelling phase
  drop_na(price) %>% 
  # Re-formatting the Categorical variables as factors so that their values can be used for modelling
  mutate_at(c("surge_multiplier", "hour", "day", "source", "destination", "cab_type", "name", "short_summary"), as.factor) %>% 
  # Scaling all numeric features except the response variable (price) to ensure that all features 
  # have equal importance and enable meaningful comparison of coefficients when modelling
  mutate_at(setdiff(colnames(.), c("surge_multiplier", "hour", "day", "source", "destination", "cab_type", "name", "short_summary", "price")),
            ~(scale(.) %>% as.vector)) %>%
  # Re-formatting the Categorical variables as numeric so that their values can be used for modelling
  mutate_at(c("surge_multiplier", "hour", "day", "source", "destination", "cab_type", "name", "short_summary"), as.numeric) 

# Selecting the best predictors found from the Recursive Feature Elimination
x_test = df_test %>%
  select_at(predictors(rfe))
# Selecting the response variable
y_test = df_test$price


