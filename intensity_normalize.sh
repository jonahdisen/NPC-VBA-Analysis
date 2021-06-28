
export FSLOUTPUTTYPE=NIFTI

for i in `ls ${1}swrm????_FLAIR.*`
do
	current=$(basename $i)
	subject=${current:4:4}

	echo $subject

	fslmaths ${1}swc2${subject}_T1.nii -thr 0.5 -bin ${1}${subject}_WM_bin.nii

	fslmaths ${1}swrm${subject}_FLAIR.nii -mas ${2}extras/probabilistic_cerebellar_atlas.nii -mas ${1}${subject}_WM_bin.nii ${1}${subject}_FLAIR_cerebellum.nii

	fslmaths ${1}${subject}_FLAIR_cerebellum -thrP 5 -uthrP 95 ${1}${subject}_FLAIR_cerebellum.nii

	mean=$(fslstats ${1}${subject}_FLAIR_cerebellum.nii -M)
	ratio=$(echo "1000 / $mean" | bc -l )

	fslmaths ${1}swrm${subject}_FLAIR.nii -mul $ratio ${1}swrm${subject}_FLAIR.nii
done