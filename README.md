# Wavelet-Based Signal Processing Using MATLAB

## Project Overview

This repository contains the MATLAB App Designer implementation developed for the MSc project:

**Wavelet-Based Denoising and Compression of Non-Stationary Signals Using MATLAB**

The project investigates wavelet-based techniques for the analysis, denoising, compression and reconstruction of non-stationary signals through an interactive MATLAB graphical user interface (GUI).

## Implemented Methods

The MATLAB application implements:

- Discrete Wavelet Transform (DWT)
- Inverse Discrete Wavelet Transform (IDWT)
- Wavelet-based signal denoising
- Wavelet coefficient-based compression
- Continuous Wavelet Transform (CWT)
- Time-frequency scalogram visualisation
- Signal reconstruction
- Quantitative performance evaluation

## Input Signals

The application evaluates three signal types:

- Noisy Sine
- Speech
- ECG

## Wavelet Configurations

The following wavelet configurations are implemented:

- Haar
- db2
- db4
- db8
- sym4
- coif1

## Performance Measures

The system evaluates the following performance measures:

- Mean Squared Error (MSE)
- Signal-to-Noise Ratio (SNR)
- Compression Ratio
- Processing Time

## Experimental Configuration

Three signal types and six wavelet configurations were evaluated using three main processing operations:

1. DWT followed by IDWT reconstruction
2. Wavelet-based denoising
3. Wavelet coefficient-based compression

This produced a total of 54 experimental configurations.

## Software Requirements

- MATLAB
- MATLAB App Designer
- MATLAB Wavelet Toolbox

## Repository Structure

```text
MATLAB_App/
    MATLAB App Designer files

Data/
    Project signal datasets

Results/
    Experimental results

Figures/
    Selected GUI screenshots[FINAL_Master_Results_Verified.xlsx](https://github.com/user-attachments/files/31930919/FINAL_Master_Results_Verified.xlsx)
<img width="842" height="503" alt="dwt composition" src="https://github.com/user-attachments/assets/72536369-2af3-4b17-a738-a56949703c2b" />
<img width="832" height="496" alt="denoise" src="https://github.com/user-attachments/assets/ee0c8124-b1c8-4f80-85bf-a4a3d0d5fa5b" />
<img width="873" height="481" alt="compress" src="https://github.com/user-attachments/assets/630ecae2-a2fa-4fe0-be88-8b00ade15c0f" />


