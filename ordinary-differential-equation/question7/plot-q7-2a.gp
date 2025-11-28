# png ファイルに出力する
set term png
set output "q7-2a.png"

# 軸と key(凡例)
set xlabel '{i}'
set ylabel '{x(t)}'
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
# set key at 0.54, 0.8
set key outside

plot 'output.dat' using 2:4 every 3::10002::10041 pointsize 0.7 pointtype 7 title 'Forward Euler' ,\
    'output.dat' using 2:5 every 3::10002::10041 pointsize 0.7 pointtype 7 title 'Runge-Kutta' ,\


quit