#!/bin/bash

dir_name="20180720_104516"
qsub -l h_vmem=16.5G,s_vmem=16G ~/matlab/avalanche/cluster/analysis/squeeze_matrices/squeeze_matrices.sh $dir_name
