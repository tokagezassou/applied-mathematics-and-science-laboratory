import numpy as np

def generate_random_matrixes(order):
    matrix = np.random.uniform(-1.0, 1.0, size=(order, order))
    vector = np.random.uniform(-1.0, 1.0, size=order)
    return matrix, vector

# 数値解を求める
def solve_equations(matrix, vector):
    order = len(vector)
    augmented_matrix = np.c_[matrix, vector]

    for i in range(order):
        pivot_index = np.argmax(np.abs(augmented_matrix[i:, i])) + i
        augmented_matrix[[i, pivot_index]] = augmented_matrix[[pivot_index, i]]

        pivot = augmented_matrix[i, i]
        for j in range(i+1, order):
            multiplier = augmented_matrix[j, i] / pivot
            augmented_matrix[j, i:] -= multiplier * augmented_matrix[i, i:]
        
    solution = np.zeros(order)
    for i in range(order-1, -1, -1):
        sum = np.dot(augmented_matrix[i, i+1:order], solution[i+1:])
        solution[i] = (augmented_matrix[i, order] - sum) / augmented_matrix[i,i]
    
    return solution        

def main():
    with open('assignment-1/output.txt', 'w', encoding='utf-8') as f:
        matrix, vector = generate_random_matrixes(3)
        true_solution = np.linalg.solve(matrix, vector)
        numerical_solution = solve_equations(matrix, vector)
        print(true_solution, file=f)
        print(numerical_solution, file=f)

if __name__ == "__main__":
    main()