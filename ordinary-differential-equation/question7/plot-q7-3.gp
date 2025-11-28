# png ファイルに出力する
set term png
set output "q7-3.png"

# 軸と key(凡例)
set xlabel '{Time}'
set ylabel '{x(t)}'
# set yrange [-1.5:2.5]
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
set key outside

plot 'output.dat' using 1:2 every ::10045::110045 pointsize 0.3 pointtype 7 title 'epsilon = 0' ,\
    'output.dat' using 1:2 every ::110047::210046 pointsize 0.3 pointtype 7 title 'epsilon = 0.1' ,\
    'output.dat' using 1:2 every ::210048::310047 pointsize 0.3 pointtype 7 title 'epsilon = 0.01' ,\
    'output.dat' using 1:2 every ::310049::410048 pointsize 0.3 pointtype 7 title 'epsilon = 0.001'


quit