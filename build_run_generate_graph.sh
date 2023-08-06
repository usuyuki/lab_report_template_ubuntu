algorithmArray=("block" "cyclic")
    # 手法のループ
    for algorithm in "${algorithmArray[@]}"
    do
    #!/bin/bash
    plotData="plot"
    # 代入するので初期化しておく
    truncate tmp/${algorithm}_avg.txt --size 0
    # スレッドごとにコンパイルして実行
    for i in `seq 1 20`
    do
        echo "$i thread"
        file="src/${algorithm}_matmul"
        sourceName="${file}.c"
        echo "run gcc -DNTHREADS=${i} -O -pthread ${sourceName} -o ${file}"
        gcc -DNTHREADS=$i -O -pthread $sourceName -o $file
        total_time=0
        index=$(echo "$i-1" | bc)
        allTime[$index]=""
        # 10回実行する
        for j in `seq 1 10`
        do
            result=$(./src/${algorithm}_matmul | grep time | awk '{print $4}')
            allTime[$index]+="$j $result
"
            # echo "$j $result"
            total_time=$(echo "$total_time + $result" | bc)
        done
        echo "${allTime[${index}]}" > tmp/${algorithm}_${i}thread.txt
        plotData+=" \"tmp/${algorithm}_${i}thread.txt\" title \"${algorithm}_${i}thread\" with lines,"
        avgTime=$(echo "scale=6; $total_time/10" | bc)
        echo "Ave $avgTime"
        echo "${i} $avgTime" >> tmp/${algorithm}_avg.txt
    done
    # スレッド数ごと、実行回数ごとのグラフ生成
    gnuplot << EOF
    set terminal png
    set output "report/img/graph_${algorithm}.png"
    set xrange [1:10]
    set xtics 1
    set xlabel "timesnumber of times"
    set yrange [0:4]
    set ylabel "execution time(s)"
    set grid
    ${plotData/%?/}
EOF
    # スレッド数ごとの平均グラフ生成
    gnuplot << EOF
    set terminal png
    set output "report/img/graph_${algorithm}_ave.png"
    set xrange [-1:20]
    set xtics 1
    set xlabel "thread"
    set yrange [0:4]
    set ylabel "execution average time(s)"
    set grid
    plot "tmp/${algorithm}_avg.txt" using 0:2:xtic(1) with boxes notitle
EOF
done
