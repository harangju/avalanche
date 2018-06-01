#!/bin/bash

cd ~/results

time=`date +%Y%m%d_%H%M%S`
mkdir $time
cd $time

# fractional connectivity
#for i in 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16
for i in 0.02 0.04 0.06 0.08 0.10
do
# p_spike
#for j in 0.000001 0.000003 0.000010 0.000030 0.00100 0.00300 0.01000
for j in 0.000001 0.000010 0.00100 0.01000
do
    dir_name="frac_conn={$i}_p_spike=$j"
    mkdir $dir_name
    cd $dir_name
    qsub ~/matlab/avalanche/cluster/run_sim.sh "param.frac_conn = $i; p_spike = $j;"
    cd ..
done
done
