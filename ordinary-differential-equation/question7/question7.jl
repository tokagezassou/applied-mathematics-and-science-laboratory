function u_prime(t, u)
    x = u[1]
    y = u[2]
    z = u[3]

    sigma = 10.0
    r = 28.0
    b = 8.0 / 3.0

    x_prime = sigma * (y - x)
    y_prime = r * x - y - x * z
    z_prime = x * y - b * z

    return [x_prime, y_prime, z_prime]
end

# 前進オイラー法
function forward_euler(u_m1, delta_t, t)
    u_est = u_m1 + u_prime(t, u_m1) * delta_t
    return u_est
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

function question1(f)
    epsilon = 0.0
    x_0 = 1.0 + epsilon
    y_0 = 0
    z_0 = 0
    u_0 = [x_0, y_0, z_0]
    delta_t = 0.01

    u_prev = u_0
    t = 0

    while t < 100
        t += delta_t
        u_est = runge_kutta(u_prev, delta_t, t)
        println(f, "$t  $(u_est[1])  $(u_est[2])  $(u_est[3])")

        u_prev = u_est
    end
end

function question2(f)
    epsilon = 0.0
    x_0 = 1.0 + epsilon
    y_0 = 0
    z_0 = 0
    u_0 = [x_0, y_0, z_0]

    for i in 0:13
        t = 0
        delta_t = 0.01 * 2.0^(-i)
        u_prev_fe = u_0
        u_prev_rc = u_0
        is_continuing = true

        while is_continuing
            t_prev = t
            t += delta_t
            u_est_fe = forward_euler(u_prev_fe, delta_t, t)
            u_est_rc = runge_kutta(u_prev_rc, delta_t, t)

            if t_prev < 15.0 && t >= 15.0
                println(f, "15  $i  $delta_t  $(u_est_fe[1])  $(u_est_rc[1])")
            end
            if t_prev < 30.0 && t >= 30.0
                println(f, "30  $i  $delta_t  $(u_est_fe[1])  $(u_est_rc[1])")
            end
            if t_prev < 60.0 && t >= 60.0
                println(f, "60  $i  $delta_t  $(u_est_fe[1])  $(u_est_rc[1])")
                is_continuing = false
            end

            u_prev_fe = u_est_fe
            u_prev_rc = u_est_rc
        end
    end
end

function question3(f)
    epsilon_map = [0, 0.1, 0.01, 0.001]
    for i in 1:4
        epsilon = epsilon_map[i]
        println(f, "----- epsilon = $epsilon -----")

        x_0 = 1.0 + epsilon
        y_0 = 0
        z_0 = 0
        u_0 = [x_0, y_0, z_0]
        u_prev = u_0

        delta_t = 0.001
        t = 0
        while t < 100
            t += delta_t
            u_est = runge_kutta(u_prev, delta_t, t)
            println(f, "$t  $(u_est[1])")
            u_prev = u_est
        end
    end
end

function main()
    open("output.dat", "w") do f
        println(f, "----- question1 -----")
        question1(f)

        println(f, "----- question2 -----")
        question2(f)

        println(f, "----- question3 -----")
        question3(f)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end