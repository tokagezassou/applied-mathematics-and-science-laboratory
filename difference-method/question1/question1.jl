function init_condition(x)
    return exp(-0.5 * (x-5)^2) / sqrt(2 * pi)
end

function euler_dirichlet(f, u_0, u_L, u_R, delta_t, max_time_index, delta_x, max_coordinate_index)
    u_j = copy(u_0)

    for t in 1:max_time_index
        u_j_prev = copy(u_j)
        for j in 2:max_coordinate_index+1
            u_j[j] = u_j_prev[j] + delta_t / (delta_x^2) * (u_j_prev[j-1] - 2*u_j_prev[j] + u_j_prev[j+1])
        end

        u_j[1] = u_L
        u_j[max_coordinate_index+2] = u_R

        if t in [100, 200, 300, 400, 500]
            println(f, "----- t = $(t * delta_t) -----")
            for j in 2:max_coordinate_index+1
                x = ((j-1) - 0.5) * delta_x
                println(f, "$x  $(u_j[j])")
            end
        end
    end
end

function euler_neumann(f, u_0, J_L, J_R, delta_t, max_time_index, delta_x, max_coordinate_index)
    u_j = copy(u_0)

    for t in 1:max_time_index
        u_j_prev = copy(u_j)
        for j in 2:max_coordinate_index+1
            u_j[j] = u_j_prev[j] + delta_t / (delta_x^2) * (u_j_prev[j-1] - 2*u_j_prev[j] + u_j_prev[j+1])
        end

        u_j[1] = u_j[2] - J_L * delta_x
        u_j[max_coordinate_index+2] = u_j[max_coordinate_index+1] + J_R * delta_x

        if t in [100, 200, 300, 400, 500]
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
        delta_t = 0.01
        max_time_index = 500
        delta_x = 0.5
        max_coordinate_index = 20

        println(f, "----- euler_dirichlet -----")
        u_0 = zeros(max_coordinate_index + 2)
        u_L = 0
        u_R = 0

        for j in 2:max_coordinate_index+1
            x_minus = (j - 2) * delta_x
            x_plus = (j - 1) * delta_x
            u_0[j] = 0.5 * (init_condition(x_minus) + init_condition(x_plus))
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

        println(f, "----- euler_neumann -----")
        u_0 = zeros(max_coordinate_index + 2)
        J_L = 0
        J_R = 0

        for j in 2:max_coordinate_index+1
            x_minus = (j - 2) * delta_x
            x_plus = (j - 1) * delta_x
            u_0[j] = 0.5 * (init_condition(x_minus) + init_condition(x_plus))
        end
        u_0[1] = u_0[2] - J_L * delta_x
        u_0[max_coordinate_index+2] = u_0[max_coordinate_index+1] + J_R * delta_x

        euler_neumann(
            f,
            u_0,
            J_L,
            J_R,
            delta_t,
            max_time_index,
            delta_x,
            max_coordinate_index
        ) 
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end