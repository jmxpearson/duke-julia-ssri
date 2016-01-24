# Simple example of how to use the distributions package

# Declare package
using Distributions

# create an object that is a multivariate normal distribution with mean mu and covariance cov
mu = zeros(2)
cov = [1 .5; .5 2];
x = [-.5;.5]
mydist = MvNormal(mu,cov); 
mydist = MvNormal(cov); # equivalent way of expressing this
println(mydist)

# evaluate the density of the distribution at point x:
println(pdf(mydist,x))

# evaluate the density of the distribution at the vector X:
X = rand(50,2)
println(pdf(mydist,X'))

# draw from the distribution n times:
println(rand(mydist,50)) # returns a d-by-n matrix, where d is the dimension of the distributions (2, in this case) and n is the number of draws

# Often when building likelihood functions, the log pdf is an object of interest.
# Distributions package allows for direct log pdf evaluation
# This is much more efficient than explicitly taking the log of the pdf
println(logpdf(mydist,x))

# Lots of other fancy features in this package (truncated distributions, mixture models, MLE)