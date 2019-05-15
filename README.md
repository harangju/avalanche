# cascades
This repository contains code for simulation and analysis used in [Ju et al. 2019](https://arxiv.org/abs/1812.09361) (*Network structure of neural systems supporting cascading dynamics predicts stimulus propagation and recovery*).

## Setup
Code developed using `MATLAB 2018a` and `python 3.7.3`.

#### Dependencies
* [Network generator](https://github.com/BassettLab/network-generator) (for all figures)
* [MIToolbox](https://github.com/Craigacp/MIToolbox) (for mutual information analysis in Figure 5)
* [linspecer](https://www.mathworks.com/matlabcentral/fileexchange/42673-beautiful-and-distinguishable-line-colors-colormap) (for all figures)

#### Empirical data
Download from [crcns](http://crcns.org/data-sets/ssc/ssc-3/about-ssc-3) (for figures 2, 3, and 4).

#### Pre-generated data
Download from [figshare](https://figshare.com/s/7fde7bdbc09c7b34074a) to plot without simulating or analyzing.

## Use
The repository's high-level structure is:
```
├──analysis
    ├──cascades
    ├──dynamics
    ├──graph
    ├──information
    └──markov
├──dynamics
    ├──inputs
    └──models
└──figures
    └──supplement
```

#### Figure generation
**To generate all figures from scratch**, simply run the scripts in `figures`, and make sure that the variables `emp_data_dir` and `pregen_data_dir` are cleared. This may take a long time for some figures.

**To generate figures from without either the empirical or pre-generated data**, run the scripts in `figures`, and specify the directories with either the empirical `emp_data_dir` or the pre-generated `pregen_data_dir` data (e.g., `emp_data_dir = /Users/username/Downloads/data` and `pregen_data_dir = '/Users/username/Downloads/Source Data'`).
