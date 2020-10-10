# cascades
This repository contains code for simulation and analysis used in [Ju et al. 2020](https://doi.org/10.1088/1741-2552/abbff1) (*Network structure of neural systems supporting cascading dynamics predicts stimulus propagation and recovery*).

## Setup
Code developed using `MATLAB 2018a` and `python 3.7.3`. For help using python in MATLAB, see [system configuration](https://www.mathworks.com/help/matlab/matlab_external/system-and-configuration-requirements.html).

### Dependencies
* [Network generator](https://github.com/BassettLab/network-generator) (for figures 1, 2, 4, and 5)
* [MIToolbox](https://github.com/Craigacp/MIToolbox) (for mutual information analysis in Figure 5)
* [linspecer](https://www.mathworks.com/matlabcentral/fileexchange/42673-beautiful-and-distinguishable-line-colors-colormap) (for figures 2, 3, and 5)
* [powerlaw](https://github.com/jeffalstott/powerlaw) (for figure 2)

## Use
The repository's high-level structure is:
```
├──analysis
    ├──cascades
    ├──depracated code
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

### Figure generation

**To generate the figures from pre-generated data**,
1. Set `source_data_dir` to the directory containing the source data (e.g. `source_data_dir = '/Users/username/Downloads/Source Data';`). Download the pre-generated **source data** from [figshare](https://figshare.com/s/f517286cad7994ab0aa9).
2. Run the scripts in `figures`.

**To generate all figures from scratch**,
1. Clear the variable `source_data_dir` (e.g. `clear source_data_dir`).
2. For figures 2, 3, and 4, set `emp_data_dir` to the directory containing the empirical data (e.g. `emp_data_dir = '/Users/username/Downloads/data';`). Download the **empirical data** from [crcns](http://crcns.org/data-sets/ssc/ssc-3/about-ssc-3). This may take a long time for some figures.
3. Run the scripts in `figures`.
