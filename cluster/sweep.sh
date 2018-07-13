#!/bin/bash

cd ~/results

time=`date +%Y%m%d_%H%M%S`
mkdir $time
cd $time

# p_rewire
for i in 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0
do
    dir_name="p_rewire=$i"
    mkdir $dir_name
    cd $dir_name
    mkdir code
    cp ~/matlab/avalanche/cluster/* code
#    qsub -l h_vmem=16.5G,s_vmem=16G ~/matlab/avalanche/cluster/run_sim.sh "p_rewire = $i;"
    qsub -l h_vmem=16.5G,s_vmem=16G ~/matlab/avalanche/cluster/run_sim.sh "param.p_rewire = $i;"
    cd ..
done
