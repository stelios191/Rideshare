#############################################
################# Resources #################
#############################################

# https://www.r-bloggers.com/2021/07/easystats-quickly-investigate-model-performance/
# http://www.sthda.com/english/articles/38-regression-model-validation/158-regression-model-accuracy-metrics-r-square-aic-bic-cp-and-more/

#############################################
######## Loading the trained models #########
#############################################

# Generalized linear model 
glm_model = read_rds("./models/glm_model.rds")
# Ridge Regression
ridge_model = read_rds("./models/ridge_model.rds")
# Bayesian Generalized Linear Model
bayesglm_model = read_rds("./models/bayesglm_model.rds")
# k-Nearest Neighbors
knn_model = read_rds("./models/knn_model.rds")
# Neural Network
xgbLinear_model = read_rds("./models/xgbLinear_model.rds")


#############################################
######### Generalized linear model ########## 
#############################################

# producing and saving the predictions for the training and testing sets
predVals_glm <- extractPrediction(list(glm_model), x_test, y_test)
saveRDS(predVals_glm, "./models/predVals_glm.rds")

###  Training Set  ###
print(glm_model)

# plot of model parameter tuning
plot(glm_model, main="GLM parameter tuning")

predVals_glm %>%
  filter(dataType == "Training") %>%
  plotObsVsPred()

###  Test Set  ###

# performance metrics of the model on the Test Set
predVals_glm %>%
  filter(dataType == "Test") %>%
  select(obs, pred) %>%
  defaultSummary()

# Plot of predicted vs observed for the Testing set
predVals_glm %>%
  filter(dataType == "Test") %>%
  plotObsVsPred()

#############################################
############# Ridge Regression ##############
#############################################

# producing and saving the predictions for the training and testing sets
predVals_ridge <- extractPrediction(list(ridge_model), x_test, y_test)
saveRDS(predVals_ridge, "./models/predVals_ridge.rds")

###  Training Set  ###
print(ridge_model)

# plot of model parameter tuning
plot(ridge_model, main="ridge regression parameter tuning")

predVals_ridge %>%
  filter(dataType == "Training") %>%
  plotObsVsPred()

###  Test Set  ###

# performance metrics of the model on the Test Set
predVals_ridge %>%
  filter(dataType == "Test") %>%
  select(obs, pred) %>%
  defaultSummary()

# Plot of predicted vs observed for the Testing set
predVals_ridge %>%
  filter(dataType == "Test") %>%
  plotObsVsPred() # very good (except for some few outliers that were not predicted accurately)

#############################################
##### Bayesian Generalized Linear Model ##### 
#############################################

# producing and saving the predictions for the training and testing sets
predVals_bayesglm <- extractPrediction(list(bayesglm_model), x_test, y_test)
saveRDS(predVals_bayesglm, "./models/predVals_bayesglm.rds")

###  Training Set  ###
print(bayesglm_model)

# plot of model parameter tuning
plot(bayesglm_model, main="bayesglm parameter tuning") # no parameters

predVals_bayesglm %>%
  filter(dataType == "Training") %>%
  plotObsVsPred()

###  Test Set  ###

# performance metrics of the model on the Test Set
predVals_bayesglm %>%
  filter(dataType == "Test") %>%
  select(obs, pred) %>%
  defaultSummary()

# Plot of predicted vs observed for the Testing set
predVals_bayesglm %>%
  filter(dataType == "Test") %>%
  plotObsVsPred()

#############################################
############ k-Nearest Neighbors ############
#############################################

# producing and saving the predictions for the training and testing sets
predVals_knn <- extractPrediction(list(knn_model), x_test, y_test)
saveRDS(predVals_knn, "./models/predVals_knn.rds")

###  Training Set  ###

# performance metrics of the model on the Training Set
print(knn_model)

# plot of model parameter tuning
plot(knn_model, main="KNN parameter tuning")

predVals_knn %>%
  filter(dataType == "Training") %>%
  plotObsVsPred()

###  Test Set  ###

