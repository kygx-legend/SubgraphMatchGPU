#!/usr/bin/env bash

get_query_arg() {
  query="0"
  # kc3 in paper => q0 in code
  if [ ${1} = "kc3" ]; then query="0"; fi
  # kc4 in paper => q3 in code
  if [ ${1} = "kc4" ]; then query="3"; fi
  # kc5 in paper => q7 in code
  if [ ${1} = "kc5" ]; then query="7"; fi
  # kc6 in paper => q11 in code
  if [ ${1} = "kc6" ]; then query="11"; fi
  # kc7 in paper => q15 in code
  if [ ${1} = "kc7" ]; then query="15"; fi
  # p1 in paper => q1 in code
  if [ ${1} = "p1" ]; then query="1"; fi
  # p2 in paper => q2 in code
  if [ ${1} = "p2" ]; then query="2"; fi
  # p3 in paper => q16 in code
  if [ ${1} = "p3" ]; then query="16"; fi
  # p4 in paper => q4 in code
  if [ ${1} = "p4" ]; then query="4"; fi
  # p5 in paper => q6 in code
  if [ ${1} = "p5" ]; then query="6"; fi
  # p6 in paper => q8 in code
  if [ ${1} = "p6" ]; then query="8"; fi
  # p7 in paper => q9 in code
  if [ ${1} = "p7" ]; then query="9"; fi
  # p8 in paper => q10 in code
  if [ ${1} = "p8" ]; then query="10"; fi
  # p9 in paper => q12 in code
  if [ ${1} = "p9" ]; then query="12"; fi
  # p10 in paper => q5 in code
  if [ ${1} = "p10" ]; then query="5"; fi
  # p11 in paper => q13 in code
  if [ ${1} = "p11" ]; then query="13"; fi
  # p12 in paper => q18 in code
  if [ ${1} = "p12" ]; then query="18"; fi
  # p13 in paper => q22 in code
  if [ ${1} = "p13" ]; then query="22"; fi
	echo $query
}

run() {
  if [ $# -lt 4 ]; then echo 'run <pbe_executable> <filename> <partition_num> <query>'; return; fi
  PBE_GPU=$1
  file_name=$2
  partition_num=$3
  partition_file="$2.fennel.part.$partition_num"
  query=`get_query_arg ${4}`

  cmd="./${PBE_GPU} -f $file_name -d 0 -a 6 -q $query -e $partition_file -p $partition_num -t 32 -v 1 -m 0 -o 2"
  echo $cmd
  $cmd > $4.log 2>&1
}

run_all() {
  if [ $# -lt 3 ]; then echo 'run_all <pbe_executable> <filename> <partition_num>'; return; fi
  PBE_GPU=$1
  file_name=$2
  partition_num=$3
  for i in {3..7}; do run $PBE_GPU $file_name $partition_num kc$i; done
  for i in {1..10}; do run $PBE_GPU $file_name $partition_num p$i; done
}

run_multi() {
  if [ $# -lt 5 ]; then echo 'run_multi <pbe_executable> <filename> <partition_num> <device_num> <query>'; return; fi
  PBE_GPU=$1
  file_name=$2
  partition_num=$3
  partition_file="$2.fennel.part.$partition_num"
  device_num=${4}
  query=`get_query_arg ${5}`

  cmd="./${PBE_GPU} -f $file_name -d 0 -a 6 -q $query -e $partition_file -p $partition_num -t 32 -v ${device_num} -m 0 -o 2"
  echo $cmd
  $cmd > $5.log 2>&1
}

print_help() {
  echo Usage:
  echo -n '  ./run_query.sh '; run
}

if [ $# -gt 0 ]; then
  if [ $1 == "-h" ]; then
    print_help
    exit
  fi
  $@
else
  print_help
fi
