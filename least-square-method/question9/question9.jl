using LinearAlgebra
using Printf

"""
課題9.1 を解くための関数です。
バネ・マス・ダンパ系 のシミュレーションと、
逐次最小二乗法 によるパラメータ推定を同時に実行します。

引数:
- k_max: シミュレーションの最大ステップ数 (課題9.1では 10000) 
- epsilon: Phi_0 の初期化に用いる正則化パラメータ 

戻り値:
- theta_history: 各ステップ k での推定パラメータ theta_hat の履歴 (k_max x 3 の行列)
- theta_final: 最終的な推定パラメータ (3要素ベクトル)
"""
function estimate_parameters_with_constant_force() 
    M_true = 2.0
    D_true = 1.0
    K_true = 3.0
    dt = 0.01
    epsilon = 1.0e-6

    theta1_true = 2.0 - (D_true / M_true) * dt
    theta2_true = -(1.0 - (D_true / M_true) * dt + (K_true / M_true) * dt^2)
    theta3_true = (dt^2) / M_true
     
    theta_hat = zeros(3)
    Phi_tilde = (1.0 / epsilon) * Matrix(I, 3, 3) 

    y_-2 = 0.0 
    y_-1 = 0.0 
    
    F_-2 = 1.0 
    F_-1 = 1.0
    F_k = 1.0         

    theta_history = zeros(10000, 3)

    for k in 1:10000
        w_k = rand() * 2.0 - 1.0 
        
        y_k = theta1_true * y_-1 + theta2_true * y_-2 + theta3_true * F_-2 + w_k

        phi_k = [y_-1 y_-2 F_-2] 
        phi_k_T = transpose(phi_k)
        
        denominator = 1.0 + (phi_k * Phi_tilde * phi_k_T)[1]
        K_k = (Phi_tilde * phi_k_T) / denominator

        # パラメータ theta_hat_k を更新 
        prediction_error = y_k - (phi_k * theta_hat)[1] # スカラ
        theta_hat = theta_hat + K_k * prediction_error # (3 x 1) ベクトル

        # 共分散行列 Phi_tilde_k を更新 
        Phi_tilde = Phi_tilde - K_k * phi_k * Phi_tilde # (3 x 3) 行列

        # 4.4. 結果を保存
        theta_history[k, :] = theta_hat

        # 4.5. 次のステップのために状態を更新
        y_k_minus_2 = y_k_minus_1
        y_k_minus_1 = y_k
        
        # F_k は常に 1.0 
        F_k_minus_2 = F_k_minus_1
        F_k_minus_1 = F_k
    end

    return theta_history, theta_hat
end

const K_MAX = 10000 # 
const EPSILON = 1.0e-6 # 正則化パラメータ 
const DT = 0.01      # 

function main()
    # ユーザーのサンプルと同様に output.dat に結果を書き出す
    open("output.dat", "w") do f
        println(f, "========== 課題 9.1 の実行結果 ==========")
        println(f, "逐次最小二乗法によるパラメータ推定 ")
        println(f, "シミュレーションステップ数 k_max = $K_MAX")
        println(f, "外力 F_k = 1.0 (一定) ")
        println(f, "初期パラメータ theta_hat_0 = [0, 0, 0]^T ")
        println(f, "初期共分散行列 Phi_tilde_0 = (1 / $EPSILON) * I ")

        # 課題9.1の関数を実行
        estimate_parameters_with_constant_force()

        println(f, "\n--- 最終推定パラメータ (k = $K_MAX) ---")
        @printf(f, "theta_hat_final = [%.8f, %.8f, %.8f]\n", theta_final[1], theta_final[2], theta_final[3])

        # --- 推定された theta から M, D, K を逆算 ---
        # 
        # theta_1 = 2 - (D/M)*dt
        # theta_2 = -(1 - (D/M)*dt + (K/M)*dt^2)
        # theta_3 = dt^2 / M
        
        println(f, "\n--- 推定パラメータからの物理量 (M, D, K) の復元 ---")
        theta1_est = theta_final[1]
        theta2_est = theta_final[2]
        theta3_est = theta_final[3]

        if theta3_est <= 0
            println(f, "M の推定値が負またはゼロになるため、M, D, K を復元できませんでした。")
        else
            # M を復元
            M_est = (DT^2) / theta3_est
            
            # D を復元 (theta_1 より)
            # (D/M)*dt = 2 - theta_1
            D_est = (2.0 - theta1_est) * M_est / DT
            
            # K を復元 (theta_2 より)
            # (K/M)*dt^2 = -theta_2 - 1 + (D/M)*dt
            # (D/M)*dt = 2 - theta_1 を代入
            # (K/M)*dt^2 = -theta_2 - 1 + (2 - theta_1) = 1 - theta_1 - theta_2
            K_est = (1.0 - theta1_est - theta2_est) * M_est / (DT^2)

            @printf(f, "M_est = %.4f (真値 M = 2.0)\n", M_est)
            @printf(f, "D_est = %.4f (真値 D = 1.0)\n", D_est)
            @printf(f, "K_est = %.4f (真値 K = 3.0)\n", K_est)
        end
        
        println(f, "\n--- 推定値の収束の様子 (最初と最後) ---")
        for k in 1:5
             @printf(f, "k=%-5d: [%.6f, %.6f, %.6f]\n", k, theta_history[k,1], theta_history[k,2], theta_history[k,3])
        end
        println(f, "...")
        for k in (K_MAX-4):K_MAX
             @printf(f, "k=%-5d: [%.6f, %.6f, %.6f]\n", k, theta_history[k,1], theta_history[k,2], theta_history[k,3])
        end
        println(f, "==========================================")
    end
    println("課題9.1のシミュレーションが完了しました。結果は 'output.dat' に保存されました。")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end