using JuMP
using Ipopt

function datagen(N,T)
    ## Generate data for a linear model to test optimization
    srand(1234)
    
    N = convert(Int64,N) #inputs to functions such as -ones- need to be integers!
    T = convert(Int64,T) #inputs to functions such as -ones- need to be integers!
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
    const ßans = [ 2.15; 0.10;  0.50; 0.10; 0.75; 1.2; 0.10;  0.50; 0.10; 0.75; 1.2; 0.10;  0.50; 0.10; 0.75; 1.2 ]
    
    # generate the std dev of the errors
    const σans = 0.3
    
    # generate the Ys from the Xs, betas, and error draws
    draw = 0 + σans*randn(N*T,1)
    const y = X*ßans+draw
    
    # return generated data so that other functions (below) have access
    return X,y,ßans,σans,n
end

X,y,ßans,σans,n = datagen(1e4,5);

# Estimate via OLS
ßhat = (X'*X)\(X'*y);
σhat = sqrt((y-X*ßhat)'*(y-X*ßhat)/(n-size(X,2)));
[round([ßhat;σhat],3) [ßans;σans]]

# Estimate via JuMP optimization package
function jumpMLE(y,X,startval)
    ## MLE of classical linear regression model
    # Declare the name of your model and the optimizer you will use
    myMLE = Model(solver=IpoptSolver(tol=1e-6));
    
    # Declare the variables you are optimizing over
    @variable(myMLE, ß[i=1:size(X,2)], start = startval[i]);
    @variable(myMLE, σ>=0.0, start = startval[end]);
    # @variable(myMLE, σ ==0.5) # use this syntax if you want to restrict a parameter to a specified value. Note that NLopt has issues with equality constraints
    
    # Write constraints here if desired
    # @NLconstraint(m, σ == σ^2)
    
    # Write your objective function
    @NLobjective(myMLE, Max, (n/2)*log(1/(2*π*σ^2))-sum((y[i]-sum(X[i,k]*ß[k] 
                            for k=1:size(X,2)))^2 for i=1:size(X,1))/(2σ^2));
    # Solve the objective function
    status = solve(myMLE)
    
    # Generate Hessian
    this_par = myMLE.colVal
    m_eval = JuMP.NLPEvaluator(myMLE);
    MathProgBase.initialize(m_eval, [:ExprGraph, :Grad, :Hess])
    hess_struct = MathProgBase.hesslag_structure(m_eval)
    hess_vec = zeros(length(hess_struct[1]))
    numconstr = length(m_eval.m.linconstr) + length(m_eval.m.quadconstr) + length(m_eval.m.nlpdata.nlconstr)
    dimension = length(myMLE.colVal)
    MathProgBase.eval_hesslag(m_eval, hess_vec, this_par, 1.0, zeros(numconstr))
    this_hess_ld = sparse(hess_struct[1], hess_struct[2], hess_vec, dimension, dimension)
    hOpt = this_hess_ld + this_hess_ld' - sparse(diagm(diag(this_hess_ld)));
    hOpt = -full(hOpt); #since we are maximizing
    
    # Calculate standard errors
    seOpt = sqrt(diag(full(hOpt)\eye(size(hOpt,1))))
    
    # Save estimates
    ßopt = getvalue(ß[:]);
    σopt = getvalue(σ);
    
    # Print estimates and log likelihood value
    # println("beta = ", bOpt)
    # println("s = ", sOpt)
    println("MLE objective: ", getobjectivevalue(myMLE))
    println("MLE status: ", status)
    return ßopt,σopt,hOpt,seOpt
end

startval = [rand(size(X,2));rand(1)];
println(size(startval))
ßJump,σJump,seJump=jumpMLE(y,X,startval);
[[ßJump;σJump] [ßans;σans]]
