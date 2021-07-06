%-----------------------------------------------------------------------
% main.m
%
% Description: main.m runs all data processing steps
% Author: Jonah Isen
% Created: February 11th, 2020
% Last Modified: June 28th, 2021
%-----------------------------------------------------------------------

data_path = '/path/to/dataset/'; %Path to multimodal MRI data
scripts_path = '/path/to/scripts/'; %Path to data processing scripts

subject_groups = {'C', 'D', 'N'}; %Performs analysis for subjects up until maxSubjects
group_sizes = {50,50,50};

preProcessing = true; %Perform pre-processing steps
statisticalAnalysis = true; %Perform statistical analysis

if preProcessing
    segment(data_path, subject_groups, group_sizes); %segment T1 into WM and GM
    
    command = "sh " + scripts_path + "skull_strip.sh " + data_path;
    system(command); %generate skull stripped T1
    
    bias_field_correct(data_path, subject_groups, group_sizes) %bias field correct FLAIR
    
    coregister(data_path, subject_groups, group_sizes); %coregister to T1
    normalize(data_path, subject_groups, group_sizes); %normalize to MNI
    
    mask(data_path, subject_groups, group_sizes); %generate individual masks from GM and WM
    command = "sh " + scripts_path + "average_mask.sh " + data_path;
    system(command); %make average mask from individual masks
    
    ground_truth(data_path, group_sizes); %process ground truth data to MNI space
    
    command = "sh " + scripts_path + "intensity_normalize.sh " + data_path;
    system(command); %intensity normalize FLAIR scans
end

if statisticalAnalysis
    command = "sh " + scripts_path + "univariate_analysis.sh " + data_path + " " + scripts_path + " D";
    system(command); %run univariate analyses for group "D" subjects
    command = "sh " + scripts_path + "univariate_analysis.sh " + data_path + " " + scripts_path + " N";
    system(command); %run univariate analyses for group "N" subjects
    command = "sh " + scripts_path + "univariate_analysis.sh " + data_path + " " + scripts_path + " C";
    system(command); %run leave one out univariate analyses for control subjects
    
    command = "sh " + scripts_path + "NPC_analysis.sh " + data_path + " " + scripts_path + " D";
    system(command); %run NPC analysis for group "D" subjects
    command = "sh " + scripts_path + "NPC_analysis.sh " + data_path + " " + scripts_path + " N";
    system(command); %run NPC analysis for group "N" subjects
    command = "sh " + scripts_path + "NPC_analysis.sh " + data_path + " " + scripts_path + " C";
    system(command); %run leave one out NPC analysis for control subjects
    
    validation(data_path, group_sizes{2})
end