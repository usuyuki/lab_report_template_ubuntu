#
# 指定したファイルをコンパイルしてから10回実行して平均を表示するシェルスクリプト
# コンパイラ ディレクトリ ファイル名 拡張子
# @example gcc sh 10.sh sample matmul c
#

compiler=$1
directory=$2
fileName=$3
extension=$4
echo "${compiler} ${directory}/${fileName}.${extension} -o ${directory}/compile/${fileName}"
${compiler} ${directory}/${fileName}.${extension} -o ${directory}/compile/${fileName}

total_time=0
# 10回実行する
for j in $(seq 1 10); do
	result=$(./${directory}/compile/${fileName} | grep time | awk '{print $4}')
	echo "${j}th time : ${result}(s)"
	total_time=$(echo "$total_time + $result" | bc)
done
avgTime=$(echo "scale=6; $total_time/10" | bc)
echo "Average time : ${avgTime}(s)"
echo "" # 空行用
