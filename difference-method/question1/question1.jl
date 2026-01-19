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

function calculate_alpha_beta(matrix_A, N)
    alpha = zeros(N)
    beta = zeros(N-1)

    alpha[1] = matrix_A[1,1]
    beta[1] = matrix_A[1,2] / alpha[1]
    for i in 2:N-1
        alpha[i] = matrix_A[i, i] - matrix_A[i, i-1] * beta[i-1]
        beta[i] = matrix_A[i, i+1] / alpha[i]
    end
    alpha[N] = matrix_A[N, N] - matrix_A[N, N-1] * beta[N-1]

    return alpha, beta
end

function crank_nicolson_dirichlet(f, u_0, u_L, u_R, delta_t, max_time_index, delta_x, max_coordinate_index)
    c = delta_t / (delta_x^2)
    u_n = copy(u_0)

    matrix_A = zeros(max_coordinate_index, max_coordinate_index)
    for i in 1:max_coordinate_index
        matrix_A[i,i] = 1 + c
    end
    for i in 2:max_coordinate_index
        matrix_A[i, i-1] = -c / 2
        matrix_A[i-1, i] = -c / 2
    end

    alpha, beta = calculate_alpha_beta(matrix_A, max_coordinate_index)

    for t in 1:max_time_index
        z = zeros(max_coordinate_index)
        z[1] = (1 - c) * u_n[2] + c * u_L + c / 2 * u_n[3]
        for j in 2:max_coordinate_index-1
            z[j] = (1 - c) * u_n[j+1] + c / 2 * (u_n[j] + u_n[j+2])
        end
        z[max_coordinate_index+1] = (1 - c) + u_n[max_coordinate_index+1] + c * u_R + c / 2 * u_n[max_coordinate_index]

        y = zeros(max_coordinate_index)
        y[1] = z[1] / alpha[1]
        for j in 2:max_coordinate_index
            y[j] = (z[j] - matrix_A[j, j-1] * y[j-1]) / alpha[j]
        end

        u_n[max_coordinate_index] = y[max_coordinate_index]
        for j in max_coordinate_index-1:-1:1
            u_n[j+1] = y[j] - beta[j] * u_n[j+2]
        end

        if t in [100, 200, 300, 400, 500]
            println(f, "----- t = $(t * delta_t) -----")
            for j in 2:max_coordinate_index+1
                x = ((j-1) - 0.5) * delta_x
                println(f, "$x  $(u_n[j])")
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

        println(f, "----- crank_nicolson_dirichlet -----")
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
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end