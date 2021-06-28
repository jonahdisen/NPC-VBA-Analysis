
#!/bin/bash
 
export FSLOUTPUTTYPE=NIFTI


for i in `ls ${1}????_T1.nii`
do
	current=$(basename $i)
	subject=${current:0:4}

	echo ${i}
	bet ${i} ${1}${subject}_T1_stripped.nii -R

done