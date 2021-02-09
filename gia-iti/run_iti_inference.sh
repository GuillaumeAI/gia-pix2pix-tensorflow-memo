#!/bin/bash
#run_iti_inference.sh
## ENV AND ARGS
checkpoint_dir=/checkpoint

source_file_name_only=$1
target_file_name_only=$2
model_dir=/model
input_dir=input
source_dir=$model_dir/input
target_dir=/out
work_dir=/prep
dim=2048
preped_dir=preped
infered_dir=/infered
#init
mkdir -p $work_dir $infered_dir

#@STCGoal PREP - Create the Split input the test is requiring
python3 prep.py --root_path $model_dir --in_path $input_dir --out_path $preped_dir --dim $dim
# Should have a preped file in /model/$preped_dir
echo "----------Listing stuff to help insure all is well in the env------"
ls /model/$preped_dir
sleep 2
echo "-----------Listing / for testing-----------"
ls /
echo "exiting, see $0 and keep coding it to continue the thing"
sleep 5
exit
#@STCGoal INFERENCE (thru Test)
     python pix2pix.py \
        --mode test \
        --output_dir "$infered_dir" \
        --input_dir "$preped_dir" \
        --checkpoint "$checkpoint_dir"

#@STCGoal Split and export results

source /model/split.sh /out/$target_file_name_only