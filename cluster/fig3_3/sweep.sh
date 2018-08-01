#!/bin/bash

cd ~/results

time=`date +%Y%m%d_%H%M%S`
mkdir $time
cd $time

#for i in `seq 2 2 98`
for i in 10
do
    redistr=`echo "scale=2; $i/100" | bc -l`
    dir_name="redistr=$redistr"
#    echo $dir_name
    mkdir $dir_name
    cd $dir_name
    mkdir code
    cp ~/matlab/avalanche/cluster/* code
    qsub -l h_vmem=16.5G,s_vmem=16G ~/matlab/avalanche/cluster/run_sim.sh "redistr = $redistr;" 
    cd ..
done
