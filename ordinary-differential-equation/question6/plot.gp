# png ファイルに出力する
set term png
set output "q6.png"

# 軸と key(凡例)
set xlabel '{Time}'
set ylabel '{Solution}'
set xrange [0:3]
set yrange [0:1e5]
# set logscale x
# set format x "10^{%T}"
set logscale y
set format y "10^{%T}"

# フォント設定
set xlabel font "Arial,20"
set ylabel font "Arial,20"
set tics font "Arial,15"
set key font "Arial,15"
# ラベルの位置調整
set xlabel offset 0,-1
set ylabel offset 1,0
#凡例の位置調整
# set key at 0.54, 0.8
# set key outside

plot 'output.dat' using 1:2 every ::1::301 linetype 1 pointsize 0.5 pointtype 7 notitle ,\
    'output.dat' using 1:2 every ::303::603 linetype 2 pointsize 0.5 pointtype 7 notitle ,\
    'output.dat' using 1:2 every ::605::905 linetype 3 pointsize 0.5 pointtype 7 notitle ,\
    keyentry with points linetype 1 pointsize 1.3 pointtype 7 title 'u_0 = 0.9' ,\
    keyentry with points linetype 2 pointsize 1.3 pointtype 7 title 'u_0 = 1.0' ,\
    keyentry with points linetype 3 pointsize 1.3 pointtype 7 title 'u_0 = 1.1'


quit