#!/bin/bash
#batch-prep-gia-ds-tii-2102011823-enginepart-v01-XTrain2102011823.sh

C:\Users\jeang\Dropbox\lib\samples\tii-game-2102\dusso-engineparts-2102011756
mount_root=/mnt/c
lib_root=$mount_root/Users/jeang/Dropbox/lib
sample_root=$lib_root/samples
root_path=$sample_root/tii-game-2102
in_path=dusso-engineparts-2102011756
out_path=out
dim=2540
do_crop=TRUE
canny_thresh1=100
canny_thresh2=200
folder_suffix=_p2p_canny

cmdcrop="python3 prep.py --root_path $root_path  --in_path $in_path  --out_path $out_path --dim $dim --do_crop $do_crop --canny_thresh1 $canny_thresh1 --canny_thresh2  $canny_thresh2 --folder_suffix $folder_suffix"
cmdstretch="python3 prep.py --root_path $root_path  --in_path $in_path  --out_path $out_path --dim $dim  --canny_thresh1 $canny_thresh1 --canny_thresh2 $canny_thresh2 --folder_suffix $folder_suffix"
$cmdcrop;$cmdstretch

# Start appearing
folder_suffix=_p2p_canny_threshdiv2
out_path=out
canny_thresh1=50
canny_thresh2=100

#@STCResults somes CC are better than others
folder_suffix=_p2p_canny_threshdiv3
out_path=out
canny_thresh1=33
canny_thresh2=77

#@STCGoal todo
folder_suffix=_p2p_canny_threshdiv4
out_path=out
canny_thresh1=25
canny_thresh2=50
