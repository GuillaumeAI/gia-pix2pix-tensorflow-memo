#!/bin/bash
#run_iti_inference.sh

canny_thresh1=80
canny_thresh2=40

dim=2048

## ENV AND ARGS
pix2pix_script=pix2pix.py

python_interpreter=python

checkpoint_dir=/checkpoint

source_file_name_only=$1
source_file_name_only_noext=${source_file_name_only%.*}
target_file_name_only=$2
model_dir=/model
input_dir=input
source_dir=$model_dir/input
target_dir=/out
work_dir=/iti
scale_size=$dim

logfile=/out/itilog.txt
sd="/out/stories/$(date +"%y%m%d%H%M")"

echo "-============================================================--">> $logfile
echo "----------$(date)-->>------------">> $logfile
echo "-============================================================--">> $logfile
    
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
echo cp $source_dir/$source_file_name_only $indir >> $logfile

#@STCGoal PREP - Create the Split input the test is requiring
echo "---PWD----" >> /out/indir.txt
pwd >> /out/indir.txt

echo "$python_interpreter  prep.py --root_path $work_dir --in_path $indir_name --out_path $preped_name --dim $dim" >> /out/indir.txt

$python_interpreter prep.py --root_path $work_dir --in_path $indir_name --out_path $preped_name --dim $dim --canny_thresh1 $canny_thresh1 --canny_thresh2 $canny_thresh2 --do_crop TRUE



# Copy the isotheric subdir in a dir we control
mkdir -p /conv_tmp
pn=$sd'__'$preped_name
mkdir -p $pn

for f in $preped_dir'_'*/* 
    do 
        fn=${source_file_name_only%.*}
        tf=$preped_dir/$fn'_flop'.jpg
        convert $f -flop $tf
        cp $f $preped_dir/
        cp $tf $preped_dir/
        cp $preped_dir/$fn'_flop'.jpg $pn
        cp $f $pn
done
#cp $preped_dir'_'*/*  $preped_dir

for dd in $preped_dir'_'*
    do 
        echo "-----------CONTENT of $dd---------" >> $logfile
        ls $dd >>  $logfile
    done


#sleep 150
#exit

echo "---------------------------------">> $logfile

echo "---------------------------------">> $logfile



# Should have a preped file in /model/$preped_dir


#@STCGoal INFERENCE (thru Test)
for direction in "AtoB" "BtoA"
do
    echo "---------------------------------">> $logfile

    echo "----Direction: $direction : ">> $logfile

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
    s=$sd'_'$direction'__'$source_file_name_only_noext
    mkdir -p $d $s
    outc=/_out_conv
    mkdir -p $outc
    # for f in $infered_dir_target/images/*.png
    # do 
    #         fn=${$f%.*}
    #          convert $f -flop $fn'_f.png'
    # done

#    cp /_out_conv/*_f*.png $d
    #cp /_out_conv/*-outputs.png $d
    #cp /_out_conv/*-outputs.png /_out_conv
    cp $infered_dir_target/images/*-outputs.png $outc    
    echo "---------------------------------">> $logfile
    echo "-----------output_dir/images--->>-------" >> $logfile
    ls $infered_dir_target/images/* >> $logfile
    
    echo "---------------------------------">> $logfile
    echo "-----------OUT_CONV_CONTENT--->>-------" >> $logfile
    ls $outc/* >> $logfile
    
    echo "-----------OUT_CONV_CONTENT---<<-------" >> $logfile
    for ff in $outc/*
    do
        echo "convert $ff -flop $d/$source_file_name_only">>  $logfile
        convert $ff -flop $d/$source_file_name_only
    done
    cp $infered_dir_target/images/*.png $s
    cp $preped_dir/* $s
    mkdir -p $s/outc
    cp $outc/* $s/outc
    (cd $infered_dir_target ; tar cf - * | (cd $s ; tar xf -))

    echo "---------------------------------">> $logfile

    echo "---exporting render: $d----------">>  $logfile
    echo "---------------------------">>   $logfile

done



#@STCGoal Split and export results

echo "--------infered : $infered_dir ------" > /out/infered.txt
ls $infered_dir  >> /out/infered.txt

#source /model/split.sh /out/$target_file_name_only

echo "====================-$(date)--<<=================-">> $logfile


sleep 5