import numpy as np
import time

def generate_random_matrixes(s):
    matrix = np.random.uniform(-1.0, 1.0, size=(s, s))
    vector = np.random.uniform(-1.0, 1.0, size=s)
    return matrix, vector

# 最大値ノルムを計算する
def norm(m):
    return np.max(np.abs(m))

# 数値解を求める
def solve_equations(matrix, vector):
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
        
    solution_tmp = np.zeros(size)
    for i in range(size):
        sum = np.dot(matrix_L[i, :i], solution_tmp[:i])
        solution_tmp[i] = vector[permutation[i]] - sum
    
    solution = np.zeros(size)
    for i in range(size-1, -1, -1):
        sum = np.dot(matrix[i, i+1:], solution[i+1:])
        solution[i] = (solution_tmp[i] - sum) / matrix[i,i]
    
    return solution        

def main():
    with open('numerical-linear-algebra/output.txt', 'w', encoding='utf-8') as f:
        size_map = [100, 200, 400, 800]
        for i in range(4):
            size = size_map[i]
            print("--------------------------------------------------------------------------------", file = f)
            print("size = ", size, file = f)

            for j in range(100):
                matrix, vector = generate_random_matrixes(size)
                true_solution = np.linalg.solve(matrix, vector)

                start_time = time.perf_counter()
                numerical_solution = solve_equations(matrix, vector)
                end_time = time.perf_counter()

                residual_norm = norm(vector - np.dot(matrix, numerical_solution))
                relative_error = norm(numerical_solution - true_solution) / norm(true_solution)
                calculation_time = end_time - start_time
                
                # trial  residual_norm  relative_error  calculation_time
                print(j+1, residual_norm, relative_error, calculation_time, file = f)

if __name__ == "__main__":
    main()