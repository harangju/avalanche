#!/bin/bash

cd ~/results

time=`date +%Y%m%d_%H%M%S`
mkdir $time
cd $time

for i in `seq 5 5 95`
do
    fc=`echo "scale=2; $i/100" | bc -l`
    dir_name="fc=$fc"
#    echo $dir_name
    mkdir $dir_name
    cd $dir_name
    qsub -l h_vmem=16.5G,s_vmem=16G ~/matlab/avalanche/cluster/run_sim.sh "prm.frac_conn = $fc;" 
    cd ..
done
