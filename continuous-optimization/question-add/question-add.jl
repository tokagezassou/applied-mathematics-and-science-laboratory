using JuMP
using Ipopt

function solve(Q, c, A, b)
    model = Model(Ipopt.Optimizer)
    set_silent(model) 

    @variable(model, x[1:2])
    @objective(model, Min, 0.5 * x' * Q * x + c' * x)
    @constraint(model, (A * x)[1] <= b)
    optimize!(model)

    if termination_status(model) == MOI.OPTIMAL
        return value.(x), objective_value(model), true
    else
        return zeros(2), 0.0, false
    end
end

function main()
    open("output.dat", "w") do f
        Q = [2.0 0.0; 0.0 1.0]
        c = [-1.0; -1.0]
        A = [1.0 1.0]
        b = 0.0

        x_opt, f_opt, is_success = solve(Q, c, A, b)
        if !is_success
            println(f, "optimal solution x* : ", x_opt)
            println(f, "optimal value : ", f_opt)
        else
            println(f, "optimal value not found")
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end