# png ファイルに出力する
set term png
set output "q2.png"

# 軸と key(凡例)
set xlabel '{Number of Data}'
set ylabel '{Minimum Square Error Estimate}'
set yrange [-1.5:2.5]
set logscale x
set format x "10^{%T}"
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

plot 'output.dat' using 1:2 every ::3::15 linetype 1 pointsize 1 pointtype 7 title 'first component' ,\
    'output.dat' using 1:3 every ::3::15 linetype 2 pointsize 1 pointtype 7 title 'second component' ,\
    'output.dat' using 1:4 every ::3::15 linetype 3 pointsize 1 pointtype 7 title 'third component' ,\
    'output.dat' using 1:5 every ::3::15 linetype 4 pointsize 1 pointtype 7 title 'fourth component' ,\
    -0.50 with lines linetype 1 linewidth 2 title 'y = -0.50' ,\
    2.0 with lines linetype 2 linewidth 2 title 'y = 2.0' ,\
    0.20 with lines linetype 3 linewidth 2 title 'y = 0.20' ,\
    -0.099 with lines linetype 4 linewidth 2 title 'y = -0.099'


quit