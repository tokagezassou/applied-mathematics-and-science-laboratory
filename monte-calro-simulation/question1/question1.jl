function get_state(states, index)
    len = length(states)
    i = index

    if index == len + 1
        i = 1
    elseif index == 0
        i = len
    end

    return states[i]
end

function update_state(probability)
    rand_val = rand()

    bool_val = 0
    if rand_val < probability
        bool_val = 1
    end

    return bool_val
end

function transit(states, index, p)
    s = get_state(states, index)
    n = get_state(states, index - 1) + get_state(states, index + 1)
    new_state = 0

    if (s, n) == (0, 1)
        new_state = update_state(p^2)
    elseif (s, n) == (0, 2) || (s, n) == (1, 0)
        new_state = update_state(p^2 * (2 - p^2))
    elseif (s, n) == (1, 1)
        new_state = update_state(p^2 * (p^3 - 2 * p^2 - p + 3))
    elseif (s, n) == (1, 2)
        new_state = update_state(p^2 * (2 - p) * (p^3 - 2 * p^2 + 2))
    else
        new_state = 0
    end

    return new_state
end    

function main()
    open("output.dat", "w") do f
        states_matrix = zeros(Int, 10, 64)
        mid_index = trunc(Int, size(states_matrix, 2) / 2)
        states_matrix[:, mid_index] .= 1
        p = 0.7

        for t in 1:256
            print(f, "$t")

            for s in 1:10
                prev_states = states_matrix[s, :]
                new_states = zeros(Int, 64)
                infection_sum = 0

                for i in 1:64
                    new_states[i] = transit(prev_states, i, p)
                    infection_sum += new_states[i]
                end

                states_matrix[s, :] = new_states
                print(f, "  $infection_sum")
            end

            print(f, "\n")
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end