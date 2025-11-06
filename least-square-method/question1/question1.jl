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
    matrix_X = Matrix(df[:, [1, 2]])
    vector_y = df[:, 3]

    return matrix_X, vector_y, false
end

# 課題1.1
function calculate_min_sqr_err_estimate(f, matrix_X, vector_y)
    data_num, data_size = size(matrix_X)
    
    inv_XTX = inv(matrix_X' * matrix_X)
    min_sqr_err_estimate = inv_XTX * (matrix_X' * vector_y)
    
    residuals = vector_y - matrix_X * min_sqr_err_estimate
    rss = sum(residuals.^2) 
    sigma2_hat = rss / (data_num - data_size)

    inv_XTX = inv(matrix_X' * matrix_X)
    cov_matrix_estimate = sigma2_hat * inv_XTX

    println(f, "----- question1.1 -----")
    println(f, "$min_sqr_err_estimate  $cov_matrix_estimate") 
    return min_sqr_err_estimate
end

# 課題1.2
function increase_data_num(f, matrix_X, vector_y)
    println(f, "----- question1.2 -----")
    for i in 1:13
        data_num = 2^i
        
        cut_X = matrix_X[1:data_num, :]
        cut_y = vector_y[1:data_num]
        
        min_sqr_err_estimate = inv(cut_X' * cut_X) * (cut_X' * cut_y)
        
        println(f, "$data_num  $(min_sqr_err_estimate[1])  $(min_sqr_err_estimate[2])")
    end
end

# 課題1.3
function calculate_determination_coefficient(f, matrix_X, vector_y, theta_hat)
    y_mean = mean(vector_y)
    y_predicted = matrix_X * theta_hat
    
    numerator = sum((y_predicted .- y_mean).^2)
    denominator = sum((vector_y .- y_mean).^2)
    
    if denominator == 0
        println("denominator == 0")
        return
    else
        determination_coefficient = numerator / denominator
    end

    println(f, "----- question1.3 -----")
    println(f, determination_coefficient)
    return
end

const CSV_FILE = "input.csv"

function main()    
    open("output.dat", "w") do f
        matrix_X, vector_y, has_err = read_csv(CSV_FILE)
        if has_err
            return
        end

        min_sqr_err_estimate = calculate_min_sqr_err_estimate(f, matrix_X, vector_y)
        increase_data_num(f, matrix_X, vector_y)
        calculate_determination_coefficient(f, matrix_X, vector_y, min_sqr_err_estimate)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end