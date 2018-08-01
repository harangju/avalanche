#!/bin/bash
# output files arrive in the working directory
#$ -cwd
# mail me when job ends
#$ -M harangju@gmail.com

sweep_params="$1"

com=""
com="$com cd('~/matlab');"
com="$com addpath(genpath('avalanche'));"
com="$com load_libs;"
com="$com set_parameters;"
com="$com $sweep_params;"
com="$com initialize;"
com="$com simulate;"
dir=`pwd`
com="$com save $dir/matlab.mat -v7.3"

#echo $com
matlab -nodisplay -nodesktop -r "$com"
