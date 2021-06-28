%-----------------------------------------------------------------------
% main.m
%
% Description: main.m runs all data processing steps
% Author: Jonah Isen
% Created: February 11th, 2020
% Last Modified: April 14th, 2020
%-----------------------------------------------------------------------

data_path = '/Volumes/data/test_data/'; %Path to multimodal MRI data
scripts_path = '/Users/jonahisen1/Documents/MATLAB/Thesis/'; %Path to multimodal MRI data

subject_groups = {'C', 'D', 'N'}; %Performs analysis for subjects up until maxSubjects
group_sizes = {7,5,10};

preProcessing = false; %Perform pre-processing steps
statisticalAnalysis = true; %Perform statistical analysis

if preProcessing
    segment(data_path, subject_groups, group_sizes); %segment T1 into WM and GM
    
    command = "sh " + scripts_path + "skull_strip.sh " + data_path;
    system(command); %generate skull stripped T1
    
    bias_field_correct(data_path, subject_groups, group_sizes) %bias field correct FLAIR
    
    coregister(data_path, subject_groups, group_sizes); %coregister to T1
    normalize(data_path, subject_groups, group_sizes); %normalize to MNI
    
    mask(data_path, subject_groups, group_sizes); %generate individual masks from GM and WM
    command = "sh " + path_to_scripts + "average_mask.sh " + path_to_data;
    system(command); %make average mask from individual masks
    
    ground_truth(data_path, group_sizes); %process ground truth data to MNI space
    
    command = "sh " + path_to_scripts + "intensity_normalize.sh " + path_to_data;
    system(command); %intensity normalize FLAIR scans
end

if statisticalAnalysis
    analysis(path, modalities, maxSubjects);
%     for i = 4:12
%         disp( sprintf( 'Calculating results with threshold = %1.1f', i*0.5 ) );
%         validation(path, modalities, maxSubjects, i*0.5);
%     end
end