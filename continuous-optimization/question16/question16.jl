function func(x)
    return 1/3*x^3 - x^2 - 3*x + 5/3
end

function func_dash(x)
    return x^2 - 2*x - 3
end

function func_2dash(x)
    return 2*x - 2
end

function gradient_descent(x, loop_count, epsilon)
    direction = - func_dash(x)
    x += 1/loop_count * direction

    is_continuing = true
    if abs(func_dash(x)) < epsilon
        is_continuing = false
    end

    return x, is_continuing
end

function newton(x, epsilon)
    direction = - func_dash(x) / func_2dash(x)
    x += direction

    is_continuing = true
    if abs(func_dash(x)) < epsilon
        is_continuing = false
    end

    return x, is_continuing
end

function main()
    open("output.dat", "w") do f
        epsilon = 1e-6
        max_calculate_num = 100000

        println(f, "----- gradient_descent -----")
        is_continuing = true
        solution = 1/2
        loop_count = 0

        while is_continuing
            loop_count += 1
            solution, is_continuing = gradient_descent(solution, loop_count, epsilon)
            if loop_count >= max_calculate_num
                println(f, "not finished within $max_calculate_num times")
                break
            end
        end
        println(f, "$solution")

        println(f, "----- newton -----")
        is_continuing = true
        solution = 5.0
        loop_count = 0

        while is_continuing
            loop_count += 1
            solution, is_continuing = newton(solution, epsilon)
            if loop_count >= max_calculate_num
                println(f, "not finished within $max_calculate_num times")
                break
            end
        end
        println(f, "$solution")
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end