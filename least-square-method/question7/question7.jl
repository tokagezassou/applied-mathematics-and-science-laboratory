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
    vector_y = df[:, 2]

    return vector_x, vector_y, false
end

function calculate_estimate_values(vector_x, vector_y)
    data_num = length(vector_x)
    
    sum_phi_T_phi = zeros(3, 3)
    sum_phi_T_y = zeros(3)

    for i in 1:data_num
        x_i = vector_x[i]
        y_i = vector_y[i]

        phi_i = [1.0 exp(-(x_i - 1.0)^2 / 2.0) exp(-(x_i + 1.0)^2)]
        phi_i_T = transpose(phi_i)

        sum_phi_T_phi += phi_i_T * phi_i
        sum_phi_T_y += phi_i_T * y_i
    end

    Phi_N_inv = sum_phi_T_phi
    
    Phi_N = inv(Phi_N_inv)
    theta_hat = Phi_N * sum_phi_T_y

    return theta_hat, Phi_N_inv, sum_phi_T_y
end


const CSV_FILE = "input.csv"

function main()
    open("output.dat", "w") do f
        vector_x, vector_y, has_err = read_csv(CSV_FILE)
        if has_err
            return
        end

        x_1 = vector_x[1:6000]
        y_1 = vector_y[1:6000]
        x_2 = vector_x[6001:10000]
        y_2 = vector_y[6001:10000]

        println(f, "----- first 6000 data -----")
        theta_hat_1, Phi_N_inv_1, sum_phi_T_y_1 = calculate_estimate_values(x_1, y_1)
        println(f, "$theta_hat_1")

        println(f, "----- last 4000 data -----")
        theta_hat_2, Phi_N_inv_2, sum_phi_T_y_2 = calculate_estimate_values(x_2, y_2)
        println(f, "$theta_hat_2")
        
        Phi_synthesized_inv = Phi_N_inv_1 + Phi_N_inv_2
        sum_phi_T_y_synthesized = sum_phi_T_y_1 + sum_phi_T_y_2
        
        theta_hat_synthesized = inv(Phi_synthesized_inv) * sum_phi_T_y_synthesized

        println(f, "----- synthesized -----")
        println(f, "$theta_hat_synthesized")

        println(f, "----- full data -----")
        theta_hat_full, _, _ = calculate_estimate_values(vector_x, vector_y)
        println(f, "$theta_hat_full")
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end