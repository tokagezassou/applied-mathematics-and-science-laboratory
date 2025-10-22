# png ファイルに出力する
set term png
set output "q7_iteration_count.png"

# 軸と key(凡例)
set xlabel '{Trial}'
set ylabel '{Iteration Count}'
# set yrange [0:1]
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

stats 'output.dat' using 5 every ::2::51 name 'n10'
stats 'output.dat' using 5 every ::54::103 name 'n20'
stats 'output.dat' using 5 every ::106::155 name 'n40'
stats 'output.dat' using 5 every ::158::207 name 'n80'

plot 'output.dat' using 1:5 every ::2::51 linetype 1 pointsize 1 pointtype 7 title 'n = 10' ,\
    'output.dat' using 1:5 every ::54::103 linetype 2 pointsize 1 pointtype 7 title 'n = 20' ,\
    'output.dat' using 1:5 every ::106::155 linetype 3 pointsize 1 pointtype 7 title 'n = 40' ,\
    'output.dat' using 1:5 every ::158::207 linetype 4 pointsize 1 pointtype 7 title 'n = 80' ,\
    n10_median with lines linetype 1 linewidth 2 title 'n = 10 median' ,\
    n20_median with lines linetype 2 linewidth 2 title 'n = 20 median' ,\
    n40_median with lines linetype 3 linewidth 2 title 'n = 40 median' ,\
    n80_median with lines linetype 4 linewidth 2 title 'n = 80 median'


quit