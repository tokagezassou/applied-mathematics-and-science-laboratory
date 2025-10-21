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
    threshold = 1e-4
    max_calculate_num = 100000

    for k in range (max_calculate_num):
        not_converged_count = 0
        # for i in range(size):
        #     for j in range(i):
        #         if norm(matrix[i,j]) / norm(matrix[i,i]) > threshold:
        #             not_converged_count += 1

        # ▽▽▽ ここから変更 ▽▽▽
        # 高速な収束判定（ベクトル化）
        
        # 1. 対角成分の絶対値を取得
        diag_abs = np.abs(np.diag(matrix))
        # ゼロ除算を避けるための小さな値
        diag_abs[diag_abs == 0] = 1.0e-12
        
        # 2. 下三角行列（対角成分を除く）の絶対値を取得
        #    （元が行列対称なので、下三角だけで十分）
        lower_tri_abs = np.abs(np.tril(matrix, k=-1))
        
        # 3. 各要素を「その行の対角成分の絶対値」で割る
        #    NumPyのブロードキャスティング機能を利用
        #    diag_abs.reshape(-1, 1) で (size,) -> (size, 1) の列ベクトルに変換
        ratios = lower_tri_abs / diag_abs.reshape(-1, 1)
        
        # 4. thresholdを超えている要素の数をカウント
        not_converged_count = np.sum(ratios > threshold)
        
        # △△△ ここまで変更 △△△
        
        if not_converged_count == 0:
            eigenvalues = np.zeros(size)
            for i in range(size):
                eigenvalues[i] = matrix[i,i]
            return eigenvalues, k+1
        
        matrix_Q, matrix_R = QR_decomposition(matrix)
        matrix = np.dot(matrix_R, matrix_Q)
    
    print("not finished within ", max_calculate_num, "times")
    return np.zeros(size), 0

# QR分解をする
def QR_decomposition(m):
    matrix = m.copy()
    size = matrix.shape[0]
    matrix_Q = np.zeros((size, size))
    matrix_R = np.zeros((size, size))
    
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

            for j in range(50):
                print("size: ", size, "  trial: ", j+1)
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