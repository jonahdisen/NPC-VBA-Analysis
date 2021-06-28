#!/bin/bash

export FSLOUTPUTTYPE=NIFTI

count=1
for i in `ls ${1}????_mask.nii`
do
	current=$(basename $i)
	echo $current
	subject=${current:0:4}
	echo $subject

	if [ $count -ge 2 ]
	then

		fslmaths ${1}summated_mask.nii -add ${1}${subject}_mask.nii ${1}summated_mask.nii

	else
		fslmaths ${1}${subject}_mask.nii -add 0 ${1}summated_mask.nii
	fi
	count=$((count+1))
done

fslmaths ${1}summated_mask.nii -div $count ${1}average_mask.nii
fslmaths ${1}average_mask.nii -thr 0.05 ${1}average_mask.nii
fslmaths ${1}average_mask.nii -bin ${1}average_mask.nii