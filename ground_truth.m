%-----------------------------------------------------------------------
% ground_truth.m
%
% Description: Pre-process gold standard data to MNI space
% Author: Jonah Isen
% Created: April 1st, 2020
% Last Modified: June 27th, 2021
%-----------------------------------------------------------------------

function ground_truth(path, sizes)

disp('Pre-processing EEG data');

batchBuffer = 0;

%coregister EEG data to T1
for i = 1:sizes{3}
    t1 = strcat(path, 'N', num2str(i, '%03.f'), '_icEEG_T1.nii');
    refT1 = strcat(path, 'N', num2str(i, '%03.f'), '_T1.nii');
    soz = strcat(path, 'N', num2str(i, '%03.f'), '_icEEG_SOZ.nii');
    
    %Coregister the SEEG data for each negative subjects
    if exist(soz, 'file') == 2 && exist(refT1, 'file') == 2 && exist(t1, 'file') == 2
        disp(refT1)
        batchBuffer = batchBuffer + 1;

        matlabbatch{batchBuffer}.spm.spatial.coreg.estwrite.ref = {refT1};
        matlabbatch{batchBuffer}.spm.spatial.coreg.estwrite.source = {t1};
        matlabbatch{batchBuffer}.spm.spatial.coreg.estwrite.other = {soz};
        matlabbatch{batchBuffer}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
        matlabbatch{batchBuffer}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
        matlabbatch{batchBuffer}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{batchBuffer}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
        matlabbatch{batchBuffer}.spm.spatial.coreg.estwrite.roptions.interp = 4;
        matlabbatch{batchBuffer}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{batchBuffer}.spm.spatial.coreg.estwrite.roptions.mask = 0;
        matlabbatch{batchBuffer}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
    end
end

if batchBuffer > 0
    spm_jobman('run',matlabbatch);
end
clear matlabbatch;

%Template generated from DARTEL normalization
final_template = strcat(path, 'Template_6.nii');

batchBuffer = 0;

%Normalize ground truth SEEG data
for i = 1:sizes{3}
    images = {};
    t1 = strcat(path, 'rN', num2str(i, '%03.f'), '_icEEG_T1.nii');
    soz = strcat(path, 'rN', num2str(i, '%03.f'), '_icEEG_SOZ.nii');
    if exist(soz, 'file') == 2
        images{1} = {t1};
        images{2} = {soz};
        flowfield = strcat(path, 'u_rc1N', num2str(i, '%03.f'), '_T1_Template.nii');
    end
    flowfield = strcat(path, 'u_rc1N', num2str(i, '%03.f'), '_T1_Template.nii');
    if exist(flowfield, 'file') == 2
        batchBuffer = batchBuffer + 1;

        matlabbatch{batchBuffer}.spm.tools.dartel.mni_norm.template = {final_template};
        matlabbatch{batchBuffer}.spm.tools.dartel.mni_norm.data.subjs.flowfields = {flowfield};
        matlabbatch{batchBuffer}.spm.tools.dartel.mni_norm.data.subjs.images = images.';
        matlabbatch{batchBuffer}.spm.tools.dartel.mni_norm.vox = [NaN NaN NaN];
        matlabbatch{batchBuffer}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                                       NaN NaN NaN];
        matlabbatch{batchBuffer}.spm.tools.dartel.mni_norm.preserve = 0;
        matlabbatch{batchBuffer}.spm.tools.dartel.mni_norm.fwhm = [0 0 0];
    end
end

%Normalize ground truth discrete lesion data
for i = 1:sizes{2}
    images = {};
    lesion = strcat(path, 'D', num2str(i, '%03.f'), '_Lesion.nii');
    if exist(lesion, 'file') == 2
        images{1} = {lesion};
        flowfield = strcat(path, 'u_rc1D', num2str(i, '%03.f'), '_T1_Template.nii');
    end
    flowfield = strcat(path, 'u_rc1D', num2str(i, '%03.f'), '_T1_Template.nii');
    if exist(flowfield, 'file') == 2
        batchBuffer = batchBuffer + 1;

        matlabbatch{batchBuffer}.spm.tools.dartel.mni_norm.template = {final_template};
        matlabbatch{batchBuffer}.spm.tools.dartel.mni_norm.data.subjs.flowfields = {flowfield};
        matlabbatch{batchBuffer}.spm.tools.dartel.mni_norm.data.subjs.images = images.';
        matlabbatch{batchBuffer}.spm.tools.dartel.mni_norm.vox = [NaN NaN NaN];
        matlabbatch{batchBuffer}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                                       NaN NaN NaN];
        matlabbatch{batchBuffer}.spm.tools.dartel.mni_norm.preserve = 0;
        matlabbatch{batchBuffer}.spm.tools.dartel.mni_norm.fwhm = [0 0 0];
    end
end

if batchBuffer > 0
    spm_jobman('run',matlabbatch);
end

end


    