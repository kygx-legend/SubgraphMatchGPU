#!/usr/bin/env bash

export PBE_HOME=.
export PBE_PREPROCESS=${PBE_HOME}/preprocess_graph
export PBE_FENNEL=${PBE_HOME}/fennel


export DATA_DIR=${PBE_HOME}/data

# mkdir data
if [[ ! -d "${DATA_DIR}" ]]; then
  echo "[Run] mkdir ${DATA_DIR}"
  mkdir ${DATA_DIR}
  echo "[Done] mkdir ${DATA_DIR}"
fi

# download
if [[ ! -f "${DATA_DIR}/com-friendster.ungraph.txt.gz" ]] && [[ ! -f "${DATA_DIR}/com-friendster.ungraph.txt" ]]; then
  echo "[Run] download friendster graph to ${DATA_DIR}"
  cd ${DATA_DIR} && wget https://snap.stanford.edu/data/bigdata/communities/com-friendster.ungraph.txt.gz && gunzip com-friendster.ungraph.txt.gz && cd ..
  echo "[Done] download friendster graph to ${DATA_DIR}"
fi

# preprocess
if [[ -f "${DATA_DIR}/com-friendster.ungraph.txt" ]]; then
  echo "[Run] preprocess friendster graph"
  ${PBE_PREPROCESS} -f ${DATA_DIR}/com-friendster.ungraph.txt -d 0 -o 1
  echo "[Done] preprocess friendster graph"
fi

# partition
if [[ -f "${DATA_DIR}/com-friendster.ungraph.txt.bin" ]]; then
  echo "[Run] partition friendster graph"
  ${PBE_FENNEL} -f ${DATA_DIR}/com-friendster.ungraph.txt.bin -h 1 -p 3
  echo "[Done] partition friendster graph"
fi
