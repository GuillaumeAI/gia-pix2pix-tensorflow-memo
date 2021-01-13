# Retrain the v01 by increasing resolution to 512 (CROP_SIZE)
export model_dir="/a/model/models/model_giapicallo_v04__201221-pix2pix-2012300846-512px"
export input_dir="/a/lib/datasets/gia-young-picasso-v04-2012211928_1024_p2p_canny/train"
export trained_dir=$model_dir
export output_test_dir=$input_dir/../test-512px-2101020826

mkdir -p $model_dir
# We did started to train already
#python pix2pix.py --mode train --output_dir $model_dir --max_epochs 250 --input_dir $input_dir --which_direction BtoA 



python pix2pix.py --mode train --output_dir $model_dir --max_epochs 250 --input_dir $input_dir --which_direction BtoA --checkpoint $model_dir  --display_freq 100


python pix2pix.py \
	--mode test \
	--output_dir "$output_test_dir" \
	--input_dir "$input_dir" \
	--checkpoint "$trained_dir"


