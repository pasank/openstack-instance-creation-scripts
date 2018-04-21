#!/bin/bash
student_id=$1

prefix='comp30023-2018'
image_id='651bdf17-b771-447d-a7c0-a73f6e6b99f4' #NeCTAR Ubuntu 16.04 LTS (Xenial) amd64
availability_zone='melbourne'

public_keys_root='/home/ubuntu/comp30023/nectar/keys'
student_keys_root=$public_keys_root'/students'
staff_keys_root=$public_keys_root'/staff'

student_public_key_file_name=$student_id'.key.pub'
student_public_key_file=$student_keys_root'/'$student_public_key_file_name

cloud_init_files_root='/home/ubuntu/comp30023/nectar/cloud-init-files/'
cloud_init_file_name='comp30023-2018-cloud-init-'$student_id
cloud_init_file=$cloud_init_files_root$cloud_init_file_name

key_pair_name=comp30023-2018
instance_name=$prefix-$student_id

#sanity check of student copied public key text
ssh-keygen -l -f $student_public_key_file > /dev/null
retval=$?
if [ $retval -ne 0 ]; then
	echo "Error validating $student_public_key_file of student $student_id"
	exit 1
else
	fingerprint=$(ssh-keygen -l -f $student_public_key_file)
	echo "Validated $student_public_key_file of student $student_id successfully. (fingerprint=$fingerprint)"
fi

mv $cloud_init_file $cloud_init_file'.old'

echo "Creating cloud init user data file $cloud_init_file"
touch $cloud_init_file

echo "Writing header of cloud init file"
printf "#cloud-config\nssh_authorized_keys:">>$cloud_init_file

echo "Adding staff keys to cloud init file"
all_staff_key_files=$staff_keys_root'/*.key.pub'
for staff_public_key_file in $all_staff_key_files
do
	echo "Adding staff key in $staff_public_key_file to cloud init user data file $cloud_init_file"

	staff_public_key_file_name=$(basename $staff_public_key_file)
	printf "\n#$staff_public_key_file_name">>$cloud_init_file
	printf "\n    - $(cat $staff_public_key_file)">>$cloud_init_file
done

echo "Adding student key $student_public_key_file to cloud init user data file $cloud_init_file"
printf "\n#$student_public_key_file_name">>$cloud_init_file
printf "\n    - $(cat $student_public_key_file)">>$cloud_init_file


nova boot --image $image_id --flavor m2.tiny --key-name $key_pair_name --availability-zone $availability_zone --user-data $cloud_init_file $instance_name
