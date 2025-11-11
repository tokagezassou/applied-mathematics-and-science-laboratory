function u_prime(t, u)
    return u
end

function print_result(f, i, u_1_est, u_1, error_prev)
    error = abs(u_1_est - u_1)

    if i == 1
        print(f, "   $error NaN")
    else
        order = log2(error_prev / error)
        print(f, "   $error $order")
    end

    # 次のerror_prevの値として返す
    return error
end

# 前進オイラー法
function forward_Euler(u_0, step_num)
    delta_t = 1.0 / step_num
    t = 0.0
    u_est = u_0

    for n in 1:step_num
        t += delta_t
        u_est += u_prime(t, u_est) * delta_t
    end

    return u_est
end

# 2次のAdams-Bashforth法
function adams_bashforth_2(u_0, step_num)
    delta_t = 1.0 / step_num
    t = 0.0
    u_est = u_0
    f_m2 = exp(t - delta_t)
    f_m1 = exp(t)
    
    for n in 1:step_num
        t += delta_t

        u_est += delta_t / 2 * (3*f_m1 - f_m2)

        f_m2 = f_m1
        f_m1 = u_prime(t, u_est)
    end

    return u_est
end

# 3次のAdams-Bashforth法
function adams_bashforth_3(u_0, step_num)
    delta_t = 1.0 / step_num
    t = 0.0
    u_est = u_0
    f_m3 = exp(t - 2*delta_t)
    f_m2 = exp(t - delta_t)
    f_m1 = exp(t)
    
    for n in 1:step_num
        t += delta_t

        u_est += delta_t / 12 * (23*f_m1 - 16*f_m2 + 5*f_m3)

        f_m3 = f_m2
        f_m2 = f_m1
        f_m1 = u_prime(t, u_est)
    end

    return u_est
end

# Heun法
function heun(u_0, step_num)
    delta_t = 1.0 / step_num
    t = 0.0
    u_est = u_0
    f_m1 = exp(t)
    
    for n in 1:step_num
        t += delta_t

        u_est_star = u_est + f_m1 * delta_t
        u_est += delta_t / 2 * (f_m1 + u_prime(t, u_est_star))

        f_m1 = u_prime(t, u_est)
    end

    return u_est
end

# Runge-Kutta法
function runge_kutta(u_0, step_num)
    delta_t = 1.0 / step_num
    t = 0.0
    u_est = u_0
    
    for n in 1:step_num
        t_m1 = t
        t += delta_t

        F_1 = u_prime(t_m1, u_est)
        F_2 = u_prime(t_m1 + delta_t/2, u_est + F_1 * delta_t / 2)
        F_3 = u_prime(t_m1 + delta_t/2, u_est + F_2 * delta_t / 2)
        F_4 = u_prime(t, u_est + F_3 * delta_t)

        u_est += delta_t / 6 * (F_1 + 2*F_2 + 2*F_3 + F_4)
    end

    return u_est
end

function main()
    open("output.dat", "w") do f
        u_0 = 1.0
        u_1 = exp(1.0)

        #初期値は適当
        error_prev_FE = 1.0
        error_prev_AB2 = 1.0
        error_prev_AB3 = 1.0
        error_prev_H = 1.0
        error_prev_RK = 1.0
        
        for i in 1:8
            print(f, "$i")
            step_num = 2^i

            u_1_est = forward_Euler(u_0, step_num)
            error_prev_FE = print_result(f, i, u_1_est, u_1, error_prev_FE)

            u_1_est = adams_bashforth_2(u_0, step_num)
            error_prev_AB2 = print_result(f, i, u_1_est, u_1, error_prev_AB2)

            u_1_est = adams_bashforth_3(u_0, step_num)
            error_prev_AB3 = print_result(f, i, u_1_est, u_1, error_prev_AB3)

            u_1_est = heun(u_0, step_num)
            error_prev_H = print_result(f, i, u_1_est, u_1, error_prev_H)

            u_1_est = runge_kutta(u_0, step_num)
            error_prev_RK = print_result(f, i, u_1_est, u_1, error_prev_RK)

            print(f, "\n")
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end