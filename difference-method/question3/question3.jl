function phi(x)
    return sqrt(2) / pi^(1/4) * exp(-2 * x^2)
end

function visscher_scheme(f, R_0, I_0, delta_t, max_time_index, delta_x, max_coordinate_index)
    # 境界条件を表すヘルパー関数
    function idx(i)
        ret = i
        if i == 0
            ret = max_coordinate_index
        elseif i == max_coordinate_index+1
            ret = 1
        end
        return ret
    end
    
    x = zeros(max_coordinate_index)
    for j in 1:max_coordinate_index
        x[j] = (j - 1/2) * delta_x - 1/2 * delta_x * max_coordinate_index
    end

    R = copy(R_0)
    I = copy(I_0)

    for t in 1:max_time_index
        R_prev = copy(R)
        I_prev = copy(I)

        for j in 1:max_coordinate_index
            R[j] = R_prev[j] + delta_t * (-1/2 * (I_prev[idx(j-1)] -2 * I_prev[j] + I_prev[idx(j+1)]) / delta_x^2 + 1/2 * x[j]^2 * I_prev[j])
        end
        for j in 1:max_coordinate_index
            I[j] = I_prev[j] - delta_t * (-1/2 * (R[idx(j-1)] -2 * R[j] + R[idx(j+1)]) / delta_x^2 + 1/2 * x[j]^2 * R[j])
        end

        if t in [1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000]
            println(f, "----- t = $(t * delta_t) -----")
            for j in 1:max_coordinate_index
                prob = R[j]^2 + I[j] * I_prev[j]
                println(f, "$(x[j])  $prob")
            end
        end
    end
end

function main()
    open("output.dat", "w") do f
        delta_t = 0.001
        max_time_index = 8000
        delta_x = 0.05
        max_coordinate_index = 400

        # 境界条件を表すヘルパー関数
        function co(y)
            L = delta_x * max_coordinate_index
            ret = y
            if y < -L / 2
                ret = co(y + L)
            elseif y > L / 2
                ret = co(y - L)
            end
            return ret
        end

        function idx(i)
            ret = i
            if i == 0
                ret = max_coordinate_index
            elseif i == max_coordinate_index+1
                ret = 1
            end
            return ret
        end

        x = zeros(max_coordinate_index)
        for j in 1:max_coordinate_index
            x[j] = (j - 1/2) * delta_x - 1/2 * delta_x * max_coordinate_index
        end

        R_0 = zeros(max_coordinate_index)
        I_0 = zeros(max_coordinate_index)
        for j in 1:max_coordinate_index
            R_0[j] = 1/2 * (phi(co(x[j] - delta_x / 2)) + phi(co(x[j] + delta_x / 2)))
        end
        for j in 1:max_coordinate_index
            I_0[j] = -delta_t * (-1/2 * (R_0[idx(j-1)] - 2*R_0[j] * R_0[idx(j+1)]) / delta_x^2 + 1/2 * x[j]^2 * R_0[j])
        end

        visscher_scheme(
            f,
            R_0,
            I_0,
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