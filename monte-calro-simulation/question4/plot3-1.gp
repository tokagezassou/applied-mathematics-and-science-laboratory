# png ファイルに出力する
set term png
set output "q4-3-1.png"

# 軸と key(凡例)
set xlabel '{Parameter z}'
set ylabel '{Magnetization Mean}'
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
set key at 1.5, 0.4
# set key outside

plot 'output3.dat' using 2:3 every ::1::12 linetype 1 pointsize 1 pointtype 7 notitle ,\
    'output3.dat' using 2:3 every ::13::24 linetype 2 pointsize 1 pointtype 7 notitle ,\
    'output3.dat' using 2:3 every ::25::36 linetype 3 pointsize 1 pointtype 7 notitle ,\
    'output3.dat' using 2:3 every ::37::48 linetype 4 pointsize 1 pointtype 7 notitle ,\
    'output3.dat' using 2:3 every ::49::60 linetype 5 pointsize 1 pointtype 7 notitle ,\
    'output3.dat' using 2:3 every ::61::72 linetype 6 pointsize 1 pointtype 7 notitle ,\
    keyentry with points linetype 1 pointsize 1.3 pointtype 7 title 'L = 12' ,\
    keyentry with points linetype 2 pointsize 1.3 pointtype 7 title 'L = 16' ,\
    keyentry with points linetype 3 pointsize 1.3 pointtype 7 title 'L = 24' ,\
    keyentry with points linetype 4 pointsize 1.3 pointtype 7 title 'L = 32' ,\
    keyentry with points linetype 5 pointsize 1.3 pointtype 7 title 'L = 48' ,\
    keyentry with points linetype 6 pointsize 1.3 pointtype 7 title 'L = 64'


quit