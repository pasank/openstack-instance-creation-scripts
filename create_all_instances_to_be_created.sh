#!/bin/bash
public_keys_root='/home/ubuntu/comp30023/nectar/keys'
student_keys_root=$public_keys_root'/students'
key_files_of_instances_to_be_created=$student_keys_root'/instances-to-be-created/*'

echo $key_files_of_instances_to_be_created
for key_file_of_instance_to_create in $key_files_of_instances_to_be_created
do
	student_key_file_basename=$(basename $key_file_of_instance_to_create)
	student_username=$(echo $student_key_file_basename | cut -d '.' -f 1)
	
	echo "Creating instance for $student_username"

	./create_nectar_instance.sh $student_username
done

