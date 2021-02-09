#!/bin/bash
#run_iti_inference.sh
## ENV AND ARGS
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
preped_name=01_preped
infered_dir=/infered
#init
mkdir -p $work_dir $infered_dir
indir_name=00_indir
indir=$work_dir/$indir_name
prepeddir=$work_dir/$preped_name
mkdir -p $indir $prepeddir

cp $source_dir/$source_file_name_only $indir
echo "---listing $indir ----------" > /out/indir.txt
echo cp $source_dir/$source_file_name_only $indir >> /out/indir.txt

#@STCGoal PREP - Create the Split input the test is requiring
echo "---PWD----" >> /out/indir.txt
pwd >> /out/indir.txt
echo "python3 prep.py --root_path $work_dir --in_path $indir_name --out_path $preped_name --dim $dim" >> /out/indir.txt
$python_interpreter prep.py --root_path $work_dir --in_path $indir_name --out_path $preped_name --dim $dim

ls $indir >> /out/indir.txt

# Copy the isotheric subdir in a dir we control
cp $prepeddir'_'*/*  $prepeddir

echo "------prep: $preped_name -  $prepeddir" >> /out/indir.txt
ls $prepeddir >> /out/indir.txt

echo "----- /iti -------" >> /out/indir.txt
ls /iti >> /out/indir.txt


#sleep 150
#exit



# Should have a preped file in /model/$preped_dir


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