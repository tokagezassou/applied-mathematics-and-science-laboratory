function func(x)
    return x^3 + 2*x^2 - 5*x - 6
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
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end