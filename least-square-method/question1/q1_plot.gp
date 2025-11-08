# png ファイルに出力する
set term png
set output "q1.png"

# 軸と key(凡例)
set xlabel '{Number of Data}'
set ylabel '{Minimum Square Error Estimate}'
# set yrange [0:1]
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
    1.5 with lines linetype 1 linewidth 2 title 'y = 1.5' ,\
    2 with lines linetype 2 linewidth 2 title 'y = 2.0'


quit