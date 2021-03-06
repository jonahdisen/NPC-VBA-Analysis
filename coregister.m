%-----------------------------------------------------------------------
% coregister.m
%
% Description: Coregisters all modalities to that subjects T1
% Author: Jonah Isen
% Created: February 11th, 2020
% Last Modified: June 25th, 2021
%-----------------------------------------------------------------------

function coregister(path, groups, sizes)

disp('Coregistering other modalities to T1');

diffusion_mods = ["DTI_FA", "DTI_MD", "NODDI_ficvf"]; %Dont need to directly coregister these modalities, warps applied from B0 coregister

%Perform coregistering of DWI to T1 for each subject, using B0 for
%registration
batchBuffer = 0;
for i = 1:length(groups)
    group = groups{i};
    size = sizes{i};
    for j = 1:size
        t1 = strcat(path, group, num2str(j, '%03.f'), '_T1_stripped.nii');
        b0 = strcat(path, group, num2str(j, '%03.f'), '_DTI_B0.nii');
        if exist(t1, 'file') == 2 && exist(b0, 'file') == 2
            batchBuffer = batchBuffer + 1;
            others = {};
            buffer = 1;
            for k = 1:length(diffusion_mods)
                temp = strcat(path, group, num2str(j, '%03.f'), '_', char(diffusion_mods(k)), '.nii');
                if exist(temp, 'file') == 2
                    others{buffer} = temp;
                    buffer = buffer + 1;
                end
            end
            matlabbatch{batchBuffer}.spm.spatial.coreg.estwrite.ref = {t1};
            matlabbatch{batchBuffer}.spm.spatial.coreg.estwrite.source = {b0};
            matlabbatch{batchBuffer}.spm.spatial.coreg.estwrite.other = others.';
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
end

%Coregister FLAIR to T1 for all subjects
for i = 1:length(groups)
    group = groups{i};
    size = sizes{i};
    for j = 1:size
        t1 = strcat(path, group, num2str(j, '%03.f'), '_T1_stripped.nii');
        source = strcat(path, 'm', group, num2str(j, '%03.f'), '_FLAIR.nii');
        if exist(source, 'file') == 2 && exist(t1, 'file') == 2
            batchBuffer = batchBuffer + 1;
            matlabbatch{batchBuffer}.spm.spatial.coreg.estwrite.ref = {t1};
            matlabbatch{batchBuffer}.spm.spatial.coreg.estwrite.source = {source};
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
end

%Run coregistration
if batchBuffer > 0
    spm_jobman('run',matlabbatch);
end

end
