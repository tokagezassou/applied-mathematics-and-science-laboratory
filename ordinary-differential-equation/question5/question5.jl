function u_prime(t, u)
    # 課題5とそろえた
    return -2 * u + 1
end

# 課題5の方法
function calculate(u_est, u_m1, u_m2, delta_t, t)
    u_est = u_m2 + 2 * u_prime(t - delta_t, u_m1) * delta_t
    u_m2 = u_m1
    u_m1 = u_est
    return u_est, u_m1, u_m2
end

function main()
    open("output.dat", "w") do f
        delta_t = 0.10
        u_0 = 1.0
        u_m2 = u_0
        u_m1 = ((1 - delta_t)  * u_m2 + delta_t) / (1 + delta_t)

        t = delta_t
        u_est = u_0

        for i in 2:100
            t += delta_t
            u_est, u_m1, u_m2 = calculate(u_est, u_m1, u_m2, delta_t, t)
            u_true = (u_0 - 1/2) * exp(-2 * t) + 1/2

            println(f, "$t  $u_est  $u_true")
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end