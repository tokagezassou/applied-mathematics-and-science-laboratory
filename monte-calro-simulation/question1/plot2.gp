# png ファイルに出力する
set term png
set output "q1-2.png"

# 軸と key(凡例)
set xlabel '{Time}'
set ylabel '{Patient Num Mean}'
set xrange [0:256]
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
set key maxrows 5
set key at 250, 13
# set key outside

plot 'q2_output.dat' using 1:2 linetype 1 pointsize 0.5 pointtype 7 notitle ,\
    'q2_output.dat' using 1:3  linetype 2 pointsize 0.5 pointtype 7 notitle ,\
    'q2_output.dat' using 1:4  linetype 3 pointsize 0.5 pointtype 7 notitle ,\
    'q2_output.dat' using 1:5  linetype 4 pointsize 0.5 pointtype 7 notitle ,\
    keyentry with points linetype 1 pointsize 1.3 pointtype 7 title 'p = 0.64' ,\
    keyentry with points linetype 2 pointsize 1.3 pointtype 7 title 'p = 0.66' ,\
    keyentry with points linetype 3 pointsize 1.3 pointtype 7 title 'p = 0.68' ,\
    keyentry with points linetype 4 pointsize 1.3 pointtype 7 title 'p = 0.70'


quit