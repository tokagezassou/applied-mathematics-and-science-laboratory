function init_condition(x, b)
    return 1 / (1 + exp(b*x - 5))^2
end

function euler_dirichlet(f, u_0, u_L, u_R, delta_t, max_time_index, delta_x, max_coordinate_index)
    u_j = copy(u_0)
    c = delta_t / (delta_x^2)

    for t in 1:max_time_index
        u_j_prev = copy(u_j)
        for j in 2:max_coordinate_index+1
            non_linear = u_j_prev[j] * (1 - u_j_prev[j]) * delta_t
            u_j[j] = u_j_prev[j] + c * (u_j_prev[j-1] - 2*u_j_prev[j] + u_j_prev[j+1]) + non_linear
        end

        u_j[1] = u_L
        u_j[max_coordinate_index+2] = u_R

        if t in [10000, 20000, 30000, 40000]
            println(f, "----- t = $(t * delta_t) -----")
            for j in 2:max_coordinate_index+1
                x = ((j-1) - 0.5) * delta_x
                println(f, "$x  $(u_j[j])")
            end
        end
    end
end

function main()
    open("output.dat", "w") do f
        delta_t = 0.001
        max_time_index = 40000
        delta_x = 0.05
        max_coordinate_index = 4000

        for b in [0.25, 0.50, 1.0]
            println(f, "----- b = $b -----")
            u_0 = zeros(max_coordinate_index + 2)
            u_L = 1.0
            u_R = 0

            for j in 2:max_coordinate_index+1
                x_minus = (j - 2) * delta_x
                x_plus = (j - 1) * delta_x
                u_0[j] = 0.5 * (init_condition(x_minus, b) + init_condition(x_plus, b))
            end
            u_0[1] = u_L
            u_0[max_coordinate_index+2] = u_R

            euler_dirichlet(
                f,
                u_0,
                u_L,
                u_R,
                delta_t,
                max_time_index,
                delta_x,
                max_coordinate_index
            )
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end