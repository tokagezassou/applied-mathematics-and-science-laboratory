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
    loop_count += 1
    direction = - func_dash(x)
    x += 1/loop_count * direction

    is_continuing = true
    if abs(func_dash(x)) < epsilon
        is_continuing = false
    end

    return x, loop_count, is_continuing
end

function main()
    open("output.dat", "w") do f
        epsilon = 1e-6

        println(f, "----- gradient_descent -----")
        is_continuing = true
        solution = 1/2
        loop_count = 0

        while is_continuing
            solution, loop_count, is_continuing = gradient_descent(solution, loop_count, epsilon)
            if loop_count >= 100000
                break
            end
        end
        println(f, "$solution")
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end