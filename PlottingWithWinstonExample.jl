using Winston

# The Curve() function in Winston allows for plotting of a function:
x = 0:0.05:4;
y = sqrt(x);
c = Curve(x, y, color="blue");
p = FramedPlot();
add(p, c)
