# Statistical distributions in Julia
# Here we will illustrate how to manipulate and utilize a wide array of statistical distributions in Julia.
using Distributions
# Let's illustrate this with the multivariate normal distribution. Let's initialize the mean and covariance matrix:
mu = zeros(2);
cov = [1 .5; .5 2]
# We create an object that is a multivariate normal distribution by calling the MvNormal() function:
mydist = MvNormal(mu,cov)
# Equivalently, because our distribution is mean-zero, we could have just declared the covariance matrix, with the zero-mean implied:
mydist2 = MvNormal(cov)
# Evaluating the density of a distribution at a point
# Once a distribution is declared, you can evaluted the density using the pdf() function:
pdf(mydist,[-.5;.5])
# We chose to evaluate at the point (-.5,.5)
# Evaluating the density of a distribution at a vector
# We can also evaluate at a vector (or array) of points:
X = rand(50,2);
size(pdf(mydist,X'))
# The output is a 50-length vector. Note that we needed to take the transpose of our matrix because pdf() expects an object with $k$ rows when the distribution is a multivariate normal of dimension $k$.
# Drawing from a distribution
# We can also take draws from our distribution using the rand() function:
y = rand(mydist,50);
size(y)
# Bonus exercise
using StatsBase
mean_and_cov(y')

# Often when building likelihood functions, the log pdf is an object of interest.
# Distributions package allows for direct log pdf evaluation
# This is much more efficient than explicitly taking the log of the pdf
logpdf(mydist,[-.5;.5])

# Lots of other fancy features in this package (truncated distributions, mixture models, MLE)