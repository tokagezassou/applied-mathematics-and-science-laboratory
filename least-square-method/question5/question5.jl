using CSV
using DataFrames
using LinearAlgebra
using Statistics

function read_csv(csv_file_path)
    if !isfile(csv_file_path)
        println("file not found: $csv_file_path")
        return nothing, nothing, true
    end
    df = CSV.read(csv_file_path, DataFrame, header=false)
    vector_x = df[:, 1]
    matrix_Y = Matrix(df[:, [2, 3]])

    return vector_x, matrix_Y, false
end

# 推定誤差共分散の計算
function calculate_min_sqr_err_estimate(f, vector_x, matrix_Y, is_print_required)
    data_num = length(vector_x)
    matrix_V = [100.0 0.0; 0.0 1.0]
    V_inv = inv(matrix_V)

    sum_phi_T_phi = zeros(2, 2)
    sum_phi_T_y = zeros(2)
    sum_phi_T_V_phi = zeros(2, 2)
    sum_phi_T_Vinv_phi = zeros(2, 2)
    sum_phi_T_Vinv_y = zeros(2)

    for i in 1:data_num
        x_i = vector_x[i]
        y_i = matrix_Y[i, :]

        phi_i = [1.0 x_i; 1.0 x_i^2]
        phi_i_T = transpose(phi_i)

        sum_phi_T_phi += phi_i_T * phi_i
        sum_phi_T_y += phi_i_T * y_i
        
        sum_phi_T_V_phi += phi_i_T * matrix_V * phi_i

        sum_phi_T_Vinv_phi += phi_i_T * V_inv * phi_i
        sum_phi_T_Vinv_y += phi_i_T * V_inv * y_i
    end

    Phi_N_standard_inv = sum_phi_T_phi
    Phi_N_standard = inv(Phi_N_standard_inv)
    theta_hat_standard = Phi_N_standard * sum_phi_T_y
    cov_standard = Phi_N_standard * sum_phi_T_V_phi * Phi_N_standard

    Phi_N_weighted_inv = sum_phi_T_Vinv_phi
    Phi_N_weighted = inv(Phi_N_weighted_inv)
    theta_hat_weighted = Phi_N_weighted * sum_phi_T_Vinv_y
    cov_weighted = Phi_N_weighted

    if is_print_required
        println(f, "----- standard -----")
        println(f, "$theta_hat_standard  $cov_standard")
        println(f, "----- weighted -----")
        println(f, "$theta_hat_weighted  $cov_weighted")
    end

    return theta_hat_standard, theta_hat_weighted
end

function increase_data_num(f, vector_x, matrix_Y)
    println(f, "----- convergence -----")
    for i in 1:9
        data_num = 2^i
        
        cut_x = vector_x[1:data_num]
        cut_Y = matrix_Y[1:data_num, :]
        
        theta_hat_standard, theta_hat_weighted = calculate_min_sqr_err_estimate(f, cut_x, cut_Y, false)
        
        println(f, "$data_num  $(theta_hat_standard[1])  $(theta_hat_standard[2])  $(theta_hat_weighted[1])  $(theta_hat_weighted[2])")
    end
end

const CSV_FILE = "input.csv"

function main()    
    open("output.dat", "w") do f
        vector_x, matrix_Y, has_err = read_csv(CSV_FILE)
        if has_err
            return
        end

        _, _ = calculate_min_sqr_err_estimate(f, vector_x, matrix_Y, true)
        increase_data_num(f, vector_x, matrix_Y)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end