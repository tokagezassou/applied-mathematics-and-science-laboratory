function state(states, i, j)
    system_size = size(states, 1)
    row = mod1(i, system_size)
    col = mod1(j, system_size)

    return states[row, col]
end

function calculate_energy_difference(states, i, j)
    sum = state(states, i+1, j) + state(states, i-1, j) + state(states, i, j+1) + state(states, i, j-1)
    dif = 2 * states[i,j] * sum
    return dif
end

function calculate_magnetization(states)
    n = length(states)
    state_sum = sum(states)

    m = abs(state_sum) / n
    return m
end

function metropolis(states, temp_z)
    t = 2 / log(1 + temp_z)
    system_size = size(states, 1)

    for i in 1:system_size
        for j in 1:system_size
            energy_dif = calculate_energy_difference(states, i, j)

            prob = exp(- energy_dif / t)
            if prob > 1.0
                prob = 1.0
            end

            r = rand()
            if r < prob
                states[i, j] *= -1
            end
        end
    end

    return states
end

function gibbs_sampling(states, temp_z)
    t = 2 / log(1 + temp_z)
    system_size = size(states, 1)

    for i in 1:system_size
        for j in 1:system_size
            energy_dif = calculate_energy_difference(states, i, j)

            prob = 1 / (1 + exp(energy_dif / t))

            r = rand()
            if r < prob
                states[i, j] *= -1
            end
        end
    end

    return states
end

function main()
    open("output1.dat", "w") do f
        println(f, "----- question 4-2 metropolis -----")
        states = ones(Int, 64, 64)
        temp_z = sqrt(2)

        for i in 1:10000
            states = metropolis(states, temp_z)
            magnetization = calculate_magnetization(states)
            println(f, "$i  $magnetization")
        end

        println(f, "----- question 4-2 gibbs_sampling -----")
        states = ones(Int, 64, 64)
        temp_z = sqrt(2)

        for i in 1:10000
            states = gibbs_sampling(states, temp_z)
            magnetization = calculate_magnetization(states)
            println(f, "$i  $magnetization")
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end