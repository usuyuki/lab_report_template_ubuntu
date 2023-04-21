gnuplot << EOF
set terminal png
set output "report/img/graph_by_type.png"
set xrange [1:10]
set xtics 1
set xlabel "times"
set yrange [0:4]
set ylabel "time(s)"
set grid
plot "tmp/block_4thread.txt" title "block" with lines,"tmp/cyclic_4thread.txt" title "cyclic" with lines,"tmp/normal.txt" title "normal" with lines
EOF
