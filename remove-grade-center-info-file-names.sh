#!/bin/bash
instances_to_be_created_folder='/home/ubuntu/comp30023/nectar/grade-center-key-downloads/instances-to-be-created-2018-03-09-20-54-01-just-key-files/'
grade_center_info_file='/home/ubuntu/comp30023/nectar/grade-center-key-downloads/instances-to-be-created-2018-03-09-20-54-01-just-key-files/grade-center-info-file-names'


cat $grade_center_info_file | awk -v p=$instances_to_be_created_folder 'RS="\n", FS="\n" { print p$1; rm -f p$1}'


