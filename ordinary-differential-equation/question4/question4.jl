function u_prime(t, u)
    # 課題5とそろえた
    return -2 * u + 1
end

# Crank-Nicolson法
function crank_nicolson(u_est, f_m1, delta_t, t)
    u_est = ((1 - delta_t)  * u_est + delta_t) / (1 + delta_t)
    f_m1 = u_prime(t, u_est)

    return u_est, f_m1
end

#予測子・修正子法
function predictor_corrector(u_est, f_m1, f_m2, delta_t, t)
    u_est_star = u_est + delta_t / 2 * (3*f_m1 + f_m2)
    u_est += delta_t / 12 * (5*u_prime(t, u_est_star) + 8*f_m1 ^ f_m2)

    f_m2 = f_m1
    f_m1 = u_prime(t, u_est)

    return u_est, f_m1, f_m2
end

# Heun法
function heun(u_est, f_m1, delta_t, t)
    u_est_star = u_est + f_m1 * delta_t
    u_est += delta_t / 2 * (f_m1 + u_prime(t, u_est_star))

    f_m1 = u_prime(t, u_est)

    return u_est, f_m1
end

function main()
    open("output.dat", "w") do f
        delta_t_map = [0.5, 1.5]
        for i in 1:2
            delta_t = delta_t_map[i]
            u_0 = 1.0

            t = 0.0
            u_est_cn = u_0
            u_est_pc = u_0
            u_est_h = u_0
            f_m1_cn = (u_0 - 1/2) * exp(-2 * t) + 1/2
            f_m1_pc = (u_0 - 1/2) * exp(-2 * t) + 1/2
            f_m2_pc = (u_0 - 1/2) * exp(-2 * (t - delta_t)) + 1/2
            f_m1_h = (u_0 - 1/2) * exp(-2 * t) + 1/2

            while t < 50
                t += delta_t
                u_est_cn, f_m1_cn = crank_nicolson(u_est_cn, f_m1_cn, delta_t, t)
                u_est_pc, f_m1_pc, f_m2_pc = predictor_corrector(u_est_pc, f_m1_pc, f_m2_pc, delta_t, t)
                u_est_h, f_m1_h = heun(u_est_h, f_m1_h, delta_t, t)
                u_true = (u_0 - 1/2) * exp(-2 * t) + 1/2

                println(f, "$t  $u_est_cn  $u_est_pc  $u_est_h  $u_true")
            end
            println(f, "-----------------------------------------")
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end