using LinearAlgebra

function func_i(x, i)
    y_map = [1.5, 2.25, 2.625]
    y = y_map[i+1]
    x0 = x[1]
    x1 = x[2]
    return y - x0 * (1 - x1^(i+1))
end

function func(x)
    ret = 0.0
    for i in 0:2
        ret += func_i(x, i)^2
    end
    return ret
end

function gradient_i(x, i)
    x0 = x[1]
    x1 = x[2]
    return [
        x1^(i+1) - 1,
        (i+1) * x0 * x1^i
    ]
end

function gradient(x)
    ret = zeros(2)
    for i in 0:2
        ret += 2 * func_i(x,i) * gradient_i(x,i)
    end
    return ret
end

function hessian_i(x, i)
    x0 = x[1]
    x1 = x[2]
    
    term22 = 0.0
    if i > 0
        term22 = (i+1) * i * x0 * x1^(i-1)
    end
    
    return [
        0             (i+1) * x1^i;
        (i+1) * x1^i  term22
    ]
end

function hessian(x)
    ret = zeros(2,2)
    for i in 0:2
        ret += 2 * (func_i(x,i) * hessian_i(x,i) + gradient_i(x,i) * transpose(gradient_i(x,i)))
    end
    return ret
end

function inner_product(a, b)
    size = length(a)

    product = 0
    for i in 1:size
        product += a[i] * b[i]
    end

    return product
end

function norm(a)
    return sqrt(inner_product(a, a))
end

function backtrack(x, step, direction, xi, ro)
    while func(x + step * direction) > func(x) + xi * step * inner_product(direction, gradient(x))
        step *= ro
    end
    return step
end

function gradient_descent(x, init_step, xi, ro, epsilon)
    direction = - gradient(x)
    step = backtrack(x, init_step, direction, xi, ro)
    x += step * direction

    is_continuing = true
    if abs(norm(gradient(x))) < epsilon
        is_continuing = false
    end

    return x, is_continuing
end

function newton(x, init_step, xi, ro, epsilon)
    eigen_values = eigvals(hessian(x))
    min_eigen_value = minimum(eigen_values)

    tau = 0.0
    if min_eigen_value < 0
        tau = abs(min_eigen_value) + 0.1
    end

    direction = - (hessian(x) + tau * I) \ gradient(x)
    step = backtrack(x, init_step, direction, xi, ro)
    x += step * direction

    is_continuing = true
    if abs(norm(gradient(x))) < epsilon
        is_continuing = false
    end

    return x, is_continuing
end

function main()
    open("output.dat", "w") do f
        init_step = 1.0
        xi = 1e-4
        ro = 0.5
        epsilon = 1e-6
        max_calculate_num = 100000
        println(f, "optimal_solution  optimal_value  loop_count")

        println(f, "----- gradient_descent -----")
        is_continuing = true
        solution = [2.0, 0.0]
        loop_count = 0

        while is_continuing
            loop_count += 1
            solution, is_continuing = gradient_descent(
                solution,
                init_step,
                xi,
                ro,
                epsilon,
            )
            if loop_count >= max_calculate_num
                println(f, "not finished within $max_calculate_num times")
                break
            end
        end
        println(f, "$solution  $(func(solution))  $loop_count")

        println(f, "----- newton -----")
        is_continuing = true
        solution = [2.0, 0.0]
        loop_count = 0

        while is_continuing
            loop_count += 1
            solution, is_continuing = newton(
                solution,
                init_step,
                xi,
                ro,
                epsilon,
            )
            if loop_count >= max_calculate_num
                println(f, "not finished within $max_calculate_num times")
                break
            end
        end
        println(f, "$solution  $(func(solution))  $loop_count")
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end