function u_prime(t, u)
    return (u - 1.0) * u
end

# Runge-Kutta法
function runge_kutta(u_m1, delta_t, t)
    t_m1 = t - delta_t

    F_1 = u_prime(t_m1, u_m1)
    F_2 = u_prime(t_m1 + delta_t/2, u_m1 + F_1 * delta_t / 2)
    F_3 = u_prime(t_m1 + delta_t/2, u_m1 + F_2 * delta_t / 2)
    F_4 = u_prime(t, u_m1 + F_3 * delta_t)

    u_est = u_m1 + delta_t / 6 * (F_1 + 2*F_2 + 2*F_3 + F_4)
    
    return u_est
end

function main()
    open("output.dat", "w") do f
        u_0_map = [0.50, 1.0, 1.50]
        for i in 1:3
            u_0 = u_0_map[i]
            delta_t = 0.02
            u_est = u_0
            t = 0.0

            println(f, "----- u_0 = $u_0 -----")

            for i in 1:100
                t += delta_t
                u_est = runge_kutta(u_est, delta_t, t)

                println(f, "$t  $u_est")
            end
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end