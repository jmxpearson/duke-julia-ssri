using Gadfly

# Line plot of random points
plot(x=rand(10),y=rand(10), Geom.point, Geom.line)

# Scatter plot of random points
plot(x=rand(10),y=rand(10))

# Plot functions
plot([sin, cos], 0, 6.2832)

# Plotting DataFrames
using RDatasets

# scatter plot
plot(dataset("datasets", "iris"), x="PetalLength", y="PetalWidth", Geom.point)

# histogram
plot(dataset("datasets", "iris"), x="SepalLength", color="Species", Geom.histogram)

# kernel density
plot(dataset("datasets", "iris"), x="SepalLength", color="Species", Geom.density)

# export to a PDF, PS, etc.:
q=plot(dataset("datasets", "iris"), x="SepalLength", color="Species", Geom.density);
draw(PDF("myplot.pdf", 5in, 3in), q)
