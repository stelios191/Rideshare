# rideshare

Welcome to ProjectTemplate!

ProjectTemplate is an R package that helps you organize your statistical
analysis projects. To load your new project, you'll first need to `setwd()` into the directory where this README file is located. Then you need to run the following two lines of R code:

	library('ProjectTemplate')
	load.project()

After you enter the second line of code, you'll see a series of automated
messages as ProjectTemplate goes about doing its work. This work involves:
* Reading in the global configuration file contained in `config`.
* Loading any R packages you listed in the configuration file.
* Reading in any datasets stored in `data` or `cache`.
* Preprocessing your data using the files in the `munge` directory.

Once that's done, you can execute any code you'd like.

in the `src` folder you can find all relevant files containing the code for the *Data Understanding Analysis, Data Quality Analysis, model development and model performance evaluation*. You can run any of these scripts to reproduce the contents of the work conducted in this project.

	`src/1-initial-eda.R`, contains general eda that is not strictly part of the project requirement but was conducted to help better visualize the dataset
	`src/2-data-understanding`, contains the data understanding analysis that investigates the structure of the data, its format, the PCA, and some further EDA.
	`src/3-data-quality-analysis`, contains the data quality analysis conducted to inform the data pre-processing
	`src/4-model-development`, contains the code for training the models, fine-tuning them, and applying sampling methods. Please bear in mind that you *DO NOT NEED TO TRAIN THE MODELS* as they have been saved in a folder of this project and can be loaded into R from `src/5-model-performance-evaluation`.
	`src/5-model-performance-evaluation`, contains the performance evaluation of the models, both on the training and the testing sets.

For the code concerning the pre-processing of the data you can look in the `munge` directory
