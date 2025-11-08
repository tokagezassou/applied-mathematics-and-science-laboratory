# png ファイルに出力する
set term png
set output "q10.png"

# 軸と key(凡例)
set xlabel '{Time}'
set ylabel '{Value of θ_k}'
# set yrange [-1.5:2.5]
# set logscale x
# set format x "10^{%T}"
# set logscale y
# set format y "10^{%T}"

# フォント設定
set xlabel font "Arial,20"
set ylabel font "Arial,20"
set tics font "Arial,15"
set key font "Arial,15"
# ラベルの位置調整
set xlabel offset 0,-1
set ylabel offset 1,0
#凡例の位置調整
set key at 7000, -0.4
# set key outside

plot 'output.dat' using 1:2 linetype 1 pointsize 0.1 pointtype 7  notitle ,\
    'output.dat' using 1:3 linetype 2 pointsize 0.2 pointtype 7 notitle ,\
    keyentry with points linetype 1 pointsize 1.3 pointtype 7 title 'estimate value' ,\
    keyentry with points linetype 2 pointsize 1.3 pointtype 7 title 'true value'


quit