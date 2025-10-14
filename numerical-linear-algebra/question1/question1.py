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
    augmented_matrix = np.c_[matrix, vector]

    for i in range(size):
        pivot_index = np.argmax(np.abs(augmented_matrix[i:, i])) + i
        augmented_matrix[[i, pivot_index]] = augmented_matrix[[pivot_index, i]]

        pivot = augmented_matrix[i, i]
        for j in range(i+1, size):
            multiplier = augmented_matrix[j, i] / pivot
            augmented_matrix[j, i:] -= multiplier * augmented_matrix[i, i:]
        
    solution = np.zeros(size)
    for i in range(size-1, -1, -1):
        sum = np.dot(augmented_matrix[i, i+1:size], solution[i+1:])
        solution[i] = (augmented_matrix[i, size] - sum) / augmented_matrix[i,i]
    
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