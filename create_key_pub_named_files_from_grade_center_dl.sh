#!/bin/bash
#renames *key.txt files to username.key.pub files and copies to renamed_key_dir and relevant to-be-created dir
grade_center_key_download_dir_name='instances-to-be-created-2018-03-16-21-11-30_2'
grade_center_key_download_root_dir='/home/ubuntu/comp30023/nectar/grade-center-key-downloads/'
grade_center_key_download_dir=$grade_center_key_download_root_dir$grade_center_key_download_dir_name

public_keys_root='/home/ubuntu/comp30023/nectar/keys'
student_keys_root=$public_keys_root'/students'
instances_to_be_created_dir=$student_keys_root'/instances-to-be-created'

suffix='.key.pub'

renamed_key_dir="$grade_center_key_download_dir/renamed_key_pub/"
mkdir -p "$renamed_key_dir"

rm $instances_to_be_created_dir -rf
mkdir -p $instances_to_be_created_dir

all_downloaded_key_files=$grade_center_key_download_dir'/*key.txt*'
for file in $all_downloaded_key_files
do
	grade_center_key_file_name=$(basename "$file")
	username=$(echo $grade_center_key_file_name | cut -d '_' -f 2)
	final_key_file_name=$username$suffix

	echo "Copying $file to $renamed_key_dir$final_key_file_name"
	cp "$file" "$renamed_key_dir$final_key_file_name"

	cp "$renamed_key_dir$final_key_file_name" "$student_keys_root"
	cp "$renamed_key_dir$final_key_file_name" "$instances_to_be_created_dir"
done
