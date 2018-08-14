using JuMP
#using NLopt
using Ipopt
#using FastGaussQuadrature
#using SpecialFunctions

function Townsend(args...)
    x = args[1]
    y = args[2]
    
    return - cos((x-0.1)*y)^2 - x*(sin(3x+y))
end

function Constr(args...)
    x = args[1]
    y = args[2]
    
    t = atan2(y, x)
    
    return (2cos(t) - cos(2t) / 2 - cos(3t) / 4 - cos(4t) / 8)^2 + 2sin(t)^2 
end

m = Model(solver=IpoptSolver(print_level=1))
JuMP.register(m, :Townsend, 2, Townsend, autodiff=true)
JuMP.register(m, :Constr, 2, Constr, autodiff=true)

@variable(m, -2.25 <= x <= 2.5)
@variable(m, -2.5 <= y <= 1.75)

@NLconstraint(m, c1, x^2 + y^2 <= Constr(x,y))

@NLobjective(m, Min, Townsend(x,y))

solve(m)
println("x = ", getvalue(x))
println("y = ", getvalue(y))
