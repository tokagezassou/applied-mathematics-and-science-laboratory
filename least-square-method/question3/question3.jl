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
    matrix_X = Matrix(df[:, [1, 2]])
    vector_y = df[:, 3]

    return matrix_X, vector_y, false
end

# 課題3.1
function calculate_min_sqr_err_estimate(f, matrix_X, vector_y)
    min_sqr_err_estimate = matrix_X \ vector_y

    println(f, "----- question3.1 -----")
    println(f, min_sqr_err_estimate) 
    return
end

# 課題3.2
function increase_data_num(f, matrix_X, vector_y)
    println(f, "----- question3.2 -----")
    for i in 1:13
        data_num = 2^i
        
        cut_X = matrix_X[1:data_num, :]
        cut_y = vector_y[1:data_num]
        
        min_sqr_err_estimate = cut_X \ cut_y
        
        println(f, "$data_num  $(min_sqr_err_estimate[1])  $(min_sqr_err_estimate[2])")
    end
end

const CSV_FILE = "input.csv"

function main()    
    open("output.dat", "w") do f
        matrix_X, vector_y, has_err = read_csv(CSV_FILE)
        if has_err
            return
        end

        calculate_min_sqr_err_estimate(f, matrix_X, vector_y)
        increase_data_num(f, matrix_X, vector_y)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end