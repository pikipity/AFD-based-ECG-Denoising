# AFD based ECG Denoising

This repository contains the key function of the AFD based ECG denoising. The AFD based ECG denoising has been introduced in ["Adaptive Fourier decomposition based ECG denoising"](http://dx.doi.org/10.1016/j.compbiomed.2016.08.013). 
These codes are implemented by MATLAB. When using these codes, please cite [our paper](http://dx.doi.org/10.1016/j.compbiomed.2016.08.013). The license follows [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/deed.en).

The AFD decomposes a signal according to its energy distribution, thereby making this algorithm suitable for separating pure ECG signal and noise with overlapping frequency ranges but different energy distributions. 
A stop criterion for the iterative decomposition process in the AFD is calculated on the basis of the estimated signal-to-noise ratio (SNR) of the noisy signal.

## Pseudocode

![Pseudocode of AFD based ECG Denoising](https://raw.githubusercontent.com/pikipity/AFD-based-ECG-Denoising/main/pseudocode.PNG)

## ECG Enhancement Performance

![ECG Enhancement Performance](https://raw.githubusercontent.com/pikipity/AFD-based-ECG-Denoising/main/Results/Denoising%20Performance.PNG)
