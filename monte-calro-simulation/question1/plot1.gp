# png ファイルに出力する
set term png
set output "q1-1.png"

# 軸と key(凡例)
set xlabel '{Time}'
set ylabel '{Patient Num}'
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
set key at 250, 30
# set key outside

plot 'q1_output.dat' using 1:2 linetype 1 pointsize 0.5 pointtype 7 notitle ,\
    'q1_output.dat' using 1:3  linetype 2 pointsize 0.5 pointtype 7 notitle ,\
    'q1_output.dat' using 1:4  linetype 3 pointsize 0.5 pointtype 7 notitle ,\
    'q1_output.dat' using 1:5  linetype 4 pointsize 0.5 pointtype 7 notitle ,\
    'q1_output.dat' using 1:6  linetype 5 pointsize 0.5 pointtype 7 notitle ,\
    'q1_output.dat' using 1:7  linetype 6 pointsize 0.5 pointtype 7 notitle ,\
    'q1_output.dat' using 1:8  linetype 7 pointsize 0.5 pointtype 7 notitle ,\
    'q1_output.dat' using 1:9  linetype 8 pointsize 0.5 pointtype 7 notitle ,\
    'q1_output.dat' using 1:10  linetype 9 pointsize 0.5 pointtype 7 notitle ,\
    'q1_output.dat' using 1:11  linetype 10 pointsize 0.5 pointtype 7 notitle ,\
    keyentry with points linetype 1 pointsize 1.3 pointtype 7 title 'sample1' ,\
    keyentry with points linetype 2 pointsize 1.3 pointtype 7 title 'sample2' ,\
    keyentry with points linetype 3 pointsize 1.3 pointtype 7 title 'sample3' ,\
    keyentry with points linetype 4 pointsize 1.3 pointtype 7 title 'sample4' ,\
    keyentry with points linetype 5 pointsize 1.3 pointtype 7 title 'sample5' ,\
    keyentry with points linetype 6 pointsize 1.3 pointtype 7 title 'sample6' ,\
    keyentry with points linetype 7 pointsize 1.3 pointtype 7 title 'sample7' ,\
    keyentry with points linetype 8 pointsize 1.3 pointtype 7 title 'sample8' ,\
    keyentry with points linetype 9 pointsize 1.3 pointtype 7 title 'sample9' ,\
    keyentry with points linetype 10 pointsize 1.3 pointtype 7 title 'sample10'


quit