# performance metrics of the model on the Test Set
predVals_knn %>%
  filter(dataType == "Test") %>%
  select(obs, pred) %>%
  defaultSummary()

# Plot of predicted vs observed for the Testing set
predVals_knn %>%
  filter(dataType == "Test") %>%
  plotObsVsPred()

#############################################
############## xgbLinear ###############
#############################################

# producing and saving the predictions for the training and testing sets
predVals_xgbLinear <- extractPrediction(list(xgbLinear_model), x_test, y_test)
saveRDS(predVals_xgbLinear, "./models/predVals_xgbLinear.rds")

###  Training Set  ###
print(xgbLinear_model)

# plot of model parameter tuning
plot(xgbLinear_model, main="xgbLinear parameter tuning")

predVals_xgbLinear %>%
  filter(dataType == "Training") %>%
  plotObsVsPred()

###  Test Set  ###

# performance metrics of the model on the Test Set
predVals_xgbLinear %>%
  filter(dataType == "Test") %>%
  select(obs, pred) %>%
  defaultSummary()

# Plot of predicted vs observed for the Testing set
predVals_xgbLinear %>%
  filter(dataType == "Test") %>%
  plotObsVsPred()



#############################################
############# Overall Summary ###############
#############################################


############# Summary metrics Data construction ###############

# combining all the models' predictions into a single dataframe
preds = rbind(predVals_xgbLinear,
              predVals_knn,
              predVals_bayesglm,
              predVals_ridge,
              predVals_glm)

# creating a dataframe to house all the performance metrics for each of the models
metrics = data.frame(row.names = unique(preds$model))

# iterating through the observed and predicted values of each model and 
# calculating their respective performance metrics on the test set
for (i in 1:length(unique(preds$model))) {
  tmp = preds %>%
        filter(dataType == "Test" & model == unique(preds$model)[i]) %>%
        select(obs, pred) %>%
        defaultSummary()
  # and then appending them to the "metrics" dataframe
  metrics = rbind(metrics,tmp)
}

# iterating through the observed and predicted values of each model and 
# calculating their respective performance metrics on the training set
for (i in 1:length(unique(preds$model))) {
  tmp = preds %>%
    filter(dataType == "Training" & model == unique(preds$model)[i]) %>%
    select(obs, pred) %>%
    defaultSummary()
  # and then appending them to the "metrics" dataframe
  metrics = rbind(metrics,tmp)
}

# adding a column for the model names
metrics$model = rep(unique(preds$model),2)

# adding a column for the data type used for the predictions
metrics$dataType = c(rep("Test",5),rep("Training",5))

# adding column names for the performance metrics
colnames(metrics) = c("RMSE", "Rsquared", "MAE", "model", "dataType")


############# Summary metrics Evaluation ###############

# observing the Performance metrics of each model
metrics

# Visualizing the Metrics per model and data set used for the predictions
grid.arrange(
  # plot of RMSE by Model and Data Type
  ggplot(metrics, aes(x = model, y = RMSE, fill = dataType)) +
    geom_bar(stat = "identity", position = "dodge") +
    scale_fill_manual(values = c("Test" = "red", "Training" = "blue")) +
    labs(x = "Model", y = "RMSE", title = "RMSE by Model and Data Type") +
    theme_minimal()
  ,
  # plot of Rsquared by Model and Data Type
  ggplot(metrics, aes(x = model, y = Rsquared, fill = dataType)) +
    geom_bar(stat = "identity", position = "dodge") +
    scale_fill_manual(values = c("Test" = "red", "Training" = "blue")) +
    labs(x = "Model", y = "Rsquared", title = "Rsquared by Model and Data Type") +
    theme_minimal()
  ,
  # plot of MAE by Model and Data Type
  ggplot(metrics, aes(x = model, y = MAE, fill = dataType)) +
    geom_bar(stat = "identity", position = "dodge") +
    scale_fill_manual(values = c("Test" = "red", "Training" = "blue")) +
    labs(x = "Model", y = "MAE", title = "MAE by Model and Data Type") +
    theme_minimal()
  
)


