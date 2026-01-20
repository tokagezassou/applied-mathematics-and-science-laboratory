# png ファイルに出力する
set term png
set output "q2-quater.png"

# 軸と key(凡例)
set xlabel '{location}'
set ylabel '{solution}'
# set xrange [-10:10]
# set logscale x
# set format x "10^{%T}"
# set logscale y
# set format y "10^{%T}"

# # 主目盛りが出てくる間隔
# set xtics 5
# set ytics 5
# # 副目盛りが主目盛りを何等分するか
# set mxtics 5
# set mytics 5
# set grid xtics ytics mxtics mytics linetype 0 linecolor rgb "gray"
# set grid layerdefault

# フォント設定
set xlabel font "Arial,20"
set ylabel font "Arial,20"
set tics font "Arial,15"
set key font "Arial,15"
# ラベルの位置調整
set xlabel offset 0,-1
set ylabel offset 1,0
#凡例の位置調整
# set key maxrows 5
# set key at 250, 30
# set key outside

plot 'output.dat' using 1:2 every ::2::4001 linetype 1 pointsize 0.5 pointtype 7 notitle ,\
    'output.dat' using 1:2 every ::4003::8002 linetype 2 pointsize 0.5 pointtype 7 notitle ,\
    'output.dat' using 1:2 every ::8004::12003 linetype 3 pointsize 0.5 pointtype 7 notitle ,\
    'output.dat' using 1:2 every ::12005::16004 linetype 4 pointsize 0.5 pointtype 7 notitle ,\
    keyentry with points linetype 1 pointsize 1.3 pointtype 7 title 't = 10' ,\
    keyentry with points linetype 2 pointsize 1.3 pointtype 7 title 't = 20' ,\
    keyentry with points linetype 3 pointsize 1.3 pointtype 7 title 't = 30' ,\
    keyentry with points linetype 4 pointsize 1.3 pointtype 7 title 't = 40'


quit