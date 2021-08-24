# Multimodal Voxel-Based Analysis using Non-Parametric Combination

This repository contains the pre-processing and analysis codes used in the work by Isen et al. titled "Non-Parametric Combination of Multimodal MRI for Lesion Detection in Focal Epilepsy".

## Introduction

One third of patients with medically refractory focal epilepsy have normal-appearing MRI scans. This poses a problem, as identification of the epileptogenic region is required to consider surgical treatment. In Isen et al., we performed a multimodal voxel-based analysis (VBA) to identify brain abnormalities in MRI-negative focal epilepsy. Using the non-parametric combination (NPC) algorithm, we combined data from various MR sequences to form a joint inference from a multivariate dataset.

## Requirements

This work was implemented as a set of MATLAB and bash routines, which can be carried out within an MATLAB environment.

For the majority of pre-processing steps of MR scans, SPM12 was used, which can be downloaded from [here](https://www.fil.ion.ucl.ac.uk/spm/software/download/)

For some pre-processing steps and all of the statistical analysis, FMRIB Software Library (FSL) was used, which can be installed from [here](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation)

The NPC analysis was run with FSL's Permutation Analysis of Linear Models tool, which can be downloaded from [here](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM/UserGuide)


## Usage

### Data

This analysis was run with the multimodal data for every subject located in the same directory. The data had the following format:

[subject group][subject ID]_[MR modality].nii

Subject group was one of the following:

- C: Control group
- D: MRI-positive group with discrete lesions on MR scans
- N: MRI-negative group with no visible findings on MR scans

Subject ID was a unique 3 character numeric identifier (ex. 001, 021, 046)

MR modality was one of the following: 
- T1: Basic T1-weighted scan
- FLAIR: Fluid-attenuated inversion recovery sequence
- DTI_B0: Non-diffusion weighted scan from diffusion tensor imaging
- DTI_FA: Fractional anisotropy from diffusion tensor imaging
- DTI_MD: Mean diffusivity from diffusion tensor imaging
- NODDI_ficvf: Neurite density index from neurite orientation and dispersion density imaging

### Running Script

The pipeline is initiated by running the main.m script

Within this script, the user can change flags to toggle both the pre-processing scripts and analysis scripts. The user should also ensure the paths to data and scripts are correctly set, and that the # of subjects for each group are correctly set.

## Relevant Citations

1. Ashburner J. A fast diffeomorphic image registration algorithm. Neuroimage. 2007;38(1):95-113. doi: 10.1016/j.neuroimage.2007.07.007
2. Ashburner J, Barnes G, Chen CC, Daunizeau J, Flandin G, Friston K, Kiebel S, Kilner J, Litvak V, Moran R, Penny W. SPM12 manual. Wellcome Trust Centre for Neuroimaging, London, UK. 2014;26:2464
3. Ashburner J, Friston KJ. Voxel-based morphometry—the methods. Neuroimage. 2000;11(6):805-21. doi: 10.1006/nimg.2000.0582
4. Winkler AM, Ridgway GR, Webster MA, Smith SM, Nichols TE. Permutation inference for the general linear model. NeuroImage. 2014;92:381-97. doi: 10.1016/j.neuroimage.2014.01.060
5. Winkler AM, Webster MA, Brooks JC, Tracey I, Smith SM, Nichols TE. Non‐parametric combination and related permutation tests for neuroimaging. Hum Brain Mapp. 2016;37(4):1486-511. doi: 10.1002/hbm.23115
