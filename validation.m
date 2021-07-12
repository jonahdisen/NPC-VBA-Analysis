%-----------------------------------------------------------------------
% validation.m
%
% Description: Generate voxel-wise results for control and
% MRI-positive groups for all analyses
% Author: Jonah Isen
% Created: April 1st, 2020
% Last Modified: July 3rd, 2021
%-----------------------------------------------------------------------


function validation(path, group_size)

trials = ["GM", "FLAIR", "DTI_MD", "DTI_FA", "NODDI_ficvf", "NPC"]; %Array of different analyses performed

%perform voxel-wise valiation for each trial
for i = 1:length(trials)
    %perform validation for each direction of comparison
    for j = 1:2
        if strcmp("NPC", trials(i)) && j == 2
            continue
        else
            if j == 1
                direction = 'decrease';
            else
                direction = 'increase';
            end
        end
        
        data = zeros(4, 1);
        buffer = 0;
        
        for k = 1:group_size
            if strcmp("NPC", trials(i))
                results = strcat(path, 'results/', char(trials(i)), '/D/D', num2str(k, '%03.f'), '/D', num2str(k, '%03.f'), '_tfce_npc_stouffer_fwep.nii');
            else
                results = strcat(path, 'results/', char(trials(i)), '_', direction, '/D/D', num2str(k, '%03.f'), '/D', num2str(k, '%03.f'), '_tfce_corrp_tstat1.nii');
            end
            if exist(results, 'file') == 2
                lesion = strcat(path, 'wD', num2str(k, '%03.f'), '_Lesion.nii');

                current = niftiread(results);
                sizes = size(current);

                %threshold at p < 0.05
                if strcmp("NPC", trials(i))
                    current(current>0.05) = 0;
                else
                    current(current<0.95) = 0;
                end
                current(isnan(current)) = 0;

                lesionMask = niftiread(lesion);

                brain = strcat(path, 'average_mask.nii');
                brainMask = niftiread(brain);
                totalVoxels = nnz(brainMask);

                correctedLesion = lesionMask & brainMask;

                overlap = current & correctedLesion;
                overlapCount = nnz(overlap);
                lesionCount = nnz(correctedLesion);
                currentCount = nnz(current);

                falsePositives = currentCount / totalVoxels;
                detectedLesion = overlapCount / lesionCount;
                
                dice = (2*overlapCount) / (lesionCount + currentCount);

                if detectedLesion >= 0
                    buffer = buffer + 1;
                    data(1, buffer) = k;
                    data(2, buffer) = detectedLesion;
                    data(3, buffer) = falsePositives;
                    data(4, buffer) = dice;
                end
            end
        end
        
        if strcmp("NPC", trials(i))
            disp('Results for NPC analysis')
        else
            disp('Results for univariate '+direction+'d '+char(trial(i))+' analysis')
        end
        disp(data)
        disp(mean(data, 2));
        boxplot(data(2, :))
    
    end
end

end