# png ファイルに出力する
set term png
set output "q3.png"

# 軸と key(凡例)
set xlabel '{Value of i}'
set ylabel '{Calclation Order}'
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

plot 'output.dat' using 1:3 pointsize 1 pointtype 7 title 'Forward Euler' ,\
    'output.dat' using 1:5 pointsize 1 pointtype 7 title 'Adams-Bashforth 2',\
    'output.dat' using 1:7 pointsize 1 pointtype 7 title 'Adams-Bashforth 3' ,\
    'output.dat' using 1:9 pointsize 1 pointtype 7 title 'Heun',\
    'output.dat' using 1:11 pointsize 1 pointtype 7 title 'Runge-Kutta'


quit