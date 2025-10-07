import numpy as np

def main():
    matrix_64 = np.random.uniform(low=-1.0, high=1.0, size=(100,100))
    matrix_32 = matrix_64.astype(np.float32)
    print(matrix_64)
    print(f"変換後の dtype:   {matrix_32.dtype}")

if __name__ == "__main__":
    main()