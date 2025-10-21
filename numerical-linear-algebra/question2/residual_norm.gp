# png ファイルに出力する
set term png
set output "q2_residual_norm.png"

# 軸と key(凡例)
set xlabel '{Trial}'
set ylabel '{Residual Norm}'
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

stats 'output.dat' using 2 every ::2::101 name 'n100'
stats 'output.dat' using 2 every ::104::203 name 'n200'
stats 'output.dat' using 2 every ::206::305 name 'n400'
stats 'output.dat' using 2 every ::308::407 name 'n800'

plot 'output.dat' using 1:2 every ::2::101 linetype 1 pointsize 1 pointtype 7 title 'n = 100' ,\
    'output.dat' using 1:2 every ::104::203 linetype 2 pointsize 1 pointtype 7 title 'n = 200' ,\
    'output.dat' using 1:2 every ::206::305 linetype 3 pointsize 1 pointtype 7 title 'n = 400' ,\
    'output.dat' using 1:2 every ::308::407 linetype 4 pointsize 1 pointtype 7 title 'n = 800' ,\
    n100_median with lines linetype 1 linewidth 2 title 'n = 100 median' ,\
    n200_median with lines linetype 2 linewidth 2 title 'n = 200 median' ,\
    n400_median with lines linetype 3 linewidth 2 title 'n = 400 median' ,\
    n800_median with lines linetype 4 linewidth 2 title 'n = 800 median'


quit