#!/bin/bash

cd ~/results

time=`date +%Y%m%d_%H%M%S`
mkdir $time
cd $time

for i in 0.001 0.003 0.010 0.030 0.100 0.300
do
    
    sweep="frac_conn=$i"
    mkdir $sweep
    cd $sweep
    qsub ~/matlab/avalanche/cluster/run_sim.sh "param.frac_conn = $i;"
    cd ..
done