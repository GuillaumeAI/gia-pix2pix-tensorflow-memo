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
work_dir=/iti
dim=2048
preped_dir=preped
infered_dir=/infered
#init
mkdir -p $work_dir $infered_dir
indir=$work_dir/00_indir
cp $source_dir/$source_file_name_only $indir
echo "---listing $indir ----------" > /out/indir.txt
echo cp $source_dir/$source_file_name_only $indir >> /out/indir.txt
ls $indir >> /out/indir.txt
mkdir -p $indir
exit

#@STCGoal PREP - Create the Split input the test is requiring
python3 prep.py --root_path $model_dir --in_path $input_dir --out_path $preped_dir --dim $dim
# Should have a preped file in /model/$preped_dir
echo "----------Listing stuff to help insure all is well in the env------">/out/ls_prep.txt
ls /model/$preped_dir >>/out/ls_prep.txt

echo "---ls /model/input...." >>/out/ls_prep.txt
ls /model/input >>/out/ls_prep.txt

sleep 1
echo "-----------Listing / for testing-----------">/out/ls_slash.txt
ls />>/out/ls_slash.txt

sleep 1
echo "-----------Listing /checkpoint for testing-----------">/out/ls_cp.txt
ls $checkpoint_dir >>/out/ls_cp.txt

echo "------Testing INputs" > /out/input-output.txt
echo $1 >> /out/input-output.txt
echo $2 >> /out/input-output.txt

echo "exiting, see $0 and keep coding it to continue the thing"
echo "something in the input dir" >> /model/input/out.txt
sleep 1
exit
#@STCGoal INFERENCE (thru Test)
     python pix2pix.py \
        --mode test \
        --output_dir "$infered_dir" \
        --input_dir "$preped_dir" \
        --checkpoint "$checkpoint_dir"

#@STCGoal Split and export results

source /model/split.sh /out/$target_file_name_only