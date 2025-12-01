function func(x)
    return 4 / (1 + x^2)
end

function main()
    open("output.dat", "w") do f
        sample_num_map = [10, 10^3, 10^5, 10^7]
        
        for s in 1:4
            sample_num = sample_num_map[s]
            fx_means = zeros(10)

            for c in 1:10
                fx_sum = 0.0

                for i in 1:sample_num
                    x = rand()
                    fx = func(x)
                    fx_sum += fx
                end

                fx_means[c] = fx_sum / sample_num
            end

            fx_est = sum(fx_means) / 10

            numerator = 0
            for c in 1:10
                numerator += (fx_means[c] - fx_est)^2
            end

            accuracy = sqrt(numerator / 10 / (10 - 1))
            println(f, "$sample_num  $fx_est  $accuracy")
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end