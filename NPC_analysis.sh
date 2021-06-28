#!/bin/bash

export FSLOUTPUTTYPE=NIFTI

declare -a mods=("DTI_MD" "DTI_FA" "NODDI_ficvf" "FLAIR")

for i in `ls ${1}${3}???_T1.*`
do
	current=$(basename $i)
	subject=${current:0:4}

	echo '########'
	echo '#' ${subject} '#'
	echo '########'
	echo
	echo 'Creating 4D Files'
	echo

	mkdir -p ${1}results/NPC/${3}/${subject}

	npc_command='palm -o '$1'results/NPC/'$3'/'$subject'/'$subject

	for j in "${mods[@]}"
	do

		echo 'Merging' $j
		
		if [ $3 = "C" ]
		then
			if [ $j = "FLAIR" ]
			then
				merge_command='fslmerge -tr '${1}'4D_'${subject}'_'${j}'.nii'
				for k in `ls ${1}C???_T1.*`
				do
					current2=$(basename $k)
					if [ $k != $i ]
					then
						curr_subject=${current2:0:4}
						merge_command="$merge_command "${1}"swrm"${curr_subject}"_"${j}".nii"
					fi
				done
				
				merge_command="$merge_command "${1}"swrm"${subject}"_"${j}".nii 1"
				$merge_command
				fslmaths ${1}4D_${subject}_FLAIR.nii -mul -1 ${1}4D_${subject}_FLAIR.nii

			elif [ $j = "DTI_MD" ]
			then
				merge_command='fslmerge -tr '${1}'4D_'${subject}'_'${j}'.nii'
				for k in `ls ${1}C???_T1.*`
				do
					current2=$(basename $k)
					if [ $k != $i ]
					then
						curr_subject=${current2:0:4}
						merge_command="$merge_command "${1}"swr"${curr_subject}"_"${j}".nii"
					fi
				done
				
				merge_command="$merge_command "${1}"swr"${subject}"_"${j}".nii 1"
				$merge_command
				fslmaths ${1}4D_${subject}_DTI_MD.nii -mul -1 ${1}4D_${subject}_DTI_MD.nii
			else
				merge_command='fslmerge -tr '${1}'4D_'${subject}'_'${j}'.nii'
				for k in `ls ${1}C???_T1.*`
				do
					current2=$(basename $k)
					if [ $k != $i ]
					then
						curr_subject=${current2:0:4}
						merge_command="$merge_command "${1}"swr"${curr_subject}"_"${j}".nii"
					fi
				done
				
				merge_command="$merge_command "${1}"swr"${subject}"_"${j}".nii 1"
				$merge_command
			fi
		else
			if [ $j = "FLAIR" ]
			then
				fslmerge -tr ${1}4D_${subject}_${j}.nii ${1}swrmC*_${j}.nii ${1}swrm${subject}_${j}.nii 1
				fslmaths ${1}4D_${subject}_FLAIR.nii -mul -1 ${1}4D_${subject}_FLAIR.nii

			elif [ $j = "DTI_MD" ]
			then
				fslmerge -tr ${1}4D_${subject}_${j}.nii ${1}swrC*_${j}.nii ${1}swr${subject}_${j}.nii 1
				fslmaths ${1}4D_${subject}_DTI_MD.nii -mul -1 ${1}4D_${subject}_DTI_MD.nii

			else
				fslmerge -tr ${1}4D_${subject}_${j}.nii ${1}swrC*_${j}.nii ${1}swr${subject}_${j}.nii 1

			fi
		fi

		npc_command="$npc_command -i "$1"4D_"$subject"_$j.nii"
	done

	echo
	echo 'Running NPC for' ${subject}
	echo

	if [ $3 = "C" ]
	then
		npc_command="$npc_command -d "$2"extras/design_controls.mat -t "$2"extras/design.con -npcmethod stouffer -npcmod -m "$1"average_mask.nii -T -Tnpc -tfce_H 2 -tfce_E 0.5 -tfce_C 6"
	else
		npc_command="$npc_command -d "$2"extras/design.mat -t "$2"extras/design.con -npcmethod stouffer -npcmod -m "$1"average_mask.nii -T -Tnpc -tfce_H 2 -tfce_E 0.5 -tfce_C 6"
	fi

	$npc_command

	for k in "${mods[@]}"
	do
		rm ${1}4D_${subject}_${k}.nii
	done
done