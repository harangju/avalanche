#!/bin/bash
# output files arrive in the working directory
#$ -cwd
# mail me when job ends
#$ -M harangju@gmail.com

dir_name="$1"

cd ~/results/$dir_name

com=""
com="$com result_dir = '~/results/$dir_name';"
com="$com addpath('~/matlab/avalanche/cluster/analysis/squeeze_matrices');"
com="$com squeeze_matrices"
#dir=`pwd`
#com="$com save $dir/matlab_cmprs.mat -v7.3"

#echo $com
matlab -nodisplay -nodesktop -r "$com"
