using CSV
using DataFrames
using LinearAlgebra
using Statistics

function read_csv(csv_file_path::String)
    if !isfile(csv_file_path)
        println("file not found: $csv_file_path")
        return nothing, nothing, true
    end
    df = CSV.read(csv_file_path, DataFrame, header=false)
    vector_x = df[:, 1]
    vector_y = df[:, 2]

    return vector_x, vector_y, false
end

function form_phi_x(vector_x)
    data_num = length(vector_x)

    matrix_X = ones(data_num, 4)
    matrix_X[:, 2] = vector_x
    matrix_X[:, 3] = vector_x .^ 2
    matrix_X[:, 4] = vector_x .^ 3
    
    return matrix_X
end

# 課題4
function calculate_min_sqr_err_estimate(f, matrix_X, vector_y)
    data_num, data_size = size(matrix_X)
    
    min_sqr_err_estimate = matrix_X \ vector_y
    residuals = vector_y - matrix_X * min_sqr_err_estimate
    rss = sum(residuals.^2) 
    sigma2_hat = rss / (data_num - data_size)

    inv_XTX = inv(matrix_X' * matrix_X)
    cov_matrix_estimate = sigma2_hat * inv_XTX

    println(f, "----- question4 -----")
    println(f, "$min_sqr_err_estimate  $cov_matrix_estimate") 
    return
end

const CSV_FILE = "input.csv"

function main()    
    open("output.dat", "w") do f
        vector_x, vector_y, has_err = read_csv(CSV_FILE)
        if has_err
            return
        end
        matrix_X = form_phi_x(vector_x)

        calculate_min_sqr_err_estimate(f, matrix_X, vector_y)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end