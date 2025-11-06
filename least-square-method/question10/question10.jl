using CSV
using DataFrames
using LinearAlgebra
using Statistics

function generate_data(size)
    vector_y = zeros(size)
    vector_theta_true = zeros(size)
    
    for k in 1:size
        theta_true = sin(0.0001 * k)
        
        w_k = rand([-1.0, 1.0])
        y_k = theta_true + w_k
        
        vector_y[k] = y_k
        vector_theta_true[k] = theta_true
    end
    return vector_y, vector_theta_true
end

"""
忘却係数付き逐次最小二乗法 (RLS) を実行します。 
課題10のモデル y_k = θ_k + w_k は、 y_k = φ_k * θ_k + w_k において
φ_k = 1 とした場合に相当します。
"""
function run_recursive_least_squares(
    vector_y::Vector{Float64}, 
    gamma::Float64, 
    P_init::Float64, 
    theta_hat_init::Float64
)
    N = length(vector_y)
    vector_theta_hat = zeros(N)
    
    # 状態変数の初期化
    theta_hat = theta_hat_init # $\hat{\theta}_{\gamma, 0}$
    P = P_init                 # $\Phi_{\gamma, 0}$

    for k in 1:N
        y_k = vector_y[k]
        
        # 課題10のモデル y_k = 1 * θ_k + w_k より、φ_k = 1
        phi_k = 1.0
        
        # ---------------------------------------------------
        # 逐次更新アルゴリズム (式 3.29, 3.30, 3.31)
        # ---------------------------------------------------
        
        # ゲイン K の計算 (式 3.30 のスカラ版) [cite: 288]
        # K = P * φ' * (γ * I_m + φ * P * φ')^-1
        # φ=1, I_m=1 のため: K = P / (γ + P)
        K = P / (gamma + P)
        
        # 推定値 θ の更新 (式 3.29) [cite: 286]
        # $\hat{\theta}_k = \hat{\theta}_{k-1} + K_k (y_k - φ_k * \hat{\theta}_{k-1})$
        theta_hat = theta_hat + K * (y_k - phi_k * theta_hat)
        
        # 共分散行列 P (Φ) の更新 (式 3.31 のスカラ版) [cite: 289]
        # P_k = (1/γ) * (P_{k-1} - K_k * φ_k * P_{k-1})
        # P_k = (1/γ) * P_{k-1} * (1 - K_k * φ_k)
        P = (1.0 / gamma) * P * (1.0 - K * phi_k)
        
        vector_theta_hat[k] = theta_hat
    end
    
    return vector_theta_hat
end

# 出力ファイル名
const OUTPUT_FILE = "output_task10.dat"

function main()
    const N_DATA = 10000
    const GAMMA = 0.99 # 忘却係数 [cite: 296]
    
    # 逐次推定の初期値 ( [cite: 248] 等を参考に設定)
    # P_0 (Φ_0): 初期共分散。大きな値は初期推定値の信頼度が低いことを意味する
    const P_INITIAL = 1000.0
    # $\hat{\theta}_0$: パラメータの初期推定値
    const THETA_HAT_INITIAL = 0.0
    
    println("Generating data for Task 10...")
    # 1. データの生成 [cite: 292, 293]
    vector_y, vector_theta_true = generate_data(N_DATA)
    
    println("Running RLS with forgetting factor...")
    # 2. 逐次最小二乗法の実行 
    vector_theta_hat = run_recursive_least_squares(
        vector_y, 
        GAMMA, 
        P_INITIAL, 
        THETA_HAT_INITIAL
    )
    
    # 3. 結果をファイルに出力 (プロット用) [cite: 296]
    open(OUTPUT_FILE, "w") do f
        # Gnuplot等で読みやすいようヘッダーを付与
        println(f, "# k  theta_true(sin(0.0001k))  theta_hat_rls")
        
        for k in 1:N_DATA
            k_str = k
            true_str = vector_theta_true[k]
            hat_str = vector_theta_hat[k]
            
            # 各時刻の k, 真値, 推定値 を出力
            println(f, "$k_str $true_str $hat_str")
        end
    end
    
    println("Finished. Results written to $OUTPUT_FILE")
    println("You can plot the results using gnuplot:")
    println("plot \"$OUTPUT_FILE\" u 1:2 w l title 'true', \\")
    println("     \"$OUTPUT_FILE\" u 1:3 w l title 'estimate (γ=$GAMMA)'")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end