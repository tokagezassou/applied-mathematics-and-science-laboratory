function func(x)
    x0 = x[1]
    x1 = x[2]
    return x0^2 + exp(x0) + x1^4 + x1^2 - 2*x0*x1 + 3
end

function gradient(x)
    x0 = x[1]
    x1 = x[2]
    return [
        2*x0 + exp(x0) - 2*x1,
        4 * x1^3 + 2*x1 - 2*x0
    ]
end

function hessian(x)
    x0 = x[1]
    x1 = x[2]
    return [
        (2 + exp(x0))  -2;
        -2             (12*x1^2 + 2)
    ]
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
    direction = - hessian(x) \ gradient(x)
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
        solution = [1.0, 1.0]
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
        solution = [1.0, 1.0]
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