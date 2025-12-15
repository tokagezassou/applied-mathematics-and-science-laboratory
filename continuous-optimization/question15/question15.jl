function func(x)
    return x^3 + 2*x^2 - 5*x - 6
end

function bisection(under, over, epsilon)
    middle = (under + over) / 2
    y = func(middle)
    is_continuing = true

    if abs(y) <= epsilon
        under = middle
        over = middle
        is_continuing = false
    else
        if y < 0
            under = middle
        else
            over = middle
        end
    end

    return under, over, is_continuing
end

function main()
    open("graph.dat", "w") do f
        start = -10.0
        goal = 10.0
        calculate_num = 10000
        division_width = (goal - start) / calculate_num

        for i in 0:calculate_num
            x = start + division_width * i
            y = func(x)
            println(f, "$x  $y  0")
        end
    end

    open("output.dat", "w") do f
        epsilon = 1e-6

        println(f, "----- bisection -----")
        under_map = [-3.1, -0.9, 1.9]
        over_map = [-2.9, -1.1, 2.1]

        for i in 1:3
            under = under_map[i]
            over = over_map[i]
            is_continuing = true

            while is_continuing
                under, over, is_continuing = bisection(under, over, epsilon)
            end
            println(f, "$(under_map[i])  $(over_map[i])  $under")
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end