#!/bin/bash
#run_iti_inference.sh
## ENV AND ARGS
pix2pix_script=pix2pix.py

python_interpreter=python

checkpoint_dir=/checkpoint

source_file_name_only=$1
target_file_name_only=$2
model_dir=/model
input_dir=input
source_dir=$model_dir/input
target_dir=/out
work_dir=/iti
dim=2048
scale_size=$dim

preped_name=01_preped
infered_dir=/infered
#init
mkdir -p $work_dir $infered_dir
indir_name=00_indir
indir=$work_dir/$indir_name
preped_dir=$work_dir/$preped_name
infered_name=02_infered
infered_dir=$work_dir/$infered_name
mkdir -p $indir $preped_dir

cp $source_dir/$source_file_name_only $indir
echo "---listing $indir ----------" > /out/indir.txt
echo cp $source_dir/$source_file_name_only $indir >> /out/indir.txt

#@STCGoal PREP - Create the Split input the test is requiring
echo "---PWD----" >> /out/indir.txt
pwd >> /out/indir.txt
echo "$python_interpreter  prep.py --root_path $work_dir --in_path $indir_name --out_path $preped_name --dim $dim" >> /out/indir.txt
$python_interpreter prep.py --root_path $work_dir --in_path $indir_name --out_path $preped_name --dim $dim

ls $indir >> /out/indir.txt

# Copy the isotheric subdir in a dir we control
cp $preped_dir'_'*/*  $preped_dir

echo "------prep: $preped_name -  $preped_dir" >> /out/indir.txt
ls $preped_dir >> /out/indir.txt

echo "----- /iti -------" >> /out/indir.txt
ls /iti >> /out/indir.txt


#sleep 150
#exit



# Should have a preped file in /model/$preped_dir



#@STCGoal INFERENCE (thru Test)
for direction in "AtoB" "BtoA"
do
    echo "----Direction: $direction : ">> /out/itilog.txt

    infered_dir_target=$infered_dir'_'$direction

    echo $python_interpreter $pix2pix_script \
    --mode test \
    --output_dir "$infered_dir_target" \
    --input_dir "$preped_dir" \
    --checkpoint "$checkpoint_dir" \
    --which_direction $direction \
    --scale_size $scale_size >> /out/itilog.txt

    $python_interpreter $pix2pix_script\
    --mode test \
    --output_dir "$infered_dir_target" \
    --input_dir "$preped_dir" \
    --checkpoint "$checkpoint_dir" \
    --which_direction $direction \
    --scale_size $scale_size

    d=/out/$direction
    mkdir -p $d
    cp $infered_dir_target/images/* $d

    echo "---exporting render: $d----------">> /out/itilog.txt
    echo "---------------------------">> /out/itilog.txt

done



#@STCGoal Split and export results

echo "--------infered : $infered_dir ------" > /out/infered.txt
ls $infered_dir  >> /out/infered.txt

#source /model/split.sh /out/$target_file_name_only

sleep 100