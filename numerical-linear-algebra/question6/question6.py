import numpy as np
import time

def generate_random_matrix(s):
    matrix_tmp = np.random.uniform(-1.0, 1.0, size=(s, s))
    matrix = matrix_tmp + np.transpose(matrix_tmp)
    return matrix

# 最大値ノルムを計算する
def norm(m):
    return np.max(np.abs(m))

# 全ての固有値を求める
def calculate_eigenvalues(m):
    matrix = m.copy()
    size = matrix.shape[0]
    threshold = 1e-3
    max_calculate_num = 100000

    for k in range (max_calculate_num):
        not_converged_count = 0
        for i in range(size):
            for j in range(i):
                if norm(matrix[i,j]) / norm(matrix[i,i]) > threshold:
                    not_converged_count += 1
        
        if not_converged_count == 0:
            eigenvalues_tmp = np.zeros(size)
            for i in range(size):
                eigenvalues_tmp[i] = matrix[i,i]
            
            eigenvalues, eigenvectors = calculate_eigenvectors(m, eigenvalues_tmp)
            return eigenvalues, eigenvectors, k+1
        
        matrix_Q, matrix_R = QR_decomposition(matrix)
        matrix = np.dot(matrix_R, matrix_Q)
    
    print("not finished within ", max_calculate_num, "times")
    return np.zeros(size), np.eye(size), 0

def calculate_eigenvectors(matrix, eigenvalues_tmp):
    size = len(eigenvalues_tmp)
    eigenvalues = np.zeros(size)
    eigenvectors = np.eye(size)

    for i in range(size):
        eigenvalues[i], eigenvectors[:,i] = calculate_eigenvector(matrix, eigenvalues_tmp[i])
    
    return eigenvalues, eigenvectors

# 固有ベクトルを求める
def calculate_eigenvector(matrix, sigma):
    size = matrix.shape[0]
    vector_x = np.random.uniform(-1.0, 1.0, size=size)
    m = matrix - sigma * np.eye(size)
    matrix_L, matrix_U, permutation = LU_decomposition(m, vector_x)
    
    threshold = 1e-12
    max_calculate_num = 100000
    mu = 999999

    for k in range(max_calculate_num):
        vector_y = solve_equations(matrix_L, matrix_U, permutation, vector_x)
        max_index = np.argmax(np.abs(vector_x))
        mu_prev = mu
        mu = vector_y[max_index] / vector_x[max_index]

        if np.abs((mu - mu_prev) / mu) < threshold:
            return 1 / mu + sigma, vector_x
        
        vector_x = vector_y / norm(vector_y)

        if k == max_calculate_num-1:
            print("not finished within ", max_calculate_num, "times")
            return 0, np.zeros(size)

# LU分解をする
def LU_decomposition(matrix, vector):
    size = len(vector)
    matrix = matrix.copy()
    vector = vector.copy()

    # 行列Lと置換πの初期化
    matrix_L = np.eye(size)
    permutation = np.arange(size, dtype=int)
    for i in range(size):
        permutation[i] = i

    for k in range(size-1):
        pivot_index = np.argmax(np.abs(matrix[k:, k])) + k
        matrix[[k, pivot_index]] = matrix[[pivot_index, k]]
        matrix_L[[k, pivot_index]] = matrix_L[[pivot_index, k]]
        permutation[[k, pivot_index]] = permutation[[pivot_index, k]]

        matrix_L[k, k] = 1
        pivot = matrix[k, k]
        for i in range(k+1, size):
            multiplier = matrix[i, k] / pivot
            matrix[i, k:] -= multiplier * matrix[k, k:]
            matrix_L[i, k] = multiplier
    
    return matrix_L, matrix, permutation

# LU分解された行列に対して方程式の解を求める
def solve_equations(matrix_L, matrix_U, permutation, vector):
    size = matrix_L.shape[0]
    solution_tmp = np.zeros(size)
    for i in range(size):
        sum = np.dot(matrix_L[i, :i], solution_tmp[:i])
        solution_tmp[i] = vector[permutation[i]] - sum
    
    solution = np.zeros(size)
    for i in range(size-1, -1, -1):
        sum = np.dot(matrix_U[i, i+1:], solution[i+1:])
        solution[i] = (solution_tmp[i] - sum) / matrix_U[i,i]
    
    return solution

# QR分解をする
def QR_decomposition(m):
    matrix = m.copy()
    size = matrix.shape[0]
    matrix_Q = np.eye(size)
    matrix_R = np.eye(size)
    
    for j in range(size):
        vector_b = matrix[:,j]
        for i in range(j):
            matrix_R[i,j] = np.dot(matrix_Q[:,i], vector_b)
            vector_b = vector_b - matrix_R[i,j] * matrix_Q[:,i]
        
        matrix_R[j,j] = np.linalg.norm(vector_b)
        matrix_Q[:,j] = vector_b / matrix_R[j,j]
    
    return matrix_Q, matrix_R

def main():
    with open('numerical-linear-algebra/output.txt', 'w', encoding='utf-8') as f:
        size_map = [10, 20, 40, 80]
        for i in range(4):
            size = size_map[i]
            print("--------------------------------------------------------------------------------", file = f)
            print("size = ", size, file = f)

            for j in range(1):
                matrix = generate_random_matrix(size)
                true_eigenvalues, true_eigenvectors = np.linalg.eig(matrix)

                start_time = time.perf_counter()
                eigenvalues, eigenvectors, calculate_num = calculate_eigenvalues(matrix)
                end_time = time.perf_counter()

                residual_norms = np.zeros(size)
                relative_errors = np.zeros(size)
                for i in range(size):
                    residual_norms[i] = norm(np.dot(matrix - eigenvalues[i] * np.eye(size), eigenvectors[:,i]))
                    relative_errors[i] = np.abs(true_eigenvalues[i] - eigenvalues[i]) / np.abs(true_eigenvalues[i])
                max_residual_norm = np.max(residual_norms)
                max_relative_error = np.max(relative_errors)
                calculation_time = end_time - start_time
                
                # trial  max_residual_norm  max_relative_error  calculation_time  calculate_num
                # print(
                #     j+1,
                #     max_residual_norm,
                #     max_relative_error,
                #     calculation_time,
                #     calculate_num,
                #     file = f
                # )
                print(
                    j+1,
                    max_residual_norm,
                    max_relative_error,
                    calculation_time,
                    calculate_num,
                )

if __name__ == "__main__":
    main()