import numpy as np
import time

def generate_random_matrixes(s):
    matrix_tmp = np.random.uniform(-1.0, 1.0, size=(s, s))
    matrix = matrix_tmp + np.transpose(matrix_tmp)
    vector = np.random.uniform(-1.0, 1.0, size=s)
    return matrix, vector

# 最大値ノルムを計算する
def norm(m):
    return np.max(np.abs(m))

# 第１固有値を求める
def calculate_first_eigenvalue(matrix, vector_x):
    size = len(vector_x)
    threshold = 1e-12
    max_calculate_num = 1000000
    mu = 999999

    for k in range(max_calculate_num):
        vector_y = np.dot(matrix, vector_x)
        max_index = np.argmax(np.abs(vector_x))
        mu_prev = mu
        mu = vector_y[max_index] / vector_x[max_index]

        if np.abs((mu - mu_prev) / mu) < threshold:
            return mu, vector_x, k+1
        
        vector_x = vector_y / norm(vector_y)

        if k == max_calculate_num-1:
            print("not finished within ", max_calculate_num, "times")
            return 0, np.zeros(size), 0     

def calculate_eigenvector_relative_error(main_vector, sub_vector):
    main_norm = norm(main_vector)
    sub_norm = norm(sub_vector)
    if main_norm < 1e-12 or sub_norm < 1e-12:
        return 999999

    sub_vector = sub_vector * (norm(main_vector) / norm(sub_vector))

    max_index = np.argmax(np.abs(main_vector))
    if main_vector[max_index] * sub_vector[max_index] < 0:
        sub_vector = -sub_vector
    
    return norm(main_vector - sub_vector) / norm(sub_vector)

def main():
    with open('numerical-linear-algebra/output.txt', 'w', encoding='utf-8') as f:
        size_map = [50, 100, 200, 400]
        for i in range(4):
            size = size_map[i]
            print("--------------------------------------------------------------------------------", file = f)
            print("size = ", size, file = f)

            for j in range(100):
                matrix, vector = generate_random_matrixes(size)
                true_eigenvalues, true_eigenvectors = np.linalg.eig(matrix)
                max_index = np.argmax(np.abs(true_eigenvalues))
                true_first_eigenvalue = true_eigenvalues[max_index]
                true_first_eigenvector = true_eigenvectors[:, max_index]

                start_time = time.perf_counter()
                first_eigenvalue, first_eigenvector, calculate_num = calculate_first_eigenvalue(matrix, vector)
                end_time = time.perf_counter()

                residual_norm = norm(first_eigenvalue * first_eigenvector - np.dot(matrix, first_eigenvector))
                eigenvalue_relative_error = np.abs(true_first_eigenvalue - first_eigenvalue) / np.abs(true_first_eigenvalue)
                eigenvector_relative_error = calculate_eigenvector_relative_error(
                    true_first_eigenvector,
                    first_eigenvector,
                )
                calculation_time = end_time - start_time
                
                # trial  residual_norm  relative_error  calculation_time
                print(
                    j+1,
                    residual_norm,
                    eigenvalue_relative_error,
                    eigenvector_relative_error,
                    calculation_time,
                    calculate_num,
                    file = f
                )

if __name__ == "__main__":
    main()