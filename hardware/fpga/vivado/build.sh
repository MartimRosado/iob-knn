#!/bin/bash
TOP_MODULE="iob_knn"

export XILINXPATH=/opt/Xilinx
export LM_LICENSE_FILE=$LM_LICENSE_FILE:$XILINXPATH/Xilinx.lic
source /tools/Xilinx/Vivado/2020.1/settings64.sh
vivado -nojournal -log vivado.log -mode batch -source ../knn.tcl -tclargs "$TOP_MODULE" "$1" "$2" "$3" "$4"
