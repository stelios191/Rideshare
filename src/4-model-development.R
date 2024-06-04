library('ProjectTemplate')
load.project()

#############################################
################# Resources ################# 
#############################################

# https://topepo.github.io/caret/available-models.html
# https://www.analyticsvidhya.com/blog/2014/12/caret-package-stop-solution-building-predictive-models/

#############################################
######### Generalized linear model ########## 
#############################################

################# Parameter Tuning ################## 

glmControl <- trainControl(
  # resampling method
  method = "repeatedcv", # Cross Validation
  # number of folds or resampling iterations 
  number = 10, # 10-fold 
  ## repeated ten times
  repeats = 10,
  verboseIter = T,
  allowParallel = T)

################## Model Training ################### 

glm_model <- train(x = x_train,
                   y = y_train,
                   method = "glmnet",
                   trControl = glmControl,
                   tuneLength = 5) # parameter optimization depth
print(glm_model)
# Saving the model for later use
saveRDS(glm_model, "./models/glm_model.rds")



#############################################
############# Ridge Regression ##############
#############################################

################# Parameter Tuning ################## 

ridgeControl <- trainControl(
  # resampling method
  method = "repeatedcv", # Cross Validation
  # number of folds or resampling iterations 
  number = 10, # 10-fold 
  ## repeated ten times
  repeats = 10,
  verboseIter = T,
  allowParallel = T)

################## Model Training ################### 

ridge_model <- train(x = x_train,
                     y = y_train,
                     method = "ridge",
                     trControl = ridgeControl,
                     tuneLength = 5) # parameter optimization depth

print(ridge_model)
saveRDS(ridge_model, "./models/ridge_model.rds")


#############################################
##### Bayesian Generalized Linear Model ##### 
#############################################

################# Parameter Tuning ################## 

bayesglmControl <- trainControl(
  # resampling method
  method = "repeatedcv", # Cross Validation
  # number of folds or resampling iterations 
  number = 10, # 10-fold 
  ## repeated ten times
  repeats = 10,
  verboseIter = T,
  allowParallel = T)

################## Model Training ################### 

bayesglm_model <- train(x = x_train,
                   y = y_train,
                   method = "bayesglm",
                   trControl = bayesglmControl,
                   tuneLength = 5) # parameter optimization depth

print(bayesglm_model)
saveRDS(bayesglm_model, "./models/bayesglm_model.rds")



#############################################
############ k-Nearest Neighbors ############
#############################################

################# Parameter Tuning ################## 

knnControl <- trainControl(
  # resampling method
  method = "cv", # Cross Validation
  # number of folds or resampling iterations 
  number = 10, # 10-fold 
  verboseIter = T,
  allowParallel = T)

################## Model Training ################### 

knn_model <- train(x = x_train,
                   y = y_train,
                   method = "knn",
                   trControl = knnControl,
                   tuneLength = 5) # parameter optimization depth

print(knn_model)
saveRDS(knn_model, "./models/knn_model.rds")



#############################################
############## xgbLinear ###############
#############################################

################# Parameter Tuning ################## 

xgbLinearControl <- trainControl(
  # resampling method
  method = "cv", # Cross Validation
  # number of folds or resampling iterations 
  number = 10, # 10-fold
  verboseIter = T,
  allowParallel = T)

################## Model Training ################### 

xgbLinear_model <- train(x = x_train,
                   y = y_train,
                   method = "xgbLinear",
                   trControl = xgbLinearControl,
                   tuneLength = 5) # parameter optimization depth

print(xgbLinear_model)
saveRDS(xgbLinear_model, "./models/xgbLinear_model.rds")




