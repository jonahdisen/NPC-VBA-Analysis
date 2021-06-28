#!/bin/bash

export FSLOUTPUTTYPE=NIFTI

declare -a mods=("GM" "DTI_MD" "DTI_FA" "NODDI_ficvf" "FLAIR")

for i in `ls ${1}${3}???_T1.*`
do
	current=$(basename $i)
	subject=${current:0:4}

	echo '########'
	echo '#' ${subject} '#'
	echo '########'

	for j in "${mods[@]}"
	do
		echo
		echo 'Merging' $j
		echo

		mkdir -p ${1}results/${j}_decrease/${3}/${subject}

		cmd='randomise -o '$1'results/'$j'_decrease/'$3'/'$subject'/'$subject

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

			elif [ $j = "GM" ]
			then
				merge_command='fslmerge -tr '${1}'4D_'${subject}'_'${j}'.nii'
				for k in `ls ${1}C???_T1.*`
				do
					current2=$(basename $k)
					if [ $k != $i ]
					then
						curr_subject=${current2:0:4}
						merge_command="$merge_command "${1}"swc1"${curr_subject}"_T1.nii"
					fi
				done
				
				merge_command="$merge_command "${1}"swc1"${subject}"_T1.nii 1"
				$merge_command
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

			elif [ $j = "GM" ]
			then
				fslmerge -tr ${1}4D_${subject}_${j}.nii ${1}swc1C*_T1.nii ${1}swc1${subject}_T1.nii 1

			else
				fslmerge -tr ${1}4D_${subject}_${j}.nii ${1}swrC*_${j}.nii ${1}swr${subject}_${j}.nii 1

			fi
		fi
		
		cmd="$cmd -i "$1"4D_"$subject"_$j.nii"

		echo
		echo 'Running '${j}' univariate analysis for' ${subject}
		echo

		if [ $3 = "C" ]
		then
			cmd="$cmd -d "$2"extras/design_controls.mat -t "$2"extras/design.con -m "$1"average_mask.nii -T -x"
		else
			cmd="$cmd -d "$2"extras/design.mat -t "$2"extras/design.con -m "$1"average_mask.nii -T -x"
		fi

		$cmd

		fslmaths ${1}4D_${subject}_${j}.nii -mul -1 ${1}4D_${subject}_${j}.nii

		mkdir -p ${1}results/${j}_increase/${3}/${subject}

		if [ $3 = "C" ]
		then
			cmd='randomise -o '$1'results/'$j'_increase/'$3'/'$subject'/'$subject' -i '$1'4D_'$subject'_'$j'.nii -d '$2'extras/design_controls.mat -t '$2'extras/design.con -m '$1'average_mask.nii -T -x'
		else
			cmd='randomise -o '$1'results/'$j'_increase/'$3'/'$subject'/'$subject' -i '$1'4D_'$subject'_'$j'.nii -d '$2'extras/design.mat -t '$2'extras/design.con -m '$1'average_mask.nii -T -x'
		fi

		$cmd

		rm ${1}4D_${subject}_${j}.nii
	done
done