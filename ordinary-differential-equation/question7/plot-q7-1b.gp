# png ファイルに出力する
set term png size 800,600  # 3次元は見にくい場合があるためサイズを少し大きく指定(任意)
set output "q7-1b.png"

# 軸と key(凡例)
set xlabel '{x}'
set ylabel '{y}'
set zlabel '{z}'

# set xrange [-10:10]
# set yrange [-10:10]
# set zrange [0:100]
# set logscale z
# set format z "10^{%T}"

# フォント設定
set xlabel font "Arial,20"
set ylabel font "Arial,20"
set zlabel font "Arial,20"
set tics font "Arial,15"
set key font "Arial,15"

# ラベルの位置調整
set xlabel offset 0,-1
set ylabel offset 1,0
# set zlabel offset 1,0

# 凡例の位置調整
set key outside

# 3次元プロット特有の設定
set view 60, 30
set grid

splot 'output.dat' using 1:2:3 every ::1::10000 pointsize 0.7 pointtype 7 notitle

quit