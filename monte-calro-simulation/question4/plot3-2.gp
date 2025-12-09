# png ファイルに出力する
set term png
set output "q4-3-2.png"

# 軸と key(凡例)
set xlabel '{System Size}'
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
# set key maxrows 6
# set key at 1.5, 0.4
set key outside

plot 'output3.dat' using 1:3 every 12::1::61 linetype 1 pointsize 1 pointtype 7 notitle ,\
    'output3.dat' using 1:3 every 12::2::62 linetype 2 pointsize 1 pointtype 7 notitle ,\
    'output3.dat' using 1:3 every 12::3::63 linetype 3 pointsize 1 pointtype 7 notitle ,\
    'output3.dat' using 1:3 every 12::4::64 linetype 4 pointsize 1 pointtype 7 notitle ,\
    'output3.dat' using 1:3 every 12::5::65 linetype 5 pointsize 1 pointtype 7 notitle ,\
    'output3.dat' using 1:3 every 12::6::66 linetype 6 pointsize 1 pointtype 7 notitle ,\
    'output3.dat' using 1:3 every 12::7::67 linetype 7 pointsize 1 pointtype 7 notitle ,\
    'output3.dat' using 1:3 every 12::8::68 linetype 8 pointsize 1 pointtype 7 notitle ,\
    'output3.dat' using 1:3 every 12::9::69 linetype 9 pointsize 1 pointtype 7 notitle ,\
    'output3.dat' using 1:3 every 12::10::70 linetype 10 pointsize 1 pointtype 7 notitle ,\
    'output3.dat' using 1:3 every 12::11::71 linetype 11 pointsize 1 pointtype 7 notitle ,\
    'output3.dat' using 1:3 every 12::12::72 linetype 12 pointsize 1 pointtype 7 notitle ,\
    keyentry with points linetype 1 pointsize 1.3 pointtype 7 title 'z = 1.225' ,\
    keyentry with points linetype 2 pointsize 1.3 pointtype 7 title 'z = 1.250' ,\
    keyentry with points linetype 3 pointsize 1.3 pointtype 7 title 'z = 1.275' ,\
    keyentry with points linetype 4 pointsize 1.3 pointtype 7 title 'z = 1.300' ,\
    keyentry with points linetype 5 pointsize 1.3 pointtype 7 title 'z = 1.325' ,\
    keyentry with points linetype 6 pointsize 1.3 pointtype 7 title 'z = 1.350' ,\
    keyentry with points linetype 7 pointsize 1.3 pointtype 7 title 'z = 1.375' ,\
    keyentry with points linetype 8 pointsize 1.3 pointtype 7 title 'z = 1.300' ,\
    keyentry with points linetype 9 pointsize 1.3 pointtype 7 title 'z = 1.425' ,\
    keyentry with points linetype 10 pointsize 1.3 pointtype 7 title 'z = 1.450' ,\
    keyentry with points linetype 11 pointsize 1.3 pointtype 7 title 'z = 1.475' ,\
    keyentry with points linetype 12 pointsize 1.3 pointtype 7 title 'z = 1.500'


quit