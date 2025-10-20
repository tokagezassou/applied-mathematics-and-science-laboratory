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
    threshold = 1e-6
    max_calculate_num = 100000
    eigenvalues = []

    for k in range (max_calculate_num):
        size = matrix.shape[0]
        not_converged_counts = np.zeros(size)
        shift = 0
        for i in range(size):
            for j in range(i):
                if norm(matrix[i,j]) / norm(matrix[i,i]) > threshold:
                    not_converged_counts[j] += 1
        
        for j in range(size):
            if not_converged_counts[j] == 0:
                eigenvalue = matrix[j,j] + shift
                eigenvalues.append(eigenvalue)
                shift += eigenvalue

                rows = np.r_[:j, j+1:size]
                cols = np.r_[:j, j+1:size]
                matrix = matrix[np.ix_(rows, cols)]
                matrix -= eigenvalue * np.eye(size-1)
                        
        matrix_Q, matrix_R = QR_decomposition(matrix)
        matrix = np.dot(matrix_R, matrix_Q)
    
    print("not finished within ", max_calculate_num, "times")
    return np.zeros(size), 0

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
            # print("size = ", size)

            for j in range(3):
                matrix = generate_random_matrix(size)
                true_eigenvalues, true_eigenvectors = np.linalg.eig(matrix)

                indices = np.argsort(true_eigenvalues)
                sorted_true_eigenvalues = true_eigenvalues[indices]
                sorted_true_eigenvectors = true_eigenvectors[:, indices]

                start_time = time.perf_counter()
                eigenvalues, calculate_num = calculate_eigenvalues(matrix)
                end_time = time.perf_counter()

                sorted_eigenvalues = np.sort(eigenvalues)

                residual_norms = np.zeros(size)
                relative_errors = np.zeros(size)
                for i in range(size):
                    residual_norms[i] = norm(np.dot(matrix - sorted_eigenvalues[i] * np.eye(size), sorted_true_eigenvectors[:,i]))
                    relative_errors[i] = np.abs(sorted_true_eigenvalues[i] - sorted_eigenvalues[i]) / np.abs(sorted_true_eigenvalues[i])
                max_residual_norm = np.max(residual_norms)
                max_relative_error = np.max(relative_errors)
                calculation_time = end_time - start_time
                
                # trial  max_residual_norm  max_relative_error  calculation_time  calculate_num
                print(
                    j+1,
                    max_residual_norm,
                    max_relative_error,
                    calculation_time,
                    calculate_num,
                    file = f
                )
                # print(
                #     j+1,
                #     max_residual_norm,
                #     max_relative_error,
                #     calculation_time,
                #     calculate_num,
                # )

if __name__ == "__main__":
    main()