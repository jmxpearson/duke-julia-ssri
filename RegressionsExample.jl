# With our knowledge of the DataFrames package, we can use Julia to estimate common regression models which are useful in summarizing and describing data.
# First, let's call the package we'll need for this demonstration. We'll be using Julia version 0.4.1 with GLM version 0.5.0 and DataFrames version 0.6.10.
using GLM
using DataFrames
# OLS
# Let's start by loading in the same CSV file from our DataFrames example: (available at https://github.com/jmxpearson/duke-julia-ssri-2016/blob/master/auto.csv)
auto = readtable("auto.csv");
showcols(auto)
# Now let's use the GLM package to estimate a simple ordinary least squares regression. Let's use :price as the dependent variable and :mpg and :weight as the indepenent variables.
# The syntax for estimating an OLS model with the GLM package is:
# object = glm(Y~X,data,Normal(),IdentityLink()) where
# object is the Julia object that stores all of the results
# Y is the dependent variable
# X is a linear combination of independent variables
# data is the name of the data frame that holds the data
# And the last two options can be adjusted to estimate other models (which we'll get to later)
# Users with experience in R will recognize the tight correspondence between Julia's GLM estimation syntax and R's.
# Let's estimate our model now:
olsest = glm(price~mpg+weight,auto,Normal(),IdentityLink())
# We see the reported coefficients, standard errors, z-values, and corresponding p-values for each covariate included in the model. Note that the intercept was automatically included.
# Additionally, we can extract these objects, and others, by the following syntax:
coef(olsest)
stderr(olsest)
[coef(olsest) stderr(olsest)]
# Additional objects that we can extract from the stored estimates object include:
# deviance(), which is the weighted sum of squares of the residuals
# vcov(), which is the estimated variance-covariance matrix of the parameters
# predict(), which obtains predicted values of the outcome for each observation
deviance(olsest)
pricehat = predict(olsest)
[convert(Array,auto[:,:price]) pricehat]
vcov(olsest)
[sqrt(diag(vcov(olsest))) stderr(olsest)]
# Binary response models
# Here we will estimate parameters associated with a binary dependent variable. The two canonical models that we will discuss here are the logistic regression model (logit) and the probit model. The two models usually give similar results, and discussing their differences is beyond the current scope.
# Logit
# The logit model is called using the Binomial() and LogitLink() options in the glm() function:
logitest = glm(foreign~mpg+weight,auto,Binomial(),LogitLink())
# Here, we can predict the probability that a given vehicle is from a foreign maker and compare that with what was observed.
[convert(Array,auto[:,:foreign]) predict(logitest)]
# Probit
# Similar to the logit case, the probit model is called using the Binomial() and ProbitLink() options in the glm() function:
probitest = glm(foreign~mpg+weight,auto,Binomial(),ProbitLink())
[convert(Array,auto[:,:foreign]) predict(probitest)]
# Factor variables
# Suppose you have a categorical variable (e.g. ethnicity, or gender) that you want to include as an independent variable in your model.
# Several existing software packages have this capability. In Stata, use i.gender; in R use gender <- as.factor(gender).
# In Julia, factor levels are created using what is called a "pooled data array."
# Let's see how they work by estimating an OLS model on the auto data frame, using the :rep78 variable, which takes on categorical values 1 through 5.
olsest2 = glm(price~mpg+weight+rep78,auto,Normal(),IdentityLink())
# Here, the glm() function thinks that :rep78 is a continuous variable. In order to "pool" this variable, we use the following syntax:
pool!(auto,:rep78);
# Once the pooling is done, we can look at the levels of the pooled vector using the levels() function:
levels(auto[:rep78])
# Now when we re-run this regression, we should expect to obtain four different coefficient estimates representing the four uniquely identifiable categories of :rep78.
olsest3 = glm(price~mpg+weight+rep78,auto,Normal(),IdentityLink())
# This is indeed the case.
# Pooling imported data automatically
# It is possible to automatically pool the data frame upon import using the makefactors option of readtable:
auto2 = readtable("auto.csv",makefactors=true);
# However, this functionality only works with string variables, so any numerical categorical variables must be pooled manually.