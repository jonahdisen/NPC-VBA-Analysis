%-----------------------------------------------------------------------
% bias_field_correct.m
%
% Description: Bias Field correct FLAIR images
% Author: Jonah Isen
% Created: February 17th, 2020
% Last Modified: June 25th, 2021
%-----------------------------------------------------------------------


function bias_field_correct(path, scripts_path, groups, sizes)

for i = 1:length(groups)
    group = groups{i};
    size = sizes{i};
    for j = 1:size
        flair = strcat(path, group, num2str(j, '%03.f'), '_FLAIR.nii');
        already = strcat(path, 'm', group, num2str(j, '%03.f'), '_FLAIR.nii');
        if exist(flair, 'file') == 2 && ~(exist(already, 'file') == 2)
            disp(flair)
            matlabbatch{1}.spm.spatial.preproc.channel.vols = {flair};
            matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.0001;
            matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
            matlabbatch{1}.spm.spatial.preproc.channel.write = [1 1];
            matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm ={strcat(scripts_path,'extras/TPM.nii,1')};
            matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
            matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {strcat(scripts_path,'extras/TPM.nii,2')};
            matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
            matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm ={strcat(scripts_path,'extras/TPM.nii,3')};
            matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
            matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm ={strcat(scripts_path,'extras/TPM.nii,4')};
            matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
            matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm ={strcat(scripts_path,'extras/TPM.nii,5')};
            matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
            matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {strcat(scripts_path,'extras/TPM.nii,6')};
            matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
            matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
            matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
            matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 0;
            matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
            matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
            matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
            matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
            matlabbatch{1}.spm.spatial.preproc.warp.write = [0 0];
            spm('defaults','FMRI')
            spm_jobman('initcfg');
            spm_jobman('run',matlabbatch);
        end
    end
end
end