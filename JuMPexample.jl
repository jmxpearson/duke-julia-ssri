using JuMP
using Ipopt

function datagen()
	## Generate data for a linear model to test optimization
	srand(1234)
	
	N = convert(Int64,1e4) #inputs to functions such as -ones- need to be integers!
	T = 5
	const n = convert(Int64,N*T) # use -const- as a way to declare a variable to be global (so other functions can access it)
	
	# generate the Xs
	const X = cat(2,ones(N*T,1),5+3*randn(N*T,1),rand(N*T,1),
	           2.5+2*randn(N*T,1),15+3*randn(N*T,1),
			   .7-.1*randn(N*T,1),5+3*randn(N*T,1),
			   rand(N*T,1),2.5+2*randn(N*T,1),
			   15+3*randn(N*T,1),.7-.1*randn(N*T,1),
			   5+3*randn(N*T,1),rand(N*T,1),2.5+2*randn(N*T,1),
			   15+3*randn(N*T,1),.7-.1*randn(N*T,1));
	
	# generate the betas (X coefficients)
	const bAns = [ 2.15; 0.10;  0.50; 0.10; 0.75; 1.2; 0.10;  0.50; 0.10; 0.75; 1.2; 0.10;  0.50; 0.10; 0.75; 1.2 ]
	
	# generate the std dev of the errors
	const sigAns = 0.3
	
	# generate the Ys from the Xs, betas, and error draws
	draw = 0 + sigAns*randn(N*T,1)
	const y = X*bAns+draw
	
	# return generated data so that other functions (below) have access
	return X,y,bAns,sigAns,n
end

X,y,bAns,sigAns,n = datagen()
# Estimate via OLS
bHat = (X'*X)\(X'*y);
sigHat = sqrt((y-X*bHat)'*(y-X*bHat)/(n-size(X,2)));
[[bHat;sigHat] [bAns;sigAns]]

# Estimate via JuMP optimization package
function jumpMLE(y,X,startval)
	## MLE of classical linear regression model
	# Declare the name of your model and the optimizer you will use
	myMLE = Model(solver=IpoptSolver(tol=1e-6))
	
	# Declare the variables you are optimizing over
	@defVar(myMLE, b[i=1:size(X,2)], start = startval[i])
	@defVar(myMLE, s >=0.0, start = startval[end])
	# @defVar(myMLE, s ==0.5) # use this syntax if you want to restrict a parameter to a specified value. Note that NLopt has issues with equality constraints
	
	# Write constraints here if desired
	# @addNLConstraint(m, µ == s^2)
	
	# Write your objective function
	# @setNLObjective(myMLE, Max, (n/2)*log(1/(2*pi*s^2))-sum{(y[i]-sum{X[i,k]*b[k], k=1:size(X,2)})^2, i=1:size(X,1)}/(2s^2))
	@setNLObjective(myMLE, Max, sum{-(1/2)*log(2*pi)-log(s)-(y[i]-sum{X[i,k]*b[k], k=1:size(X,2)})^2, i=1:size(X,1)}/(2s^2));
	# Solve the objective function
	status = solve(myMLE)
	
	# Generate Hessian
	this_par = myMLE.colVal
	m_eval = JuMP.JuMPNLPEvaluator(myMLE);
	MathProgBase.initialize(m_eval, [:ExprGraph, :Grad, :Hess])
	hess_struct = MathProgBase.hesslag_structure(m_eval)
	hess_vec = zeros(length(hess_struct[1]))
	numconstr = length(m_eval.m.linconstr) + length(m_eval.m.quadconstr) + length(m_eval.m.nlpdata.nlconstr)
	dimension = length(myMLE.colVal)
	MathProgBase.eval_hesslag(m_eval, hess_vec, this_par, 1.0, zeros(numconstr))
	this_hess_ld = sparse(hess_struct[1], hess_struct[2], hess_vec, dimension, dimension)
	hOpt = this_hess_ld + this_hess_ld' - sparse(diagm(diag(this_hess_ld)));
	hOpt = -full(hOpt) #since we are maximizing
	
	# Calculate standard errors
	seOpt = sqrt(diag(full(hOpt)\eye(size(hOpt,1))))
	
	# Save estimates
	bOpt = getValue(b[:])
	sOpt = getValue(s)
	
	# Print estimates and log likelihood value
	# println("beta = ", bOpt)
	# println("s = ", sOpt)
	println("MLE objective: ", getObjectiveValue(myMLE))
	println("MLE status: ", status)
	return bOpt,sOpt,hOpt,seOpt
end

bJump,sigJump,seJump=jumpMLE(y,X,rand(size(X,2)));
[[bJump;sigJump] [bAns;sigAns]]
