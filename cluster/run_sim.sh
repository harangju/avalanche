#!/bin/bash
# output files arrive in the working directory
#$ -cwd
# mail me when job ends
#$ -M harangju@gmail.com

com=""
com="$com cd('~/matlab');"
com="$com addpath(genpath('avalanche'));"
com="$com load_libs;"
com="$com set_parameters;"
com="$com initialize;"
com="$com simulate;"

matlab -nodisplay -nodesktop -r "$com"
